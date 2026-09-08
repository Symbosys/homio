import 'package:flutter/material.dart';
import '../../../core/layout/adaptive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/widgets/state_feedback_widgets.dart';
import '../data/sales_repository.dart';
import '../domain/sales_domain_models.dart';
import '../domain/sales_enums.dart';
import '../widgets/crm_header.dart';
import '../widgets/create_lead_dialog.dart';
import '../widgets/lead_detail_360_modal.dart';
import '../widgets/lead_import_export_dialog.dart';

/// Screen 2: Leads Directory & Pipeline
/// Supports Table View & Kanban Board, full filtering, bulk operations,
/// and smooth modal triggers for 360° inspection and creation.
class SalesLeadsPage extends StatefulWidget {
  const SalesLeadsPage({super.key});

  @override
  State<SalesLeadsPage> createState() => _SalesLeadsPageState();
}

class _SalesLeadsPageState extends State<SalesLeadsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  bool _isActionLoading = false;
  String _viewMode = 'table'; // 'table' or 'kanban'

  // Filter states
  CrmStage? _selectedStage;
  LeadSourceType? _selectedSource;
  String _selectedRep = 'All Reps';
  String _selectedWorkType = 'All Types';
  String _selectedScope = 'All Organization';

  List<LeadItem> _leads = [];
  final Set<String> _selectedLeadIds = {};

  final List<String> _salesReps = [
    'All Reps',
    'Ananya Verma',
    'Rohan Kapoor',
    'Pooja Nair',
    'Vikram Oberoi',
  ];

  final List<String> _workTypes = [
    'All Types',
    'Full Turnkey',
    'Woodwork & Carpentry',
    'False Ceiling',
    'Modular Kitchen',
  ];

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLeads({bool preserveScroll = true}) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() {
      _isLoading = true;
    });

    LeadWorkType? workTypeFilter;
    if (_selectedWorkType == 'Full Turnkey') workTypeFilter = LeadWorkType.fullTurnkey;
    if (_selectedWorkType == 'Woodwork & Carpentry') workTypeFilter = LeadWorkType.woodwork;
    if (_selectedWorkType == 'False Ceiling') workTypeFilter = LeadWorkType.falseCeiling;
    if (_selectedWorkType == 'Modular Kitchen') workTypeFilter = LeadWorkType.modularKitchen;

    final leads = await SalesRepository.instance.getLeads(
      stage: _selectedStage,
      source: _selectedSource,
      assignedTo: _selectedRep == 'All Reps' ? null : _selectedRep,
      workType: workTypeFilter,
      query: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
    );

    if (!mounted) return;
    setState(() {
      _leads = leads;
      _isLoading = false;
    });

    if (preserveScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final max = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(savedOffset.clamp(0.0, max));
        }
      });
    }
  }

  void _openLeadDetail(LeadItem lead) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LeadDetail360Modal(
        lead: lead,
        onLeadUpdated: () => _loadLeads(preserveScroll: true),
      ),
    );
  }

  void _openCreateLeadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CreateLeadDialog(
        onLeadCreated: (newLead) {
          _loadLeads(preserveScroll: true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lead "${newLead.clientName}" created successfully (${newLead.id})'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openImportExportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => LeadImportExportDialog(
        currentLeads: _leads,
        onImportComplete: () => _loadLeads(preserveScroll: true),
      ),
    );
  }

  Future<void> _quickChangeStage(LeadItem lead, CrmStage newStage) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isActionLoading = true);
    await SalesRepository.instance.updateLeadStage(lead.id, newStage);
    await _loadLeads(preserveScroll: false);
    if (!mounted) return;
    setState(() => _isActionLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Stage changed to ${newStage.displayName} for ${lead.clientName}'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _applyBulkStage(CrmStage stage) async {
    if (_selectedLeadIds.isEmpty) return;
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isActionLoading = true);

    await SalesRepository.instance.bulkUpdateStage(_selectedLeadIds.toList(), stage);
    _selectedLeadIds.clear();
    await _loadLeads(preserveScroll: false);
    if (!mounted) return;
    setState(() => _isActionLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated stage to ${stage.displayName} for selected leads'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _applyBulkAssign(String rep) async {
    if (_selectedLeadIds.isEmpty) return;
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isActionLoading = true);

    await SalesRepository.instance.bulkAssignLeads(_selectedLeadIds.toList(), rep);
    _selectedLeadIds.clear();
    await _loadLeads(preserveScroll: false);
    if (!mounted) return;
    setState(() => _isActionLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assigned selected leads to $rep'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenType = AdaptiveLayout.getScreenType(context);
    final isDesktop = screenType == ScreenType.desktop || screenType == ScreenType.laptop;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Top Header
          CrmHeader(
            title: 'Leads Directory & Pipeline',
            subtitle: 'Manage client enquiries, turnkey qualification, and end-to-end stage velocity.',
            scope: _selectedScope,
            onScopeChanged: (val) {
              setState(() => _selectedScope = val);
              _loadLeads(preserveScroll: true);
            },
            onRefresh: () => _loadLeads(preserveScroll: true),
            actionButtons: [
              OutlinedButton.icon(
                onPressed: _openImportExportDialog,
                icon: const Icon(Icons.swap_vert_rounded, size: 16),
                label: const Text('Import / Export'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : AppColors.darkTextPrimary,
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _openCreateLeadDialog,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Lead'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),

          // Localized Loading indicator for actions
          DashboardInlineLoadingIndicator(isLoading: _isActionLoading),

          // Main View Body
          Expanded(
            child: _isLoading && _leads.isEmpty
                ? const DashboardSkeleton(itemCount: 8, height: 60)
                : RefreshIndicator(
                    onRefresh: () => _loadLeads(preserveScroll: true),
                    child: SingleChildScrollView(
                      key: const PageStorageKey('sales_leads_page_scroll'),
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Filter & Control Bar
                          _buildFilterControlBar(isDark, isDesktop),
                          const SizedBox(height: 12),

                          // Bulk Action Bar (when items selected)
                          if (_selectedLeadIds.isNotEmpty) ...[
                            _buildBulkActionBar(isDark),
                            const SizedBox(height: 12),
                          ],

                          // View Modes
                          if (_viewMode == 'table') ...[
                            if (isDesktop)
                              _buildDataTableDesktop(isDark)
                            else
                              _buildCardListMobile(isDark),
                          ] else ...[
                            _buildKanbanFunnelView(isDark),
                          ],
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControlBar(bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Search & Filter Dropdowns
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Search Input
              SizedBox(
                width: 220,
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _loadLeads(preserveScroll: true),
                  decoration: InputDecoration(
                    hintText: 'Search client, phone, DLF...',
                    hintStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              _loadLeads(preserveScroll: true);
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                ),
              ),

              // Stage Filter
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<CrmStage?>(
                    value: _selectedStage,
                    isDense: true,
                    hint: const Text('All Stages', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem<CrmStage?>(
                        value: null,
                        child: Text('All Stages', style: TextStyle(fontSize: 12)),
                      ),
                      ...CrmStage.values.map(
                        (s) => DropdownMenuItem<CrmStage?>(
                          value: s,
                          child: Text(s.displayName, style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedStage = val);
                      _loadLeads(preserveScroll: true);
                    },
                  ),
                ),
              ),

              // Source Filter
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<LeadSourceType?>(
                    value: _selectedSource,
                    isDense: true,
                    hint: const Text('All Sources', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem<LeadSourceType?>(
                        value: null,
                        child: Text('All Sources', style: TextStyle(fontSize: 12)),
                      ),
                      ...LeadSourceType.values.map(
                        (s) => DropdownMenuItem<LeadSourceType?>(
                          value: s,
                          child: Text(s.displayName, style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedSource = val);
                      _loadLeads(preserveScroll: true);
                    },
                  ),
                ),
              ),

              // Work Type Filter
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedWorkType,
                    isDense: true,
                    items: _workTypes.map(
                      (wt) => DropdownMenuItem<String>(
                        value: wt,
                        child: Text(wt, style: const TextStyle(fontSize: 12)),
                      ),
                    ).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedWorkType = val);
                        _loadLeads(preserveScroll: true);
                      }
                    },
                  ),
                ),
              ),

              // Sales Rep Filter
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedRep,
                    isDense: true,
                    items: _salesReps.map(
                      (r) => DropdownMenuItem<String>(
                        value: r,
                        child: Text(r, style: const TextStyle(fontSize: 12)),
                      ),
                    ).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedRep = val);
                        _loadLeads(preserveScroll: true);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          // Right Switcher: Table / Kanban toggle + Lead count
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_leads.length} leads',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(width: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'table',
                    icon: Icon(Icons.table_rows_rounded, size: 16),
                    label: Text('Table', style: TextStyle(fontSize: 12)),
                  ),
                  ButtonSegment(
                    value: 'kanban',
                    icon: Icon(Icons.view_kanban_rounded, size: 16),
                    label: Text('Kanban', style: TextStyle(fontSize: 12)),
                  ),
                ],
                selected: {_viewMode},
                onSelectionChanged: (set) {
                  setState(() => _viewMode = set.first);
                },
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActionBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '${_selectedLeadIds.length} lead(s) selected',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const Spacer(),

          // Bulk Assign Rep
          PopupMenuButton<String>(
            tooltip: 'Assign Rep',
            itemBuilder: (ctx) => _salesReps.where((r) => r != 'All Reps').map((rep) {
              return PopupMenuItem(
                value: rep,
                child: Text(rep, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onSelected: _applyBulkAssign,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.person_add_alt_1_rounded, size: 15),
                  SizedBox(width: 6),
                  Text('Assign Rep', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Bulk Change Stage
          PopupMenuButton<CrmStage>(
            tooltip: 'Change Stage',
            itemBuilder: (ctx) => CrmStage.values.map((stage) {
              return PopupMenuItem(
                value: stage,
                child: Text(stage.displayName, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onSelected: _applyBulkStage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.timeline_rounded, size: 15),
                  SizedBox(width: 6),
                  Text('Change Stage', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          IconButton(
            tooltip: 'Clear Selection',
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: () => setState(() => _selectedLeadIds.clear()),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTableDesktop(bool isDark) {
    if (_leads.isEmpty) {
      return _buildEmptyState(isDark);
    }

    final allSelected = _selectedLeadIds.length == _leads.length;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 1000),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
              ),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 68,
              columnSpacing: 18,
              horizontalMargin: 16,
              columns: [
                DataColumn(
                  label: Checkbox(
                    value: allSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedLeadIds.addAll(_leads.map((l) => l.id));
                        } else {
                          _selectedLeadIds.clear();
                        }
                      });
                    },
                  ),
                ),
                const DataColumn(label: Text('Lead ID & Client', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Stage', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Property / Work', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Budget', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Source', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Assigned To', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Score', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Next Follow-up', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: _leads.map((lead) {
                final isSelected = _selectedLeadIds.contains(lead.id);

                return DataRow(
                  selected: isSelected,
                  onSelectChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedLeadIds.add(lead.id);
                      } else {
                        _selectedLeadIds.remove(lead.id);
                      }
                    });
                  },
                  cells: [
                    DataCell(
                      Checkbox(
                        value: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedLeadIds.add(lead.id);
                            } else {
                              _selectedLeadIds.remove(lead.id);
                            }
                          });
                        },
                      ),
                    ),
                    DataCell(
                      InkWell(
                        onTap: () => _openLeadDetail(lead),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    lead.clientName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  if (lead.isQualified) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified_rounded, size: 14, color: Colors.blue),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${lead.id} • ${lead.phone}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      PopupMenuButton<CrmStage>(
                        tooltip: 'Quick change stage',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: lead.stage.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: lead.stage.color.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(color: lead.stage.color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                lead.stage.displayName,
                                style: TextStyle(color: lead.stage.color, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_drop_down, size: 14, color: lead.stage.color),
                            ],
                          ),
                        ),
                        itemBuilder: (ctx) => CrmStage.values.map((s) {
                          return PopupMenuItem(
                            value: s,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 8),
                                Text(s.displayName, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          );
                        }).toList(),
                        onSelected: (newStage) => _quickChangeStage(lead, newStage),
                      ),
                    ),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lead.projectType,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${lead.workType.displayName} • ${lead.areaSqFt} sq.ft',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(
                        '₹${lead.budgetAmount.toStringAsFixed(1)} L',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lead.source.displayName,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                            child: Text(
                              lead.assignedTo.isNotEmpty ? lead.assignedTo[0] : 'U',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(lead.assignedTo, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: lead.leadScore >= 80
                              ? Colors.green.withValues(alpha: 0.15)
                              : Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${lead.leadScore.toInt()}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: lead.leadScore >= 80 ? Colors.green.shade700 : Colors.amber.shade800,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        lead.nextFollowupDate ?? 'Not scheduled',
                        style: TextStyle(
                          fontSize: 11,
                          color: (lead.nextFollowupDate?.contains('Today') ?? false)
                              ? Colors.redAccent
                              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          fontWeight: (lead.nextFollowupDate?.contains('Today') ?? false) ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone_outlined, size: 16, color: Colors.blue),
                            tooltip: 'Call Client',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Calling ${lead.clientName} (${lead.phone})...')),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.green),
                            tooltip: 'WhatsApp Client',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening WhatsApp for ${lead.clientName}...')),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            tooltip: 'View 360° Profile',
                            onPressed: () => _openLeadDetail(lead),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardListMobile(bool isDark) {
    if (_leads.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _leads.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final lead = _leads[idx];
        return InkWell(
          onTap: () => _openLeadDetail(lead),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                lead.clientName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              if (lead.isQualified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, size: 15, color: Colors.blue),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${lead.id} • ${lead.phone}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: lead.stage.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lead.stage.displayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: lead.stage.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${lead.projectType} • ${lead.workType.displayName} • ${lead.areaSqFt} sq.ft',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Budget: ₹${lead.budgetAmount.toStringAsFixed(1)} L',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      'Rep: ${lead.assignedTo}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Next: ${lead.nextFollowupDate ?? 'Not scheduled'}',
                      style: TextStyle(
                        fontSize: 11,
                        color: (lead.nextFollowupDate?.contains('Today') ?? false) ? Colors.redAccent : null,
                        fontWeight: (lead.nextFollowupDate?.contains('Today') ?? false) ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone_outlined, size: 18, color: Colors.blue),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Calling ${lead.phone}...')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.green),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('WhatsApp ${lead.phone}...')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKanbanFunnelView(bool isDark) {
    return SizedBox(
      height: 680,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CrmStage.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, idx) {
          final stage = CrmStage.values[idx];
          final stageLeads = _leads.where((l) => l.stage == stage).toList();
          final totalStageValue = stageLeads.fold(0.0, (sum, l) => sum + l.budgetAmount);

          return Container(
            width: 280,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Kanban Column Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: stage.color.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                    border: Border(bottom: BorderSide(color: stage.color.withValues(alpha: 0.2))),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: stage.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          stage.displayName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: stage.color),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${stageLeads.length}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Value Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: Text(
                    'Pipeline: ₹${totalStageValue.toStringAsFixed(1)} L',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Lead cards in Kanban
                Expanded(
                  child: stageLeads.isEmpty
                      ? Center(
                          child: Text(
                            'No leads in stage',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(10),
                          itemCount: stageLeads.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (ctx, lIdx) {
                            final lead = stageLeads[lIdx];
                            return _buildKanbanCard(lead, isDark);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKanbanCard(LeadItem lead, bool isDark) {
    return InkWell(
      onTap: () => _openLeadDetail(lead),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    lead.clientName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (lead.isQualified)
                  const Icon(Icons.verified_rounded, size: 13, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              lead.projectType,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${lead.budgetAmount.toStringAsFixed(1)} L',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    lead.assignedTo.split(' ').first,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    lead.nextFollowupDate ?? 'Not scheduled',
                    style: TextStyle(
                      fontSize: 10,
                      color: (lead.nextFollowupDate?.contains('Today') ?? false) ? Colors.redAccent : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      fontWeight: (lead.nextFollowupDate?.contains('Today') ?? false) ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.filter_list_off_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text('No leads match the selected filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(
            'Try resetting your search query or stage filters to view pipeline records.',
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedStage = null;
                _selectedSource = null;
                _selectedWorkType = 'All Types';
                _selectedRep = 'All Reps';
              });
              _loadLeads(preserveScroll: true);
            },
            child: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }
}

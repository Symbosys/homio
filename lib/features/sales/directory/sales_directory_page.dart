import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sales_models.dart';
import '../models/sales_mock_data.dart';
import '../widgets/sales_header.dart';
import '../widgets/lead_detail_modal.dart';

class SalesDirectoryPage extends StatefulWidget {
  const SalesDirectoryPage({super.key});

  @override
  State<SalesDirectoryPage> createState() => _SalesDirectoryPageState();
}

class _SalesDirectoryPageState extends State<SalesDirectoryPage> {
  SalesDateFilter _selectedDateFilter = SalesDateFilter.thisMonth;
  late List<SalesLeadItem> _leads;
  String _searchQuery = '';
  String _selectedStageId = 'ALL';
  bool _isCardView = false;

  @override
  void initState() {
    super.initState();
    _leads = List<SalesLeadItem>.from(SalesMockData.leads);
  }

  List<SalesLeadItem> get _filteredLeads {
    var list = _leads;
    if (_selectedStageId != 'ALL') {
      list = list.where((l) => l.stageId == _selectedStageId).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((l) =>
        l.clientName.toLowerCase().contains(q) ||
        l.phone.contains(q) ||
        l.projectType.toLowerCase().contains(q) ||
        l.siteAddress.toLowerCase().contains(q) ||
        l.assignedConsultant.toLowerCase().contains(q)
      ).toList();
    }
    return list;
  }

  void _openLeadDetail(SalesLeadItem lead) {
    LeadDetailModal.show(
      context,
      lead: lead,
      stages: SalesMockData.interiorStages,
      onLeadUpdated: (updated) {
        setState(() {
          final idx = _leads.indexWhere((l) => l.id == updated.id);
          if (idx != -1) {
            _leads[idx] = updated;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final leads = _filteredLeads;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            SalesHeader(
              title: 'Lead Directory & Dynamic Intake Forms',
              subtitle: 'Multi-funnel master database, dynamic client registration & communication logs',
              icon: Icons.folder_shared_outlined,
              activeFilter: _selectedDateFilter,
              onFilterChanged: (filter) => setState(() => _selectedDateFilter = filter),
              primaryAction: ElevatedButton.icon(
                icon: const Icon(Icons.person_add_alt_1_outlined, size: 14),
                label: const Text('Register Lead', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                onPressed: () => _showIntakeModal(context),
              ),
              additionalFilters: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.file_upload_outlined, size: 14),
                  label: const Text('Import CSV', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('CSV Intake: 52 leads mapped & verified.')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter Bar + View Toggle
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Search Input
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: TextField(
                            style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                            decoration: InputDecoration(
                              hintText: 'Search by client name, mobile (+91), project type, address or consultant...',
                              hintStyle: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                              prefixIcon: Icon(Icons.search, size: 15, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                              prefixIconConstraints: const BoxConstraints(minWidth: 34, minHeight: 32),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              filled: true,
                              fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
                              ),
                            ),
                            onChanged: (val) => setState(() => _searchQuery = val),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // View Switcher (Table vs Cards)
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.view_list_rounded, size: 16, color: !_isCardView ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              constraints: const BoxConstraints(),
                              onPressed: () => setState(() => _isCardView = false),
                              tooltip: 'Table View',
                            ),
                            IconButton(
                              icon: Icon(Icons.grid_view_rounded, size: 16, color: _isCardView ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              constraints: const BoxConstraints(),
                              onPressed: () => setState(() => _isCardView = true),
                              tooltip: 'Card View',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Stage Filter Row
                  Row(
                    children: [
                      Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Stage: ', style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedStageId,
                                isDense: true,
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                items: [
                                  const DropdownMenuItem(value: 'ALL', child: Text('All Pipeline Stages', style: TextStyle(fontSize: 10.5))),
                                  ...SalesMockData.interiorStages.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name, style: const TextStyle(fontSize: 10.5)))),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedStageId = val);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${leads.length} Records',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Content Area: Table View vs Card View
            if (!_isCardView)
              _buildMasterTableView(context, leads, isDark)
            else
              _buildFocusCardGridView(context, leads, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterTableView(BuildContext context, List<SalesLeadItem> leads, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, 920.0);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.0),
                  1: FlexColumnWidth(1.6),
                  2: FlexColumnWidth(1.3),
                  3: FlexColumnWidth(1.1),
                  4: FlexColumnWidth(1.3),
                  5: FlexColumnWidth(1.2),
                  6: FlexColumnWidth(1.3),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    ),
                    children: const [
                      _Th('Lead Details'),
                      _Th('Property & Scope'),
                      _Th('Pipeline Stage'),
                      _Th('Estimated Budget'),
                      _Th('Assigned Closer'),
                      _Th('Next Follow-up'),
                      _Th('Actions'),
                    ],
                  ),
                  ...leads.map((lead) {
                    final stage = SalesMockData.interiorStages.firstWhere(
                      (s) => s.id == lead.stageId,
                      orElse: () => SalesMockData.interiorStages.first,
                    );

                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.darkBorder : AppColors.lightSurfaceSubtle,
                          ),
                        ),
                      ),
                      children: [
                        // Lead Details
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                          child: InkWell(
                            onTap: () => _openLeadDetail(lead),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      lead.clientName,
                                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                                    ),
                                    if (lead.lastCallAudioUrl != null) ...[
                                      const SizedBox(width: 4),
                                      const Icon(Icons.mic, size: 11, color: Color(0xFF10B981)),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 1.5),
                                Text(
                                  '${lead.phone} • ${lead.siteAddress}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Property & Scope
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lead.projectType, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 1.5),
                              Text(lead.workDescription, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        // Stage Badge
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: stage.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                stage.name,
                                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: stage.color),
                              ),
                            ),
                          ),
                        ),
                        // Budget
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                          child: Text(
                            '₹${lead.budgetAmount.toStringAsFixed(1)}L',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                          ),
                        ),
                        // Closer
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 9,
                                backgroundColor: const Color(0xFF3B82F6),
                                child: Text(
                                  lead.assignedConsultant[0],
                                  style: const TextStyle(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  lead.assignedConsultant,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Next Follow-up
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                          child: Row(
                            children: [
                              Icon(
                                lead.isFollowupOverdue ? Icons.error_outline : Icons.schedule,
                                size: 12,
                                color: lead.isFollowupOverdue ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  lead.nextFollowupTime,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: lead.isFollowupOverdue ? FontWeight.w700 : FontWeight.w500,
                                    color: lead.isFollowupOverdue ? const Color(0xFFEF4444) : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Actions
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.phone_in_talk, size: 14, color: Color(0xFF3B82F6)),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'AI Autodial',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Dialing ${lead.clientName} (${lead.phone})')),
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                icon: const Icon(Icons.chat_bubble_outline, size: 14, color: Color(0xFF10B981)),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'WhatsApp',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Opening WhatsApp for ${lead.clientName}')),
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, size: 14, color: Color(0xFF64748B)),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Focus Card',
                                onPressed: () => _openLeadDetail(lead),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFocusCardGridView(BuildContext context, List<SalesLeadItem> leads, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final isMedium = constraints.maxWidth > 600;
        final double cardWidth = isWide
            ? (constraints.maxWidth - 24) / 3
            : isMedium
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: leads.map((lead) {
            return SizedBox(
              width: cardWidth,
              child: _buildSingleFocusCard(context, lead, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSingleFocusCard(BuildContext context, SalesLeadItem lead, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(lead.id, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
              ),
              Text(
                '₹${lead.budgetAmount.toStringAsFixed(1)}L',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(lead.clientName, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
          Text('${lead.projectType} • ${lead.siteAddress}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            children: lead.tags.map((t) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(t, style: const TextStyle(fontSize: 8.5)),
              );
            }).toList(),
          ),
          const Divider(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: const Color(0xFF6366F1),
                    child: Text(lead.assignedConsultant[0], style: const TextStyle(fontSize: 8, color: Colors.white)),
                  ),
                  const SizedBox(width: 5),
                  Text(lead.assignedConsultant, style: const TextStyle(fontSize: 10)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone, size: 13, color: Color(0xFF2563EB)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble, size: 13, color: Color(0xFF10B981)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.open_in_new, size: 13),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _openLeadDetail(lead),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showIntakeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const _DynamicIntakeModal(),
    );
  }
}

class _DynamicIntakeModal extends StatefulWidget {
  const _DynamicIntakeModal();

  @override
  State<_DynamicIntakeModal> createState() => _DynamicIntakeModalState();
}

class _DynamicIntakeModalState extends State<_DynamicIntakeModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _projectCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  bool _vastuPreferred = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    InputDecoration modalInputDeco(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        isDense: true,
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
        ),
      );
    }

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Multi-Schema Lead Registration', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            'Dynamic schema tailored for client homebuyers or designer talent pool',
            style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF2563EB),
            unselectedLabelColor: const Color(0xFF64748B),
            labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
            tabs: const [
              Tab(text: 'Homeowner / Interior Client'),
              Tab(text: 'Designer / Architect Candidate'),
            ],
          ),
        ],
      ),
      content: SizedBox(
        width: 480,
        height: 300,
        child: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameCtrl,
                          style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          decoration: modalInputDeco('Client Full Name *'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _phoneCtrl,
                          style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          decoration: modalInputDeco('WhatsApp Mobile *'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _projectCtrl,
                    style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    decoration: modalInputDeco('Project & Site Address *'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _budgetCtrl,
                    style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    keyboardType: TextInputType.number,
                    decoration: modalInputDeco('Target Budget (₹ in Lakhs) *'),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Vastu Shastra Compliance Preferred', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                    value: _vastuPreferred,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _vastuPreferred = val),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  TextField(
                    style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    decoration: modalInputDeco('Candidate Full Name *'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    decoration: modalInputDeco('Portfolio URL / Behance Link *'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    decoration: modalInputDeco('Residential Experience (Years)'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(fontSize: 11.5)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lead registered and routed.')),
            );
          },
          child: const Text('Save & Route', style: TextStyle(fontSize: 11.5)),
        ),
      ],
    );
  }
}

class _Th extends StatelessWidget {
  final String text;
  const _Th(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}

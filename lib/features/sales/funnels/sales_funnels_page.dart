import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sales_models.dart';
import '../models/sales_mock_data.dart';
import '../widgets/sales_header.dart';
import '../widgets/sales_metric_card.dart';
import '../widgets/sales_kanban_board.dart';

class SalesFunnelsPage extends StatefulWidget {
  const SalesFunnelsPage({super.key});

  @override
  State<SalesFunnelsPage> createState() => _SalesFunnelsPageState();
}

class _SalesFunnelsPageState extends State<SalesFunnelsPage> {
  SalesDateFilter _selectedDateFilter = SalesDateFilter.thisMonth;
  FunnelListType _selectedFunnel = FunnelListType.interiorClient;
  late List<SalesLeadItem> _leads;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _leads = List<SalesLeadItem>.from(SalesMockData.leads);
  }

  List<SalesFunnelStage> get _currentStages {
    switch (_selectedFunnel) {
      case FunnelListType.interiorClient:
        return SalesMockData.interiorStages;
      case FunnelListType.designerRecruitment:
        return SalesMockData.hiringStages;
      case FunnelListType.vendorPartnership:
        return SalesMockData.vendorStages;
    }
  }

  List<SalesLeadItem> get _filteredLeads {
    var list = _leads;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((l) =>
        l.clientName.toLowerCase().contains(q) ||
        l.phone.contains(q) ||
        l.projectType.toLowerCase().contains(q) ||
        l.siteAddress.toLowerCase().contains(q)
      ).toList();
    }
    return list;
  }

  void _handleLeadUpdated(SalesLeadItem updatedLead) {
    setState(() {
      final idx = _leads.indexWhere((l) => l.id == updatedLead.id);
      if (idx != -1) {
        _leads[idx] = updatedLead;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final stages = _currentStages;
    final leads = _filteredLeads;

    final double totalPipelineVal = leads.fold(0.0, (acc, l) => acc + l.budgetAmount);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6),
            child: SalesHeader(
              title: 'Lead Pipelines & Conversion Funnels',
              subtitle: 'Drag-and-drop opportunity kanban, stage velocity SLA timers & multi-funnel switcher',
              icon: Icons.view_kanban_outlined,
              activeFilter: _selectedDateFilter,
              onFilterChanged: (filter) => setState(() => _selectedDateFilter = filter),
              additionalFilters: [
                // Funnel Picker Dropdown
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<FunnelListType>(
                      value: _selectedFunnel,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                      items: FunnelListType.values.map((f) {
                        return DropdownMenuItem<FunnelListType>(
                          value: f,
                          child: Row(
                            children: [
                              Icon(
                                f == FunnelListType.interiorClient
                                    ? Icons.home_work_outlined
                                    : f == FunnelListType.designerRecruitment
                                        ? Icons.badge_outlined
                                        : Icons.inventory_2_outlined,
                                size: 14,
                                color: const Color(0xFF2563EB),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                f.title,
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedFunnel = val);
                      },
                    ),
                  ),
                ),
              ],
              primaryAction: ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Add Opportunity', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                onPressed: () => _showAddLeadModal(context),
              ),
            ),
          ),

          // Funnel Quick KPI Strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final isMedium = constraints.maxWidth > 600;
                final double width = isWide
                    ? (constraints.maxWidth - 36) / 4
                    : isMedium
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth;

                return Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    SizedBox(
                      width: width,
                      child: SalesMetricCard(
                        metric: SalesKpiMetric(
                          id: 'fn_val',
                          title: 'Active Funnel Value',
                          value: '₹${totalPipelineVal.toStringAsFixed(1)}L',
                          changeText: '${leads.length} leads',
                          isPositive: true,
                          icon: Icons.monetization_on_outlined,
                          color: const Color(0xFF2563EB),
                          subtitle: 'Weighted pipeline',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const SalesMetricCard(
                        metric: SalesKpiMetric(
                          id: 'fn_hot',
                          title: 'High-Intent Hot Leads',
                          value: '4 Leads',
                          changeText: 'Score > 80',
                          isPositive: true,
                          icon: Icons.local_fire_department_rounded,
                          color: Color(0xFFEF4444),
                          subtitle: 'Urgent 4h SLA',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const SalesMetricCard(
                        metric: SalesKpiMetric(
                          id: 'fn_vel',
                          title: 'Avg Stage Velocity',
                          value: '4.2 Days',
                          changeText: '< 5d target',
                          isPositive: true,
                          icon: Icons.speed_rounded,
                          color: Color(0xFF10B981),
                          subtitle: 'Discovery (1.8d)',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const SalesMetricCard(
                        metric: SalesKpiMetric(
                          id: 'fn_win',
                          title: 'Win Conversion SLA',
                          value: '29.4%',
                          changeText: '+2.1% wk',
                          isPositive: true,
                          icon: Icons.check_circle_outline_rounded,
                          color: Color(0xFF8B5CF6),
                          subtitle: 'Turnkey deals',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 34,
              child: TextField(
                style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: InputDecoration(
                  hintText: 'Search pipeline by client name, phone, project or location...',
                  hintStyle: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  prefixIcon: Icon(Icons.search, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 34),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : Colors.white,
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
          const SizedBox(height: 10),

          // Kanban Board Canvas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SalesKanbanBoard(
                stages: stages,
                leads: leads,
                onLeadUpdated: _handleLeadUpdated,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showAddLeadModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final projectCtrl = TextEditingController();
    final budgetCtrl = TextEditingController();

    InputDecoration modalInputDeco(String label, {String? prefix}) {
      return InputDecoration(
        labelText: label,
        prefixText: prefix,
        labelStyle: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        isDense: true,
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Text('Add Opportunity to ${_selectedFunnel.title}', style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Contact / Client Name *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Mobile Phone Number (+91) *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: projectCtrl,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Project / Scope Description *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: budgetCtrl,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                keyboardType: TextInputType.number,
                decoration: modalInputDeco('Estimated Budget (₹ in Lakhs) *'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontSize: 11.5)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                final newLead = SalesLeadItem(
                  id: 'LEAD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                  clientName: nameCtrl.text,
                  phone: phoneCtrl.text,
                  email: '${nameCtrl.text.toLowerCase().replaceAll(' ', '.')}@gmail.com',
                  siteAddress: 'Bangalore Metro Area',
                  projectType: projectCtrl.text.isNotEmpty ? projectCtrl.text : '3BHK Apartment',
                  workDescription: 'Turnkey Modular Interior',
                  budgetAmount: double.tryParse(budgetCtrl.text) ?? 25.0,
                  stageId: _currentStages.first.id,
                  source: 'Manual CRM Entry',
                  assignedConsultant: 'Aarav Singhania',
                  meetingPreference: 'Experience Center / Office',
                  createdDate: 'Sep 6, 2026',
                  nextFollowupTime: 'Today, 4:00 PM',
                  isFollowupOverdue: false,
                  tags: ['New Enquiry'],
                );
                setState(() {
                  _leads.insert(0, newLead);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lead "${newLead.clientName}" created successfully.')),
                );
              }
            },
            child: const Text('Create Opportunity', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }
}

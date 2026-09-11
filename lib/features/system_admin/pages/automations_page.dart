import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_phase2_models.dart';
import '../models/admin_phase2_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class AutomationsPage extends StatefulWidget {
  const AutomationsPage({super.key});

  @override
  State<AutomationsPage> createState() => _AutomationsPageState();
}

class _AutomationsPageState extends State<AutomationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<WorkflowAutomation> _automations = List.from(AdminPhase2MockData.automations);
  final List<AutomationExecutionLog> _executionLogs = List.from(AdminPhase2MockData.executionLogs);

  String _searchQuery = '';
  AutomationStatus? _statusFilter;
  String? _moduleFilter;
  WorkflowAutomation? _selectedAutomationForBuilder;
  AutomationExecutionLog? _selectedExecutionDetail;
  bool _isCreateWorkflowModalOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<WorkflowAutomation> get _filteredAutomations {
    return _automations.where((auto) {
      if (_statusFilter != null && auto.status != _statusFilter) return false;
      if (_moduleFilter != null && auto.module != _moduleFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = auto.name.toLowerCase().contains(q) ||
            auto.triggerEvent.toLowerCase().contains(q) ||
            auto.module.toLowerCase().contains(q);
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(context);

    final totalActive = _automations.where((a) => a.status == AutomationStatus.active).length;
    final totalPaused = _automations.where((a) => a.status == AutomationStatus.paused).length;
    final totalExecToday = _automations.fold<int>(0, (sum, a) => sum + a.executionCount);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header
                AdminHeader(
                  title: 'Workflow Automations Engine',
                  description: 'Centralized visual trigger engine managing auto-lead assignment, drip communications, payment links, and SLA timers.',
                  icon: Icons.auto_mode_rounded,
                  breadcrumbs: const ['Homio Administration', 'Operations Control', 'Automations'],
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Workflow dry-run simulation initiated across test lead cluster.')),
                        );
                      },
                      icon: const Icon(Icons.play_circle_outline_rounded, size: 16),
                      label: const Text('Simulate Dry Run', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isCreateWorkflowModalOpen = true),
                      icon: const Icon(Icons.add_task_rounded, size: 16),
                      label: const Text('Create Automation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                // 2. Metrics Summary
                AdminSummaryCards(
                  metrics: [
                    AdminMetricItem(
                      label: 'Active Automations',
                      value: '$totalActive Live Workflows',
                      subtitle: 'Zero downtime engine',
                      icon: Icons.bolt_rounded,
                      color: AppColors.success,
                      trendText: '100% Operational',
                      isPositiveTrend: true,
                    ),
                    AdminMetricItem(
                      label: 'Paused / Draft',
                      value: '$totalPaused Workflows',
                      subtitle: 'Under review or archived',
                      icon: Icons.pause_circle_outline_rounded,
                      color: AppColors.warning,
                    ),
                    AdminMetricItem(
                      label: 'Total Lifetime Runs',
                      value: '$totalExecToday Executions',
                      subtitle: 'Traceable in audit ledgers',
                      icon: Icons.history_rounded,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'Execution Reliability',
                      value: '99.7%',
                      subtitle: '19 failures auto-recovered',
                      icon: Icons.verified_user_outlined,
                      color: AppColors.secondary,
                    ),
                  ],
                ),

                // 3. Navigation Tabs
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    border: Border(
                      bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) => setState(() {}),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(icon: Icon(Icons.account_tree_outlined, size: 18), text: 'Workflow Automation Library'),
                      Tab(icon: Icon(Icons.terminal_rounded, size: 18), text: 'Execution History & Step Trace'),
                    ],
                  ),
                ),

                // 4. Tab Views
                if (_tabController.index == 0)
                  _buildLibraryTab(isDark, isMobile),
                if (_tabController.index == 1)
                  _buildHistoryTab(isDark, isMobile),
              ],
            ),
          ),

          // Visual Workflow Builder Modal / Drawer
          if (_selectedAutomationForBuilder != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _buildWorkflowVisualViewer(isDark),
            ),

          // Execution Detail Drawer
          if (_selectedExecutionDetail != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _buildExecutionDetailDrawer(isDark),
            ),

          // Create Workflow Modal
          if (_isCreateWorkflowModalOpen)
            _buildCreateWorkflowModal(isDark),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 1: AUTOMATION LIBRARY
  // ==========================================================================
  Widget _buildLibraryTab(bool isDark, bool isMobile) {
    final list = _filteredAutomations;

    return Column(
      children: [
        // Filter Bar
        AdminFilterBar(
          searchQuery: _searchQuery,
          onSearchChanged: (q) => setState(() => _searchQuery = q),
          searchHint: 'Search automations by title, trigger event, module...',
          filterControls: [
            DropdownButton<AutomationStatus?>(
              value: _statusFilter,
              hint: const Text('All States', style: TextStyle(fontSize: 12)),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: null, child: Text('All States', style: TextStyle(fontSize: 12))),
                for (final st in AutomationStatus.values)
                  DropdownMenuItem(value: st, child: Text(st.label, style: const TextStyle(fontSize: 12))),
              ],
              onChanged: (val) => setState(() => _statusFilter = val),
            ),
          ],
        ),

        // Workflow Cards
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final auto = list[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Title, module, status
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(auto.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                              Text('${auto.module} • Created by ${auto.createdBy}', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                            ],
                          ),
                        ),
                        AdminStatusBadge(label: auto.status.label, color: auto.status.color),
                      ],
                    ),
                    const Divider(height: 20),

                    // Trigger and Action Summary (WHEN -> THEN)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                                child: const Text('WHEN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(auto.triggerDescription, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(4)),
                                child: const Text('THEN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Execute ${auto.actions.length} action(s): ${auto.actions.map((a) => a.description).join(" → ")}',
                                  style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Bottom info & controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Runs: ${auto.executionCount}',
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 12),
                            if (auto.failureCount > 0)
                              Text(
                                'Failures: ${auto.failureCount}',
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.error),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => setState(() => _selectedAutomationForBuilder = auto),
                              icon: const Icon(Icons.account_tree_outlined, size: 14),
                              label: const Text('View Workflow (WHEN/IF/THEN)', style: TextStyle(fontSize: 11.5)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: auto.status == AutomationStatus.active,
                              activeThumbColor: AppColors.success,
                              onChanged: (val) {
                                _showSafetyModalForAutomation(auto, val);
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
        ),
      ],
    );
  }

  // ==========================================================================
  // TAB 2: EXECUTION HISTORY
  // ==========================================================================
  Widget _buildHistoryTab(bool isDark, bool isMobile) {
    final logs = _executionLogs;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Automation Execution Audit Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          Text('Detailed step-by-step traces of event triggers, condition evaluations, and gateway response times.', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(log.automationName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                          AdminStatusBadge(label: log.result.label, color: log.result.color),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Target Record: ${log.triggeredRecordType} (${log.triggeredRecordTitle}) • Duration: ${log.durationFormatted}', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      const SizedBox(height: 10),
                      Text(log.stepTrace, style: const TextStyle(fontSize: 12, height: 1.4)),
                      if (log.failureReason != null) ...[
                        const SizedBox(height: 8),
                        Text('Failure: ${log.failureReason!}', style: const TextStyle(fontSize: 11.5, color: AppColors.error, fontWeight: FontWeight.w600)),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => setState(() => _selectedExecutionDetail = log),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Inspect Execution Trace', style: TextStyle(fontSize: 11.5)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // VISUAL WORKFLOW BUILDER (WHEN -> IF -> THEN -> OTHERWISE)
  // ==========================================================================
  Widget _buildWorkflowVisualViewer(bool isDark) {
    final auto = _selectedAutomationForBuilder!;

    return AdminDrawerLayout(
      title: auto.name,
      subtitle: '${auto.module} • Visual Workflow Map',
      onClose: () => setState(() => _selectedAutomationForBuilder = null),
      footerActions: [
        OutlinedButton(
          onPressed: () => setState(() => _selectedAutomationForBuilder = null),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Test payload dispatched for "${auto.name}".')),
            );
          },
          icon: const Icon(Icons.bug_report_outlined, size: 16),
          label: const Text('Trigger Test Run'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. WHEN Section
            _buildVisualNodeHeader('WHEN (Business Trigger Event)', Icons.flash_on_rounded, AppColors.primary),
            _buildVisualCard(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(auto.triggerEvent, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  const SizedBox(height: 4),
                  Text(auto.triggerDescription, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                ],
              ),
            ),

            _buildFlowArrow(),

            // 2. IF Section (Conditions)
            _buildVisualNodeHeader('IF (Rule Conditions)', Icons.filter_alt_outlined, AppColors.warning),
            _buildVisualCard(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: auto.conditions.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                          child: Text(c.logicalOp, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.warning)),
                        ),
                        const SizedBox(width: 8),
                        Text('${c.field} ${c.operator} "${c.value}"', style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            _buildFlowArrow(),

            // 3. THEN Section (Actions Pipeline)
            _buildVisualNodeHeader('THEN (Automated Actions Pipeline)', Icons.play_arrow_rounded, AppColors.success),
            _buildVisualCard(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: auto.actions.map((act) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(act.description, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                              Text('Target: ${act.target} • Delay: ${act.delayString}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            Text('Execution Summary', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            const SizedBox(height: 6),
            Text('Total Lifetime Executions: ${auto.executionCount}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            Text('Failure Rate: ${((auto.failureCount / (auto.executionCount == 0 ? 1 : auto.executionCount)) * 100).toStringAsFixed(2)}%', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualNodeHeader(String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildVisualCard(bool isDark, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: child,
    );
  }

  Widget _buildFlowArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Icon(Icons.arrow_downward_rounded, size: 18, color: AppColors.primary),
      ),
    );
  }

  // ==========================================================================
  // SAFETY MODAL FOR WORKFLOW STATE CHANGE
  // ==========================================================================
  void _showSafetyModalForAutomation(WorkflowAutomation auto, bool activate) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              activate ? Icons.play_circle_outline_rounded : Icons.pause_circle_outline_rounded,
              color: activate ? AppColors.success : AppColors.warning,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                activate ? 'Activate Automation' : 'Pause Automation',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          activate
              ? 'Activating "${auto.name}" will evaluate incoming leads, meetings, and quotations immediately. Automated WhatsApp and email messages will be dispatched according to the configured rule schedule.'
              : 'Pausing "${auto.name}" will immediately suspend all automated stage-change communications, lead assignments, and reminder drips driven by this rule.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: activate ? AppColors.primary : AppColors.warning,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              setState(() {
                final idx = _automations.indexWhere((a) => a.id == auto.id);
                if (idx != -1) {
                  _automations[idx] = auto.copyWith(
                    status: activate ? AutomationStatus.active : AutomationStatus.paused,
                  );
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Workflow "${auto.name}" is now ${activate ? "ACTIVE" : "PAUSED"}.',
                  ),
                ),
              );
            },
            child: Text(activate ? 'Confirm & Activate' : 'Confirm & Pause'),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // EXECUTION DETAIL DRAWER
  // ==========================================================================
  Widget _buildExecutionDetailDrawer(bool isDark) {
    final log = _selectedExecutionDetail!;

    return AdminDrawerLayout(
      title: 'Execution Trace #${log.id}',
      subtitle: '${log.automationName} • ${log.result.label}',
      onClose: () => setState(() => _selectedExecutionDetail = null),
      footerActions: [
        OutlinedButton(
          onPressed: () => setState(() => _selectedExecutionDetail = null),
          child: const Text('Close'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminStatusBadge(label: log.result.label, color: log.result.color),
          const SizedBox(height: 14),
          Text('Executed At: ${log.executedAt.toIso8601String().replaceFirst('T', ' ').substring(0, 19)} IST', style: const TextStyle(fontSize: 12)),
          Text('Triggered By: ${log.triggerEvent}', style: const TextStyle(fontSize: 12)),
          Text('Target Record: ${log.triggeredRecordType} (${log.triggeredRecordTitle})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Divider(height: 24),
          const Text('Actions Performed', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final a in log.actionsExecuted)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 14, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(child: Text(a, style: const TextStyle(fontSize: 12))),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const Text('Full Step Trace Log', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(log.stepTrace, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // CREATE WORKFLOW MODAL
  // ==========================================================================
  Widget _buildCreateWorkflowModal(bool isDark) {
    final nameCtrl = TextEditingController();
    String selectedModule = 'Sales CRM & Funnels';
    String selectedTrigger = 'Lead Created';

    return Center(
      child: Container(
        width: 520,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Create Visual Automation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _isCreateWorkflowModalOpen = false),
                ),
              ],
            ),
            const Divider(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Workflow Automation Title *',
                hintText: 'e.g. Luxury Penthouse VIP Lead Alert',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedModule,
              decoration: InputDecoration(
                labelText: 'Operational Module',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'Sales CRM & Funnels', child: Text('Sales CRM & Funnels', style: TextStyle(fontSize: 13))),
                DropdownMenuItem(value: 'Quotation & Estimation', child: Text('Quotation & Estimation', style: TextStyle(fontSize: 13))),
                DropdownMenuItem(value: 'Site Execution & Civil', child: Text('Site Execution & Civil', style: TextStyle(fontSize: 13))),
                DropdownMenuItem(value: 'Finance & Payments', child: Text('Finance & Payments', style: TextStyle(fontSize: 13))),
              ],
              onChanged: (val) {
                if (val != null) selectedModule = val;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedTrigger,
              decoration: InputDecoration(
                labelText: 'WHEN (Trigger Event)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'Lead Created', child: Text('Lead Created / Ingested', style: TextStyle(fontSize: 13))),
                DropdownMenuItem(value: 'Meeting Scheduled', child: Text('Meeting Scheduled on Calendar', style: TextStyle(fontSize: 13))),
                DropdownMenuItem(value: 'Quotation Nearing Expiry', child: Text('Quotation Nearing 15-Day Expiry', style: TextStyle(fontSize: 13))),
                DropdownMenuItem(value: 'Milestone 100% Inspected', child: Text('Milestone 100% Inspected & Signed Off', style: TextStyle(fontSize: 13))),
              ],
              onChanged: (val) {
                if (val != null) selectedTrigger = val;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => setState(() => _isCreateWorkflowModalOpen = false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please provide an automation title.')),
                      );
                      return;
                    }

                    final newWorkflow = WorkflowAutomation(
                      id: 'auto_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text,
                      module: selectedModule,
                      triggerEvent: selectedTrigger,
                      triggerDescription: 'WHEN $selectedTrigger occurs',
                      status: AutomationStatus.active,
                      conditions: [
                        const WorkflowCondition(field: 'Record.status', operator: 'equals', value: 'Active'),
                      ],
                      actions: [
                        const WorkflowAction(actionType: 'send_notification', target: 'Assigned Staff', description: 'Dispatch in-app alert and update task timeline'),
                      ],
                      createdBy: 'Administrator',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    setState(() {
                      _automations.insert(0, newWorkflow);
                      _isCreateWorkflowModalOpen = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Workflow "${newWorkflow.name}" configured and active.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Save & Activate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

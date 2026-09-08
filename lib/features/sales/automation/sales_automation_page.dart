import 'package:flutter/material.dart';
import '../../../core/layout/adaptive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/widgets/state_feedback_widgets.dart';
import '../data/sales_repository.dart';
import '../domain/sales_domain_models.dart';
import '../domain/sales_enums.dart';
import '../widgets/crm_header.dart';

/// Screen 9: Sales Automation & Workflow Builder
/// Manages Trigger -> Condition -> Action -> Delay sequences, instant WhatsApp
/// welcome drips, auto-assignment algorithms, and stage change automations.
class SalesAutomationPage extends StatefulWidget {
  const SalesAutomationPage({super.key});

  @override
  State<SalesAutomationPage> createState() => _SalesAutomationPageState();
}

class _SalesAutomationPageState extends State<SalesAutomationPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  bool _isLoading = true;
  bool _isActionLoading = false;
  String _selectedScope = 'All Organization';

  List<AutomationWorkflow> _automations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAutomations();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAutomations({bool preserveScroll = true}) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isLoading = true);

    final results = await SalesRepository.instance.getAutomations();
    if (!mounted) return;
    setState(() {
      _automations = results;
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

  Future<void> _toggleAutomation(AutomationWorkflow auto) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isActionLoading = true);

    await SalesRepository.instance.toggleAutomation(auto.id);
    await _loadAutomations(preserveScroll: false);
    if (!mounted) return;
    setState(() => _isActionLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workflow "${auto.name}" is now ${auto.isActive ? "PAUSED" : "ACTIVE"}'),
        backgroundColor: auto.isActive ? Colors.amber.shade800 : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openWorkflowBuilderDialog() {
    final nameCtrl = TextEditingController();
    AutomationTrigger trigger = AutomationTrigger.leadCreated;
    final conditionCtrl = TextEditingController(text: 'Budget >= ₹25L AND City == "Gurugram"');
    final actionCtrl = TextEditingController(text: 'Send Luxury PDF Brochure via WhatsApp & Assign Ananya');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.hub_rounded, color: AppColors.primary),
              SizedBox(width: 10),
              Text('Build New Sales Automation Workflow'),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Workflow Name *',
                      hintText: 'e.g. VIP Penthouse Fast-Track SLA',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<AutomationTrigger>(
                    initialValue: trigger,
                    decoration: const InputDecoration(
                      labelText: 'Event Trigger',
                      border: OutlineInputBorder(),
                    ),
                    items: AutomationTrigger.values.map((t) {
                      return DropdownMenuItem(value: t, child: Text(t.displayName));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setDlgState(() => trigger = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: conditionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Qualification Conditions (Rule Engine)',
                      hintText: 'e.g. areaSqFt > 3000',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: actionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Target Actions & Webhooks',
                      hintText: 'e.g. Assign Round-Robin, Fire Webhook to WhatsApp Engine',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                final newWorkflow = AutomationWorkflow(
                  id: 'AUTO-${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  trigger: trigger,
                  conditions: conditionCtrl.text.trim(),
                  actions: actionCtrl.text.trim(),
                  isActive: true,
                  executionCount: 0,
                  lastTriggered: 'Just now',
                );
                setState(() {
                  _automations.insert(0, newWorkflow);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Workflow "${newWorkflow.name}" activated!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Deploy Workflow'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenType = AdaptiveLayout.getScreenType(context);
    final isDesktop = screenType == ScreenType.desktop || screenType == ScreenType.laptop;

    final activeCount = _automations.where((a) => a.isActive).length;
    final totalExecutions = _automations.fold<int>(0, (sum, a) => sum + a.executionCount);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CrmHeader(
            title: 'Sales Automation & Drip Engine',
            subtitle: 'Trigger -> Condition -> Action sequences, WhatsApp welcome drips, SLA escalations, and auto-assignment.',
            scope: _selectedScope,
            onScopeChanged: (val) {
              setState(() => _selectedScope = val);
              _loadAutomations(preserveScroll: true);
            },
            onRefresh: () => _loadAutomations(preserveScroll: true),
            actionButtons: [
              FilledButton.icon(
                onPressed: _openWorkflowBuilderDialog,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Workflow'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),

          DashboardInlineLoadingIndicator(isLoading: _isActionLoading),

          // Main View Body
          Expanded(
            child: _isLoading && _automations.isEmpty
                ? const DashboardSkeleton(itemCount: 6, height: 75)
                : RefreshIndicator(
                    onRefresh: () => _loadAutomations(preserveScroll: true),
                    child: SingleChildScrollView(
                      key: const PageStorageKey('sales_automation_page_scroll'),
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // KPI Metric Strip
                          _buildAutomationKpis(activeCount, _automations.length, totalExecutions, isDark, isDesktop),
                          const SizedBox(height: 16),

                          // Tab bar
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                            child: Column(
                              children: [
                                TabBar(
                                  controller: _tabController,
                                  labelColor: AppColors.primary,
                                  unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  indicatorColor: AppColors.primary,
                                  tabs: const [
                                    Tab(icon: Icon(Icons.hub_rounded, size: 18), text: 'Active Workflow Sequences'),
                                    Tab(icon: Icon(Icons.mark_chat_unread_rounded, size: 18), text: 'WhatsApp Drip Templates'),
                                  ],
                                ),
                                SizedBox(
                                  height: 600,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _buildWorkflowsList(isDark),
                                      _buildWhatsAppTemplatesTab(isDark),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildAutomationKpis(int active, int total, int executions, bool isDark, bool isDesktop) {
    final cards = [
      _buildMiniKpi(
        title: 'Active Workflows',
        value: '$active / $total Active',
        subtitle: 'Running in real-time engine',
        icon: Icons.hub_rounded,
        color: AppColors.primary,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'Monthly Executions',
        value: '$executions Triggers',
        subtitle: 'Automated CRM actions taken',
        icon: Icons.flash_on_rounded,
        color: Colors.amber.shade800,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'SLA Reliability',
        value: '99.8%',
        subtitle: 'Zero missed lead SLAs',
        icon: Icons.verified_user_rounded,
        color: Colors.green,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'Round Robin Engine',
        value: 'Optimal Balance',
        subtitle: 'Even lead distribution across reps',
        icon: Icons.sync_alt_rounded,
        color: Colors.blue,
        isDark: isDark,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
      );
    }
  }

  Widget _buildMiniKpi({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowsList(bool isDark) {
    if (_automations.isEmpty) {
      return const Center(child: Text('No workflows configured.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _automations.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final auto = _automations[idx];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Status toggle
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (auto.isActive ? Colors.green : Colors.grey).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.smart_toy_rounded, color: auto.isActive ? Colors.green : Colors.grey, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auto.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(
                          'Triggered ${auto.executionCount} times • Last active: ${auto.lastTriggered}',
                          style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: auto.isActive,
                    onChanged: (val) => _toggleAutomation(auto),
                    activeThumbColor: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Visual Pipeline Blocks: Trigger -> Condition -> Action
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildVisualBlock('TRIGGER', auto.trigger.displayName, Colors.blue, isDark),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey),
                  _buildVisualBlock('CONDITION', auto.conditions, Colors.purple, isDark),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey),
                  _buildVisualBlock('ACTION', auto.actions, Colors.green, isDark),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVisualBlock(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildWhatsAppTemplatesTab(bool isDark) {
    final templates = [
      {
        'title': 'Luxury Penthouse Welcome + Portfolio PDF',
        'trigger': 'Immediate on Meta Lead Ad Ingestion',
        'body': 'Dear {{client_name}}, thank you for expressing interest in HOMIO Luxury Turnkey Interiors. Here is our exclusive DLF Camellias and Golf Course portfolio for your reference. Our Senior Design Partner will connect shortly.',
      },
      {
        'title': 'Post Site Laser Measurement Confirmation',
        'trigger': 'When Site Survey status -> Completed',
        'body': 'Hi {{client_name}}, our laser measurement survey for your {{area_sqft}} sq.ft residence is recorded. Our architectural design studio is currently working on your initial 3D space planning layout.',
      },
      {
        'title': 'Cold Enquiry Re-engagement Drip (7 Days Inactive)',
        'trigger': 'Lead Inactive for 7 days',
        'body': 'Hello {{client_name}}, we noticed you were considering interior turnkey execution for your property. Would you like to view our recent client handover video walk-through?',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: templates.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (ctx, idx) {
        final t = templates[idx];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(t['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Meta Approved Template', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Trigger: ${t['trigger']}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black26 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(t['body']!, style: const TextStyle(fontSize: 12, height: 1.4)),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/layout/adaptive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/widgets/state_feedback_widgets.dart';
import '../data/sales_repository.dart';
import '../domain/sales_domain_models.dart';
import '../domain/sales_enums.dart';
import '../widgets/crm_header.dart';
import '../widgets/lead_detail_360_modal.dart';

/// Screen 8: Sales Tasks & Operational Activity Manager
/// Manages interior sales deliverables: BOQ revisions, quotation drafting,
/// site laser surveys, 3D design approvals, and priority execution.
class SalesTasksPage extends StatefulWidget {
  const SalesTasksPage({super.key});

  @override
  State<SalesTasksPage> createState() => _SalesTasksPageState();
}

class _SalesTasksPageState extends State<SalesTasksPage> {
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isActionLoading = false;
  String _selectedScope = 'All Organization';
  CrmTaskStatus? _selectedStatus;
  String _selectedPriority = 'All';

  List<SalesTaskItem> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks({bool preserveScroll = true}) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isLoading = true);

    final results = await SalesRepository.instance.getTasks(
      status: _selectedStatus,
      priority: _selectedPriority,
    );

    if (!mounted) return;
    setState(() {
      _tasks = results;
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

  Future<void> _updateStatus(SalesTaskItem task, CrmTaskStatus newStatus) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isActionLoading = true);

    await SalesRepository.instance.updateTaskStatus(task.id, newStatus);
    await _loadTasks(preserveScroll: false);
    if (!mounted) return;
    setState(() => _isActionLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" updated to ${newStatus.displayName}'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openAddTaskDialog() {
    final titleCtrl = TextEditingController();
    final leadNameCtrl = TextEditingController();
    String priority = 'High';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_task_rounded, color: AppColors.primary),
              SizedBox(width: 10),
              Text('Create Sales Deliverable Task'),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Task Title *',
                    hintText: 'e.g. Send Revised Modular Kitchen BOQ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: leadNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Linked Client Name',
                    hintText: 'e.g. Rahul Sharma',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: priority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Urgent', 'High', 'Medium', 'Low'].map((p) {
                    return DropdownMenuItem(value: p, child: Text(p));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setDlgState(() => priority = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                final newTask = SalesTaskItem(
                  id: 'TSK-${DateTime.now().millisecondsSinceEpoch}',
                  leadId: 'HOM-LD-1024',
                  leadName: leadNameCtrl.text.trim().isNotEmpty ? leadNameCtrl.text.trim() : 'Active Client',
                  title: titleCtrl.text.trim(),
                  dueDate: 'Today, 06:00 PM',
                  priority: priority,
                  status: CrmTaskStatus.pending,
                  assignedTo: 'Ananya Verma',
                  subtasks: const ['Draft scope', 'Get manager signoff', 'Send PDF to WhatsApp'],
                );
                await SalesRepository.instance.createTask(newTask);
                _loadTasks(preserveScroll: true);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task "${newTask.title}" created successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Create Task'),
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

    final pendingCount = _tasks.where((t) => t.status == CrmTaskStatus.pending).length;
    final inProgressCount = _tasks.where((t) => t.status == CrmTaskStatus.inProgress).length;
    final completedCount = _tasks.where((t) => t.status == CrmTaskStatus.completed).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CrmHeader(
            title: 'Sales Tasks & Pre-Sales Deliverables',
            subtitle: 'Quotation drafting, laser measurement checklists, 3D presentation approvals, and SLAs.',
            scope: _selectedScope,
            onScopeChanged: (val) {
              setState(() => _selectedScope = val);
              _loadTasks(preserveScroll: true);
            },
            onRefresh: () => _loadTasks(preserveScroll: true),
            actionButtons: [
              FilledButton.icon(
                onPressed: _openAddTaskDialog,
                icon: const Icon(Icons.add_task_rounded, size: 18),
                label: const Text('New Task'),
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
            child: _isLoading && _tasks.isEmpty
                ? const DashboardSkeleton(itemCount: 6, height: 75)
                : RefreshIndicator(
                    onRefresh: () => _loadTasks(preserveScroll: true),
                    child: SingleChildScrollView(
                      key: const PageStorageKey('sales_tasks_page_scroll'),
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // KPI Metric Strip
                          _buildTaskKpis(pendingCount, inProgressCount, completedCount, _tasks.length, isDark, isDesktop),
                          const SizedBox(height: 16),

                          // Filter Bar
                          _buildFilterBar(isDark),
                          const SizedBox(height: 16),

                          // Tasks List
                          _buildTasksList(isDark),
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

  Widget _buildTaskKpis(int pending, int inProgress, int completed, int total, bool isDark, bool isDesktop) {
    final cards = [
      _buildMiniKpi(
        title: 'Pending Tasks',
        value: '$pending Tasks',
        subtitle: 'Awaiting start',
        icon: Icons.pending_actions_rounded,
        color: Colors.amber.shade800,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'In Progress',
        value: '$inProgress Active',
        subtitle: 'Currently being prepared',
        icon: Icons.autorenew_rounded,
        color: Colors.blue,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'Completed',
        value: '$completed Done',
        subtitle: 'Delivered to client',
        icon: Icons.check_circle_outline_rounded,
        color: Colors.green,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'Total Deliverables',
        value: '$total Total',
        subtitle: 'Full sales sprint queue',
        icon: Icons.checklist_rounded,
        color: AppColors.primary,
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

  Widget _buildFilterBar(bool isDark) {
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
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // Status filter
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<CrmTaskStatus?>(
                    value: _selectedStatus,
                    isDense: true,
                    hint: const Text('All Statuses', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Statuses', style: TextStyle(fontSize: 12))),
                      ...CrmTaskStatus.values.map(
                        (s) => DropdownMenuItem(value: s, child: Text(s.displayName, style: const TextStyle(fontSize: 12))),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedStatus = val);
                      _loadTasks(preserveScroll: true);
                    },
                  ),
                ),
              ),

              // Priority filter
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedPriority,
                    isDense: true,
                    items: ['All', 'Urgent', 'High', 'Medium', 'Low'].map(
                      (p) => DropdownMenuItem(value: p, child: Text(p == 'All' ? 'All Priorities' : p, style: const TextStyle(fontSize: 12))),
                    ).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedPriority = val);
                        _loadTasks(preserveScroll: true);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${_tasks.length} deliverables in sprint',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(bool isDark) {
    if (_tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: const Column(
          children: [
            Icon(Icons.task_alt_rounded, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text('No tasks match selected filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final task = _tasks[idx];
        final isCompleted = task.status == CrmTaskStatus.completed;

        return Container(
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
                  // Status switcher popup
                  PopupMenuButton<CrmTaskStatus>(
                    tooltip: 'Change Task Status',
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: task.status.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: task.status.color.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(task.status.icon, size: 14, color: task.status.color),
                          const SizedBox(width: 4),
                          Text(
                            task.status.displayName,
                            style: TextStyle(color: task.status.color, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.arrow_drop_down, size: 14),
                        ],
                      ),
                    ),
                    itemBuilder: (ctx) => CrmTaskStatus.values.map((s) {
                      return PopupMenuItem(
                        value: s,
                        child: Row(
                          children: [
                            Icon(s.icon, size: 16, color: s.color),
                            const SizedBox(width: 8),
                            Text(s.displayName, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                    onSelected: (newStatus) => _updateStatus(task, newStatus),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (c) => LeadDetail360Modal(leadId: task.leadId),
                                );
                              },
                              child: Text(
                                '${task.leadName} (${task.leadId})',
                                style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Priority Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: task.priority == 'Urgent' ? Colors.redAccent.withValues(alpha: 0.15) : Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        color: task.priority == 'Urgent' ? Colors.redAccent : Colors.amber.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Checklist Subtasks
              if (task.subtasks.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: task.subtasks.map((st) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_box_outline_blank_rounded, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          const SizedBox(width: 5),
                          Text(st, style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
              ],

              // Meta row
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  const SizedBox(width: 4),
                  Text('Due: ${task.dueDate}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                  const SizedBox(width: 14),
                  Icon(Icons.person_outline_rounded, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  const SizedBox(width: 4),
                  Text('Assignee: ${task.assignedTo}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

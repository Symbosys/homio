import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../data/task_repository.dart';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/state_feedback_widgets.dart';
import '../widgets/task_detail_drawer.dart';

/// Screen 2: My Tasks & Follow-up Command Center.
/// Features Task Summary KPIs, Multi-View Mode (List, Kanban, Calendar),
/// full interactive Task Detail Drawer, and dedicated Follow-up Management queue with Quick Actions.
class DashboardTasksPage extends StatefulWidget {
  final String userName;

  const DashboardTasksPage({
    super.key,
    this.userName = 'Vikram Malhotra',
  });

  @override
  State<DashboardTasksPage> createState() => _DashboardTasksPageState();
}

class _DashboardTasksPageState extends State<DashboardTasksPage>
    with SingleTickerProviderStateMixin {
  final TaskRepository _repository = TaskRepository.instance;
  final ScrollController _scrollController = ScrollController();

  late TabController _viewTabController;
  DashboardDateFilter _dateFilter = DashboardDateFilter.today;
  DashboardScopeFilter _scopeFilter = DashboardScopeFilter.myWork;

  String _searchQuery = '';
  String _activeFilterPill = 'All'; // All, Today, Upcoming, Overdue, Completed
  TaskPriority? _filterPriority;
  TaskStatus? _filterStatus;
  DateTime _selectedCalendarDay = DateTime(2026, 9, 8);

  bool _isLoading = true;
  bool _hasLoadedOnce = false;
  List<TaskItem> _tasks = [];
  List<FollowUpItem> _followups = [];

  @override
  void initState() {
    super.initState();
    _viewTabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _viewTabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final savedOffset = _scrollController.hasClients ? _scrollController.offset : null;
    setState(() => _isLoading = true);
    final tasks = await _repository.getTasks(
      searchQuery: _searchQuery,
      priority: _filterPriority,
      status: _filterStatus,
      dateFilter: _dateFilter,
    );
    final followups = await _repository.getFollowUps(
      searchQuery: _searchQuery,
    );

    if (mounted) {
      setState(() {
        _tasks = tasks;
        _followups = followups;
        _isLoading = false;
        _hasLoadedOnce = true;
      });
      if (savedOffset != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            final target = savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent);
            _scrollController.jumpTo(target);
          }
        });
      }
    }
  }

  List<TaskItem> get _filteredTasks {
    var list = _tasks;
    switch (_activeFilterPill) {
      case 'Today':
        list = list.where((t) => t.dueDate == 'Today').toList();
        break;
      case 'Upcoming':
        list = list.where((t) => t.dueDate != 'Today' && !t.isCompleted).toList();
        break;
      case 'Overdue':
        list = list.where((t) => t.dueDate == 'Yesterday' && !t.isCompleted).toList();
        break;
      case 'Completed':
        list = list.where((t) => t.isCompleted).toList();
        break;
      case 'All':
      default:
        break;
    }
    return list;
  }

  void _openCreateTaskDialog() {
    final titleCtrl = TextEditingController();
    final clientCtrl = TextEditingController();
    final projectCtrl = TextEditingController();
    final dueTimeCtrl = TextEditingController(text: '03:00 PM');
    TaskPriority priority = TaskPriority.high;
    String category = 'Execution';

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
              contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_task_rounded, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Create New Operational Task',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              content: SizedBox(
                width: 440,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFieldLabel('Task Title', isDark),
                      TextField(
                        controller: titleCtrl,
                        style: GoogleFonts.inter(fontSize: 12),
                        decoration: _inputDecoration('e.g. Laser inspect false ceiling framing', isDark),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Client Name', isDark),
                                TextField(
                                  controller: clientCtrl,
                                  style: GoogleFonts.inter(fontSize: 12),
                                  decoration: _inputDecoration('e.g. Rahul Sharma', isDark),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Project / Site', isDark),
                                TextField(
                                  controller: projectCtrl,
                                  style: GoogleFonts.inter(fontSize: 12),
                                  decoration: _inputDecoration('e.g. DLF Phase 5 Villa', isDark),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Priority', isDark),
                                Container(
                                  height: 38,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                                    borderRadius: AppRadius.sm,
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<TaskPriority>(
                                      value: priority,
                                      isExpanded: true,
                                      dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                                      items: TaskPriority.values.map((p) {
                                        return DropdownMenuItem(
                                          value: p,
                                          child: Row(
                                            children: [
                                              Icon(p.icon, size: 14, color: p.color),
                                              const SizedBox(width: 6),
                                              Text(p.label, style: GoogleFonts.inter(fontSize: 12)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setDialogState(() => priority = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Due Time', isDark),
                                TextField(
                                  controller: dueTimeCtrl,
                                  style: GoogleFonts.inter(fontSize: 12),
                                  decoration: _inputDecoration('03:00 PM', isDark),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleCtrl.text.trim().isEmpty) return;
                    final newTask = TaskItem(
                      id: 'TSK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      title: titleCtrl.text.trim(),
                      clientName: clientCtrl.text.trim().isEmpty ? 'Site Client' : clientCtrl.text.trim(),
                      projectName: projectCtrl.text.trim().isEmpty ? 'DLF Project' : projectCtrl.text.trim(),
                      priority: priority,
                      status: TaskStatus.todo,
                      dueDate: 'Today',
                      dueTime: dueTimeCtrl.text.trim(),
                      category: category,
                      assignedTo: widget.userName,
                    );
                    await _repository.createTask(newTask);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    _loadData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                  child: Text('Create Task', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      border: OutlineInputBorder(borderRadius: AppRadius.sm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          key: const PageStorageKey('dashboard_tasks_scroll'),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Common Header
              DashboardHeader(
                title: 'My Tasks & Follow-up Center',
                subtitle: 'Manage assigned operational execution, client calls & daily action items',
                icon: Icons.checklist_rounded,
                userName: widget.userName,
                activeDateFilter: _dateFilter,
                activeScopeFilter: _scopeFilter,
                onDateFilterChanged: (f) {
                  setState(() => _dateFilter = f);
                  _loadData();
                },
                onScopeFilterChanged: (s) {
                  setState(() => _scopeFilter = s);
                  _loadData();
                },
                onRefresh: _loadData,
                primaryAction: ElevatedButton.icon(
                  onPressed: _openCreateTaskDialog,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text(
                    '+ Create Task',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),

              // Non-disruptive inline indicator right below header
              DashboardInlineLoadingIndicator(isLoading: _isLoading && _hasLoadedOnce),

              if (_isLoading && !_hasLoadedOnce) ...[
                const DashboardSkeletonLoader(height: 88),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 52),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 380),
              ] else ...[
                // 2. Task Summary KPI Cards Row
                _buildTaskSummaryCards(isDark, isMobile, isTablet),
                const SizedBox(height: 18),

                // 3. Search & View Mode Switcher Strip
                _buildSearchAndFiltersStrip(isDark, isMobile),
                const SizedBox(height: 16),

                // 4. Multi-View Area (List / Kanban / Calendar) with Localized Loading
                LocalizedLoadingOverlay(
                  isLoading: _isLoading && _hasLoadedOnce,
                  message: 'Updating tasks...',
                  child: _buildViewContent(isDark, isMobile),
                ),
                const SizedBox(height: 24),

                // 5. Dedicated Follow-up Management Section
                _buildFollowUpManagementSection(isDark, isMobile),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION: TASK SUMMARY CARDS
  // ===========================================================================
  Widget _buildTaskSummaryCards(bool isDark, bool isMobile, bool isTablet) {
    final total = _tasks.length;
    final today = _tasks.where((t) => t.dueDate == 'Today').length;
    final completed = _tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;
    final overdue = _tasks.where((t) => t.dueDate == 'Yesterday' && !t.isCompleted).length;

    final cards = [
      _buildKpiCard('Total Tasks', '$total', 'assigned pipeline', const Color(0xFF6366F1), isDark),
      _buildKpiCard("Today's Tasks", '$today', 'actionable today', const Color(0xFF3B82F6), isDark),
      _buildKpiCard('Completed', '$completed', 'verified done', const Color(0xFF10B981), isDark),
      _buildKpiCard('Pending', '$pending', 'in progress / waiting', const Color(0xFFF59E0B), isDark),
      _buildKpiCard('Overdue', '$overdue', 'past SLA', const Color(0xFFEF4444), isDark),
    ];

    if (isMobile) {
      return SizedBox(
        height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: cards.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) => SizedBox(width: 145, child: cards[index]),
        ),
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList(),
    );
  }

  Widget _buildKpiCard(String label, String value, String sub, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: color),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION: SEARCH & FILTERS STRIP
  // ===========================================================================
  Widget _buildSearchAndFiltersStrip(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchBox(isDark),
                const SizedBox(height: 10),
                _buildFilterPills(isDark),
                const SizedBox(height: 10),
                _buildViewTabs(isDark),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 4, child: _buildSearchBox(isDark)),
                const SizedBox(width: 14),
                Expanded(flex: 5, child: _buildFilterPills(isDark)),
                const SizedBox(width: 14),
                _buildViewTabs(isDark),
              ],
            ),
    );
  }

  Widget _buildSearchBox(bool isDark) {
    return TextField(
      onChanged: (val) {
        _searchQuery = val;
        _loadData();
      },
      style: GoogleFonts.inter(fontSize: 12),
      decoration: InputDecoration(
        hintText: 'Search tasks, clients, projects...',
        hintStyle: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        prefixIcon: const Icon(Icons.search_rounded, size: 16),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(borderRadius: AppRadius.sm),
      ),
    );
  }

  Widget _buildFilterPills(bool isDark) {
    final pills = ['All', 'Today', 'Upcoming', 'Overdue', 'Completed'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: pills.map((p) {
          final isSel = _activeFilterPill == p;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(p),
              selected: isSel,
              showCheckmark: false,
              labelStyle: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                color: isSel ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              backgroundColor: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
              selectedColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
              onSelected: (_) => setState(() => _activeFilterPill = p),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildViewTabs(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.sm,
      ),
      child: TabBar(
        controller: _viewTabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: isDark ? Colors.white : AppColors.primary,
        unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        indicator: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
          borderRadius: AppRadius.xs,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
            ),
          ],
        ),
        tabs: const [
          Tab(text: 'List View'),
          Tab(text: 'Kanban'),
          Tab(text: 'Calendar'),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION: MULTI-VIEW CONTENT
  // ===========================================================================
  Widget _buildViewContent(bool isDark, bool isMobile) {
    return SizedBox(
      height: 480,
      child: TabBarView(
        controller: _viewTabController,
        children: [
          _buildListView(isDark, isMobile),
          _buildKanbanView(isDark, isMobile),
          _buildCalendarView(isDark, isMobile),
        ],
      ),
    );
  }

  // 1. List View
  Widget _buildListView(bool isDark, bool isMobile) {
    final tasks = _filteredTasks;
    if (tasks.isEmpty) {
      return const DashboardEmptyState(
        icon: Icons.done_all_rounded,
        title: 'No tasks found',
        message: 'No operational tasks match your active filters.',
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, _) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: () => TaskDetailDrawer.show(
                context,
                task: task,
                onTaskUpdated: (updated) => _loadData(),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Checkbox(
                value: task.isCompleted,
                activeColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (_) async {
                  await _repository.toggleTaskCompletion(task.id);
                  _loadData();
                },
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted
                            ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: task.priority.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.priority.label,
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: task.priority.color),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                '${task.projectName} • ${task.clientName} • Due ${task.dueDate} (${task.dueTime})',
                style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
            ),
          );
        },
      ),
    );
  }

  // 2. Kanban View
  Widget _buildKanbanView(bool isDark, bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildKanbanColumn(TaskStatus.todo, isDark)),
        const SizedBox(width: 10),
        Expanded(child: _buildKanbanColumn(TaskStatus.inProgress, isDark)),
        const SizedBox(width: 10),
        Expanded(child: _buildKanbanColumn(TaskStatus.waiting, isDark)),
        const SizedBox(width: 10),
        Expanded(child: _buildKanbanColumn(TaskStatus.completed, isDark)),
      ],
    );
  }

  Widget _buildKanbanColumn(TaskStatus status, bool isDark) {
    final colTasks = _tasks.where((t) => t.status == status).toList();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Column Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status.label,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: status.color),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(color: status.color, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '${colTasks.length}',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Task Cards
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: colTasks.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = colTasks[index];
                return InkWell(
                  onTap: () => TaskDetailDrawer.show(context, task: task, onTaskUpdated: (_) => _loadData()),
                  borderRadius: AppRadius.sm,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : Colors.white,
                      borderRadius: AppRadius.sm,
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(color: task.priority.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                task.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task.clientName,
                          style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task.dueTime,
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0xFF64748B)),
                            ),
                            if (task.checklist.isNotEmpty)
                              Text(
                                '${task.checklistCompletedCount}/${task.checklist.length}',
                                style: GoogleFonts.inter(fontSize: 9.5, color: const Color(0xFF10B981)),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 3. Calendar View
  Widget _buildCalendarView(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'September 2026',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left_rounded, size: 18)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right_rounded, size: 18)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Day Selector Strip
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(14, (i) {
                final day = DateTime(2026, 9, 1 + i);
                final isSelected = _selectedCalendarDay.day == day.day;
                return InkWell(
                  onTap: () => setState(() => _selectedCalendarDay = day),
                  borderRadius: AppRadius.sm,
                  child: Container(
                    width: 48,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9)),
                      borderRadius: AppRadius.sm,
                    ),
                    child: Column(
                      children: [
                        Text(
                          ['M', 'T', 'W', 'T', 'F', 'S', 'S'][day.weekday - 1],
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isSelected ? Colors.white70 : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tasks scheduled for September ${_selectedCalendarDay.day}, 2026',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _tasks.take(4).length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.sm,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      Text(
                        task.dueTime,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.title,
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        task.clientName,
                        style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION: DEDICATED FOLLOW-UP MANAGEMENT QUEUE
  // ===========================================================================
  Widget _buildFollowUpManagementSection(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.phone_in_talk_rounded, size: 18, color: Color(0xFF0EA5E9)),
                  const SizedBox(width: 8),
                  Text(
                    'Client Follow-up Telemetry Queue',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '${_followups.where((f) => !f.isDone).length} Pending Calls',
                style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: const Color(0xFF0EA5E9)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Follow-up cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _followups.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = _followups[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: item.sentiment == 'hot'
                        ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFollowupHeader(item, isDark),
                          const SizedBox(height: 8),
                          Text(item.notes, style: GoogleFonts.inter(fontSize: 11.5)),
                          const SizedBox(height: 10),
                          _buildFollowupActions(item),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFollowupHeader(item, isDark),
                                const SizedBox(height: 4),
                                Text(
                                  item.notes,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildFollowupActions(item),
                        ],
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFollowupHeader(FollowUpItem item, bool isDark) {
    return Row(
      children: [
        Text(
          item.clientName,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item.phone,
          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
          decoration: BoxDecoration(
            color: item.sentiment == 'hot'
                ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                : const Color(0xFFF59E0B).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item.sentiment.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: item.sentiment == 'hot' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
            ),
          ),
        ),
        const Spacer(),
        Text(
          item.scheduledTime,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildFollowupActions(FollowUpItem item) {
    return Wrap(
      spacing: 6,
      children: [
        IconButton.filledTonal(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Dialing ${item.phone}...')),
            );
          },
          icon: const Icon(Icons.call_rounded, size: 14),
          tooltip: 'Call Client',
        ),
        IconButton.filledTonal(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening WhatsApp template for ${item.clientName}...')),
            );
          },
          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
          tooltip: 'WhatsApp Client',
        ),
        IconButton.filledTonal(
          onPressed: () async {
            await _repository.completeFollowUp(item.id);
            _loadData();
          },
          icon: Icon(
            item.isDone ? Icons.check_circle : Icons.check_rounded,
            size: 14,
            color: item.isDone ? const Color(0xFF10B981) : null,
          ),
          tooltip: 'Mark Complete',
        ),
      ],
    );
  }
}

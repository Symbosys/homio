import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_kpi_card.dart';
import '../widgets/project_shared_widgets.dart';

/// Project Tasks page — provides list, kanban, and table views for project tasks,
/// with filter bars, inline status updating, and task creation.
class ProjectTasksPage extends StatefulWidget {
  const ProjectTasksPage({super.key});

  @override
  State<ProjectTasksPage> createState() => _ProjectTasksPageState();
}

class _ProjectTasksPageState extends State<ProjectTasksPage> {
  final _repo = ProjectsRepository();
  String? _selectedProjectId;
  String _searchQuery = '';
  ProjectTaskStatus? _statusFilter;
  ProjectTaskPriority? _priorityFilter;
  TaskViewMode _viewMode = TaskViewMode.list;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final active = _repo.projects.where((p) => p.status.isActive).toList();
    if (active.isNotEmpty) {
      _selectedProjectId = active.first.id;
    } else if (_repo.projects.isNotEmpty) {
      _selectedProjectId = _repo.projects.first.id;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  List<ProjectTask> get _filteredTasks {
    var list = _selectedProjectId != null
        ? _repo.getTasksForProject(_selectedProjectId!)
        : _repo.tasks;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((t) =>
          t.name.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q) ||
          t.assignee.toLowerCase().contains(q) ||
          t.areaRoom.toLowerCase().contains(q)).toList();
    }
    if (_statusFilter != null) {
      list = list.where((t) => t.status == _statusFilter).toList();
    }
    if (_priorityFilter != null) {
      list = list.where((t) => t.priority == _priorityFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tasks = _filteredTasks;

    final totalCount = tasks.length;
    final inProgressCount = tasks.where((t) => t.status == ProjectTaskStatus.inProgress).length;
    final completedCount = tasks.where((t) => t.status == ProjectTaskStatus.completed).length;
    final overdueCount = tasks.where((t) => t.isOverdue).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'Project Tasks',
              subtitle: 'Manage site operations, work items, and assignments',
              icon: Icons.checklist_rtl_rounded,
              actions: [
                _buildProjectSelector(isDark),
                const SizedBox(width: 8),
                _buildPriorityFilter(isDark),
                const SizedBox(width: 8),
                _buildStatusFilter(isDark),
                const SizedBox(width: 8),
                _buildViewToggle(isDark),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showCreateTaskDialog(context, isDark),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('New Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingSkeleton(isDark)
                  : RefreshIndicator(
                      onRefresh: () async => setState(() {}),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // KPI row
                            Row(
                              children: [
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Total Tasks',
                                    value: '$totalCount',
                                    icon: Icons.format_list_bulleted_rounded,
                                    iconColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'In Progress',
                                    value: '$inProgressCount',
                                    icon: Icons.pending_actions_rounded,
                                    iconColor: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Completed',
                                    value: '$completedCount',
                                    icon: Icons.task_alt_rounded,
                                    iconColor: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ProjectKpiCard(
                                    label: 'Overdue / Delayed',
                                    value: '$overdueCount',
                                    icon: Icons.warning_amber_rounded,
                                    iconColor: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Search bar
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                              ),
                              child: TextField(
                                onChanged: (v) => setState(() => _searchQuery = v),
                                style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Search tasks by name, description, assignee, room/area...',
                                  hintStyle: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // View rendering
                            if (tasks.isEmpty)
                              const ProjectEmptyState(
                                title: 'No tasks found',
                                description: 'Create a new task or adjust filters to view items.',
                                icon: Icons.checklist_rtl_rounded,
                              )
                            else if (_viewMode == TaskViewMode.kanban)
                              _buildKanbanBoard(tasks, isDark)
                            else if (_viewMode == TaskViewMode.table)
                              _buildTaskTable(tasks, isDark)
                            else
                              _buildTaskList(tasks, isDark),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<ProjectTask> tasks, bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task, isDark);
      },
    );
  }

  Widget _buildTaskCard(ProjectTask task, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: task.isOverdue
              ? AppColors.error.withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Checkbox to mark complete quickly
              Checkbox(
                value: task.status == ProjectTaskStatus.completed,
                activeColor: AppColors.success,
                onChanged: (val) {
                  final newStatus = (val ?? false) ? ProjectTaskStatus.completed : ProjectTaskStatus.inProgress;
                  _repo.updateTaskStatus(task.id, newStatus);
                  setState(() {});
                },
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: task.status == ProjectTaskStatus.completed ? TextDecoration.lineThrough : null,
                        color: task.status == ProjectTaskStatus.completed
                            ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildPriorityBadge(task.priority),
              const SizedBox(width: 8),
              _buildStatusMenu(task, isDark),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                if (task.areaRoom.isNotEmpty)
                  _buildMetaTag(Icons.meeting_room_outlined, task.areaRoom, isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                if (task.assignee.isNotEmpty)
                  _buildMetaTag(Icons.person_outline_rounded, task.assignee, isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                _buildMetaTag(
                  Icons.calendar_today_outlined,
                  'Due ${_formatDate(task.dueDate)}${task.isOverdue ? " (Overdue)" : ""}',
                  task.isOverdue ? AppColors.error : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                if (task.estimatedHours > 0)
                  _buildMetaTag(
                    Icons.schedule_rounded,
                    '${task.actualHours.toStringAsFixed(0)}h / ${task.estimatedHours.toStringAsFixed(0)}h',
                    isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                if (task.checklist.isNotEmpty)
                  _buildMetaTag(
                    Icons.checklist_rounded,
                    '${task.completedChecklistCount}/${task.checklist.length} done',
                    AppColors.primary,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTable(List<ProjectTask> tasks, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
          ),
          columns: const [
            DataColumn(label: Text('Task Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Room / Area', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Assignee', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Priority', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Due Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Hours', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
          ],
          rows: tasks.map((task) {
            return DataRow(
              cells: [
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(
                      task.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        decoration: task.status == ProjectTaskStatus.completed ? TextDecoration.lineThrough : null,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(task.areaRoom.isEmpty ? '—' : task.areaRoom, style: const TextStyle(fontSize: 12))),
                DataCell(Text(task.assignee.isEmpty ? '—' : task.assignee, style: const TextStyle(fontSize: 12))),
                DataCell(_buildPriorityBadge(task.priority)),
                DataCell(
                  Text(
                    _formatDate(task.dueDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: task.isOverdue ? AppColors.error : null,
                      fontWeight: task.isOverdue ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                DataCell(Text('${task.actualHours.toStringAsFixed(0)} / ${task.estimatedHours.toStringAsFixed(0)}h', style: const TextStyle(fontSize: 12))),
                DataCell(_buildStatusMenu(task, isDark)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildKanbanBoard(List<ProjectTask> tasks, bool isDark) {
    const columns = [
      ProjectTaskStatus.toDo,
      ProjectTaskStatus.inProgress,
      ProjectTaskStatus.waiting,
      ProjectTaskStatus.completed,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columns.map((status) {
          final colTasks = tasks.where((t) => t.status == status).toList();
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: status.color)),
                    const SizedBox(width: 6),
                    Text(
                      status.label,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: status.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                      child: Text('${colTasks.length}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: status.color)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (colTasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text('No tasks', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ),
                  )
                else
                  ...colTasks.map((t) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                decoration: t.status == ProjectTaskStatus.completed ? TextDecoration.lineThrough : null,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildPriorityBadge(t.priority),
                                Text(_formatDate(t.dueDate), style: TextStyle(fontSize: 10, color: t.isOverdue ? AppColors.error : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))),
                              ],
                            ),
                          ],
                        ),
                      )),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriorityBadge(ProjectTaskPriority priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priority.icon, size: 10, color: priority.color),
          const SizedBox(width: 3),
          Text(priority.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: priority.color)),
        ],
      ),
    );
  }

  Widget _buildStatusMenu(ProjectTask task, bool isDark) {
    return PopupMenuButton<ProjectTaskStatus>(
      initialValue: task.status,
      tooltip: 'Change Task Status',
      onSelected: (newStatus) {
        _repo.updateTaskStatus(task.id, newStatus);
        setState(() {});
      },
      itemBuilder: (context) => ProjectTaskStatus.values.map((s) {
        return PopupMenuItem(
          value: s,
          child: Row(
            children: [
              Icon(s.icon, size: 14, color: s.color),
              const SizedBox(width: 8),
              Text(s.label, style: TextStyle(fontSize: 12, color: s.color, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: task.status.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: task.status.color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(task.status.icon, size: 12, color: task.status.color),
            const SizedBox(width: 4),
            Text(task.status.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: task.status.color)),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 14, color: task.status.color),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaTag(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
      ],
    );
  }

  Widget _buildViewToggle(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleBtn(TaskViewMode.list, Icons.view_list_rounded, isDark),
          _buildToggleBtn(TaskViewMode.kanban, Icons.view_kanban_outlined, isDark),
          _buildToggleBtn(TaskViewMode.table, Icons.table_chart_outlined, isDark),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(TaskViewMode mode, IconData icon, bool isDark) {
    final isActive = _viewMode == mode;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _viewMode = mode),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive ? AppColors.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectSelector(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: _selectedProjectId,
          isDense: true,
          hint: Text('All Projects', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text('All Projects', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ..._repo.projects.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text('${p.code} — ${p.name}', style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _selectedProjectId = v),
        ),
      ),
    );
  }

  Widget _buildPriorityFilter(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProjectTaskPriority?>(
          value: _priorityFilter,
          isDense: true,
          hint: Text('Priority', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<ProjectTaskPriority?>(
              value: null,
              child: Text('All Priorities', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...ProjectTaskPriority.values.map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _priorityFilter = v),
        ),
      ),
    );
  }

  Widget _buildStatusFilter(bool isDark) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProjectTaskStatus?>(
          value: _statusFilter,
          isDense: true,
          hint: Text('Status', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: [
            DropdownMenuItem<ProjectTaskStatus?>(
              value: null,
              child: Text('All Statuses', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            ),
            ...ProjectTaskStatus.values.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.label, style: const TextStyle(fontSize: 12)),
                )),
          ],
          onChanged: (v) => setState(() => _statusFilter = v),
        ),
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final roomCtrl = TextEditingController();
    final assigneeCtrl = TextEditingController();
    final estHoursCtrl = TextEditingController(text: '8');
    ProjectTaskPriority priority = ProjectTaskPriority.medium;
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              title: Text('New Project Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Task Name *', hintText: 'e.g. Electrical conduit piping in Master Bedroom'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Description', hintText: 'Detailed task scope or specifications'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: roomCtrl,
                              decoration: const InputDecoration(labelText: 'Room / Area', hintText: 'e.g. Master Bedroom'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: assigneeCtrl,
                              decoration: const InputDecoration(labelText: 'Assignee', hintText: 'e.g. Rahul electrician'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<ProjectTaskPriority>(
                              initialValue: priority,
                              decoration: const InputDecoration(labelText: 'Priority'),
                              items: ProjectTaskPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.label, style: const TextStyle(fontSize: 12)))).toList(),
                              onChanged: (v) => setDialogState(() => priority = v ?? priority),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: estHoursCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Est. Hours', hintText: '8'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) return;
                    final newTask = ProjectTask(
                      id: 'task-${DateTime.now().millisecondsSinceEpoch}',
                      projectId: _selectedProjectId ?? (_repo.projects.isNotEmpty ? _repo.projects.first.id : 'proj-1'),
                      name: nameCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      areaRoom: roomCtrl.text.trim(),
                      assignee: assigneeCtrl.text.trim(),
                      priority: priority,
                      status: ProjectTaskStatus.toDo,
                      startDate: DateTime.now(),
                      dueDate: dueDate,
                      estimatedHours: double.tryParse(estHoursCtrl.text.trim()) ?? 8,
                      actualHours: 0,
                    );
                    _repo.addTask(newTask);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Create Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}';
  }

  Widget _buildLoadingSkeleton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProjectSkeleton.kpiRow(count: 4, isDark: isDark),
          const SizedBox(height: 16),
          ...List.generate(5, (_) => ProjectSkeleton.listTile(isDark: isDark)),
        ],
      ),
    );
  }
}

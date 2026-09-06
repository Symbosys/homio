import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';
import '../models/execution_mock_data.dart';
import '../widgets/execution_header.dart';
import '../widgets/execution_metric_card.dart';
import '../widgets/project_form_modal.dart';
import '../widgets/wbs_task_card.dart';
import '../widgets/task_reschedule_modal.dart';

class ExecutionProjectsPage extends StatefulWidget {
  const ExecutionProjectsPage({super.key});

  @override
  State<ExecutionProjectsPage> createState() => _ExecutionProjectsPageState();
}

class _ExecutionProjectsPageState extends State<ExecutionProjectsPage> {
  late List<ProjectMaster> _projects;
  String? _selectedProjectId;
  String _searchQuery = '';
  ContractModel? _selectedModel;
  ProjectStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _projects = List.from(ExecutionMockData.projects);
    if (_projects.isNotEmpty) {
      _selectedProjectId = _projects.first.id;
    }
  }

  ProjectMaster? get _currentProject {
    if (_projects.isEmpty) return null;
    return _projects.firstWhere(
      (p) => p.id == _selectedProjectId,
      orElse: () => _projects.first,
    );
  }

  List<ProjectMaster> get _filteredProjects {
    return _projects.where((p) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = p.projectName.toLowerCase().contains(q) ||
            p.projectCode.toLowerCase().contains(q) ||
            p.clientName.toLowerCase().contains(q) ||
            p.siteLocation.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedModel != null && p.contractModel != _selectedModel) {
        return false;
      }
      if (_selectedStatus != null && p.status != _selectedStatus) {
        return false;
      }
      return true;
    }).toList();
  }

  void _addNewProject() {
    ProjectFormModal.show(
      context: context,
      onSubmit: (newProj) {
        setState(() {
          _projects.insert(0, newProj);
          _selectedProjectId = newProj.id;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project "${newProj.projectName}" created successfully!')),
        );
      },
    );
  }

  void _editProject(ProjectMaster proj) {
    ProjectFormModal.show(
      context: context,
      initialProject: proj,
      onSubmit: (updated) {
        setState(() {
          final idx = _projects.indexWhere((p) => p.id == updated.id);
          if (idx != -1) {
            _projects[idx] = updated;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project "${updated.projectName}" updated.')),
        );
      },
    );
  }

  void _handleRescheduleTask(WbsTask task) {
    final proj = _currentProject;
    if (proj == null) return;

    TaskRescheduleModal.show(
      context: context,
      task: task,
      onConfirm: (rescheduleRecord) {
        setState(() {
          // Find stream and task
          for (final stream in proj.workStreams) {
            final tIndex = stream.tasks.indexWhere((t) => t.id == task.id);
            if (tIndex != -1) {
              final oldTask = stream.tasks[tIndex];
              final updatedHistory = List<RescheduleAuditRecord>.from(oldTask.rescheduleHistory)
                ..add(rescheduleRecord);

              stream.tasks[tIndex] = oldTask.copyWith(
                revisedEndDate: rescheduleRecord.revisedDate,
                rescheduleHistory: updatedHistory,
                delayReason: rescheduleRecord.reason,
              );
              break;
            }
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${task.title}" rescheduled. Delay reason logged in audit log.'),
            backgroundColor: AppColors.warning,
          ),
        );
      },
    );
  }

  void _handleToggleSubtask(WbsTask task, int subtaskIndex, bool done) {
    final proj = _currentProject;
    if (proj == null) return;

    setState(() {
      for (final stream in proj.workStreams) {
        final tIndex = stream.tasks.indexWhere((t) => t.id == task.id);
        if (tIndex != -1) {
          final oldTask = stream.tasks[tIndex];
          final updatedItems = List<WbsChecklistItem>.from(oldTask.checklist);
          updatedItems[subtaskIndex] = updatedItems[subtaskIndex].copyWith(isDone: done);

          final completedCount = updatedItems.where((i) => i.isDone).length;
          final newProgress = updatedItems.isEmpty ? 0.0 : completedCount / updatedItems.length;

          stream.tasks[tIndex] = oldTask.copyWith(
            checklist: updatedItems,
            progress: newProgress,
            status: newProgress == 1.0
                ? WbsTaskStatus.completed
                : (newProgress > 0 ? WbsTaskStatus.inProgress : WbsTaskStatus.notStarted),
          );
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = _filteredProjects;
    final current = _currentProject;

    // Metric Calculations
    final activeCount = _projects.where((p) => p.status == ProjectStatus.inProgress).length;
    final onTrackCount = _projects.where((p) => p.health == TimelineHealth.onTrack).length;
    final delayedCount = _projects.where((p) => p.health == TimelineHealth.delayed || p.health == TimelineHealth.atRisk).length;
    final totalBudget = _projects.fold<double>(0.0, (acc, p) => acc + p.totalContractValue);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            ExecutionHeader(
              title: 'Project Execution & WBS Master',
              subtitle: 'Multi-contract tracking, milestone work streams, tasks & delay audit controls',
              primaryActionLabel: 'New Project',
              primaryActionIcon: Icons.add,
              onPrimaryAction: _addNewProject,
              searchHint: 'Search projects, clients, codes...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting master execution schedule (Excel/PDF)...')),
                    );
                  },
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  label: const Text('Export WBS'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top KPI Metric Cards
            Row(
              children: [
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Active Projects',
                    value: '$activeCount',
                    subtitle: 'Of ${_projects.length} Total Projects',
                    icon: Icons.construction,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'On-Track Timeline',
                    value: '$onTrackCount',
                    subtitle: 'Milestones met to date',
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Delayed / At-Risk',
                    value: '$delayedCount',
                    subtitle: 'Requires supervisor audit',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Order Book',
                    value: '₹${(totalBudget / 100000).toStringAsFixed(1)}L',
                    subtitle: 'Combined contract value',
                    icon: Icons.currency_rupee,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filter Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 20, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Filters:',
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 14),
                  // Model filter
                  DropdownButton<ContractModel?>(
                    value: _selectedModel,
                    hint: const Text('Contract Model: All'),
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Contract Models')),
                      ...ContractModel.values.map(
                        (m) => DropdownMenuItem(value: m, child: Text(m.label)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedModel = v),
                  ),
                  const SizedBox(width: 20),
                  // Status filter
                  DropdownButton<ProjectStatus?>(
                    value: _selectedStatus,
                    hint: const Text('Status: All'),
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Statuses')),
                      ...ProjectStatus.values.map(
                        (s) => DropdownMenuItem(value: s, child: Text(s.label)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedStatus = v),
                  ),
                  const Spacer(),
                  Text(
                    'Showing ${filtered.length} of ${_projects.length} projects',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Two-Pane or Vertical Project Layout
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 1050;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Selector Column (Left)
                      SizedBox(
                        width: 360,
                        child: _buildProjectSelectorList(filtered, isDark),
                      ),
                      const SizedBox(width: 20),
                      // Detailed Project View & WBS Tasks (Right)
                      Expanded(
                        child: current != null
                            ? _buildProjectDetailWbs(current, isDark)
                            : const Center(child: Text('Select a project to view WBS details')),
                      ),
                    ],
                  );
                } else {
                  // Stacked layout for smaller devices
                  return Column(
                    children: [
                      _buildProjectSelectorList(filtered, isDark),
                      const SizedBox(height: 24),
                      if (current != null) _buildProjectDetailWbs(current, isDark),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSelectorList(List<ProjectMaster> list, bool isDark) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROJECT DIRECTORY',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, idx) {
            final p = list[idx];
            final isSelected = p.id == _selectedProjectId;

            return InkWell(
              onTap: () => setState(() => _selectedProjectId = p.id),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08)
                      : (isDark ? AppColors.darkCard : AppColors.lightCard),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            p.projectCode,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildHealthBadge(p.health),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.projectName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${p.clientName} • ${p.siteLocation}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: p.overallProgress,
                              minHeight: 6,
                              backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              color: p.health == TimelineHealth.delayed
                                  ? AppColors.error
                                  : (p.overallProgress == 1.0
                                      ? AppColors.success
                                      : AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(p.overallProgress * 100).toInt()}%',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Model badge & budget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            p.contractModel.label,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '₹${(p.totalContractValue / 100000).toStringAsFixed(1)}L',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
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

  Widget _buildProjectDetailWbs(ProjectMaster proj, bool isDark) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project Overview Hero Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
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
                              proj.projectName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            _buildHealthBadge(proj.health),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Client: ${proj.clientName} (${proj.clientPhone}) • Location: ${proj.siteLocation}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _editProject(proj),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Project'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 14),
              // Meta Row
              Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  _buildMetaCol('Contract Model', proj.contractModel.label, Icons.description_outlined),
                  _buildMetaCol('Supervisor', proj.siteSupervisorName, Icons.person_pin_outlined),
                  _buildMetaCol('Designer', proj.interiorDesignerName, Icons.brush_outlined),
                  _buildMetaCol('Contract Value', '₹${proj.totalContractValue.toStringAsFixed(0)}', Icons.payments_outlined),
                  _buildMetaCol(
                    'Timeline',
                    '${proj.startDate.day}/${proj.startDate.month}/${proj.startDate.year} → ${proj.expectedEndDate.day}/${proj.expectedEndDate.month}/${proj.expectedEndDate.year}',
                    Icons.date_range_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // WBS Work Streams Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Work Breakdown Structure (WBS)',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Milestone streams, granular task checklists & delay audit control',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddTaskDialog(proj),
              icon: const Icon(Icons.add_task, size: 18),
              label: const Text('Add WBS Task'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Milestone Streams & Tasks
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: proj.workStreams.length,
          separatorBuilder: (_, _) => const SizedBox(height: 20),
          itemBuilder: (context, sIdx) {
            final stream = proj.workStreams[sIdx];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stream Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.view_timeline, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stream.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Weightage: ${stream.weightagePercentage.toStringAsFixed(0)}% • Contractor: ${stream.contractorName}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: stream.isCompleted
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          stream.isCompleted
                              ? 'Stream Completed'
                              : '${(stream.streamProgress * 100).toInt()}% Done',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: stream.isCompleted ? AppColors.success : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Tasks inside this stream
                  if (stream.tasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text('No tasks created in this milestone stream yet.'),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stream.tasks.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, tIdx) {
                        final task = stream.tasks[tIdx];
                        return WbsTaskCard(
                          task: task,
                          onReschedule: () => _handleRescheduleTask(task),
                          onToggleSubtask: (subIdx, isDone) =>
                              _handleToggleSubtask(task, subIdx, isDone),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetaCol(String label, String val, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
            Text(
              val,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthBadge(TimelineHealth health) {
    Color bg;
    Color fg;
    switch (health) {
      case TimelineHealth.onTrack:
        bg = AppColors.success.withValues(alpha: 0.15);
        fg = AppColors.success;
        break;
      case TimelineHealth.atRisk:
        bg = AppColors.warning.withValues(alpha: 0.15);
        fg = AppColors.warning;
        break;
      case TimelineHealth.delayed:
        bg = AppColors.error.withValues(alpha: 0.15);
        fg = AppColors.error;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        health.label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAddTaskDialog(ProjectMaster proj) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final assignedController = TextEditingController(text: 'Rajesh Sharma Construction');
    var selectedStream = proj.workStreams.first;
    var priority = TaskPriority.high;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add WBS Task'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<MilestoneWorkStream>(
                  initialValue: selectedStream,
                  decoration: const InputDecoration(labelText: 'Milestone Stream'),
                  items: proj.workStreams
                      .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => selectedStream = v);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title *',
                    hintText: 'e.g. Master bedroom wall leveling & plaster',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Task Scope / Description',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: assignedController,
                  decoration: const InputDecoration(
                    labelText: 'Assigned Contractor / Trade',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskPriority>(
                  initialValue: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: TaskPriority.values
                      .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => priority = v);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                final newTask = WbsTask(
                  id: 'TASK-${DateTime.now().millisecondsSinceEpoch}',
                  streamId: selectedStream.id,
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                  assignedTo: assignedController.text.trim(),
                  priority: priority,
                  status: WbsTaskStatus.notStarted,
                  startDate: DateTime.now(),
                  plannedEndDate: DateTime.now().add(const Duration(days: 7)),
                  progress: 0.0,
                  checklist: [
                    WbsChecklistItem(id: 'c1', label: 'Initial site preparation & marking', isDone: false),
                    WbsChecklistItem(id: 'c2', label: 'Material arrival & quality verification', isDone: false),
                    WbsChecklistItem(id: 'c3', label: 'Execution & supervisor sign-off', isDone: false),
                  ],
                );

                setState(() {
                  selectedStream.tasks.add(newTask);
                });

                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Task "${newTask.title}" added to ${selectedStream.name}.')),
                );
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

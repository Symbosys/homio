import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';
import '../models/execution_mock_data.dart';
import '../widgets/execution_header.dart';
import '../widgets/execution_metric_card.dart';
import '../widgets/gantt_chart_widget.dart';
import '../widgets/task_reschedule_modal.dart';

class ExecutionGanttPage extends StatefulWidget {
  const ExecutionGanttPage({super.key});

  @override
  State<ExecutionGanttPage> createState() => _ExecutionGanttPageState();
}

class _ExecutionGanttPageState extends State<ExecutionGanttPage> {
  late List<ProjectMaster> _projects;
  String? _selectedProjectId;
  String? _selectedStreamId;
  bool _showBaselineComparison = true;

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

  void _handleReschedule(WbsTask task) {
    TaskRescheduleModal.show(
      context: context,
      task: task,
      onConfirm: (record) {
        setState(() {
          final proj = _currentProject;
          if (proj == null) return;
          for (final stream in proj.workStreams) {
            final idx = stream.tasks.indexWhere((t) => t.id == task.id);
            if (idx != -1) {
              final old = stream.tasks[idx];
              final updatedHistory = List<RescheduleAuditRecord>.from(old.rescheduleHistory)
                ..add(record);
              stream.tasks[idx] = old.copyWith(
                revisedEndDate: record.revisedDate,
                rescheduleHistory: updatedHistory,
                delayReason: record.reason,
              );
              break;
            }
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gantt updated: "${task.title}" shifted to ${record.revisedDate.day}/${record.revisedDate.month} with audit log.'),
            backgroundColor: AppColors.warning,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final proj = _currentProject;

    // Statistics for the Gantt page
    int totalTasks = 0;
    int completedTasks = 0;
    int delayedTasks = 0;
    int criticalPathCount = 0;

    if (proj != null) {
      for (final s in proj.workStreams) {
        for (final t in s.tasks) {
          totalTasks++;
          if (t.isCompleted) completedTasks++;
          if (t.isDelayed) delayedTasks++;
          if (t.priority == TaskPriority.critical || t.priority == TaskPriority.high) {
            criticalPathCount++;
          }
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ExecutionHeader(
              title: 'Interactive Gantt Chart & Timeline',
              subtitle: 'Visual baseline vs revised timeline, milestone dependencies & schedule slip analytics',
              primaryActionLabel: 'Audit Reschedule',
              primaryActionIcon: Icons.history_toggle_off,
              onPrimaryAction: () {
                if (proj != null && proj.workStreams.isNotEmpty && proj.workStreams.first.tasks.isNotEmpty) {
                  _handleReschedule(proj.workStreams.first.tasks.first);
                }
              },
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generating Gantt PDF export...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Export Gantt PDF'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Metrics Cards
            Row(
              children: [
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Tracked Tasks',
                    value: '$totalTasks',
                    subtitle: 'Across ${proj?.workStreams.length ?? 0} Work Streams',
                    icon: Icons.assignment_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Completed Tasks',
                    value: '$completedTasks',
                    subtitle: '${totalTasks > 0 ? ((completedTasks / totalTasks) * 100).toInt() : 0}% milestone velocity',
                    icon: Icons.task_alt,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Delayed Tasks',
                    value: '$delayedTasks',
                    subtitle: 'Mandatory reason logged',
                    icon: Icons.error_outline,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Critical Path Items',
                    value: '$criticalPathCount',
                    subtitle: 'High/Critical priority tasks',
                    icon: Icons.alt_route,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Controls & Filters Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Select Project
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.apartment, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedProjectId,
                        underline: const SizedBox(),
                        items: _projects.map((p) {
                          return DropdownMenuItem(
                            value: p.id,
                            child: Text(
                              '${p.projectName} (${p.projectCode})',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _selectedProjectId = v;
                              _selectedStreamId = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Filter Stream
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButton<String?>(
                        value: _selectedStreamId,
                        hint: const Text('All Milestone Streams'),
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Milestone Streams')),
                          if (proj != null)
                            ...proj.workStreams.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))),
                        ],
                        onChanged: (v) => setState(() => _selectedStreamId = v),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Baseline vs Revised toggle
                  FilterChip(
                    label: const Text('Show Baseline Comparison'),
                    selected: _showBaselineComparison,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: AppColors.primary,
                    onSelected: (val) => setState(() => _showBaselineComparison = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Gantt Chart Container
            if (proj != null)
              GanttChartWidget(
                project: proj,
                filteredStreamId: _selectedStreamId,
                showBaseline: _showBaselineComparison,
                onTaskTap: (task) => _handleReschedule(task),
              )
            else
              const Center(child: Text('No project selected.')),
          ],
        ),
      ),
    );
  }
}

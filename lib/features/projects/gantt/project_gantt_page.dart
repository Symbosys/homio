import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';
import '../widgets/project_page_header.dart';
import '../widgets/project_shared_widgets.dart';

/// Interactive Gantt chart page with Day/Week/Month zoom,
/// milestone bars, task bars, dependency visualization, and delay markers.
class ProjectGanttPage extends StatefulWidget {
  const ProjectGanttPage({super.key});

  @override
  State<ProjectGanttPage> createState() => _ProjectGanttPageState();
}

class _ProjectGanttPageState extends State<ProjectGanttPage> {
  final _repo = ProjectsRepository();
  String? _selectedProjectId;
  GanttZoomLevel _zoomLevel = GanttZoomLevel.week;
  bool _isLoading = true;
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final activeProjects = _repo.projects.where((p) => p.status.isActive).toList();
    if (activeProjects.isNotEmpty) {
      _selectedProjectId = activeProjects.first.id;
    } else if (_repo.projects.isNotEmpty) {
      _selectedProjectId = _repo.projects.first.id;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  List<GanttTaskItem> get _ganttItems {
    if (_selectedProjectId == null) return [];
    return _repo.getGanttItems(_selectedProjectId!);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            ProjectPageHeader(
              title: 'Gantt / Timeline',
              subtitle: 'Visual project schedule with dependencies',
              icon: Icons.waterfall_chart_outlined,
              actions: [
                _buildProjectSelector(isDark),
                const SizedBox(width: 8),
                _buildZoomSelector(isDark),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingSkeleton(isDark)
                  : _ganttItems.isEmpty
                      ? const ProjectEmptyState(
                          title: 'No tasks or milestones',
                          description: 'Add tasks to this project to see the Gantt chart.',
                          icon: Icons.waterfall_chart_outlined,
                        )
                      : _buildGanttChart(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGanttChart(bool isDark) {
    final items = _ganttItems;
    if (items.isEmpty) return const SizedBox.shrink();

    final earliest = items.map((i) => i.startDate).reduce((a, b) => a.isBefore(b) ? a : b);
    final latest = items.map((i) => i.endDate).reduce((a, b) => a.isAfter(b) ? a : b);
    final totalDays = latest.difference(earliest).inDays + 14;

    final dayWidth = _zoomLevel == GanttZoomLevel.day ? 40.0 : _zoomLevel == GanttZoomLevel.week ? 18.0 : _zoomLevel == GanttZoomLevel.month ? 6.0 : 2.0;
    final chartWidth = totalDays * dayWidth;
    const rowHeight = 42.0;
    const labelWidth = 240.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          children: [
            // Header row
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Container(
                    width: labelWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text('Task / Milestone', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: chartWidth,
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                        ),
                        child: _buildDateHeaders(earliest, totalDays, dayWidth, isDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Expanded(
              child: Row(
                children: [
                  // Task Labels
                  SizedBox(
                    width: labelWidth,
                    child: ListView.builder(
                      controller: _verticalScrollController,
                      itemCount: items.length,
                      itemExtent: rowHeight,
                      itemBuilder: (context, idx) {
                        final item = items[idx];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                              bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.3),
                            ),
                            color: idx.isEven ? Colors.transparent : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle).withValues(alpha: 0.3),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              if (item.isMilestone)
                                Icon(Icons.flag_rounded, size: 14, color: AppColors.secondary)
                              else
                                Icon(item.status.icon, size: 14, color: item.status.color),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: item.isMilestone ? FontWeight.w700 : FontWeight.w500,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Gantt Bars
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: chartWidth,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemExtent: rowHeight,
                          itemBuilder: (context, idx) {
                            final item = items[idx];
                            final startOffset = item.startDate.difference(earliest).inDays * dayWidth;
                            final barWidth = (item.durationDays.clamp(1, totalDays)) * dayWidth;

                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.3),
                                ),
                                color: idx.isEven ? Colors.transparent : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle).withValues(alpha: 0.3),
                              ),
                              child: Stack(
                                children: [
                                  // Today marker
                                  Positioned(
                                    left: DateTime.now().difference(earliest).inDays * dayWidth,
                                    top: 0, bottom: 0, width: 1.5,
                                    child: Container(color: AppColors.error.withValues(alpha: 0.4)),
                                  ),
                                  // Task bar
                                  Positioned(
                                    left: startOffset,
                                    top: item.isMilestone ? 8 : 10,
                                    child: item.isMilestone
                                        ? _buildMilestoneMarker(item)
                                        : _buildTaskBar(item, barWidth, isDark),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeaders(DateTime start, int totalDays, double dayWidth, bool isDark) {
    final months = <String>[];
    final days = <Widget>[];
    DateTime current = start;
    String lastMonth = '';

    for (int i = 0; i < totalDays; i++) {
      final monthStr = '${_monthName(current.month)} ${current.year}';
      if (monthStr != lastMonth) {
        months.add(monthStr);
        lastMonth = monthStr;
      }

      final isToday = current.year == DateTime.now().year &&
          current.month == DateTime.now().month &&
          current.day == DateTime.now().day;

      if (_zoomLevel == GanttZoomLevel.day || (_zoomLevel == GanttZoomLevel.week && current.weekday == 1)) {
        days.add(
          Container(
            width: _zoomLevel == GanttZoomLevel.day ? dayWidth : dayWidth * 7,
            alignment: Alignment.center,
            child: Text(
              _zoomLevel == GanttZoomLevel.day ? '${current.day}' : 'W${_weekNumber(current)}',
              style: TextStyle(
                fontSize: 9,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: isToday ? AppColors.error : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ),
          ),
        );
      }
      current = current.add(const Duration(days: 1));
    }

    return Row(children: days);
  }

  Widget _buildTaskBar(GanttTaskItem item, double barWidth, bool isDark) {
    final isDelayed = item.isDelayed;
    final barColor = isDelayed ? AppColors.error : item.status.color;

    return Tooltip(
      message: '${item.title}\n${item.assignee}\n${item.durationDays}d • ${(item.progress * 100).toStringAsFixed(0)}%',
      child: Container(
        width: barWidth.clamp(8, double.infinity),
        height: 22,
        decoration: BoxDecoration(
          color: barColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: barColor.withValues(alpha: 0.5), width: 0.5),
        ),
        child: Stack(
          children: [
            // Progress fill
            FractionallySizedBox(
              widthFactor: item.progress.clamp(0, 1),
              child: Container(
                decoration: BoxDecoration(
                  color: barColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            // Reschedule marker
            if (item.isRescheduled)
              Positioned(
                right: 2, top: 2,
                child: Icon(Icons.update_rounded, size: 10, color: AppColors.warning),
              ),
            // Label
            if (barWidth > 60)
              Center(
                child: Text(
                  item.title,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneMarker(GanttTaskItem item) {
    return Tooltip(
      message: '📍 ${item.title}\n${item.durationDays}d • ${(item.progress * 100).toStringAsFixed(0)}%',
      child: Container(
        width: 24, height: 24,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [BoxShadow(color: AppColors.secondary.withValues(alpha: 0.3), blurRadius: 4)],
        ),
        child: const Icon(Icons.flag_rounded, size: 12, color: Colors.white),
      ),
    );
  }

  Widget _buildProjectSelector(bool isDark) {
    return Container(
      height: 34, padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedProjectId, isDense: true,
          hint: Text('Project', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          icon: Icon(Icons.expand_more, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: _repo.projects.map((p) => DropdownMenuItem(value: p.id, child: Text('${p.code} — ${p.name}', style: const TextStyle(fontSize: 12)))).toList(),
          onChanged: (v) => setState(() => _selectedProjectId = v),
        ),
      ),
    );
  }

  Widget _buildZoomSelector(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: GanttZoomLevel.values.map((z) {
          final isActive = _zoomLevel == z;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _zoomLevel = z),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(z.label, style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _monthName(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[m - 1];
  }

  int _weekNumber(DateTime d) {
    final startOfYear = DateTime(d.year, 1, 1);
    return ((d.difference(startOfYear).inDays) / 7).ceil();
  }

  Widget _buildLoadingSkeleton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ProjectSkeleton.card(isDark: isDark, height: 400),
    );
  }
}

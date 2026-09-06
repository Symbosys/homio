import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/execution_models.dart';

enum GanttViewScale { days, weeks, months }

/// Professional interactive Gantt Chart Timeline with expandable WBS hierarchy,
/// baseline vs actual comparison, critical path flags, and delay audit controls.
class GanttChartWidget extends StatefulWidget {
  final ProjectMaster project;
  final String? filteredStreamId;
  final bool showBaseline;
  final ValueChanged<WbsTask>? onTaskTap;

  const GanttChartWidget({
    super.key,
    required this.project,
    this.filteredStreamId,
    this.showBaseline = true,
    this.onTaskTap,
  });

  @override
  State<GanttChartWidget> createState() => _GanttChartWidgetState();
}

class _GanttChartWidgetState extends State<GanttChartWidget> {
  final Set<String> _expandedStreamIds = {};
  GanttViewScale _viewScale = GanttViewScale.weeks;
  bool _highlightCriticalPath = true;

  @override
  void initState() {
    super.initState();
    _expandAll();
  }

  @override
  void didUpdateWidget(covariant GanttChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project.id != widget.project.id) {
      _expandAll();
    }
  }

  void _expandAll() {
    _expandedStreamIds.clear();
    for (final stream in widget.project.milestones) {
      _expandedStreamIds.add(stream.id);
    }
  }

  void _collapseAll() {
    setState(() {
      _expandedStreamIds.clear();
    });
  }

  void _toggleStream(String streamId) {
    setState(() {
      if (_expandedStreamIds.contains(streamId)) {
        _expandedStreamIds.remove(streamId);
      } else {
        _expandedStreamIds.add(streamId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final streams = widget.filteredStreamId != null
        ? widget.project.milestones
            .where((m) => m.id == widget.filteredStreamId)
            .toList()
        : widget.project.milestones;

    if (streams.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timeline_outlined, size: 48, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
              const SizedBox(height: 12),
              Text(
                'No Milestone Work Streams Configured',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Configure milestone work streams in the Project Master to view the interactive Gantt chart.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Determine timeline date bounds
    var minDate = widget.project.startDate;
    var maxDate = widget.project.targetHandoverDate;

    for (final s in streams) {
      if (s.startDate.isBefore(minDate)) minDate = s.startDate;
      if (s.endDate.isAfter(maxDate)) maxDate = s.endDate;
      for (final t in s.tasks) {
        if (t.startDate.isBefore(minDate)) minDate = t.startDate;
        if (t.currentDueDate.isAfter(maxDate)) maxDate = t.currentDueDate;
        if (t.originalTargetDate.isAfter(maxDate)) maxDate = t.originalTargetDate;
      }
    }

    // Add padding days
    minDate = minDate.subtract(const Duration(days: 3));
    maxDate = maxDate.add(const Duration(days: 7));
    final totalDays = maxDate.difference(minDate).inDays.clamp(14, 400);

    // Compute metrics
    int totalTaskCount = 0;
    int completedCount = 0;
    int delayedCount = 0;
    int criticalCount = 0;
    for (final s in streams) {
      for (final t in s.tasks) {
        totalTaskCount++;
        if (t.isCompleted) completedCount++;
        if (t.isDelayed) delayedCount++;
        if (t.priority == TaskPriority.critical || t.priority == TaskPriority.high) {
          criticalCount++;
        }
      }
    }

    const double leftPanelWidth = 380;
    const double chartCanvasWidth = 850;
    final totalWidth = leftPanelWidth + chartCanvasWidth;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------------------------
          // 1. Interactive Control Toolbar
          // -----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                // Title & Health Status
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.waterfall_chart_rounded, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Interactive Gantt Schedule',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.project.timelineHealth.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.project.timelineHealth.label,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: widget.project.timelineHealth.color,
                        ),
                      ),
                    ),
                  ],
                ),

                // View Scale & Toggles
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // View Scale Segmented Pill
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildScaleButton('Days', GanttViewScale.days),
                          _buildScaleButton('Weeks', GanttViewScale.weeks),
                          _buildScaleButton('Months', GanttViewScale.months),
                        ],
                      ),
                    ),

                    // Expand / Collapse All
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _expandedStreamIds.length == streams.length
                          ? _collapseAll
                          : () => setState(_expandAll),
                      icon: Icon(
                        _expandedStreamIds.length == streams.length
                            ? Icons.unfold_less
                            : Icons.unfold_more,
                        size: 14,
                      ),
                      label: Text(
                        _expandedStreamIds.length == streams.length ? 'Collapse All' : 'Expand All',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),

                    // Critical Path Highlight Toggle
                    FilterChip(
                      label: const Text('Critical Path'),
                      selected: _highlightCriticalPath,
                      selectedColor: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      checkmarkColor: const Color(0xFFEF4444),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _highlightCriticalPath ? const Color(0xFFEF4444) : null,
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: (val) => setState(() => _highlightCriticalPath = val),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // -----------------------------------------------------------------
          // 2. Legend Strip
          // -----------------------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: isDark ? AppColors.darkCard.withValues(alpha: 0.5) : AppColors.lightCard.withValues(alpha: 0.5),
            child: Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                _buildLegendItem('Completed', AppColors.success),
                _buildLegendItem('In Progress', AppColors.primary),
                _buildLegendItem('Delayed / Slipped', AppColors.error),
                if (widget.showBaseline)
                  _buildDashedLegendItem('Baseline Plan', Colors.grey),
                if (_highlightCriticalPath)
                  _buildLegendItem('Critical Path Task', const Color(0xFFDC2626)),
                const SizedBox(width: 8),
                Text(
                  '💡 Tip: Click any task to open audit reschedule modal',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // -----------------------------------------------------------------
          // 3. Scrollable Dual-Pane Gantt Matrix
          // -----------------------------------------------------------------
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline Header Ruler (Dual Pane)
                  Container(
                    height: 38,
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    child: Row(
                      children: [
                        // Left Panel Title
                        SizedBox(
                          width: leftPanelWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                Text(
                                  'WORK BREAKDOWN (WBS)',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'DATES / STATUS',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Right Timeline Date Ruler
                        SizedBox(
                          width: chartCanvasWidth,
                          child: _buildTimelineRuler(minDate, maxDate, totalDays, isDark),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Stream & Task Rows
                  ...streams.map((stream) {
                    final isExpanded = _expandedStreamIds.contains(stream.id);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Milestone Stream Row
                        _buildStreamRow(stream, minDate, totalDays, chartCanvasWidth, leftPanelWidth, isDark, isExpanded),
                        const Divider(height: 1),

                        // Granular Tasks Rows (if expanded)
                        if (isExpanded)
                          ...stream.tasks.map((task) {
                            return Column(
                              children: [
                                _buildTaskRow(task, stream, minDate, totalDays, chartCanvasWidth, leftPanelWidth, isDark),
                                const Divider(height: 1),
                              ],
                            );
                          }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // -----------------------------------------------------------------
          // 4. Gantt Summary Footer Analytics
          // -----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 20,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildSummaryBadge(
                  Icons.assignment_outlined,
                  '$totalTaskCount Tasks',
                  'Total WBS Units',
                  AppColors.primary,
                ),
                _buildSummaryBadge(
                  Icons.check_circle_outline,
                  '$completedCount Done',
                  '${totalTaskCount > 0 ? ((completedCount / totalTaskCount) * 100).toInt() : 0}% velocity',
                  AppColors.success,
                ),
                _buildSummaryBadge(
                  Icons.warning_amber_rounded,
                  '$delayedCount Slipped',
                  'Delay audited',
                  delayedCount > 0 ? AppColors.error : AppColors.success,
                ),
                _buildSummaryBadge(
                  Icons.alt_route,
                  '$criticalCount Critical',
                  'High priority path',
                  AppColors.warning,
                ),
                const Spacer(),
                Text(
                  'Handover Target: ${_formatFullDate(widget.project.targetHandoverDate)} (${widget.project.targetHandoverDate.difference(DateTime.now()).inDays} days remaining)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Stream Row Widget
  // ---------------------------------------------------------------------------
  Widget _buildStreamRow(
    MilestoneWorkStream stream,
    DateTime minDate,
    int totalDays,
    double canvasWidth,
    double leftWidth,
    bool isDark,
    bool isExpanded,
  ) {
    final startOffset = stream.startDate.difference(minDate).inDays.clamp(0, totalDays);
    final duration = stream.endDate.difference(stream.startDate).inDays.clamp(1, totalDays);
    final leftFrac = (startOffset / totalDays).clamp(0.0, 0.90);
    final widthFrac = (duration / totalDays).clamp(0.05, 1.0 - leftFrac);

    final Color color = stream.completionPercentage >= 1.0
        ? AppColors.success
        : stream.completionPercentage > 0.0
            ? AppColors.primary
            : Colors.grey;

    return InkWell(
      onTap: () => _toggleStream(stream.id),
      child: Container(
        color: isDark
            ? AppColors.darkSurfaceSubtle.withValues(alpha: 0.6)
            : AppColors.lightSurfaceSubtle.withValues(alpha: 0.6),
        child: Row(
          children: [
            // Left Panel WBS Info
            SizedBox(
              width: leftWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stream.name,
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${stream.tasks.length} tasks • ${_formatShortDate(stream.startDate)} → ${_formatShortDate(stream.endDate)}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${(stream.completionPercentage * 100).toInt()}%',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Canvas: Milestone Duration Bracket
            SizedBox(
              width: canvasWidth,
              height: 38,
              child: Stack(
                children: [
                  _buildTodayMarker(minDate, totalDays, canvasWidth, isDark),
                  Positioned(
                    left: leftFrac * canvasWidth,
                    width: widthFrac * canvasWidth,
                    top: 8,
                    bottom: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: isDark ? 0.25 : 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: color, width: 1.2),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: stream.completionPercentage.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${stream.name} (${(stream.completionPercentage * 100).toInt()}%)',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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

  // ---------------------------------------------------------------------------
  // Granular Task Row Widget
  // ---------------------------------------------------------------------------
  Widget _buildTaskRow(
    WbsTask task,
    MilestoneWorkStream stream,
    DateTime minDate,
    int totalDays,
    double canvasWidth,
    double leftWidth,
    bool isDark,
  ) {
    final startOffset = task.startDate.difference(minDate).inDays.clamp(0, totalDays);
    final duration = task.currentDueDate.difference(task.startDate).inDays.clamp(1, totalDays);
    final leftFrac = (startOffset / totalDays).clamp(0.0, 0.90);
    final widthFrac = (duration / totalDays).clamp(0.04, 1.0 - leftFrac);

    // Baseline calculation
    final baseDuration = task.originalTargetDate.difference(task.startDate).inDays.clamp(1, totalDays);
    final baseWidthFrac = (baseDuration / totalDays).clamp(0.04, 1.0 - leftFrac);

    final isCritical = _highlightCriticalPath &&
        (task.priority == TaskPriority.critical || task.priority == TaskPriority.urgent);

    final Color barColor = task.isCompleted
        ? AppColors.success
        : task.isDelayed
            ? AppColors.error
            : AppColors.primary;

    return InkWell(
      onTap: () => widget.onTaskTap?.call(task),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Left Task Info
            SizedBox(
              width: leftWidth,
              child: Padding(
                padding: const EdgeInsets.only(left: 32, right: 10),
                child: Row(
                  children: [
                    // Critical Path / Status Bullet
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: isCritical ? const Color(0xFFDC2626) : barColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                task.id,
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${task.assigneeName} • ${_formatShortDate(task.startDate)} → ${_formatShortDate(task.currentDueDate)}',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                                ),
                              ),
                              if (task.isDelayed) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    '+${task.daysDelayed}d slip',
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.error),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_calendar_outlined, size: 14),
                      tooltip: 'Reschedule / Audit Task',
                      onPressed: () => widget.onTaskTap?.call(task),
                    ),
                  ],
                ),
              ),
            ),

            // Right Canvas: Interactive Task Bar
            SizedBox(
              width: canvasWidth,
              height: 36,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildTodayMarker(minDate, totalDays, canvasWidth, isDark),

                  // Baseline Bar (Ghost/Muted outline)
                  if (widget.showBaseline && task.isDelayed)
                    Positioned(
                      left: leftFrac * canvasWidth,
                      width: baseWidthFrac * canvasWidth,
                      top: 4,
                      bottom: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.6),
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Base: ${_formatShortDate(task.originalTargetDate)}',
                          style: GoogleFonts.inter(fontSize: 8, color: Colors.grey),
                        ),
                      ),
                    ),

                  // Actual / Revised Task Bar
                  Positioned(
                    left: leftFrac * canvasWidth,
                    width: widthFrac * canvasWidth,
                    top: widget.showBaseline && task.isDelayed ? 10 : 6,
                    bottom: 6,
                    child: Tooltip(
                      message: '${task.title}\nDue: ${_formatShortDate(task.currentDueDate)}\nAssignee: ${task.assigneeName}${task.isDelayed ? '\nDelay: +${task.daysDelayed} days (${task.delayReason ?? 'No reason logged'})' : ''}',
                      child: Container(
                        decoration: BoxDecoration(
                          color: barColor.withValues(alpha: isDark ? 0.35 : 0.25),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isCritical ? const Color(0xFFDC2626) : barColor,
                            width: isCritical ? 1.8 : 1.0,
                          ),
                          boxShadow: isCritical
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFDC2626).withValues(alpha: 0.25),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Stack(
                          children: [
                            // Progress Fill
                            FractionallySizedBox(
                              widthFactor: task.progress.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: barColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            // Label inside bar
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  '${task.title} (${(task.progress * 100).toInt()}%)',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: task.progress > 0.4 ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
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

  // ---------------------------------------------------------------------------
  // Timeline Date Ruler
  // ---------------------------------------------------------------------------
  Widget _buildTimelineRuler(DateTime minDate, DateTime maxDate, int totalDays, bool isDark) {
    final intervalCount = _viewScale == GanttViewScale.days ? 14 : (_viewScale == GanttViewScale.weeks ? 8 : 5);
    final intervalDays = totalDays / intervalCount;

    return Row(
      children: List.generate(intervalCount, (idx) {
        final date = minDate.add(Duration(days: (idx * intervalDays).toInt()));
        return Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 0.8,
                ),
              ),
            ),
            child: Text(
              _formatShortDate(date),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Today Guide Marker
  // ---------------------------------------------------------------------------
  Widget _buildTodayMarker(DateTime minDate, int totalDays, double canvasWidth, bool isDark) {
    final now = DateTime.now();
    final todayOffset = now.difference(minDate).inDays;
    if (todayOffset < 0 || todayOffset > totalDays) return const SizedBox();

    final todayFrac = (todayOffset / totalDays).clamp(0.0, 1.0);

    return Positioned(
      left: todayFrac * canvasWidth,
      top: 0,
      bottom: 0,
      child: Container(
        width: 2,
        color: AppColors.primary.withValues(alpha: 0.85),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper Widgets
  // ---------------------------------------------------------------------------
  Widget _buildScaleButton(String label, GanttViewScale scale) {
    final isSelected = _viewScale == scale;
    return InkWell(
      onTap: () => setState(() => _viewScale = scale),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDashedLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 6,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSummaryBadge(IconData icon, String val, String sub, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(val, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
            Text(sub, style: GoogleFonts.inter(fontSize: 9, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  String _formatShortDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';

  String _formatFullDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

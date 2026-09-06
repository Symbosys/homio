import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/dashboard_mock_data.dart';
import '../models/dashboard_models.dart';

// ============================================================================
// 1. 30-DAY VELOCITY AREA / LINE CHART
// ============================================================================
class DashboardVelocityLineChart extends StatelessWidget {
  final List<({int day, double score})> dataPoints;
  final String title;

  const DashboardVelocityLineChart({
    super.key,
    this.dataPoints = DashboardMockData.velocityTrend30Days,
    this.title = '30-Day Productivity & Velocity Trend',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart_rounded, size: 16, color: Color(0xFF6366F1)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  'Peak 94.2%',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}%',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (val, meta) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Day ${val.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: 30,
                minY: 75,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints.map((p) => FlSpot(p.day.toDouble(), p.score)).toList(),
                    isCurved: true,
                    color: const Color(0xFF6366F1),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 3,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: const Color(0xFF6366F1),
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: isDark ? 0.35 : 0.2),
                          const Color(0xFF6366F1).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. WEEKLY TASK VELOCITY GROUPED BAR CHART
// ============================================================================
class DashboardWeeklyTaskBarChart extends StatelessWidget {
  final List<({String day, int completed, int target})> weeklyData;

  const DashboardWeeklyTaskBarChart({
    super.key,
    this.weeklyData = DashboardMockData.weeklyTaskStats,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, size: 16, color: Color(0xFF0EA5E9)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Weekly Task Clearance vs Target',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendIndicator('Done', const Color(0xFF0EA5E9), isDark),
                  const SizedBox(width: 8),
                  _buildLegendIndicator('Target', isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1), isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 16,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 4,
                      reservedSize: 22,
                      getTitlesWidget: (val, meta) => Text(
                        val.toInt().toString(),
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx >= 0 && idx < weeklyData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              weeklyData[idx].day,
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF334155),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(weeklyData.length, (idx) {
                  final item = weeklyData[idx];
                  return BarChartGroupData(
                    x: idx,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: item.completed.toDouble(),
                        color: const Color(0xFF0EA5E9),
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                      BarChartRodData(
                        toY: item.target.toDouble(),
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        width: 6,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(2),
                          topRight: Radius.circular(2),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendIndicator(String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 3. DEPARTMENT WORKLOAD DONUT / PIE CHART
// ============================================================================
class DashboardWorkloadDonutChart extends StatelessWidget {
  final List<DepartmentWorkload> departments;

  const DashboardWorkloadDonutChart({
    super.key,
    this.departments = DashboardMockData.departmentWorkloads,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart_rounded, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Workload by Department',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 32,
                    sections: departments.map((w) {
                      return PieChartSectionData(
                        value: w.percentage,
                        color: w.color,
                        radius: 18,
                        showTitle: false,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: departments.map((w) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: w.color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              w.departmentName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                          Text(
                            '${w.percentage.toInt()}%',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ============================================================================
// 4. TASK PRIORITY BAR CHART
// ============================================================================
class DashboardTaskPriorityBarChart extends StatelessWidget {
  final List<DashboardTaskItem> tasks;

  const DashboardTaskPriorityBarChart({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final urgentCount = tasks.where((t) => t.priority.toLowerCase() == 'urgent').length;
    final highCount = tasks.where((t) => t.priority.toLowerCase() == 'high').length;
    final mediumCount = tasks.where((t) => t.priority.toLowerCase() == 'medium').length;
    final lowCount = tasks.where((t) => t.priority.toLowerCase() == 'low').length;

    final data = [
      (label: 'Urgent', count: urgentCount, color: const Color(0xFFEF4444)),
      (label: 'High', count: highCount, color: const Color(0xFFF97316)),
      (label: 'Medium', count: mediumCount, color: const Color(0xFF3B82F6)),
      (label: 'Low', count: lowCount, color: const Color(0xFF10B981)),
    ];

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stacked_bar_chart, size: 16, color: Color(0xFFF97316)),
              const SizedBox(width: 8),
              Text(
                'Task Distribution by Priority',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 20,
                      getTitlesWidget: (val, meta) => Text(
                        val.toInt().toString(),
                        style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx >= 0 && idx < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              data[idx].label,
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: data[idx].color,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(data.length, (idx) {
                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: data[idx].count.toDouble(),
                        color: data[idx].color,
                        width: 18,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 5. FOLLOWUP CONVERSION TREND SPLINE CHART
// ============================================================================
class DashboardFollowupConversionChart extends StatelessWidget {
  final List<({int week, double rate})> points;

  const DashboardFollowupConversionChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Followup-to-Meeting Conversion Rate',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '75.5% Conversion',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}%',
                        style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Week ${val.toInt()}',
                          style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: 4,
                minY: 30,
                maxY: 90,
                lineBarsData: [
                  LineChartBarData(
                    spots: points.map((p) => FlSpot(p.week.toDouble(), p.rate)).toList(),
                    isCurved: true,
                    color: const Color(0xFF10B981),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF10B981).withValues(alpha: isDark ? 0.3 : 0.15),
                          const Color(0xFF10B981).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 6. ATTENDANCE WORK HOURS BAR CHART
// ============================================================================
class DashboardAttendanceHoursBarChart extends StatelessWidget {
  final List<({int day, double hours})> dailyHours;

  const DashboardAttendanceHoursBarChart({super.key, required this.dailyHours});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF0EA5E9)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Daily Work Duration (Past 30 Days)',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Text(
                'Target: 8.0 hrs/day',
                style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF10B981), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                maxY: 12,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 22,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}h',
                        style: GoogleFonts.inter(fontSize: 9, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 4,
                      getTitlesWidget: (val, meta) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'D${val.toInt()}',
                          style: GoogleFonts.inter(fontSize: 9, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: dailyHours.map((d) {
                  return BarChartGroupData(
                    x: d.day,
                    barRods: [
                      BarChartRodData(
                        toY: d.hours,
                        color: d.hours >= 8.0 ? const Color(0xFF0EA5E9) : const Color(0xFFF59E0B),
                        width: 7,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(2),
                          topRight: Radius.circular(2),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 7. ATTENDANCE STATUS DONUT CHART
// ============================================================================
class DashboardAttendanceStatusDonutChart extends StatelessWidget {
  final int presentDays;
  final int lateDays;
  final int leaveDays;

  const DashboardAttendanceStatusDonutChart({
    super.key,
    required this.presentDays,
    required this.lateDays,
    required this.leaveDays,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.donut_large, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Text(
                'Attendance Status Ratio',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(value: presentDays.toDouble(), color: const Color(0xFF10B981), radius: 18, showTitle: false),
                      PieChartSectionData(value: lateDays.toDouble(), color: const Color(0xFFF59E0B), radius: 18, showTitle: false),
                      PieChartSectionData(value: leaveDays.toDouble(), color: const Color(0xFF8B5CF6), radius: 18, showTitle: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatusRow('Present', presentDays, const Color(0xFF10B981), isDark),
                    const SizedBox(height: 6),
                    _buildStatusRow('Late (Grace)', lateDays, const Color(0xFFF59E0B), isDark),
                    const SizedBox(height: 6),
                    _buildStatusRow('Leave', leaveDays, const Color(0xFF8B5CF6), isDark),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, int count, Color color, bool isDark) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
        Text(
          '$count days',
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
        ),
      ],
    );
  }
}

// ============================================================================
// 8. TRAVEL MILEAGE LINE CHART
// ============================================================================
class DashboardTravelMileageLineChart extends StatelessWidget {
  final List<({int day, double km})> dataPoints;

  const DashboardTravelMileageLineChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.route_outlined, size: 16, color: Color(0xFF0EA5E9)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '30-Day Travel Mileage & Distance Log (km)',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Text(
                'Total: 486 km',
                style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFF0EA5E9)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 26,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}k',
                        style: GoogleFonts.inter(fontSize: 9, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (val, meta) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'D${val.toInt()}',
                          style: GoogleFonts.inter(fontSize: 9, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: 30,
                minY: 0,
                maxY: 40,
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints.map((p) => FlSpot(p.day.toDouble(), p.km)).toList(),
                    isCurved: true,
                    color: const Color(0xFF0EA5E9),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0EA5E9).withValues(alpha: isDark ? 0.3 : 0.15),
                          const Color(0xFF0EA5E9).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 9. FIELD VISIT PURPOSE PIE CHART
// ============================================================================
class DashboardVisitPurposePieChart extends StatelessWidget {
  final List<FieldVisitItem> visits;

  const DashboardVisitPurposePieChart({super.key, required this.visits});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart, size: 16, color: Color(0xFF6366F1)),
              const SizedBox(width: 8),
              Text(
                'Visit Purpose Categorization',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 28,
                    sections: [
                      PieChartSectionData(value: 40, color: const Color(0xFF6366F1), radius: 18, showTitle: false),
                      PieChartSectionData(value: 30, color: const Color(0xFF10B981), radius: 18, showTitle: false),
                      PieChartSectionData(value: 20, color: const Color(0xFFF59E0B), radius: 18, showTitle: false),
                      PieChartSectionData(value: 10, color: const Color(0xFF0EA5E9), radius: 18, showTitle: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLegendItem('Inspection (40%)', const Color(0xFF6366F1), isDark),
                    const SizedBox(height: 5),
                    _buildLegendItem('Client Review (30%)', const Color(0xFF10B981), isDark),
                    const SizedBox(height: 5),
                    _buildLegendItem('Material Audit (20%)', const Color(0xFFF59E0B), isDark),
                    const SizedBox(height: 5),
                    _buildLegendItem('Measurement (10%)', const Color(0xFF0EA5E9), isDark),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDark) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 10. 6-MONTH INCENTIVE PROGRESSION BAR CHART
// ============================================================================
class DashboardIncentiveProgressionBarChart extends StatelessWidget {
  final List<({String month, double amount})> monthlyIncentives;

  const DashboardIncentiveProgressionBarChart({super.key, required this.monthlyIncentives});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stacked_line_chart, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '6-Month Incentive Progression (₹)',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Text(
                'Sep: ₹28,500',
                style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFF10B981)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 35000,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10000,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10000,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) => Text(
                        '${(val / 1000).toInt()}k',
                        style: GoogleFonts.inter(fontSize: 9, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx >= 0 && idx < monthlyIncentives.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              monthlyIncentives[idx].month,
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppColors.lightTextPrimary,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(monthlyIncentives.length, (idx) {
                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: monthlyIncentives[idx].amount,
                        color: const Color(0xFF10B981),
                        width: 14,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 11. EARNINGS STREAMS BREAKDOWN DONUT CHART
// ============================================================================
class DashboardEarningsDonutChart extends StatelessWidget {
  final double salary;
  final double incentives;
  final double travel;

  const DashboardEarningsDonutChart({
    super.key,
    required this.salary,
    required this.incentives,
    required this.travel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = salary + incentives + travel;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart, size: 16, color: Color(0xFF0EA5E9)),
              const SizedBox(width: 8),
              Text(
                'Earnings Streams Composition',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(value: salary, color: const Color(0xFF0EA5E9), radius: 18, showTitle: false),
                      PieChartSectionData(value: incentives, color: const Color(0xFF10B981), radius: 18, showTitle: false),
                      PieChartSectionData(value: travel, color: const Color(0xFF6366F1), radius: 18, showTitle: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStreamRow('Base Salary', salary, total, const Color(0xFF0EA5E9), isDark),
                    const SizedBox(height: 6),
                    _buildStreamRow('Incentives', incentives, total, const Color(0xFF10B981), isDark),
                    const SizedBox(height: 6),
                    _buildStreamRow('Travel Claims', travel, total, const Color(0xFF6366F1), isDark),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildStreamRow(String label, double amount, double total, Color color, bool isDark) {
    final pct = ((amount / total) * 100).toStringAsFixed(0);
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
        Text(
          '$pct%',
          style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/dashboard_mock_data.dart';
import '../models/dashboard_models.dart';
import '../widgets/compact_data_table.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_metric_card.dart';
import '../widgets/productivity_score_ring.dart';

/// Executive Owner/Management Overview & Score Dashboard.
/// Features live KPI metrics, velocity charts, workload distribution,
/// and productivity score gauges.
class DashboardOverviewPage extends StatefulWidget {
  const DashboardOverviewPage({super.key});

  @override
  State<DashboardOverviewPage> createState() => _DashboardOverviewPageState();
}

class _DashboardOverviewPageState extends State<DashboardOverviewPage> {
  DashboardDateFilter _dateFilter = DashboardDateFilter.today;

  void _handleFilterChange(DashboardDateFilter filter) {
    setState(() {
      _dateFilter = filter;
    });
  }

  void _handleRefresh() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Dashboard metrics refreshed',
          style: GoogleFonts.inter(fontSize: 12),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
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
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with filter & actions
              DashboardHeader(
                title: 'Overview & Velocity Score',
                subtitle: 'Real-time team execution metrics, productivity index & operational telemetry',
                icon: Icons.dashboard_outlined,
                activeFilter: _dateFilter,
                onFilterChanged: _handleFilterChange,
                onRefresh: _handleRefresh,
                primaryAction: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 14),
                  label: Text(
                    'Export Report',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
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

              // Alert strip / Critical Broadcast Banner
              _buildAlertBanner(isDark),
              const SizedBox(height: 16),

              // 4 Executive KPI Cards
              _buildKpiGrid(isMobile, isTablet),
              const SizedBox(height: 18),

              // Productivity Score Gauge & 30-Day Velocity Line Chart Row
              _buildScoreAndVelocityRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Weekly Task Volume Grouped Bar Chart & Department Workload Donut Chart Row
              _buildBarAndDonutRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Actionable Feed: Today's Tasks preview & Active Field Visits
              _buildBottomFeedRow(isDark, isMobile, isTablet),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2A38) : const Color(0xFFEFF6FF),
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? const Color(0xFF2563EB).withValues(alpha: 0.3) : const Color(0xFF93C5FD),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active_outlined, size: 14, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '3 high-priority followups scheduled within the next 60 minutes. Active geofence punch recorded at 09:30 AM (98.4% team accuracy).',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFFBFDBFE) : const Color(0xFF1E40AF),
              ),
            ),
          ),
          const SizedBox(width: 8),
          DashboardBadge(
            label: 'LIVE OPS',
            color: const Color(0xFF2563EB),
            icon: Icons.bolt,
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(bool isMobile, bool isTablet) {
    final kpis = DashboardMockData.overviewKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 118,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return DashboardMetricCard(metric: kpis[index]);
      },
    );
  }

  Widget _buildScoreAndVelocityRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          ProductivityScoreRing(scoreData: DashboardMockData.productivityScore),
          const SizedBox(height: 16),
          DashboardVelocityLineChart(dataPoints: DashboardMockData.velocityTrend30Days),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: ProductivityScoreRing(scoreData: DashboardMockData.productivityScore),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 6,
          child: DashboardVelocityLineChart(dataPoints: DashboardMockData.velocityTrend30Days),
        ),
      ],
    );
  }

  Widget _buildBarAndDonutRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          DashboardWeeklyTaskBarChart(weeklyData: DashboardMockData.weeklyTaskStats),
          const SizedBox(height: 16),
          DashboardWorkloadDonutChart(departments: DashboardMockData.departmentWorkloads),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: DashboardWeeklyTaskBarChart(weeklyData: DashboardMockData.weeklyTaskStats),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: DashboardWorkloadDonutChart(departments: DashboardMockData.departmentWorkloads),
        ),
      ],
    );
  }

  Widget _buildBottomFeedRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        children: [
          _buildTasksPreviewCard(isDark),
          const SizedBox(height: 16),
          _buildVisitsPreviewCard(isDark),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _buildTasksPreviewCard(isDark),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: _buildVisitsPreviewCard(isDark),
        ),
      ],
    );
  }

  Widget _buildTasksPreviewCard(bool isDark) {
    final tasks = DashboardMockData.tasks.take(4).toList();

    return CompactTableCard(
      title: "Today's Task Telemetry",
      subtitle: "Recent task status and completion progression",
      trailing: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 28)),
        child: Text(
          'View All (18)',
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 15,
                  color: task.isCompleted ? const Color(0xFF10B981) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            task.clientName,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '•  ${task.dueTime}',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                DashboardBadge(
                  label: task.priority.toUpperCase(),
                  color: task.priorityColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVisitsPreviewCard(bool isDark) {
    final visits = DashboardMockData.fieldVisits.take(4).toList();

    return CompactTableCard(
      title: 'Active Field Visits',
      subtitle: 'On-site inspections & mileage verification',
      trailing: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 28)),
        child: Text(
          'Mileage Log',
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: visits.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        itemBuilder: (context, index) {
          final visit = visits[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: visit.statusColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Icon(Icons.location_on_outlined, size: 15, color: visit.statusColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visit.clientName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${visit.siteLocation} (${visit.distanceKm} km)',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                DashboardBadge(
                  label: visit.status.toUpperCase(),
                  color: visit.statusColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

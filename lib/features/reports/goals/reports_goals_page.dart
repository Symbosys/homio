import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/reports_mock_data.dart';
import '../models/reports_models.dart';
import '../widgets/reports_charts.dart';
import '../widgets/reports_common_widgets.dart';
import '../widgets/reports_controls_bar.dart';
import '../widgets/reports_drilldown_modal.dart';
import '../widgets/reports_export_dialog.dart';
import '../widgets/reports_filter_drawer.dart';

/// Screen 10: Goals / Productivity Analytics Screen.
/// Enterprise-grade organizational target tracking, OKRs, and employee productivity.
class ReportsGoalsPage extends StatefulWidget {
  const ReportsGoalsPage({super.key});

  @override
  State<ReportsGoalsPage> createState() => _ReportsGoalsPageState();
}

class _ReportsGoalsPageState extends State<ReportsGoalsPage> {
  ReportFilterState _filterState = const ReportFilterState();

  void _onDrillDown(String title, String category, String metricValue, List<Map<String, dynamic>> records) {
    ReportsDrilldownModal.show(
      context,
      title: title,
      category: category,
      metricValue: metricValue,
      records: records,
    );
  }

  void _openExportDialog() {
    ReportsExportDialog.show(
      context,
      reportTitle: 'Goals & Productivity Analytics Report',
      dateRangeLabel: _filterState.dateFilter.label,
    );
  }

  void _openFilterDrawer() {
    ReportsFilterDrawer.show(
      context,
      initialFilter: _filterState,
      onApply: (newFilter) {
        setState(() => _filterState = newFilter);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
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
              // 1. Controls Bar
              ReportsControlsBar(
                title: 'Goals / Productivity',
                subtitle: 'Track organizational goals, team targets, individual performance, productivity, and achievement against planned objectives',
                icon: Icons.flag_rounded,
                filterState: _filterState,
                onFilterChanged: (newFilter) => setState(() => _filterState = newFilter),
                onOpenFilterDrawer: _openFilterDrawer,
                onExport: _openExportDialog,
                onRefresh: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Corporate OKRs and productivity telemetry refreshed', style: GoogleFonts.inter(fontSize: 12)),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onSaveView: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved current goals & productivity view preset'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              // 2. Goal KPIs
              _buildGoalKpis(isMobile, isTablet),
              const SizedBox(height: 16),

              // 3. Goal Status Distribution & At-Risk Intervention (Split Grid)
              if (isMobile) ...[
                _buildStatusDistributionSection(isDark),
                const SizedBox(height: 16),
                _buildAtRiskGoalsSection(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildStatusDistributionSection(isDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 7,
                      child: _buildAtRiskGoalsSection(isDark),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // 4. Department Productivity Summary Table
              _buildDepartmentProductivitySection(isDark, isMobile),
              const SizedBox(height: 16),

              // 5. Individual Productivity (Role-Contextual Leaderboard)
              _buildIndividualProductivitySection(isDark, isMobile),
              const SizedBox(height: 16),

              // 6. Master Goal Details Register Table
              _buildMasterGoalTable(isDark, isMobile),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 1: GOAL KPIS
  // ==========================================================================
  Widget _buildGoalKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.goalsKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : (MediaQuery.sizeOf(context).width > 1500 ? 6 : 3));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 135,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return EnterpriseKpiCard(
          title: kpi.title,
          value: kpi.value,
          previousValue: kpi.previousValue,
          growthPercent: kpi.growthPercent,
          isPositive: kpi.isPositive,
          targetText: kpi.target,
          targetProgress: kpi.targetAchievementPercent / 100,
          icon: kpi.icon,
          color: kpi.color,
          onTap: () {
            _onDrillDown(
              kpi.title,
              kpi.category,
              kpi.value,
              [
                {
                  'title': 'Q3 Revenue Booking Target (₹2.00 Cr)',
                  'subtitle': 'Owner: Aarav Singhania • Sales Team',
                  'status': '92.0% Achieved',
                  'statusColor': const Color(0xFF10B981),
                  'metric': '₹1.84 Cr / ₹2.00 Cr',
                  'date': 'Due: Sep 30, 2026',
                  'badge': 'On Track',
                },
                {
                  'title': 'Italian Marble Wastage (< 3%)',
                  'subtitle': 'Owner: Mohan Lal • Stone Team',
                  'status': 'At Risk',
                  'statusColor': const Color(0xFFEF4444),
                  'metric': '4.8% Actual Wastage',
                  'date': 'Due: Sep 30, 2026',
                  'badge': 'Transit Breakage Claim',
                },
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // SECTION 2: GOAL STATUS DISTRIBUTION
  // ==========================================================================
  Widget _buildStatusDistributionSection(bool isDark) {
    return ReportSectionContainer(
      title: 'Goal Status Breakdown',
      subtitle: 'Distribution of 56 corporate objectives across completion stages',
      icon: Icons.pie_chart_outline_rounded,
      iconColor: const Color(0xFF10B981),
      child: ReportGoalStatusDonutChart(distribution: ReportsMockData.goalStatusDistribution),
    );
  }

  // ==========================================================================
  // SECTION 3: AT-RISK GOALS INTERVENTION PANEL
  // ==========================================================================
  Widget _buildAtRiskGoalsSection(bool isDark) {
    final atRisk = ReportsMockData.atRiskGoalsList;

    return ReportSectionContainer(
      title: 'At-Risk Objectives — Intervention Required',
      subtitle: 'Critical goals tracking behind schedule, approaching deadlines, or experiencing operational blockers',
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFEF4444),
      child: Column(
        children: atRisk.map((g) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: g.riskColor.withValues(alpha: isDark ? 0.12 : 0.05),
              borderRadius: AppRadius.sm,
              border: Border.all(color: g.riskColor.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.flag_circle_rounded, size: 20, color: g.riskColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              g.goalName,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: g.riskColor.withValues(alpha: 0.2), borderRadius: AppRadius.xs),
                            child: Text('${g.daysRemaining}d Left', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: g.riskColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${g.ownerName} • ${g.department} • Progress: ${g.currentAchievement} / ${g.targetValue}',
                        style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Blocker: ${g.blockerNotes}',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: g.riskColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _onDrillDown(
                      g.goalName,
                      g.department,
                      'Target: ${g.targetValue}',
                      [
                        {
                          'title': g.goalName,
                          'subtitle': 'Owner: ${g.ownerName}',
                          'status': g.riskStatus,
                          'statusColor': g.riskColor,
                          'metric': '${g.currentAchievement} (Remaining: ${g.remainingValue})',
                          'date': 'Due: ${g.dueDate}',
                          'badge': g.blockerNotes,
                        },
                      ],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: g.riskColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    minimumSize: const Size(60, 28),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.xs),
                  ),
                  child: Text('Inspect', style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 4: DEPARTMENT PRODUCTIVITY SUMMARY TABLE
  // ==========================================================================
  Widget _buildDepartmentProductivitySection(bool isDark, bool isMobile) {
    final departments = ReportsMockData.departmentProductivitySummaries;

    return ReportSectionContainer(
      title: 'Department Goal Achievement & Productivity',
      subtitle: 'Comparative departmental performance, targets completed, and contribution metrics',
      icon: Icons.corporate_fare_rounded,
      iconColor: const Color(0xFF6366F1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 38,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 50,
          horizontalMargin: 8,
          columnSpacing: 16,
          columns: [
            DataColumn(label: Text('Department', style: _headerStyle(isDark))),
            DataColumn(label: Text('Staff Count', style: _headerStyle(isDark))),
            DataColumn(label: Text('Goals Assigned', style: _headerStyle(isDark))),
            DataColumn(label: Text('Achievement %', style: _headerStyle(isDark))),
            DataColumn(label: Text('Productivity %', style: _headerStyle(isDark))),
            DataColumn(label: Text('Work Completed', style: _headerStyle(isDark))),
            DataColumn(label: Text('Revenue Impact', style: _headerStyle(isDark))),
            DataColumn(label: Text('At Risk', style: _headerStyle(isDark))),
          ],
          rows: departments.map((d) {
            return DataRow(
              cells: [
                DataCell(Text(d.department, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text('${d.teamSize}', style: _monoStyle(isDark))),
                DataCell(Text('${d.goalsCompleted}/${d.goalsAssigned}', style: _monoStyle(isDark))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (d.achievementPercent >= 90 ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${d.achievementPercent}%',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: d.achievementPercent >= 90 ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${d.productivityPercent}%',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6)),
                    ),
                  ),
                ),
                DataCell(Text('${d.tasksCompleted} Tasks • ${d.projectsCompleted} Projects', style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text('₹${d.revenueContributionLakhs.toStringAsFixed(1)}L', style: _monoStyle(isDark, color: const Color(0xFF10B981)))),
                DataCell(
                  Text(
                    '${d.atRiskGoalsCount} At Risk',
                    style: _monoStyle(isDark, color: d.atRiskGoalsCount > 0 ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 5: INDIVIDUAL PRODUCTIVITY
  // ==========================================================================
  Widget _buildIndividualProductivitySection(bool isDark, bool isMobile) {
    final individuals = ReportsMockData.individualProductivityList;

    return ReportSectionContainer(
      title: 'Role-Contextual Productivity Index',
      subtitle: 'Employee execution volume, billable working hours, goal attainment, and overdue work',
      icon: Icons.person_search_rounded,
      iconColor: const Color(0xFF3B82F6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 38,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 50,
          horizontalMargin: 8,
          columnSpacing: 16,
          columns: [
            DataColumn(label: Text('Employee / Role', style: _headerStyle(isDark))),
            DataColumn(label: Text('Department / Team', style: _headerStyle(isDark))),
            DataColumn(label: Text('Goals Met', style: _headerStyle(isDark))),
            DataColumn(label: Text('Achievement %', style: _headerStyle(isDark))),
            DataColumn(label: Text('Productivity %', style: _headerStyle(isDark))),
            DataColumn(label: Text('Work Done', style: _headerStyle(isDark))),
            DataColumn(label: Text('Hours Logged', style: _headerStyle(isDark))),
          ],
          rows: individuals.map((ind) {
            return DataRow(
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(ind.employeeName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                      Text(ind.role, style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
                DataCell(Text('${ind.department} (${ind.team})', style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text('${ind.goalsCompleted}/${ind.goalsAssigned}', style: _monoStyle(isDark))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (ind.achievementPercent >= 90 ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${ind.achievementPercent}%',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: ind.achievementPercent >= 90 ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${ind.productivityPercent}%',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6)),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '${ind.tasksCompleted} Tasks • ${ind.projectsCompleted} Prj ${ind.designsCompleted > 0 ? '• ${ind.designsCompleted} Des' : ''}',
                    style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                  ),
                ),
                DataCell(Text('${ind.productiveHours}h / ${ind.workHours}h', style: _monoStyle(isDark))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 6: MASTER GOAL DETAILS REGISTER
  // ==========================================================================
  Widget _buildMasterGoalTable(bool isDark, bool isMobile) {
    final goals = ReportsMockData.goalDetailRecords;

    return ReportSectionContainer(
      title: 'Corporate Objectives & Key Results (OKR) Register',
      subtitle: 'Complete list of enterprise goals, assigned owners, target metrics, progress, and status',
      icon: Icons.table_chart_rounded,
      iconColor: const Color(0xFF6366F1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 40,
          dataRowMinHeight: 46,
          dataRowMaxHeight: 52,
          horizontalMargin: 10,
          columnSpacing: 16,
          columns: [
            DataColumn(label: Text('Goal ID', style: _headerStyle(isDark))),
            DataColumn(label: Text('Objective Name', style: _headerStyle(isDark))),
            DataColumn(label: Text('Type', style: _headerStyle(isDark))),
            DataColumn(label: Text('Owner / Dept', style: _headerStyle(isDark))),
            DataColumn(label: Text('Due Date', style: _headerStyle(isDark))),
            DataColumn(label: Text('Achievement %', style: _headerStyle(isDark))),
            DataColumn(label: Text('Status', style: _headerStyle(isDark))),
            DataColumn(label: Text('Priority', style: _headerStyle(isDark))),
          ],
          rows: goals.map((g) {
            return DataRow(
              cells: [
                DataCell(Text(g.goalId, style: _monoStyle(isDark))),
                DataCell(
                  SizedBox(
                    width: 240,
                    child: Text(
                      g.goalName,
                      style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(g.goalType, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
                DataCell(Text('${g.ownerName} (${g.department})', style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text(g.dueDate, style: GoogleFonts.inter(fontSize: 10, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(
                  Text(
                    '${g.achievementPercent}%',
                    style: _monoStyle(isDark, color: g.achievementPercent >= 90 ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: g.statusColor.withValues(alpha: 0.15), borderRadius: AppRadius.xs),
                    child: Text(g.status, style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: g.statusColor)),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: g.priorityColor.withValues(alpha: 0.15), borderRadius: AppRadius.xs),
                    child: Text(g.priority, style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: g.priorityColor)),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  TextStyle _headerStyle(bool isDark) {
    return GoogleFonts.inter(
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      letterSpacing: 0.3,
    );
  }

  TextStyle _monoStyle(bool isDark, {Color? color}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? Colors.white : AppColors.lightTextPrimary),
    );
  }
}

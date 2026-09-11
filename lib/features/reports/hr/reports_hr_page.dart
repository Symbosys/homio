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

/// Screen 7: HR Analytics Screen.
/// Enterprise-grade workforce and employee intelligence for Homio CRM.
class ReportsHrPage extends StatefulWidget {
  const ReportsHrPage({super.key});

  @override
  State<ReportsHrPage> createState() => _ReportsHrPageState();
}

class _ReportsHrPageState extends State<ReportsHrPage> {
  ReportFilterState _filterState = const ReportFilterState();
  String _compositionDimension = 'Department'; // 'Department', 'Role', 'Employment Type'

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
      reportTitle: 'HR Analytics Report',
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
                title: 'HR Analytics',
                subtitle: 'Analyze workforce composition, attendance, leave, recruitment, retention, and employee productivity',
                icon: Icons.badge_rounded,
                filterState: _filterState,
                onFilterChanged: (newFilter) => setState(() => _filterState = newFilter),
                onOpenFilterDrawer: _openFilterDrawer,
                onExport: _openExportDialog,
                onRefresh: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('HR attendance logs and recruitment pipelines updated', style: GoogleFonts.inter(fontSize: 12)),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onSaveView: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved current HR view preset'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              // 2. Workforce KPIs
              _buildWorkforceKpis(isMobile, isTablet),
              const SizedBox(height: 16),

              // 3. Workforce Composition & Headcount Trend (Split Grid)
              if (isMobile || isTablet) ...[
                _buildCompositionSection(isDark),
                const SizedBox(height: 16),
                _buildHeadcountTrendSection(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildCompositionSection(isDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: _buildHeadcountTrendSection(isDark),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // 4. Attendance & Leave Analytics (Split Grid)
              if (isMobile || isTablet) ...[
                _buildAttendanceSection(isDark),
                const SizedBox(height: 16),
                _buildLeaveSection(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildAttendanceSection(isDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: _buildLeaveSection(isDark),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // 5. Recruitment Funnel & Open Positions
              if (isMobile || isTablet) ...[
                _buildRecruitmentFunnelSection(isDark),
                const SizedBox(height: 16),
                _buildOpenPositionsSection(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildRecruitmentFunnelSection(isDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: _buildOpenPositionsSection(isDark),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // 6. Master Department Summary Table
              _buildDepartmentSummaryTable(isDark, isMobile),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 1: WORKFORCE KPIS
  // ==========================================================================
  Widget _buildWorkforceKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.hrKpis;
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
                  'title': 'Active Staff Directory',
                  'subtitle': 'Verified Corporate & Site Payroll',
                  'status': '176 Active',
                  'statusColor': const Color(0xFF10B981),
                  'metric': '95.6% Active',
                  'date': 'Current Period',
                  'badge': 'Attendance 94.2%',
                },
                {
                  'title': 'New Joiners (Sep 2026)',
                  'subtitle': 'Onboarding & Induction Cohort',
                  'status': '6 Joined',
                  'statusColor': const Color(0xFF3B82F6),
                  'metric': '100% Induction Done',
                  'date': 'Sep 01, 2026',
                  'badge': 'Design & Execution',
                },
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // SECTION 2: WORKFORCE COMPOSITION
  // ==========================================================================
  Widget _buildCompositionSection(bool isDark) {
    final composition = ReportsMockData.hrCompositionDepartments;

    return ReportSectionContainer(
      title: 'Workforce Composition',
      subtitle: 'Staff headcount distribution by division, average tenure, and talent concentration',
      icon: Icons.pie_chart_rounded,
      iconColor: const Color(0xFF6366F1),
      trailing: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          borderRadius: AppRadius.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: ['Department', 'Role'].map((d) {
            final isSelected = _compositionDimension == d;
            return InkWell(
              onTap: () => setState(() => _compositionDimension = d),
              borderRadius: AppRadius.xs,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected ? (isDark ? AppColors.primary : Colors.white) : Colors.transparent,
                  borderRadius: AppRadius.xs,
                  boxShadow: isSelected && !isDark ? [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))
                  ] : null,
                ),
                child: Text(
                  d,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.primary)
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      child: Column(
        children: composition.map((c) {
          return InkWell(
            onTap: () {
              _onDrillDown(
                'Department: ${c.category}',
                '${c.count} Employees (${c.percentage}%)',
                'Avg Tenure: ${c.avgTenure} Yrs',
                [
                  {
                    'title': '${c.category} Team Directory',
                    'subtitle': 'Department Headcount & Allocation',
                    'status': '${c.count} Active',
                    'statusColor': c.color,
                    'metric': '${c.avgTenure} Yrs Avg Tenure',
                    'date': 'Current Roster',
                    'badge': '${c.percentage}% of Workforce',
                  },
                ],
              );
            },
            borderRadius: AppRadius.sm,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: c.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c.category,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${c.count} (${c.percentage.toStringAsFixed(1)}%) • ${c.avgTenure}y avg',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: c.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: (c.percentage / 100).clamp(0.02, 1.0),
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(c.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 3: HEADCOUNT TREND
  // ==========================================================================
  Widget _buildHeadcountTrendSection(bool isDark) {
    return ReportSectionContainer(
      title: 'Headcount Evolution',
      subtitle: 'Net talent additions, new joiners, exits, and total closing roster',
      icon: Icons.trending_up_rounded,
      iconColor: const Color(0xFF10B981),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildTrendBadge('Opening: 160', const Color(0xFF6366F1), isDark),
              _buildTrendBadge('+38 Joiners', const Color(0xFF10B981), isDark),
              _buildTrendBadge('-14 Exits', const Color(0xFFEF4444), isDark),
              _buildTrendBadge('Closing: 184', const Color(0xFF3B82F6), isDark),
            ],
          ),
          const SizedBox(height: 12),
          ReportHrHeadcountBarChart(trend: ReportsMockData.hrHeadcountTrend),
        ],
      ),
    );
  }

  Widget _buildTrendBadge(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: AppRadius.xs,
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 4: ATTENDANCE ANALYTICS
  // ==========================================================================
  Widget _buildAttendanceSection(bool isDark) {
    final departments = ReportsMockData.hrAttendanceDepartments;

    return ReportSectionContainer(
      title: 'Attendance & Punctuality Analytics',
      subtitle: 'Average presence, late check-ins, and department-level attendance rate',
      icon: Icons.how_to_reg_rounded,
      iconColor: const Color(0xFF3B82F6),
      child: Column(
        children: [
          Row(
            children: [
              _buildAttendanceMetric('94.2%', 'Present', const Color(0xFF10B981), isDark),
              const SizedBox(width: 8),
              _buildAttendanceMetric('3.8%', 'Absent', const Color(0xFFEF4444), isDark),
              const SizedBox(width: 8),
              _buildAttendanceMetric('1.4%', 'Late', const Color(0xFFF59E0B), isDark),
              const SizedBox(width: 8),
              _buildAttendanceMetric('0.6%', 'Half-Day', const Color(0xFF8B5CF6), isDark),
            ],
          ),
          const SizedBox(height: 12),
          ...departments.take(4).map((dept) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      dept.department,
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${dept.presentDays}/${dept.workingDays}d • ${dept.attendancePercent}%',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: dept.attendancePercent >= 95 ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAttendanceMetric(String value, String label, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
          borderRadius: AppRadius.sm,
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 5: LEAVE ANALYTICS
  // ==========================================================================
  Widget _buildLeaveSection(bool isDark) {
    final leaves = ReportsMockData.hrLeaveAnalytics;

    return ReportSectionContainer(
      title: 'Leave Utilization Breakdown',
      subtitle: 'Approved, pending & utilized leave days by policy category',
      icon: Icons.event_busy_rounded,
      iconColor: const Color(0xFFF59E0B),
      child: Column(
        children: leaves.map((l) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l.leaveType,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${l.daysTaken}d taken • ${l.approved} app (${l.pending} pend)',
                        style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w600, color: l.color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (l.utilizationPercent / 100).clamp(0.05, 1.0),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(l.color),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 6: RECRUITMENT FUNNEL & OPEN POSITIONS
  // ==========================================================================
  Widget _buildRecruitmentFunnelSection(bool isDark) {
    final stages = ReportsMockData.hrRecruitmentFunnel;

    return ReportSectionContainer(
      title: 'Recruitment & Talent Pipeline',
      subtitle: 'Candidate progression from initial application to offer acceptance',
      icon: Icons.filter_alt_rounded,
      iconColor: const Color(0xFF8B5CF6),
      child: Column(
        children: stages.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: s.color.withValues(alpha: 0.15), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(
                    '${s.candidateCount}',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w800, color: s.color),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.stageName, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                      Text('Conversion: ${s.conversionRate.toStringAsFixed(1)}% • ${s.avgDaysInStage}d avg', style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOpenPositionsSection(bool isDark) {
    final positions = ReportsMockData.hrOpenPositions;

    return ReportSectionContainer(
      title: 'Priority Active Vacancies',
      subtitle: 'Critical roles currently open with candidate pipeline counts',
      icon: Icons.work_outline_rounded,
      iconColor: const Color(0xFF14B8A6),
      child: Column(
        children: positions.map((p) {
          return InkWell(
            onTap: () {
              _onDrillDown(
                p.title,
                p.department,
                '${p.candidatesCount} Candidates',
                [
                  {
                    'title': 'Job Requisition: ${p.title}',
                    'subtitle': 'Hiring Manager: ${p.hiringManager} • Target: ${p.targetHires}',
                    'status': p.status,
                    'statusColor': const Color(0xFF10B981),
                    'metric': '${p.candidatesCount} Applicants',
                    'date': 'Open ${p.daysOpen} days',
                    'badge': '${p.interviewsHeld} Interviews Done',
                  },
                ],
              );
            },
            borderRadius: AppRadius.sm,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.4) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.sm,
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 0.8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${p.department} • ${p.hiringManager} • ${p.daysOpen}d open',
                          style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${p.candidatesCount} Pipeline',
                      style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 7: MASTER DEPARTMENT SUMMARY TABLE
  // ==========================================================================
  Widget _buildDepartmentSummaryTable(bool isDark, bool isMobile) {
    final summaries = ReportsMockData.hrDepartmentSummaries;

    return ReportSectionContainer(
      title: 'Department Workforce & Performance Matrix',
      subtitle: 'Consolidated view of headcount, attendance, open positions, attrition & average tenure',
      icon: Icons.table_chart_rounded,
      iconColor: const Color(0xFF6366F1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 40,
          dataRowMinHeight: 46,
          dataRowMaxHeight: 52,
          horizontalMargin: 10,
          columnSpacing: 18,
          columns: [
            DataColumn(label: Text('Department', style: _headerStyle(isDark))),
            DataColumn(label: Text('Headcount', style: _headerStyle(isDark))),
            DataColumn(label: Text('Joiners / Exits', style: _headerStyle(isDark))),
            DataColumn(label: Text('Attendance %', style: _headerStyle(isDark))),
            DataColumn(label: Text('Leave Days', style: _headerStyle(isDark))),
            DataColumn(label: Text('Open Positions', style: _headerStyle(isDark))),
            DataColumn(label: Text('Attrition %', style: _headerStyle(isDark))),
            DataColumn(label: Text('Avg Tenure', style: _headerStyle(isDark))),
          ],
          rows: summaries.map((s) {
            return DataRow(
              cells: [
                DataCell(Text(s.department, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text('${s.headcount}', style: _monoStyle(isDark))),
                DataCell(
                  Text(
                    '+${s.newJoiners} / -${s.exits}',
                    style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600, color: s.exits > s.newJoiners ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${s.attendancePercent}%',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                    ),
                  ),
                ),
                DataCell(Text('${s.leaveDays}d', style: _monoStyle(isDark))),
                DataCell(Text('${s.openPositions} (${s.pipelineCount} in pipeline)', style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(
                  Text(
                    '${s.attritionPercent}%',
                    style: _monoStyle(isDark, color: s.attritionPercent > 5 ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                  ),
                ),
                DataCell(Text('${s.avgTenureYears} Yrs', style: _monoStyle(isDark))),
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

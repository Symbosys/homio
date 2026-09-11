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

/// Screen 8: Service / Labour Analytics Screen.
/// Enterprise-grade field operations, labour productivity and SLA tracking.
class ReportsServicePage extends StatefulWidget {
  const ReportsServicePage({super.key});

  @override
  State<ReportsServicePage> createState() => _ReportsServicePageState();
}

class _ReportsServicePageState extends State<ReportsServicePage> {
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
      reportTitle: 'Service & Labour Analytics Report',
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
                title: 'Service / Labour Analytics',
                subtitle: 'Monitor service workload, labour utilization, job completion, response time, productivity, and labour costs',
                icon: Icons.construction_rounded,
                filterState: _filterState,
                onFilterChanged: (newFilter) => setState(() => _filterState = newFilter),
                onOpenFilterDrawer: _openFilterDrawer,
                onExport: _openExportDialog,
                onRefresh: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Field service tickets and contractor logs updated', style: GoogleFonts.inter(fontSize: 12)),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onSaveView: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved current service & labour view preset'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              // 2. Service & Labour KPIs
              _buildServiceKpis(isMobile, isTablet),
              const SizedBox(height: 16),

              // 3. Workload Trend & Service Workflow Funnel (Split Grid)
              if (isMobile || isTablet) ...[
                _buildWorkloadTrendSection(isDark),
                const SizedBox(height: 16),
                _buildWorkflowStagesSection(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildWorkloadTrendSection(isDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: _buildWorkflowStagesSection(isDark),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // 4. Labour Productivity & Trade Cost Analysis (Split Grid)
              if (isMobile || isTablet) ...[
                _buildLabourProductivitySection(isDark, isMobile),
                const SizedBox(height: 16),
                _buildLabourCostSection(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: _buildLabourProductivitySection(isDark, isMobile),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: _buildLabourCostSection(isDark),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // 5. Master Service Performance Table
              _buildMasterServiceTable(isDark, isMobile),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 1: SERVICE KPIS
  // ==========================================================================
  Widget _buildServiceKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.serviceKpis;
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
                  'title': 'Italian Marble Polishing Job #4019',
                  'subtitle': 'Project: DLF Camellias • Client: Rajiv Singhania',
                  'status': 'Completed',
                  'statusColor': const Color(0xFF10B981),
                  'metric': '18.0 Hrs SLA Met',
                  'date': 'Sep 06, 2026',
                  'badge': 'Worker: Mohan Lal',
                },
                {
                  'title': 'HVAC Duct Leakage Ticket #4021',
                  'subtitle': 'Project: Gurgaon Golf Course • Client: Gaurav K.',
                  'status': 'Overdue',
                  'statusColor': const Color(0xFFEF4444),
                  'metric': '54.0 Hrs (SLA Breached)',
                  'date': 'Aug 29, 2026',
                  'badge': 'Squad Beta',
                },
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // SECTION 2: WORKLOAD TREND
  // ==========================================================================
  Widget _buildWorkloadTrendSection(bool isDark) {
    return ReportSectionContainer(
      title: 'Service Workload & Resolution Trend',
      subtitle: 'Completed, in-progress, and overdue field tickets across months',
      icon: Icons.timeline_rounded,
      iconColor: const Color(0xFF10B981),
      child: Column(
        children: [
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _buildLegend(const Color(0xFF10B981), 'Completed', isDark),
              _buildLegend(const Color(0xFFF59E0B), 'In Progress', isDark),
              _buildLegend(const Color(0xFFEF4444), 'Overdue', isDark),
            ],
          ),
          const SizedBox(height: 12),
          ReportServiceWorkloadChart(points: ReportsMockData.serviceWorkloadTrend),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SECTION 3: WORKFLOW FUNNEL
  // ==========================================================================
  Widget _buildWorkflowStagesSection(bool isDark) {
    final stages = ReportsMockData.serviceWorkflowStages;

    return ReportSectionContainer(
      title: 'Service Lifecycle Progression',
      subtitle: 'Step-by-step conversion from request intake to customer sign-off',
      icon: Icons.account_tree_rounded,
      iconColor: const Color(0xFF6366F1),
      child: Column(
        children: stages.map((st) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: st.color.withValues(alpha: 0.15), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(
                    '${st.count}',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w800, color: st.color),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        st.stageName,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${st.conversionPercent}% conversion • ${st.avgDwellHours}h dwell time',
                        style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (st.overdueCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${st.overdueCount} Overdue',
                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444)),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 4: LABOUR PRODUCTIVITY LEADERBOARD
  // ==========================================================================
  Widget _buildLabourProductivitySection(bool isDark, bool isMobile) {
    final list = ReportsMockData.labourProductivityList;

    return ReportSectionContainer(
      title: 'Worker & Trade Team Productivity',
      subtitle: 'Hours utilized, jobs completed, cost incurred, and quality ratings',
      icon: Icons.badge_outlined,
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
            DataColumn(label: Text('Worker / Trade', style: _headerStyle(isDark))),
            DataColumn(label: Text('Team / Supervisor', style: _headerStyle(isDark))),
            DataColumn(label: Text('Jobs Done', style: _headerStyle(isDark))),
            DataColumn(label: Text('Utilization %', style: _headerStyle(isDark))),
            DataColumn(label: Text('Avg Time', style: _headerStyle(isDark))),
            DataColumn(label: Text('Labour Cost', style: _headerStyle(isDark))),
            DataColumn(label: Text('Rating', style: _headerStyle(isDark))),
          ],
          rows: list.map((w) {
            return DataRow(
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(w.workerName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                      Text(w.trade, style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
                DataCell(Text('${w.team} (${w.supervisor})', style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text('${w.completedJobs}/${w.assignedJobs}', style: _monoStyle(isDark))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (w.utilizationPercent >= 90 ? const Color(0xFF10B981) : const Color(0xFF3B82F6)).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      '${w.utilizationPercent}%',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: w.utilizationPercent >= 90 ? const Color(0xFF10B981) : const Color(0xFF3B82F6)),
                    ),
                  ),
                ),
                DataCell(Text('${w.avgCompletionHours}h', style: _monoStyle(isDark))),
                DataCell(Text('₹${(w.labourCost / 1000).toStringAsFixed(0)}k', style: _monoStyle(isDark))),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 3),
                      Text('${w.rating}', style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                    ],
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
  // SECTION 5: LABOUR COST ANALYSIS BY TRADE
  // ==========================================================================
  Widget _buildLabourCostSection(bool isDark) {
    final costs = ReportsMockData.labourCostBreakdown;

    return ReportSectionContainer(
      title: 'Labour Costs by Trade',
      subtitle: 'Disbursements across skilled trades vs budget allocation',
      icon: Icons.payments_rounded,
      iconColor: const Color(0xFF8B5CF6),
      child: Column(
        children: costs.map((c) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        c.title,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '₹${(c.actualCost / 100000).toStringAsFixed(2)}L',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: c.isOverBudget ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '₹${c.costPerHour}/h • ₹${c.costPerJob}/job',
                        style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        c.isOverBudget ? '+₹${(c.variance / 1000).toStringAsFixed(0)}k Over' : '-₹${(c.variance.abs() / 1000).toStringAsFixed(0)}k Under',
                        style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w600, color: c.isOverBudget ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 6: MASTER SERVICE PERFORMANCE TABLE
  // ==========================================================================
  Widget _buildMasterServiceTable(bool isDark, bool isMobile) {
    final records = ReportsMockData.servicePerformanceRecords;

    return ReportSectionContainer(
      title: 'Service Request Execution Register',
      subtitle: 'Individual maintenance, installation, snag resolution, and milestone completion logs',
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
            DataColumn(label: Text('Service ID', style: _headerStyle(isDark))),
            DataColumn(label: Text('Customer / Project', style: _headerStyle(isDark))),
            DataColumn(label: Text('Service Type', style: _headerStyle(isDark))),
            DataColumn(label: Text('Worker / PM', style: _headerStyle(isDark))),
            DataColumn(label: Text('Priority', style: _headerStyle(isDark))),
            DataColumn(label: Text('Status', style: _headerStyle(isDark))),
            DataColumn(label: Text('SLA Compliance', style: _headerStyle(isDark))),
            DataColumn(label: Text('Cost', style: _headerStyle(isDark))),
          ],
          rows: records.map((r) {
            return DataRow(
              cells: [
                DataCell(Text(r.serviceId, style: _monoStyle(isDark))),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(r.customerName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                      Text(r.projectName, style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
                DataCell(Text(r.serviceType, style: GoogleFonts.inter(fontSize: 11, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text('${r.assignedWorker} (${r.supervisor})', style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: r.priorityColor.withValues(alpha: 0.15), borderRadius: AppRadius.xs),
                    child: Text(r.priority, style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: r.priorityColor)),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: r.statusColor.withValues(alpha: 0.15), borderRadius: AppRadius.xs),
                    child: Text(r.status, style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: r.statusColor)),
                  ),
                ),
                DataCell(
                  Text(
                    '${r.slaStatus} (${r.resolutionTimeHours}h)',
                    style: _monoStyle(isDark, color: r.slaStatus == 'Met' ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                  ),
                ),
                DataCell(Text('₹${(r.labourCost / 1000).toStringAsFixed(1)}k', style: _monoStyle(isDark))),
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

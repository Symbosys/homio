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

/// Screen 4: Projects & Site Execution Analytics Screen.
/// Provides operations, site engineering, and project managers with live telemetry
/// across active site milestones, delay warnings, planned vs actual variance,
/// budget utilization, PM productivity leaderboards, and site risk/issue triage.
class ReportsExecutionPage extends StatefulWidget {
  const ReportsExecutionPage({super.key});

  @override
  State<ReportsExecutionPage> createState() => _ReportsExecutionPageState();
}

class _ReportsExecutionPageState extends State<ReportsExecutionPage> {
  ReportFilterState _filterState = const ReportFilterState();
  bool _isLoading = false;

  void _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _isLoading = false);
  }

  void _handleExport() {
    ReportsExportDialog.show(
      context,
      reportTitle: 'Project Execution & Milestone Delivery Audit',
      dateRangeLabel: _filterState.dateFilter.label,
    );
  }

  void _handleOpenFilters() {
    ReportsFilterDrawer.show(
      context,
      initialFilter: _filterState,
      onApply: (updated) => setState(() => _filterState = updated),
    );
  }

  void _openDrilldown(String title, String category, String metricValue, List<Map<String, dynamic>> records) {
    ReportsDrilldownModal.show(
      context,
      title: title,
      category: category,
      metricValue: metricValue,
      records: records,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;
    final isLargeDesktop = width >= 1440;

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
              // Header Controls Bar
              ReportsControlsBar(
                title: 'Projects / Execution Analytics',
                subtitle: 'Monitor project delivery, progress, timelines, budgets, risks, resources, and execution performance',
                icon: Icons.construction_rounded,
                filterState: _filterState,
                onFilterChanged: (val) => setState(() => _filterState = val),
                onOpenFilterDrawer: _handleOpenFilters,
                onRefresh: _handleRefresh,
                onExport: _handleExport,
              ),

              if (_isLoading) ...[
                const SizedBox(height: 20),
                const ReportLoadingSkeleton(height: 140),
                const SizedBox(height: 18),
                const ReportLoadingSkeleton(height: 320),
              ] else ...[
                // Critical Delay Warning Banner
                _buildCriticalWarningBanner(isDark),
                const SizedBox(height: 16),

                // 1. Project Execution KPI Cards Grid (12 Metrics)
                _buildKpisSection(isMobile, isTablet, isLargeDesktop),
                const SizedBox(height: 18),

                // 2. Health Distribution & Task Status (Side by side on desktop)
                if (isMobile || isTablet) ...[
                  _buildHealthDonutSection(isDark),
                  const SizedBox(height: 18),
                  _buildTaskExecutionSection(isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _buildHealthDonutSection(isDark)),
                      const SizedBox(width: 16),
                      Expanded(flex: 6, child: _buildTaskExecutionSection(isDark)),
                    ],
                  ),
                ],
                const SizedBox(height: 18),

                // 3. Project Performance Master Table (Full Width)
                _buildProjectPerformanceTable(isDark, isMobile),
                const SizedBox(height: 18),

                // 4. Project Manager Performance & Risks / Issues (Side by side on desktop)
                if (isMobile || isTablet) ...[
                  _buildPmPerformanceSection(isDark, isMobile),
                  const SizedBox(height: 18),
                  _buildRisksSection(isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _buildPmPerformanceSection(isDark, isMobile)),
                      const SizedBox(width: 16),
                      Expanded(flex: 6, child: _buildRisksSection(isDark)),
                    ],
                  ),
                ],
                const SizedBox(height: 18),

                // 5. Site Photo & Video Progress Timeline Feed
                _buildSiteMediaFeed(isDark),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // CRITICAL WARNING BANNER
  // ==========================================================================
  Widget _buildCriticalWarningBanner(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        final infoColumn = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 20, color: Color(0xFFEF4444)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Site Delay Alert: Godrej Woods 3BHK (+15 Days Behind Schedule)',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'A/C ducting height conflict in ceiling. Corrective double-shift carpentry dispatched.',
                    style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
          ],
        );

        final actionBtn = ElevatedButton(
          onPressed: () {
            _openDrilldown(
              'Godrej Woods 3BHK Escalation',
              'Site Delays',
              '+15 Days Behind Schedule',
              [
                {'id': 'TSK-104', 'title': 'False ceiling framework dismantling', 'subtitle': 'Site Engineer: Ramesh Patel • Priority: High', 'amount': null, 'status': 'In Progress', 'statusColor': const Color(0xFFF59E0B)},
                {'id': 'TSK-105', 'title': 'HVAC duct realignment with OEM', 'subtitle': 'Vendor: Daikin Regional Desk • Priority: Critical', 'amount': null, 'status': 'Blocked', 'statusColor': const Color(0xFFEF4444)},
              ],
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF4444),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
          child: Text('Inspect Delay', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700)),
        );

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: AppRadius.md,
            border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.35)),
          ),
          child: isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoColumn,
                    const SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft, child: actionBtn),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: infoColumn),
                    const SizedBox(width: 12),
                    actionBtn,
                  ],
                ),
        );
      },
    );
  }

  // ==========================================================================
  // 1. EXECUTION KPIS SECTION
  // ==========================================================================
  Widget _buildKpisSection(bool isMobile, bool isTablet, bool isLargeDesktop) {
    final kpis = ReportsMockData.executionKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : (isLargeDesktop ? 6 : 3));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 132,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final k = kpis[index];
        return EnterpriseKpiCard(
          title: k.title,
          value: k.value,
          growthPercent: 8.5,
          isPositive: k.isPositive,
          targetText: k.subtitle,
          targetProgress: k.targetProgress,
          icon: k.icon,
          color: k.color,
          onTap: () {
            _openDrilldown(
              k.title,
              'Site Execution',
              k.value,
              [
                {'id': 'PRJ-1048', 'title': 'DLF Magnolias 4BHK Penthouse', 'subtitle': 'PM: Vikram Malhotra • Woodwork Stage (78.5%)', 'amount': '₹24.5L', 'status': 'On Track', 'statusColor': const Color(0xFF10B981)},
                {'id': 'PRJ-1049', 'title': 'Prestige Falcon City Villa', 'subtitle': 'PM: Sunil Gavaskar • Civil Stage (42.0%)', 'amount': '₹18.0L', 'status': 'At Risk (+8d)', 'statusColor': const Color(0xFFF59E0B)},
                {'id': 'PRJ-1050', 'title': 'Godrej Woods 3BHK Turnkey', 'subtitle': 'PM: Pooja Hegde • Handover Milestone (62.4%)', 'amount': '₹14.5L', 'status': 'Delayed (+15d)', 'statusColor': const Color(0xFFEF4444)},
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // 2. HEALTH DISTRIBUTION & TASK EXECUTION
  // ==========================================================================
  Widget _buildHealthDonutSection(bool isDark) {
    const distribution = ReportsMockData.executionHealthDistribution;

    return ReportSectionContainer(
      title: 'Project Health & Timeline Delivery',
      subtitle: 'Distribution of active turnkey sites by SLA schedule status',
      icon: Icons.donut_large_rounded,
      iconColor: const Color(0xFF10B981),
      child: const ReportProjectHealthDonutChart(distribution: distribution),
    );
  }

  Widget _buildTaskExecutionSection(bool isDark) {
    const tasks = ReportsMockData.executionTaskSummary;

    return ReportSectionContainer(
      title: 'Site Task Execution & Punchlist Status',
      subtitle: 'Active daily micro-tasks across civil, woodwork, electrical, and finishing',
      icon: Icons.checklist_rounded,
      iconColor: const Color(0xFF3B82F6),
      trailing: Text(
        '${tasks.totalTasks} Total Tasks',
        style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6)),
      ),
      child: Column(
        children: [
          _buildTaskBar('Completed Tasks', tasks.completed, tasks.totalTasks, const Color(0xFF10B981), isDark),
          _buildTaskBar('In Progress', tasks.inProgress, tasks.totalTasks, const Color(0xFF3B82F6), isDark),
          _buildTaskBar('Pending Allocation', tasks.pending, tasks.totalTasks, const Color(0xFFF59E0B), isDark),
          _buildTaskBar('Blocked by Dependency', tasks.blocked, tasks.totalTasks, const Color(0xFF8B5CF6), isDark),
          _buildTaskBar('Overdue / Past SLA', tasks.overdue, tasks.totalTasks, const Color(0xFFEF4444), isDark),
        ],
      ),
    );
  }

  Widget _buildTaskBar(String label, int count, int total, Color color, bool isDark) {
    final pct = total > 0 ? ((count / total) * 100).toStringAsFixed(1) : '0';
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text('$count ($pct%)', style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: total > 0 ? count / total : 0,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 3. PROJECT PERFORMANCE TABLE
  // ==========================================================================
  Widget _buildProjectPerformanceTable(bool isDark, bool isMobile) {
    final projects = ReportsMockData.executionProjectsList;

    return ReportSectionContainer(
      title: 'Active Projects Performance Ledger',
      subtitle: 'Schedule variance, budget utilization, task progress, and risk classification',
      icon: Icons.table_view_rounded,
      iconColor: const Color(0xFF6366F1),
      trailing: ElevatedButton.icon(
        onPressed: _handleExport,
        icon: const Icon(Icons.download_rounded, size: 13),
        label: Text('Export Projects', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),
      child: isMobile
          ? Column(children: projects.map((p) => _buildMobileProjectCard(p, isDark)).toList())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 36,
                dataRowMinHeight: 44,
                dataRowMaxHeight: 48,
                columnSpacing: 18,
                horizontalMargin: 8,
                columns: [
                  DataColumn(label: Text('Project Name', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Project Manager', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Planned Handover', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Actual Progress', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Variance', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Budget (Lakhs)', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Actual Cost', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Tasks Overdue', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Status', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Risk', style: _headerStyle(isDark))),
                ],
                rows: projects.map((p) {
                  final isBehind = p.scheduleVarianceDays > 0;
                  final varianceColor = isBehind ? const Color(0xFFEF4444) : const Color(0xFF10B981);

                  return DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(p.projectName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                            Text('${p.projectId} • Customer: ${p.customer}', style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                      DataCell(Text(p.projectManager, style: GoogleFonts.inter(fontSize: 11))),
                      DataCell(Text(p.plannedCompletion, style: GoogleFonts.inter(fontSize: 11))),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${p.progressPercent.toStringAsFixed(1)}%', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 48,
                              child: LinearProgressIndicator(
                                value: p.progressPercent / 100.0,
                                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                valueColor: AlwaysStoppedAnimation<Color>(p.statusColor),
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          isBehind ? '+${p.scheduleVarianceDays}d delay' : '${p.scheduleVarianceDays}d ahead',
                          style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w600, color: varianceColor),
                        ),
                      ),
                      DataCell(Text('₹${p.budgetLakhs}L', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('₹${p.actualCostLakhs}L', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600))),
                      DataCell(
                        p.tasksOverdue > 0
                            ? Text('${p.tasksOverdue} overdue', style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444)))
                            : const Text('0', style: TextStyle(color: Color(0xFF10B981))),
                      ),
                      DataCell(ReportStatusBadge(label: p.status, color: p.statusColor)),
                      DataCell(
                        ReportStatusBadge(
                          label: p.riskLevel,
                          color: p.riskLevel == 'Low'
                              ? const Color(0xFF10B981)
                              : (p.riskLevel == 'Medium' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildMobileProjectCard(ProjectPerformanceItem p, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  p.projectName,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              ReportStatusBadge(label: p.status, color: p.statusColor),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'PM: ${p.projectManager} • Target: ${p.plannedCompletion}',
            style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text('Progress: ${p.progressPercent}%', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700)),
              Text('Budget: ₹${p.actualCostLakhs}L / ₹${p.budgetLakhs}L', style: GoogleFonts.jetBrainsMono(fontSize: 10.5)),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 4. PROJECT MANAGER PERFORMANCE & RISKS
  // ==========================================================================
  Widget _buildPmPerformanceSection(bool isDark, bool isMobile) {
    final pms = ReportsMockData.projectManagerPerformanceList;

    return ReportSectionContainer(
      title: 'Project Manager Delivery Rankings',
      subtitle: 'On-time milestone delivery SLA and task completion rates',
      icon: Icons.badge_outlined,
      iconColor: const Color(0xFF0D9488),
      child: Column(
        children: pms.map((pm) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.15),
                  child: Text(
                    pm.projectManager.isNotEmpty ? pm.projectManager[0] : 'P',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF0D9488)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              pm.projectManager,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${pm.onTimePercent}% On-Time', style: GoogleFonts.jetBrainsMono(fontSize: 11.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
                        ],
                      ),
                      Text(
                        'Active Sites: ${pm.activeProjects} • Completed: ${pm.completedProjects} • Overdue Tasks: ${pm.overdueTasks}',
                        style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  Widget _buildRisksSection(bool isDark) {
    final risks = ReportsMockData.projectRisksList;

    return ReportSectionContainer(
      title: 'Active Project Risks & Critical Issues',
      subtitle: 'Schedule conflicts, stockouts, and site-level mitigation plans',
      icon: Icons.report_problem_outlined,
      iconColor: const Color(0xFFEF4444),
      child: Column(
        children: risks.map((r) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
              border: Border.all(color: r.severityColor.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReportStatusBadge(label: r.severity, color: r.severityColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.projectName,
                        style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(r.riskTitle, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                const SizedBox(height: 2),
                Text('Mitigation: ${r.mitigation}', style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // 5. SITE MEDIA FEED
  // ==========================================================================
  Widget _buildSiteMediaFeed(bool isDark) {
    final feeds = ReportsMockData.siteMediaFeed;

    return ReportSectionContainer(
      title: 'Real-Time Site Inspection Media Feed',
      subtitle: 'Live photo and laser measurement uploads from site engineers',
      icon: Icons.photo_camera_outlined,
      iconColor: const Color(0xFF8B5CF6),
      child: Column(
        children: feeds.map((f) {
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                    borderRadius: AppRadius.sm,
                    border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.25)),
                  ),
                  child: const Icon(Icons.apartment_rounded, color: Color(0xFF8B5CF6), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              f.siteLocation,
                              style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(f.timeAgo, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                        ],
                      ),
                      Text('Stage: ${f.stage} • Uploaded by ${f.uploadedBy}', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF3B82F6))),
                      const SizedBox(height: 4),
                      Text(f.note, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
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

  TextStyle _headerStyle(bool isDark) {
    return GoogleFonts.inter(
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/reports_mock_data.dart';
import '../models/reports_models.dart';
import '../widgets/reports_common_widgets.dart';
import '../widgets/reports_controls_bar.dart';
import '../widgets/reports_drilldown_modal.dart';
import '../widgets/reports_export_dialog.dart';
import '../widgets/reports_filter_drawer.dart';

/// Screen 5: Design Analytics Screen.
/// Provides design studio heads, creative directors, and operations managers
/// with granular telemetry across design requests, 3D file turnaround time,
/// client approval cycles, revision drivers, designer productivity rankings,
/// and full-width design file lifecycle tracking.
class ReportsDesignPage extends StatefulWidget {
  const ReportsDesignPage({super.key});

  @override
  State<ReportsDesignPage> createState() => _ReportsDesignPageState();
}

class _ReportsDesignPageState extends State<ReportsDesignPage> {
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
      reportTitle: 'Design Productivity & SLA Turnaround Audit',
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
                title: 'Design Analytics',
                subtitle: 'Track design workload, turnaround time, approvals, revisions, productivity, and design delivery performance',
                icon: Icons.draw_rounded,
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
                // 1. Design KPI Cards Grid (12 Metrics)
                _buildKpisSection(isMobile, isTablet, isLargeDesktop),
                const SizedBox(height: 18),

                // 2. Design Workflow Funnel
                _buildWorkflowFunnelSection(isDark, isMobile),
                const SizedBox(height: 18),

                // 3. Turnaround SLA & Revision Analysis (Side by side on desktop)
                if (isMobile || isTablet) ...[
                  _buildTurnaroundSection(isDark, isMobile),
                  const SizedBox(height: 18),
                  _buildRevisionAnalysisSection(isDark, isMobile),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _buildTurnaroundSection(isDark, isMobile)),
                      const SizedBox(width: 16),
                      Expanded(flex: 6, child: _buildRevisionAnalysisSection(isDark, isMobile)),
                    ],
                  ),
                ],
                const SizedBox(height: 18),

                // 4. Designer Productivity Leaderboard Table
                _buildDesignerPerformanceTable(isDark, isMobile),
                const SizedBox(height: 18),

                // 5. Design Performance Master Table (Full Width)
                _buildDesignRecordsTable(isDark, isMobile),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. DESIGN KPIS SECTION
  // ==========================================================================
  Widget _buildKpisSection(bool isMobile, bool isTablet, bool isLargeDesktop) {
    final kpis = ReportsMockData.designKpis;
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
          growthPercent: 9.2,
          isPositive: k.isPositive,
          targetText: k.subtitle,
          targetProgress: k.targetProgress,
          icon: k.icon,
          color: k.color,
          onTap: () {
            _openDrilldown(
              k.title,
              'Design Deliverables',
              k.value,
              [
                {'id': 'DSG-201', 'title': 'DLF Magnolias 4BHK Master Suite V-Ray', 'subtitle': 'Designer: Kriti Sanon • V-Ray Render Approved', 'amount': null, 'status': 'Approved', 'statusColor': const Color(0xFF10B981)},
                {'id': 'DSG-202', 'title': 'Prestige Falcon City Kitchen Joinery', 'subtitle': 'Designer: Devansh Roy • Awaiting client laminate pick', 'amount': null, 'status': 'Pending Review', 'statusColor': const Color(0xFFF59E0B)},
                {'id': 'DSG-203', 'title': 'Godrej Woods False Ceiling CAD', 'subtitle': 'Designer: Ananya Deshmukh • A/C duct adjustment', 'amount': null, 'status': 'Revision Needed', 'statusColor': const Color(0xFFEF4444)},
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // 2. DESIGN WORKFLOW FUNNEL
  // ==========================================================================
  Widget _buildWorkflowFunnelSection(bool isDark, bool isMobile) {
    final stages = ReportsMockData.designWorkflowFunnel;

    return ReportSectionContainer(
      title: 'Design Delivery Workflow & SLA Pipeline',
      subtitle: 'Average turnaround duration and drop-offs across creative stages',
      icon: Icons.alt_route_rounded,
      iconColor: const Color(0xFF6366F1),
      child: Column(
        children: stages.map((s) {
          final statsText = isMobile
              ? '${s.count} (${s.percentage}%) • ${s.avgTimeHours}h'
              : '${s.count} files (${s.percentage}%) • Avg ${s.avgTimeHours}h';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        s.stageName,
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        statsText,
                        style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w600, color: s.color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: s.percentage / 100.0,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(s.color),
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
  // 3. TURNAROUND SLA & REVISION ANALYSIS
  // ==========================================================================
  Widget _buildTurnaroundSection(bool isDark, bool isMobile) {
    final metrics = ReportsMockData.designTurnaroundMetrics;

    return ReportSectionContainer(
      title: 'Turnaround Time (TAT) by Design Type',
      subtitle: 'Average, median, fastest, slowest days, and SLA compliance %',
      icon: Icons.timer_outlined,
      iconColor: const Color(0xFF3B82F6),
      child: Column(
        children: metrics.map((m) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.category, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(
                        isMobile ? '${m.medianDays}d med • ${m.fastestDays}d fast' : 'Median: ${m.medianDays}d • Fastest: ${m.fastestDays}d • Slowest: ${m.slowestDays}d',
                        style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${m.avgDays} Days Avg', style: GoogleFonts.jetBrainsMono(fontSize: 11.5, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6))),
                    Text('${m.slaCompliancePercent}% SLA Met', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRevisionAnalysisSection(bool isDark, bool isMobile) {
    final buckets = ReportsMockData.designRevisionBuckets;

    return ReportSectionContainer(
      title: 'Revision Frequency & Redesign Drivers',
      subtitle: '60.7% of deliverables achieve first-time homeowner approval',
      icon: Icons.replay_rounded,
      iconColor: const Color(0xFFF59E0B),
      child: Column(
        children: buckets.map((b) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        b.revisionRange,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isMobile ? '${b.designCount} (${b.percentage}%)' : '${b.designCount} designs (${b.percentage}%)',
                        style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w600, color: b.color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: b.percentage / 100.0,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(b.color),
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
  // 4. DESIGNER PRODUCTIVITY TABLE
  // ==========================================================================
  Widget _buildDesignerPerformanceTable(bool isDark, bool isMobile) {
    final designers = ReportsMockData.designerPerformanceList;

    return ReportSectionContainer(
      title: 'Designer Productivity & CSAT Rankings',
      subtitle: 'Completed deliverables, turnaround velocity, approval rate, and quality scorecard',
      icon: Icons.leaderboard_outlined,
      iconColor: const Color(0xFF10B981),
      trailing: ElevatedButton.icon(
        onPressed: _handleExport,
        icon: const Icon(Icons.download_rounded, size: 13),
        label: Text('Export Rankings', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),
      child: isMobile
          ? Column(children: designers.map((d) => _buildMobileDesignerCard(d, isDark)).toList())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 36,
                dataRowMinHeight: 44,
                dataRowMaxHeight: 48,
                columnSpacing: 18,
                horizontalMargin: 8,
                columns: [
                  DataColumn(label: Text('Rank', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Designer', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Team', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Assigned', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Completed', style: _headerStyle(isDark))),
                  DataColumn(label: Text('In Progress', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Avg TAT', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Avg Revisions', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Approval Rate', style: _headerStyle(isDark))),
                  DataColumn(label: Text('On-Time %', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Quality Score', style: _headerStyle(isDark))),
                ],
                rows: designers.map((d) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: d.rank == 1
                                ? const Color(0xFFF59E0B).withValues(alpha: 0.18)
                                : (isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF1F5F9)),
                            shape: BoxShape.circle,
                          ),
                          child: Text('#${d.rank}', style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                              child: Text(
                                d.designerName.isNotEmpty ? d.designerName[0] : 'D',
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(d.designerName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      DataCell(Text(d.team, style: GoogleFonts.inter(fontSize: 11))),
                      DataCell(Text('${d.assignedDesigns}', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('${d.completedDesigns}', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)))),
                      DataCell(Text('${d.inProgressDesigns}', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('${d.avgTurnaroundDays}d', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('${d.avgRevisionCount}', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('${d.approvalRate}%', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1)))),
                      DataCell(Text('${d.onTimeDeliveryPercent}%', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: const Color(0xFF10B981)))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.15), borderRadius: AppRadius.full),
                          child: Text('${d.qualityScore} / 10', style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFF59E0B))),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildMobileDesignerCard(DesignerPerformanceDetailItem d, bool isDark) {
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
            backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.15),
            child: Text(
              d.designerName.isNotEmpty ? d.designerName[0] : 'D',
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
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
                        d.designerName,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${d.approvalRate}% Approval', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
                  ],
                ),
                Text(
                  '${d.team} • ${d.completedDesigns} Completed • TAT ${d.avgTurnaroundDays}d',
                  style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 5. DESIGN RECORDS MASTER TABLE
  // ==========================================================================
  Widget _buildDesignRecordsTable(bool isDark, bool isMobile) {
    final records = ReportsMockData.designRecordsList;

    return ReportSectionContainer(
      title: 'Design Deliverables Master Ledger',
      subtitle: 'File type, priority, assignment timelines, client approval status, and SLA compliance',
      icon: Icons.folder_open_outlined,
      iconColor: const Color(0xFF8B5CF6),
      child: isMobile
          ? Column(children: records.map((r) => _buildMobileRecordCard(r, isDark)).toList())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 36,
                dataRowMinHeight: 44,
                dataRowMaxHeight: 48,
                columnSpacing: 18,
                horizontalMargin: 8,
                columns: [
                  DataColumn(label: Text('Design File', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Designer', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Type', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Priority', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Assigned', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Due Date', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Status', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Approval', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Revisions', style: _headerStyle(isDark))),
                  DataColumn(label: Text('SLA Status', style: _headerStyle(isDark))),
                ],
                rows: records.map((r) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(r.designName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                            Text('${r.designId} • ${r.projectName}', style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                      DataCell(Text(r.designer, style: GoogleFonts.inter(fontSize: 11))),
                      DataCell(Text(r.designType, style: GoogleFonts.inter(fontSize: 10.5))),
                      DataCell(
                        ReportStatusBadge(
                          label: r.priority,
                          color: r.priority == 'Urgent'
                              ? const Color(0xFFEF4444)
                              : (r.priority == 'High' ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6)),
                        ),
                      ),
                      DataCell(Text(r.assignedDate, style: GoogleFonts.inter(fontSize: 11))),
                      DataCell(Text(r.dueDate, style: GoogleFonts.inter(fontSize: 11))),
                      DataCell(ReportStatusBadge(label: r.status, color: r.statusColor)),
                      DataCell(
                        Text(
                          r.approvalStatus,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: r.approvalStatus == 'Approved'
                                ? const Color(0xFF10B981)
                                : (r.approvalStatus == 'Pending' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                          ),
                        ),
                      ),
                      DataCell(Text('${r.revisionCount}', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(
                        ReportStatusBadge(
                          label: r.slaStatus,
                          color: r.slaStatus == 'Within SLA' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildMobileRecordCard(DesignRecordItem r, bool isDark) {
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
                  r.designName,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              ReportStatusBadge(label: r.status, color: r.statusColor),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${r.designId} • Designer: ${r.designer} • Due: ${r.dueDate}',
            style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Approval: ${r.approvalStatus}',
                  style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              ReportStatusBadge(label: r.slaStatus, color: r.slaStatus == 'Within SLA' ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
            ],
          ),
        ],
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

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../dashboard/widgets/compact_data_table.dart';
import '../models/reports_mock_data.dart';
import '../models/reports_models.dart';
import '../widgets/reports_charts.dart';
import '../widgets/reports_header.dart';
import '../widgets/reports_metric_card.dart';

/// Execution & Delays Telemetry Screen.
/// Highlights on-time (Green) vs >=1 week delay (Red alert), projects by stage pie charts,
/// client snag complaints, 10-day overdue site visit alerts, and photo/video timeline feeds.
class ReportsExecutionPage extends StatefulWidget {
  const ReportsExecutionPage({super.key});

  @override
  State<ReportsExecutionPage> createState() => _ReportsExecutionPageState();
}

class _ReportsExecutionPageState extends State<ReportsExecutionPage> {
  ReportDateFilter _dateFilter = ReportDateFilter.thisMonth;
  final List<ExecutionProjectProgressItem> _projects = List.from(ReportsMockData.executionProjects);
  final List<ExecutionComplaintItem> _complaints = List.from(ReportsMockData.executionComplaints);
  final List<SiteMediaFeedItem> _mediaFeed = List.from(ReportsMockData.siteMediaFeed);

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
              // Header
              ReportHeader(
                title: 'Execution & Project Delays',
                subtitle: 'Active site progression, milestone delay warnings, snag SLA metrics & physical audit compliance',
                icon: Icons.construction_rounded,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
                primaryAction: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 14),
                  label: Text(
                    'Export Delay Audit',
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

              // Critical Alert Banner: Delay & Overdue Visit Warnings
              _buildCriticalWarningBanner(isDark),
              const SizedBox(height: 16),

              // 4 Execution KPIs
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Charts Row: Projects by Stage Donut & Complaint Categories
              _buildChartsRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Full-Width Active Sites & Delays Ledger Table
              _buildProjectsTable(isDark),
              const SizedBox(height: 18),

              // Site Progress Media Timeline Feed
              _buildMediaTimelineFeed(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCriticalWarningBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C1919) : const Color(0xFFFEF2F2),
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.4 : 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, size: 15, color: Color(0xFFEF4444)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ALERT: 2 active sites (PRJ-984 & PRJ-988) have not had a physical engineer visit for >10 days. 4 projects are delayed by ≥1 week.',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
              ),
            ),
          ),
          const SizedBox(width: 8),
          DashboardBadge(
            label: 'AUDIT OVERDUE',
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.executionKpis;
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
        return ReportMetricCard(metric: kpis[index]);
      },
    );
  }

  Widget _buildChartsRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          const ReportExecutionStageDonutChart(),
          const SizedBox(height: 16),
          _buildComplaintsMatrixCard(isDark),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 5,
          child: ReportExecutionStageDonutChart(),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: _buildComplaintsMatrixCard(isDark),
        ),
      ],
    );
  }

  void _openSnagsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          title: Row(
            children: [
              const Icon(Icons.bug_report_outlined, size: 18, color: Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              Text(
                'Active Snag Complaints (${_complaints.length})',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _complaints.length,
              separatorBuilder: (_, _) => const Divider(height: 12),
              itemBuilder: (context, index) {
                final c = _complaints[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: c.statusColor.withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: Icon(Icons.warning_amber_rounded, size: 14, color: c.statusColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(c.ticketId, style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                              const SizedBox(width: 6),
                              Text('• ${c.clientName}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(c.issueDescription, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    DashboardBadge(label: c.status.toUpperCase(), color: c.statusColor),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: GoogleFonts.inter(fontSize: 12)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildComplaintsMatrixCard(bool isDark) {
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
              const Icon(Icons.bug_report_outlined, size: 16, color: Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Client Snags & Complaint Resolution SLA',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              InkWell(
                onTap: _openSnagsDialog,
                borderRadius: AppRadius.full,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: AppRadius.full,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '88.4% SLA Pass',
                        style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.arrow_forward_ios, size: 8, color: Color(0xFF10B981)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _complaintRow('1. Quality & Finish Snags', '24 cases', '88% solved in 48h', const Color(0xFF3B82F6), isDark),
          _complaintRow('2. Vendor Delivery Delays', '12 cases', 'Avg 4.2 days', const Color(0xFFF59E0B), isDark),
          _complaintRow('3. Site Cleanliness & Behaviour', '7 cases', '100% on-time cleanup', const Color(0xFF10B981), isDark),
          _complaintRow('4. Open Unresolved Tickets', '2 cases', 'In engineering review', const Color(0xFFEF4444), isDark),
        ],
      ),
    );
  }

  Widget _complaintRow(String title, String count, String resolution, Color color, bool isDark) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
              ),
              Text(
                resolution,
                style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ],
          ),
        ),
        Text(
          count,
          style: GoogleFonts.jetBrainsMono(fontSize: 11.5, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }

  Widget _buildProjectsTable(bool isDark) {
    return CompactTableCard(
      title: 'Active Sites Execution Status & Delay Tracker',
      subtitle: 'Green indicators show on-time milestones; Red badges highlight ≥1 week delivery delays',
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.file_download_outlined, size: 13),
        label: Text('Export Ledger', style: GoogleFonts.inter(fontSize: 11)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          visualDensity: VisualDensity.compact,
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, 960.0);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.2), // PROJECT ID
                  1: FlexColumnWidth(3.0), // PROJECT & CLIENT
                  2: FlexColumnWidth(2.0), // STAGE
                  3: FlexColumnWidth(2.0), // PROGRESS
                  4: FlexColumnWidth(1.6), // DELAY STATUS
                  5: FlexColumnWidth(1.8), // SITE ENGINEER
                  6: FlexColumnWidth(1.8), // LAST VISIT
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      _buildHeaderCell('PROJECT ID', isDark),
                      _buildHeaderCell('PROJECT / HOMEOWNER', isDark),
                      _buildHeaderCell('CURRENT STAGE', isDark),
                      _buildHeaderCell('PROGRESS %', isDark),
                      _buildHeaderCell('TIMELINE STATUS', isDark),
                      _buildHeaderCell('SITE ENGINEER', isDark),
                      _buildHeaderCell('LAST PHYSICAL AUDIT', isDark),
                    ],
                  ),
                  ..._projects.map((p) {
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.lightBorder.withValues(alpha: 0.8),
                            width: 0.8,
                          ),
                        ),
                      ),
                      children: [
                        // PROJECT ID
                        _buildDataCell(
                          Text(
                            p.projectId,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        // PROJECT / HOMEOWNER
                        _buildDataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.projectName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                p.clientName,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // CURRENT STAGE
                        _buildDataCell(
                          Text(
                            p.stage,
                            style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white),
                          ),
                        ),
                        // PROGRESS %
                        _buildDataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${p.progressPercent.toInt()}%',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              LinearProgressIndicator(
                                value: p.progressPercent / 100.0,
                                minHeight: 4,
                                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                valueColor: AlwaysStoppedAnimation<Color>(p.isDelayed ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ],
                          ),
                        ),
                        // TIMELINE STATUS
                        _buildDataCell(
                          DashboardBadge(
                            label: p.isDelayed ? 'DELAYED ${p.delayDays}D' : 'ON TIME (GREEN)',
                            color: p.isDelayed ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                          ),
                        ),
                        // SITE ENGINEER
                        _buildDataCell(
                          Text(
                            p.siteEngineer,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        // LAST PHYSICAL AUDIT
                        _buildDataCell(
                          Row(
                            children: [
                              Icon(
                                p.isVisitOverdue ? Icons.error_outline_rounded : Icons.check_circle_outline,
                                size: 14,
                                color: p.isVisitOverdue ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  p.lastPhysicalVisitDate,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: p.isVisitOverdue ? const Color(0xFFEF4444) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                    fontWeight: p.isVisitOverdue ? FontWeight.w700 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaTimelineFeed(bool isDark) {
    return CompactTableCard(
      title: 'Site Progress Video & Photo Timeline Feed',
      subtitle: 'Live visual proof uploaded by field engineers with milestone notes and timestamps',
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _mediaFeed.length,
        separatorBuilder: (_, _) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        itemBuilder: (context, index) {
          final m = _mediaFeed[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.sm,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        m.mediaUrl,
                        width: 90,
                        height: 65,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 90,
                          height: 65,
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          child: const Icon(Icons.image_outlined, size: 22),
                        ),
                      ),
                      if (m.isVideo)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, size: 16, color: Colors.white),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            m.clientName,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          DashboardBadge(label: m.stage.toUpperCase(), color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            m.timeAgo,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Location: ${m.siteLocation} • Uploaded by ${m.uploadedBy}',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.note,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening full resolution site media for ${m.clientName}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  tooltip: 'View Full Media',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCell(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: content,
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../dashboard/widgets/compact_data_table.dart';
import '../models/reports_mock_data.dart';
import '../models/reports_models.dart';
import '../widgets/reports_header.dart';
import '../widgets/reports_metric_card.dart';

/// Design Productivity & CSAT Scorecard Executive Screen.
/// Features file approval telemetry, CSAT scores out of 10,
/// team ranking with prize mentions, compensation breakdowns, and design file status tables.
class ReportsDesignPage extends StatefulWidget {
  const ReportsDesignPage({super.key});

  @override
  State<ReportsDesignPage> createState() => _ReportsDesignPageState();
}

class _ReportsDesignPageState extends State<ReportsDesignPage> {
  ReportDateFilter _dateFilter = ReportDateFilter.thisMonth;
  final List<DesignFileApprovalItem> _files = List.from(ReportsMockData.designApprovals);

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
                title: 'Design Productivity & CSAT Ratings',
                subtitle: 'File approvals pipeline, 3D rendering hours, customer satisfaction index & designer rankings',
                icon: Icons.draw_rounded,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
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

              // 4 Design KPIs
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Designer of the Month & CSAT Scorecard Row
              _buildPerformerAndCsatRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Designer Compensation & Incentive Breakdown Card
              _buildCompensationHero(isDark, isMobile),
              const SizedBox(height: 18),

              // Full-Width Design File Approvals & Revision Table
              _buildFileApprovalsTable(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.designKpis;
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

  Widget _buildPerformerAndCsatRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          _buildTopPerformerCard(isDark),
          const SizedBox(height: 16),
          _buildCsatScorecard(isDark),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _buildTopPerformerCard(isDark),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: _buildCsatScorecard(isDark),
        ),
      ],
    );
  }

  Widget _buildTopPerformerCard(bool isDark) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.4 : 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, size: 18, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  Text(
                    'Designer of the Month (Rank #1)',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                ),
                child: Text(
                  'Prize: ₹25,000 Bonus',
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFF59E0B)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                child: const Text('KS', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFF59E0B))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kriti Sanon (Lead Architect)',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '34 3D files completed • 14 client projects closed • 98.2% Score',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metricPill('172 hrs', 'Worked', const Color(0xFF3B82F6), isDark),
              _metricPill('22 Meets', 'Consultations', const Color(0xFF10B981), isDark),
              _metricPill('8 Visits', 'Site Audits', const Color(0xFF8B5CF6), isDark),
              _metricPill('9.8 / 10', 'CSAT', const Color(0xFFF59E0B), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricPill(String val, String label, Color color, bool isDark) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 1),
        Text(label, style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
      ],
    );
  }

  Widget _buildCsatScorecard(bool isDark) {
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
              const Icon(Icons.star_half_rounded, size: 16, color: Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Client CSAT Breakdown (9.3 / 10.0)',
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
                  'Grade A+',
                  style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                ),
              ),
            ],
          ),
          _csatBarRow('1. Design Quality & Material Aesthetics', 9.5, 10.0, const Color(0xFF10B981), isDark),
          _csatBarRow('2. Punctuality & 3D Milestone Delivery', 9.1, 10.0, const Color(0xFF3B82F6), isDark),
          _csatBarRow('3. Designer Communication & Site Demeanor', 9.4, 10.0, const Color(0xFF8B5CF6), isDark),
          _csatBarRow('4. Budget Alignment & Estimation Accuracy', 9.2, 10.0, const Color(0xFFF59E0B), isDark),
        ],
      ),
    );
  }

  Widget _csatBarRow(String title, double score, double maxScore, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              '${score.toStringAsFixed(1)} / $maxScore',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: (score / maxScore).clamp(0.02, 1.0),
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompensationHero(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCompItem('Base Salary', '₹60,000', const Color(0xFF3B82F6), isDark),
                const SizedBox(height: 10),
                _buildCompItem('Overtime Hours', '+₹8,500', const Color(0xFF10B981), isDark),
                const SizedBox(height: 10),
                _buildCompItem('Project Incentives', '+₹22,000', const Color(0xFF8B5CF6), isDark),
                const SizedBox(height: 10),
                _buildCompItem('Tax & TDS Deductions', '-₹2,500', const Color(0xFFEF4444), isDark),
                const Divider(height: 16),
                _buildCompItem('Net Monthly Earnings', '₹88,000', const Color(0xFF10B981), isDark, isTotal: true),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCompItem('Base Salary', '₹60,000', const Color(0xFF3B82F6), isDark),
                Container(width: 1, height: 36, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                _buildCompItem('Overtime Hours', '+₹8,500', const Color(0xFF10B981), isDark),
                Container(width: 1, height: 36, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                _buildCompItem('Project Incentives', '+₹22,000', const Color(0xFF8B5CF6), isDark),
                Container(width: 1, height: 36, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                _buildCompItem('Tax Deductions', '-₹2,500', const Color(0xFFEF4444), isDark),
                Container(width: 1, height: 36, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                _buildCompItem('Net Take-Home', '₹88,000', const Color(0xFF10B981), isDark, isTotal: true),
              ],
            ),
    );
  }

  Widget _buildCompItem(String title, String val, Color color, bool isDark, {bool isTotal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 11.5 : 10.5,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: GoogleFonts.jetBrainsMono(
            fontSize: isTotal ? 15 : 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFileApprovalsTable(bool isDark) {
    return CompactTableCard(
      title: 'Design File Approval Pipeline & Revisions',
      subtitle: '3D renders, working drawings & CNC cutting sheets sent to site execution',
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.file_download_outlined, size: 13),
        label: Text('Export Audit', style: GoogleFonts.inter(fontSize: 11)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          visualDensity: VisualDensity.compact,
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, 920.0);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.2), // PROJECT ID
                  1: FlexColumnWidth(2.8), // PROJECT & CLIENT
                  2: FlexColumnWidth(1.8), // DESIGNER
                  3: FlexColumnWidth(2.2), // FILE TYPE
                  4: FlexColumnWidth(1.4), // STATUS
                  5: FlexColumnWidth(1.4), // DATE
                  6: FlexColumnWidth(3.0), // NOTES
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
                      _buildHeaderCell('PROJECT / CLIENT', isDark),
                      _buildHeaderCell('DESIGN LEAD', isDark),
                      _buildHeaderCell('FILE TYPE', isDark),
                      _buildHeaderCell('STATUS', isDark),
                      _buildHeaderCell('SUBMITTED', isDark),
                      _buildHeaderCell('REVIEW NOTES', isDark),
                    ],
                  ),
                  ..._files.map((f) {
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
                            f.projectId,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        // PROJECT / CLIENT
                        _buildDataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.projectName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                f.clientName,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // DESIGN LEAD
                        _buildDataCell(
                          Text(
                            f.designerName,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        // FILE TYPE
                        _buildDataCell(
                          Text(
                            f.fileType,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // STATUS
                        _buildDataCell(
                          DashboardBadge(label: f.status.toUpperCase(), color: f.statusColor),
                        ),
                        // SUBMITTED
                        _buildDataCell(
                          Text(
                            f.submittedDate,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // REVIEW NOTES
                        _buildDataCell(
                          Text(
                            f.reviewNotes,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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

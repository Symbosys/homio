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

/// Vendor & Labour Ratings Scorecard Screen.
/// Highlights contractor performance scores /10, critical alerts for scores < 5.0,
/// Winner of the Month recognition, and detailed trade scorecards.
class ReportsVendorRatingsPage extends StatefulWidget {
  const ReportsVendorRatingsPage({super.key});

  @override
  State<ReportsVendorRatingsPage> createState() => _ReportsVendorRatingsPageState();
}

class _ReportsVendorRatingsPageState extends State<ReportsVendorRatingsPage> {
  ReportDateFilter _dateFilter = ReportDateFilter.thisQuarter;
  String _tradeFilter = 'All Trades';
  final List<VendorScorecardItem> _vendors = List.from(ReportsMockData.vendorScorecards);

  void _openVendorAuditDialog(VendorScorecardItem vendor) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          title: Row(
            children: [
              const Icon(Icons.verified_user_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Quality Audit: ${vendor.vendorName}',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Trade Category: ${vendor.tradeCategory} • Active Sites: ${vendor.activeSitesCount}',
                  style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(height: 14),
                _auditScoreTile('1. Finish & Joinery Quality', vendor.qualityScore, isDark),
                const SizedBox(height: 8),
                _auditScoreTile('2. Milestone Punctuality SLA', vendor.punctualityScore, isDark),
                const SizedBox(height: 8),
                _auditScoreTile('3. Material Wastage & Yield Control', vendor.wastageControlScore, isDark),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (vendor.isCriticalAlert ? const Color(0xFFEF4444) : const Color(0xFF10B981)).withValues(alpha: 0.12),
                    borderRadius: AppRadius.sm,
                    border: Border.all(
                      color: (vendor.isCriticalAlert ? const Color(0xFFEF4444) : const Color(0xFF10B981)).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    vendor.isCriticalAlert
                        ? 'CRITICAL WARNING: Score below 5.0 threshold. Mandatory supervisor re-audit required before new project assignment.'
                        : 'COMPLIANT: Vendor meets Homio Gold Standard specifications.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: vendor.isCriticalAlert ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: GoogleFonts.inter(fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Audit report generated for ${vendor.vendorName}'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Generate Audit Certificate', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  Widget _auditScoreTile(String label, double score, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
            Text('${score.toInt()}%', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: score >= 80 ? const Color(0xFF10B981) : const Color(0xFFEF4444))),
          ],
        ),
        const SizedBox(height: 3),
        LinearProgressIndicator(
          value: score / 100.0,
          minHeight: 4,
          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          valueColor: AlwaysStoppedAnimation<Color>(score >= 80 ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
          borderRadius: BorderRadius.circular(2),
        ),
      ],
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
              // Header
              ReportHeader(
                title: 'Vendor & Labour Ratings',
                subtitle: 'Subcontractor scorecards, trade performance evaluations, critical audit alerts & winner recognition',
                icon: Icons.star_half_rounded,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
                additionalFilters: [
                  _buildTradeFilter(isDark),
                ],
                primaryAction: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 14),
                  label: Text(
                    'Export Scorecards',
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

              // Critical Alert Banner (< 5.0 Ratings)
              _buildCriticalVendorBanner(isDark),
              const SizedBox(height: 16),

              // 4 Vendor KPIs
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Winner of the Month Hero Showcase
              _buildWinnerOfMonthHero(isDark, isMobile),
              const SizedBox(height: 18),

              // Full-Width Vendor Scorecard Ledger Table
              _buildVendorTable(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeFilter(bool isDark) {
    const trades = ['All Trades', 'Carpentry', 'Civil & Masonry', 'Electrical', 'Plumbing', 'Painting'];
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _tradeFilter,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
          dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.sm,
          items: trades.map((t) {
            return DropdownMenuItem<String>(
              value: t,
              child: Text(t),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _tradeFilter = val);
          },
        ),
      ),
    );
  }

  Widget _buildCriticalVendorBanner(bool isDark) {
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
            child: const Icon(Icons.report_problem_outlined, size: 15, color: Color(0xFFEF4444)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'QUALITY ALERT: 2 vendor contractors (Shree Sai Painters & Prime Flow Sanitary) scored below 5.0 / 10.0. Further project assignments paused pending onsite audit.',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
              ),
            ),
          ),
          const SizedBox(width: 8),
          DashboardBadge(
            label: 'AUDIT REQUIRED',
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.vendorKpis;
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

  Widget _buildWinnerOfMonthHero(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.4 : 0.3),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWinnerTitle(isDark),
                const SizedBox(height: 12),
                _buildWinnerStats(isDark),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 5, child: _buildWinnerTitle(isDark)),
                Container(width: 1, height: 60, color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: _buildWinnerStats(isDark)),
              ],
            ),
    );
  }

  Widget _buildWinnerTitle(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.workspace_premium_rounded, size: 24, color: Color(0xFFF59E0B)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Royal Woodcraft & Modulars',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  DashboardBadge(label: 'WINNER', color: const Color(0xFFF59E0B)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Trade: Carpentry & Joinery • 6 active sites • 0 snags reported in 90 days',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWinnerStats(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _winnerPill('9.8 / 10', 'Overall Rating', const Color(0xFF10B981), isDark),
        _winnerPill('99.0%', 'Quality Score', const Color(0xFF3B82F6), isDark),
        _winnerPill('96.0%', 'Punctuality', const Color(0xFF8B5CF6), isDark),
        _winnerPill('42 Sites', 'Completed', const Color(0xFFF59E0B), isDark),
      ],
    );
  }

  Widget _winnerPill(String val, String label, Color color, bool isDark) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 1),
        Text(label, style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
      ],
    );
  }

  Widget _buildVendorTable(bool isDark) {
    return CompactTableCard(
      title: 'Certified Vendor & Labour Scorecards',
      subtitle: 'Complete trade performance audits including finish quality, punctuality and material wastage indices',
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
          final tableWidth = math.max(constraints.maxWidth, 960.0);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.2), // VENDOR ID
                  1: FlexColumnWidth(3.0), // VENDOR NAME
                  2: FlexColumnWidth(2.0), // TRADE
                  3: FlexColumnWidth(1.5), // RATING /10
                  4: FlexColumnWidth(1.4), // QUALITY
                  5: FlexColumnWidth(1.4), // PUNCTUALITY
                  6: FlexColumnWidth(1.4), // ACTIVE SITES
                  7: FlexColumnWidth(1.4), // AUDIT STATUS
                  8: FlexColumnWidth(1.0), // ACTION
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
                      _buildHeaderCell('VENDOR ID', isDark),
                      _buildHeaderCell('CONTRACTOR / AGENCY', isDark),
                      _buildHeaderCell('TRADE CATEGORY', isDark),
                      _buildHeaderCell('OVERALL RATING', isDark),
                      _buildHeaderCell('QUALITY %', isDark),
                      _buildHeaderCell('PUNCTUAL %', isDark),
                      _buildHeaderCell('ACTIVE SITES', isDark),
                      _buildHeaderCell('AUDIT STATUS', isDark),
                      _buildHeaderCell('ACTION', isDark, align: TextAlign.center),
                    ],
                  ),
                  ..._vendors.map((v) {
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
                        // VENDOR ID
                        _buildDataCell(
                          Text(
                            v.vendorId,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        // CONTRACTOR / AGENCY
                        _buildDataCell(
                          Row(
                            children: [
                              if (v.isWinnerOfMonth)
                                const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(Icons.workspace_premium, size: 14, color: Color(0xFFF59E0B)),
                                ),
                              Expanded(
                                child: Text(
                                  v.vendorName,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // TRADE
                        _buildDataCell(
                          Text(
                            v.tradeCategory,
                            style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                        // RATING /10
                        _buildDataCell(
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: v.overallRating >= 8.0
                                    ? const Color(0xFF10B981)
                                    : (v.overallRating >= 5.0 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${v.overallRating.toStringAsFixed(1)} / 10',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: v.overallRating >= 8.0
                                      ? const Color(0xFF10B981)
                                      : (v.overallRating >= 5.0 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // QUALITY
                        _buildDataCell(
                          Text(
                            '${v.qualityScore.toInt()}%',
                            style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                          ),
                        ),
                        // PUNCTUAL
                        _buildDataCell(
                          Text(
                            '${v.punctualityScore.toInt()}%',
                            style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                          ),
                        ),
                        // ACTIVE SITES
                        _buildDataCell(
                          Text(
                            '${v.activeSitesCount} Sites',
                            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                        // AUDIT STATUS
                        _buildDataCell(
                          DashboardBadge(
                            label: v.auditStatus.toUpperCase(),
                            color: v.auditStatus == 'Certified'
                                ? const Color(0xFF10B981)
                                : (v.auditStatus == 'Audit Pending' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                          ),
                        ),
                        // ACTION
                        _buildDataCell(
                          Center(
                            child: TextButton(
                              onPressed: () => _openVendorAuditDialog(v),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                minimumSize: const Size(40, 26),
                              ),
                              child: Text(
                                'Audit',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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

  Widget _buildHeaderCell(String text, bool isDark, {TextAlign align = TextAlign.start}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget content, {EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: content,
    );
  }
}

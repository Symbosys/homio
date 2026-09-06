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

/// Sales & Telecalling Reports Executive Screen.
/// Provides meeting types, objections bar charts, calling minutes telemetry,
/// and full-width sales top ranker leaderboard table.
class ReportsSalesPage extends StatefulWidget {
  const ReportsSalesPage({super.key});

  @override
  State<ReportsSalesPage> createState() => _ReportsSalesPageState();
}

class _ReportsSalesPageState extends State<ReportsSalesPage> {
  ReportDateFilter _dateFilter = ReportDateFilter.thisMonth;
  String _meetingTypeFilter = 'All Formats';
  final List<SalesTopRankerItem> _rankers = List.from(ReportsMockData.salesTopRankers);

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
                title: 'Sales & Telecalling Performance',
                subtitle: 'Consultation conversions, objection analytics, calling duration & consultant leaderboards',
                icon: Icons.phone_in_talk_rounded,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
                additionalFilters: [
                  _buildMeetingFormatFilter(isDark),
                ],
                primaryAction: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 14),
                  label: Text(
                    'Export CSV',
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

              // 4 Sales KPIs
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Objections Analysis & Meeting Formats Row
              _buildObjectionsAndFormatsRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Full-Width Top Rankers Leaderboard Table
              _buildLeaderboardTable(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingFormatFilter(bool isDark) {
    const formats = ['All Formats', 'Site Visits (48%)', 'Experience Center (36%)', 'Zoom / Online (16%)'];
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
          value: _meetingTypeFilter,
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
          items: formats.map((f) {
            return DropdownMenuItem<String>(
              value: f,
              child: Text(f),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _meetingTypeFilter = val);
          },
        ),
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.salesKpis;
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

  Widget _buildObjectionsAndFormatsRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          ReportObjectionsBarChart(objections: ReportsMockData.salesObjections),
          const SizedBox(height: 16),
          _buildTelecallingSummaryCard(isDark),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: ReportObjectionsBarChart(objections: ReportsMockData.salesObjections),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: _buildTelecallingSummaryCard(isDark),
        ),
      ],
    );
  }

  Widget _buildTelecallingSummaryCard(bool isDark) {
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
              const Icon(Icons.speed_rounded, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Telecalling Efficiency Index',
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
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          _telecomStatRow('Outbound Dials Logged', '1,480 calls', '+14.2% vs SLA', const Color(0xFF3B82F6), isDark),
          _telecomStatRow('Total Talk Time', '104.0 hours', 'Avg 4.2 mins/call', const Color(0xFF10B981), isDark),
          _telecomStatRow('Meetings Converted', '315 sessions', '21.3% dial-to-meet', const Color(0xFF8B5CF6), isDark),
          _telecomStatRow('Followups Pending', '42 scheduled', 'Within SLA window', const Color(0xFFF59E0B), isDark),
        ],
      ),
    );
  }

  Widget _telecomStatRow(String title, String value, String sub, Color color, bool isDark) {
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
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              Text(
                sub,
                style: GoogleFonts.inter(
                  fontSize: 9.5,
                  color: isDark ? AppColors.darkTextSecondary.withValues(alpha: 0.7) : AppColors.lightTextSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardTable(bool isDark) {
    return CompactTableCard(
      title: 'Sales Consultants Leaderboard & Top Rankers',
      subtitle: 'Rankings calculated across total calls, talk minutes, consultations done, and closed order values',
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.file_download_outlined, size: 13),
        label: Text('Export Leaderboard', style: GoogleFonts.inter(fontSize: 11)),
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
                  0: FlexColumnWidth(1.0), // RANK
                  1: FlexColumnWidth(3.0), // CONSULTANT
                  2: FlexColumnWidth(1.4), // CALLS LOGGED
                  3: FlexColumnWidth(1.4), // MINUTES
                  4: FlexColumnWidth(1.4), // MEETINGS
                  5: FlexColumnWidth(1.4), // BOOKINGS
                  6: FlexColumnWidth(1.6), // REVENUE (₹)
                  7: FlexColumnWidth(1.3), // WIN RATE
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
                      _buildHeaderCell('# RANK', isDark),
                      _buildHeaderCell('SALES CONSULTANT', isDark),
                      _buildHeaderCell('CALLS LOGGED', isDark),
                      _buildHeaderCell('TOTAL MINS', isDark),
                      _buildHeaderCell('MEETINGS', isDark),
                      _buildHeaderCell('BOOKINGS', isDark),
                      _buildHeaderCell('REVENUE (LAKHS)', isDark),
                      _buildHeaderCell('WIN RATE', isDark),
                    ],
                  ),
                  ..._rankers.map((r) {
                    final isTop3 = r.rank <= 3;
                    final rankColor = r.rank == 1
                        ? const Color(0xFFF59E0B)
                        : (r.rank == 2 ? const Color(0xFF94A3B8) : const Color(0xFFB45309));

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
                        // RANK
                        _buildDataCell(
                          Row(
                            children: [
                              if (isTop3)
                                Icon(Icons.emoji_events, size: 14, color: rankColor)
                              else
                                const SizedBox(width: 14),
                              const SizedBox(width: 4),
                              Text(
                                '#${r.rank}',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: isTop3 ? rankColor : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // CONSULTANT
                        _buildDataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                                child: Text(
                                  r.consultantName.substring(0, 1),
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  r.consultantName,
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
                        // CALLS LOGGED
                        _buildDataCell(
                          Text(
                            '${r.callsCount}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        // MINUTES
                        _buildDataCell(
                          Text(
                            '${r.callMinutes}m',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // MEETINGS
                        _buildDataCell(
                          Text(
                            '${r.meetingsDone}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        // BOOKINGS
                        _buildDataCell(
                          Text(
                            '${r.bookingsCount} Closed',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                        // REVENUE
                        _buildDataCell(
                          Text(
                            '₹${r.revenueGenerated.toStringAsFixed(1)} Lakhs',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                        // WIN RATE
                        _buildDataCell(
                          DashboardBadge(
                            label: '${r.conversionRate.toStringAsFixed(1)}%',
                            color: r.conversionRate >= 45.0 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
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

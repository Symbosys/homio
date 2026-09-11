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

/// Screen 9: Customer Feedback Analytics Screen.
/// Enterprise-grade customer satisfaction, NPS, and sentiment tracking.
class ReportsFeedbackPage extends StatefulWidget {
  const ReportsFeedbackPage({super.key});

  @override
  State<ReportsFeedbackPage> createState() => _ReportsFeedbackPageState();
}

class _ReportsFeedbackPageState extends State<ReportsFeedbackPage> {
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
      reportTitle: 'Customer Feedback & CSAT Report',
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
                title: 'Customer Feedback Analytics',
                subtitle: 'Monitor customer satisfaction, feedback trends, ratings, complaints, resolution performance, and experience quality',
                icon: Icons.reviews_rounded,
                filterState: _filterState,
                onFilterChanged: (newFilter) => setState(() => _filterState = newFilter),
                onOpenFilterDrawer: _openFilterDrawer,
                onExport: _openExportDialog,
                onRefresh: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Customer surveys and NPS sentiment stream refreshed', style: GoogleFonts.inter(fontSize: 12)),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onSaveView: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved current customer feedback view preset'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              // 2. Customer Experience KPIs
              _buildFeedbackKpis(isMobile, isTablet),
              const SizedBox(height: 16),

              // 3. Attention Required: Escalations & Low Ratings
              _buildAlertsSection(isDark),
              const SizedBox(height: 16),

              // 4. Rating Distribution & Sentiment Breakdown (Split Grid)
              if (isMobile || isTablet) ...[
                _buildRatingDistributionSection(isDark),
                const SizedBox(height: 16),
                _buildSentimentBreakdownSection(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildRatingDistributionSection(isDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: _buildSentimentBreakdownSection(isDark),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // 5. Complaints & Issue Resolution Table
              _buildComplaintsSection(isDark, isMobile),
              const SizedBox(height: 16),

              // 6. Master Customer Feedback Register
              _buildMasterFeedbackTable(isDark, isMobile),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION 1: FEEDBACK KPIS
  // ==========================================================================
  Widget _buildFeedbackKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.feedbackKpis;
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
                  'title': 'Rajiv Singhania • 5.0 ★ Review',
                  'subtitle': 'DLF Camellias Luxury Penthouse Fitout',
                  'status': 'Verified 5-Star',
                  'statusColor': const Color(0xFF10B981),
                  'metric': '100% CSAT',
                  'date': 'Sep 06, 2026',
                  'badge': 'Promoter',
                },
                {
                  'title': 'Gaurav Khandelwal • 2.0 ★ Ticket',
                  'subtitle': 'Gurgaon Golf Course Residence',
                  'status': 'Escalated',
                  'statusColor': const Color(0xFFEF4444),
                  'metric': 'Detractor (-100 NPS)',
                  'date': 'Sep 01, 2026',
                  'badge': 'HVAC Delay Ticket',
                },
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // SECTION 2: ATTENTION REQUIRED ALERTS
  // ==========================================================================
  Widget _buildAlertsSection(bool isDark) {
    final alerts = ReportsMockData.customerExperienceAlerts;

    return ReportSectionContainer(
      title: 'Customer Experience Exceptions — Attention Required',
      subtitle: 'Critical escalation notices, low ratings, and unresolved complaints exceeding SLA',
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFEF4444),
      child: Column(
        children: alerts.map((a) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: a.severityColor.withValues(alpha: isDark ? 0.12 : 0.05),
              borderRadius: AppRadius.sm,
              border: Border.all(color: a.severityColor.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.error_outline_rounded, size: 18, color: a.severityColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              a.issueType,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: a.severityColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(color: a.severityColor.withValues(alpha: 0.2), borderRadius: AppRadius.xs),
                            child: Text('${a.daysOpen}d Open', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: a.severityColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${a.customerName} • ${a.projectName}: ${a.details}',
                        style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _onDrillDown(
                      'Escalation: ${a.customerName}',
                      a.issueType,
                      'Rating: ${a.rating} ★',
                      [
                        {
                          'title': a.issueType,
                          'subtitle': 'Assigned to Executive Escalation Desk',
                          'status': 'Action Required',
                          'statusColor': a.severityColor,
                          'metric': '${a.daysOpen} Days Open',
                          'date': 'Requires Resolution',
                          'badge': a.actionRequired,
                        },
                      ],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: a.severityColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: const Size(60, 28),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.xs),
                  ),
                  child: Text('Review', style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // SECTION 3: RATING DISTRIBUTION
  // ==========================================================================
  Widget _buildRatingDistributionSection(bool isDark) {
    final ratings = ReportsMockData.feedbackRatingDistribution;

    return ReportSectionContainer(
      title: 'Star Rating Distribution',
      subtitle: 'Breakdown of 264 verified customer ratings across turnkey milestones',
      icon: Icons.star_half_rounded,
      iconColor: const Color(0xFFF59E0B),
      child: ReportCustomerRatingBarChart(ratings: ratings),
    );
  }

  // ==========================================================================
  // SECTION 4: SENTIMENT THEMES
  // ==========================================================================
  Widget _buildSentimentBreakdownSection(bool isDark) {
    final sentiments = ReportsMockData.feedbackSentiments;

    return ReportSectionContainer(
      title: 'Sentiment & Experience Tone',
      subtitle: 'Automated natural language sentiment classification on client comments',
      icon: Icons.psychology_rounded,
      iconColor: const Color(0xFF6366F1),
      child: Column(
        children: sentiments.map((s) {
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
                        s.sentiment,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${s.count} (${s.percentage.toStringAsFixed(1)}%) • ${s.trendText}',
                        style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w600, color: s.color),
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
                    value: (s.percentage / 100).clamp(0.02, 1.0),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(s.color),
                    minHeight: 6,
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
  // SECTION 5: COMPLAINTS REGISTER
  // ==========================================================================
  Widget _buildComplaintsSection(bool isDark, bool isMobile) {
    final complaints = ReportsMockData.feedbackComplaints;

    return ReportSectionContainer(
      title: 'Customer Complaints & Grievance Log',
      subtitle: 'Formal customer escalation tickets, root causes, assigned managers & resolution days',
      icon: Icons.support_agent_rounded,
      iconColor: const Color(0xFFEF4444),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 38,
          dataRowMinHeight: 46,
          dataRowMaxHeight: 52,
          horizontalMargin: 8,
          columnSpacing: 16,
          columns: [
            DataColumn(label: Text('Complaint ID', style: _headerStyle(isDark))),
            DataColumn(label: Text('Customer / Project', style: _headerStyle(isDark))),
            DataColumn(label: Text('Category', style: _headerStyle(isDark))),
            DataColumn(label: Text('Assigned To', style: _headerStyle(isDark))),
            DataColumn(label: Text('Priority', style: _headerStyle(isDark))),
            DataColumn(label: Text('Status', style: _headerStyle(isDark))),
            DataColumn(label: Text('Resolution Time', style: _headerStyle(isDark))),
          ],
          rows: complaints.map((c) {
            return DataRow(
              cells: [
                DataCell(Text(c.complaintId, style: _monoStyle(isDark))),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(c.customerName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                      Text(c.projectName, style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
                DataCell(Text(c.category, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary))),
                DataCell(Text(c.assignedTo, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: c.priorityColor.withValues(alpha: 0.15), borderRadius: AppRadius.xs),
                    child: Text(c.priority, style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: c.priorityColor)),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: c.statusColor.withValues(alpha: 0.15), borderRadius: AppRadius.xs),
                    child: Text(c.status, style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: c.statusColor)),
                  ),
                ),
                DataCell(
                  Text(
                    '${c.resolutionDays} Days ${c.isSlaBreached ? '(Breached)' : ''}',
                    style: _monoStyle(isDark, color: c.isSlaBreached ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
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
  // SECTION 6: MASTER FEEDBACK REGISTER TABLE
  // ==========================================================================
  Widget _buildMasterFeedbackTable(bool isDark, bool isMobile) {
    final records = ReportsMockData.customerFeedbackRecords;

    return ReportSectionContainer(
      title: 'Customer Feedback & Review Stream',
      subtitle: 'Live feed of milestone reviews, customer ratings, verbatim feedback, and supervisor response',
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
            DataColumn(label: Text('Feedback ID', style: _headerStyle(isDark))),
            DataColumn(label: Text('Customer / Project', style: _headerStyle(isDark))),
            DataColumn(label: Text('Rating', style: _headerStyle(isDark))),
            DataColumn(label: Text('Sentiment', style: _headerStyle(isDark))),
            DataColumn(label: Text('Comments', style: _headerStyle(isDark))),
            DataColumn(label: Text('Lead Assigned', style: _headerStyle(isDark))),
            DataColumn(label: Text('Date', style: _headerStyle(isDark))),
          ],
          rows: records.map((r) {
            final isPositive = r.sentiment == 'Positive';
            final color = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);

            return DataRow(
              cells: [
                DataCell(Text(r.feedbackId, style: _monoStyle(isDark))),
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
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 3),
                      Text('${r.rating}', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                    ],
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: AppRadius.xs),
                    child: Text(r.sentiment, style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: color)),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 260,
                    child: Text(
                      r.comments,
                      style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(r.assignedEmployee, style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
                DataCell(Text(r.feedbackDate, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
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

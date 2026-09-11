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
import '../widgets/reports_stage_funnel.dart';

/// Screen 2: Marketing Analytics Screen.
/// Provides marketing leaders and growth teams with real-time telemetry across
/// paid ad campaigns, organic lead generation, channel ROAS, stage conversion funnel,
/// campaign performance ledger, and high vs underperforming initiative triage.
class ReportsMarketingPage extends StatefulWidget {
  const ReportsMarketingPage({super.key});

  @override
  State<ReportsMarketingPage> createState() => _ReportsMarketingPageState();
}

class _ReportsMarketingPageState extends State<ReportsMarketingPage> {
  ReportFilterState _filterState = const ReportFilterState();
  bool _isLoading = false;
  final List<SocialCommentItem> _comments = List.from(ReportsMockData.socialComments);

  void _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _isLoading = false);
  }

  void _handleExport() {
    ReportsExportDialog.show(
      context,
      reportTitle: 'Marketing Performance & Campaign ROI Audit',
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

  void _handleAiReplyToggle(int index) {
    setState(() {
      final item = _comments[index];
      _comments[index] = SocialCommentItem(
        id: item.id,
        author: item.author,
        platform: item.platform,
        commentText: item.commentText,
        postTitle: item.postTitle,
        timeAgo: item.timeAgo,
        isAiReplied: !item.isAiReplied,
        replyText: !item.isAiReplied
            ? 'Thank you for reaching out! Our senior designer has sent you an instant direct message.'
            : null,
      );
    });
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
                title: 'Marketing Analytics',
                subtitle: 'Track campaigns, lead generation, acquisition performance, conversion, spend, and marketing ROI',
                icon: Icons.campaign_rounded,
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
                // 1. Marketing KPI Grid (11 KPI metrics)
                _buildKpisSection(isMobile, isTablet, isLargeDesktop),
                const SizedBox(height: 18),

                // 2. Interactive Conversion Funnel
                const ReportStageFunnelWidget(stages: ReportsMockData.marketingFunnelStages),
                const SizedBox(height: 18),

                // 3. Lead Acquisition by Source & Channel Performance (Side by side on desktop)
                if (isMobile || isTablet) ...[
                  _buildLeadAcquisitionSection(isDark),
                  const SizedBox(height: 18),
                  _buildChannelPerformanceSection(isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildLeadAcquisitionSection(isDark)),
                      const SizedBox(width: 16),
                      Expanded(flex: 5, child: _buildChannelPerformanceSection(isDark)),
                    ],
                  ),
                ],
                const SizedBox(height: 18),

                // 4. Campaign Performance Table (Full Width)
                _buildCampaignPerformanceTable(isDark, isMobile),
                const SizedBox(height: 18),

                // 5. Top vs Underperforming Campaigns
                if (isMobile || isTablet) ...[
                  _buildTopCampaignsSection(isDark),
                  const SizedBox(height: 18),
                  _buildUnderperformingSection(isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildTopCampaignsSection(isDark)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildUnderperformingSection(isDark)),
                    ],
                  ),
                ],
                const SizedBox(height: 18),

                // 6. Social Media Engagement Stream with AI Replies
                _buildSocialMediaStream(isDark),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. MARKETING KPIS
  // ==========================================================================
  Widget _buildKpisSection(bool isMobile, bool isTablet, bool isLargeDesktop) {
    final kpis = ReportsMockData.marketingKpis;
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
          growthPercent: 14.8,
          isPositive: k.isPositive,
          targetText: k.subtitle,
          targetProgress: k.targetProgress,
          icon: k.icon,
          color: k.color,
          onTap: () {
            _openDrilldown(
              k.title,
              'Marketing Acquisition',
              k.value,
              [
                {'id': 'LEAD-901', 'title': 'Rohan Sharma (Bangalore Whitefield)', 'subtitle': 'Source: Meta Ads • German Finish Kitchen inquiry', 'amount': '₹4.8L est', 'status': 'MQL Verified', 'statusColor': const Color(0xFF10B981)},
                {'id': 'LEAD-902', 'title': 'Vikram Mehra (Gurgaon Golf Course)', 'subtitle': 'Source: Google PMax • 4BHK Penthouse full turnkey', 'amount': '₹18.5L est', 'status': 'Meeting Scheduled', 'statusColor': const Color(0xFF3B82F6)},
                {'id': 'LEAD-903', 'title': 'Ananya Roy (Mumbai Powai)', 'subtitle': 'Source: Website Inbound • Free 3D concept request', 'amount': '₹6.2L est', 'status': 'Tele-Qualified', 'statusColor': const Color(0xFF0EA5E9)},
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // 2. LEAD ACQUISITION BY SOURCE
  // ==========================================================================
  Widget _buildLeadAcquisitionSection(bool isDark) {
    final sources = ReportsMockData.marketingLeadSources;
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return ReportSectionContainer(
      title: 'Lead Acquisition by Channel & Source',
      subtitle: 'Volume, qualification rate, CPL, and attributed gross revenue',
      icon: Icons.hub_rounded,
      iconColor: const Color(0xFF6366F1),
      trailing: Text(
        '1,248 Total Inbound',
        style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1)),
      ),
      child: Column(
        children: sources.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              s.source,
                              style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isMobile
                          ? '${s.leadVolume} leads • ₹${s.costPerLead.toInt()} CPL'
                          : '${s.leadVolume} leads • ${s.conversionRate}% Qual • ₹${s.costPerLead.toInt()} CPL • ₹${s.revenueGeneratedLakhs.toStringAsFixed(1)}L',
                      style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w600, color: s.color),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (s.leadVolume / 450.0).clamp(0.05, 1.0),
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
  // 3. CHANNEL PERFORMANCE RANKING
  // ==========================================================================
  Widget _buildChannelPerformanceSection(bool isDark) {
    final reasons = ReportsMockData.marketingDecliningReasons;

    return ReportSectionContainer(
      title: 'Disqualification & Drop-off Telemetry',
      subtitle: 'Primary causes for customer churn prior to proposal stage',
      icon: Icons.pie_chart_outline_rounded,
      iconColor: const Color(0xFFEF4444),
      child: ReportObjectionsBarChart(
        objections: reasons.map((r) => SalesObjectionItem(objectionName: r.reason, count: r.count, percentage: r.percentage, color: r.color)).toList(),
      ),
    );
  }

  // ==========================================================================
  // 4. CAMPAIGN PERFORMANCE TABLE
  // ==========================================================================
  Widget _buildCampaignPerformanceTable(bool isDark, bool isMobile) {
    final campaigns = ReportsMockData.marketingCampaigns;

    return ReportSectionContainer(
      title: 'Campaign Performance & Attribution Ledger',
      subtitle: 'Real-time spend, lead volume, opportunities created, closed bookings, and ROI',
      icon: Icons.table_chart_outlined,
      iconColor: const Color(0xFF3B82F6),
      trailing: ElevatedButton.icon(
        onPressed: _handleExport,
        icon: const Icon(Icons.download_rounded, size: 13),
        label: Text('Export Campaigns', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),
      child: isMobile
          ? Column(
              children: campaigns.map((c) => _buildMobileCampaignCard(c, isDark)).toList(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 36,
                dataRowMinHeight: 44,
                dataRowMaxHeight: 48,
                columnSpacing: 18,
                horizontalMargin: 8,
                columns: [
                  DataColumn(label: Text('Campaign Name', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Channel', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Spend', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Leads', style: _headerStyle(isDark))),
                  DataColumn(label: Text('MQLs', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Won', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Revenue', style: _headerStyle(isDark))),
                  DataColumn(label: Text('CPL', style: _headerStyle(isDark))),
                  DataColumn(label: Text('ROI', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Status', style: _headerStyle(isDark))),
                  DataColumn(label: Text('Actions', style: _headerStyle(isDark))),
                ],
                rows: campaigns.map((c) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(c.campaignName, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                            Text('Owner: ${c.campaignOwner} • ${c.campaignType}', style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                      DataCell(Text(c.channel, style: GoogleFonts.inter(fontSize: 11))),
                      DataCell(Text('₹${c.actualSpendLakhs.toStringAsFixed(2)}L', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600))),
                      DataCell(Text('${c.leads}', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('${c.qualifiedLeads}', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('${c.wonDeals}', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)))),
                      DataCell(Text('₹${c.revenueLakhs.toStringAsFixed(1)}L', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700))),
                      DataCell(Text('₹${c.cpl.toInt()}', style: GoogleFonts.jetBrainsMono(fontSize: 11))),
                      DataCell(Text('${c.roi.toStringAsFixed(1)}x', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1)))),
                      DataCell(ReportStatusBadge(label: c.status, color: c.status == 'Active' ? const Color(0xFF10B981) : const Color(0xFF3B82F6))),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined, size: 15),
                              tooltip: 'View Leads',
                              onPressed: () {
                                _openDrilldown(
                                  c.campaignName,
                                  'Campaign Leads',
                                  '${c.leads} Leads • ₹${c.revenueLakhs}L Revenue',
                                  [
                                    {'id': 'CMP-L1', 'title': 'Anand Verma', 'subtitle': 'Source: ${c.channel} • Verified Lead', 'amount': '₹3.8L', 'status': 'Won', 'statusColor': const Color(0xFF10B981)},
                                    {'id': 'CMP-L2', 'title': 'Suresh Menon', 'subtitle': 'Source: ${c.channel} • Concept Presented', 'amount': '₹5.2L', 'status': 'Negotiation', 'statusColor': const Color(0xFFF59E0B)},
                                  ],
                                );
                              },
                            ),
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

  Widget _buildMobileCampaignCard(MarketingCampaignItem c, bool isDark) {
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
                  c.campaignName,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightTextPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ReportStatusBadge(label: c.status, color: c.status == 'Active' ? const Color(0xFF10B981) : const Color(0xFF3B82F6)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Channel: ${c.channel} • Spend: ₹${c.actualSpendLakhs}L • ROI: ${c.roi}x',
            style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text('Leads: ${c.leads} (MQL: ${c.qualifiedLeads})', style: GoogleFonts.jetBrainsMono(fontSize: 10)),
              Text('Won: ${c.wonDeals} (₹${c.revenueLakhs}L)', style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
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

  // ==========================================================================
  // 5. TOP & UNDERPERFORMING CAMPAIGNS
  // ==========================================================================
  Widget _buildTopCampaignsSection(bool isDark) {
    return ReportSectionContainer(
      title: 'Top Performing Campaigns',
      subtitle: 'Highest Return on Ad Spend (ROAS) and quality lead velocity',
      icon: Icons.star_rounded,
      iconColor: const Color(0xFF10B981),
      child: Column(
        children: [
          _buildPerformanceCard(
            title: 'Bangalore Luxury 4BHK V-Ray Reel',
            metric: '35.4x ROI • 38 Won Deals (₹52.4L)',
            highlight: 'Meta Video Ads • ₹474 CPL',
            isPositive: true,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildPerformanceCard(
            title: 'Free 3D Vastu Blueprint Magnet',
            metric: '38.8x ROI • 24 Won Deals (₹34.2L)',
            highlight: 'Meta Lead Forms • ₹231 CPL',
            isPositive: true,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildUnderperformingSection(bool isDark) {
    return ReportSectionContainer(
      title: 'Underperforming Campaigns (Triage)',
      subtitle: 'High cost-per-lead or low consultation conversion rates',
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFEF4444),
      child: Column(
        children: [
          _buildPerformanceCard(
            title: 'Gurgaon Penthouse Architecture Showcase',
            metric: '₹788 CPL • 16.6x ROI • 7.7% Conv',
            highlight: 'Display & YouTube • High CPM (\$14.2)',
            isPositive: false,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildPerformanceCard(
            title: 'Modular Kitchen German Finish Search',
            metric: '₹709 CPL • Elevated Google Bids on keywords',
            highlight: 'Recommendation: Restructure negative match keywords',
            isPositive: false,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard({
    required String title,
    required String metric,
    required String highlight,
    required bool isPositive,
    required bool isDark,
  }) {
    final color = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                const SizedBox(height: 2),
                Text(metric, style: GoogleFonts.jetBrainsMono(fontSize: 10.5, fontWeight: FontWeight.w600, color: color)),
                Text(highlight, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 6. SOCIAL MEDIA INQUIRIES STREAM
  // ==========================================================================
  Widget _buildSocialMediaStream(bool isDark) {
    return ReportSectionContainer(
      title: 'Social Inbound Telemetry & AI Auto-Reply Stream',
      subtitle: 'Real-time homeowner inquiries across Instagram, YouTube, and Pinterest',
      icon: Icons.forum_outlined,
      iconColor: const Color(0xFFEC4899),
      child: Column(
        children: _comments.asMap().entries.map((entry) {
          final idx = entry.key;
          final c = entry.value;
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
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              c.author,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFEC4899),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEC4899).withValues(alpha: 0.15),
                              borderRadius: AppRadius.xs,
                            ),
                            child: Text(
                              c.platform,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFEC4899),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      c.timeAgo,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('"${c.commentText}"', style: GoogleFonts.inter(fontSize: 11, fontStyle: FontStyle.italic)),
                const SizedBox(height: 6),
                if (c.isAiReplied && c.replyText != null) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.15 : 0.08),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, size: 12, color: Color(0xFF10B981)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'AI Auto-Replied: ${c.replyText!}',
                            style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF10B981)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  OutlinedButton.icon(
                    onPressed: () => _handleAiReplyToggle(idx),
                    icon: const Icon(Icons.auto_awesome, size: 12),
                    label: Text('Trigger AI Instant Response', style: GoogleFonts.inter(fontSize: 10.5)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
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
}

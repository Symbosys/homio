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
import '../widgets/reports_stage_funnel.dart';

/// Marketing & Funnel Analytics Executive Screen.
/// Provides CPL, CAC, Stage-wise conversion funnel, ad spend breakdown,
/// declining reasons, and social media AI reply engagement stream.
class ReportsMarketingPage extends StatefulWidget {
  const ReportsMarketingPage({super.key});

  @override
  State<ReportsMarketingPage> createState() => _ReportsMarketingPageState();
}

class _ReportsMarketingPageState extends State<ReportsMarketingPage> {
  ReportDateFilter _dateFilter = ReportDateFilter.thisMonth;
  String _sourceFilter = 'All Sources';
  final List<SocialCommentItem> _comments = List.from(ReportsMockData.socialComments);

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
            ? 'Thank you for reaching out! Our design consultant has sent you a direct message.'
            : null,
      );
    });
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
                title: 'Marketing & Funnel Analytics',
                subtitle: 'Paid acquisition CPL, organic lead velocity, stage drop-offs & social telemetry',
                icon: Icons.campaign_rounded,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
                additionalFilters: [
                  _buildSourceFilter(isDark),
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

              // KPI Grid
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Stage-Wise Conversion Funnel
              const ReportStageFunnelWidget(stages: ReportsMockData.marketingFunnelStages),
              const SizedBox(height: 18),

              // Charts Row: Declining Reasons & Social Growth
              _buildChartsRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Social Media Inquiries Stream with AI Auto-Reply
              _buildSocialCommentsStream(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceFilter(bool isDark) {
    const sources = ['All Sources', 'Paid (Meta/Google)', 'Organic Inbound', 'Referrals'];
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
          value: _sourceFilter,
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
          items: sources.map((s) {
            return DropdownMenuItem<String>(
              value: s,
              child: Text(s),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _sourceFilter = val);
          },
        ),
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = ReportsMockData.marketingKpis;
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
          _buildDecliningReasonsCard(isDark),
          const SizedBox(height: 16),
          const ReportSocialGrowthBarChart(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _buildDecliningReasonsCard(isDark),
        ),
        const SizedBox(width: 16),
        const Expanded(
          flex: 5,
          child: ReportSocialGrowthBarChart(),
        ),
      ],
    );
  }

  Widget _buildDecliningReasonsCard(bool isDark) {
    final reasons = ReportsMockData.marketingDecliningReasons;

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
        children: [
          Row(
            children: [
              const Icon(Icons.cancel_outlined, size: 16, color: Color(0xFFEF4444)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Lead Declining Reasons (173 Unconverted)',
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
                  color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  'Top: Price Mismatch',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reasons.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final r = reasons[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          r.reason,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          '${r.count} leads (${r.percentage}%)',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: r.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (r.percentage / 100.0).clamp(0.02, 1.0),
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: r.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCommentsStream(bool isDark) {
    return CompactTableCard(
      title: 'Social Media Inquiries & AI Auto-Reply Stream',
      subtitle: 'Live comments from Instagram Reels, YouTube Tours, and Pinterest with AI response validation',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: AppRadius.full,
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.4 : 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 12, color: Color(0xFF10B981)),
                const SizedBox(width: 4),
                Text(
                  'AI Auto-Pilot: ON',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _comments.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        itemBuilder: (context, index) {
          final c = _comments[index];
          final isInstagram = c.platform == 'Instagram';
          final isYoutube = c.platform == 'YouTube';
          final platformColor = isInstagram
              ? const Color(0xFFE1306C)
              : (isYoutube ? const Color(0xFFFF0000) : const Color(0xFFE60023));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: platformColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Icon(
                    isInstagram ? Icons.camera_alt_outlined : (isYoutube ? Icons.play_circle_outline : Icons.push_pin_outlined),
                    size: 16,
                    color: platformColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            c.author,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          DashboardBadge(
                            label: c.platform.toUpperCase(),
                            color: platformColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            c.timeAgo,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        c.commentText,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Post: ${c.postTitle}',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (c.isAiReplied && c.replyText != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            borderRadius: AppRadius.sm,
                            border: Border.all(
                              color: const Color(0xFF10B981).withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.auto_awesome, size: 13, color: Color(0xFF10B981)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Homio AI Assistant Response:',
                                      style: GoogleFonts.inter(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF10B981),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      c.replyText!,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _handleAiReplyToggle(index),
                  icon: Icon(
                    c.isAiReplied ? Icons.edit_outlined : Icons.send_rounded,
                    size: 13,
                  ),
                  label: Text(
                    c.isAiReplied ? 'Manual Edit' : 'AI Reply',
                    style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: c.isAiReplied ? AppColors.primary : const Color(0xFF10B981),
                    side: BorderSide(
                      color: c.isAiReplied
                          ? AppColors.primary.withValues(alpha: 0.4)
                          : const Color(0xFF10B981).withValues(alpha: 0.4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

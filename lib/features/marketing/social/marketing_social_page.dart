import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../data/marketing_repository.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';
import '../widgets/marketing_header.dart';
import '../widgets/social_inbox_widget.dart';

class MarketingSocialPage extends StatefulWidget {
  const MarketingSocialPage({super.key});

  @override
  State<MarketingSocialPage> createState() => _MarketingSocialPageState();
}

class _MarketingSocialPageState extends State<MarketingSocialPage> {
  final _repo = MarketingRepository();
  bool _isRefreshing = false;
  late List<SocialPlatformMetric> _platformMetrics;
  late List<SocialPostItem> _topPosts;
  late List<SocialMessageItem> _socialMessages;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _platformMetrics = _repo.getSocialMetrics();
    _topPosts = _repo.getTopSocialPosts();
    _socialMessages = _repo.getSocialMessages();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _loadData();
        _isRefreshing = false;
      });
    }
  }

  void _handleApproveReply(SocialMessageItem msg) {
    _repo.markMessageReplied(msg.id);
    _handleRefresh();
  }

  void _handleConvertToLead(SocialMessageItem msg) {
    _repo.convertMessageToLead(msg.id);
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          key: const PageStorageKey('marketing_social_scroll_key'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketingHeader(
                title: 'Social Analytics & AI Engagement',
                subtitle: 'Instagram, YouTube, and Pinterest performance, viral video attribution, and AI copilot inbox',
                isRefreshing: _isRefreshing,
                onRefresh: _handleRefresh,
              ),
              const SizedBox(height: 20),

              // Platform Metric Cards (Instagram, YouTube, Pinterest)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 850;
                  final crossAxisCount = isWide ? 3 : 1;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isWide ? 1.4 : 2.0,
                    ),
                    itemCount: _platformMetrics.length,
                    itemBuilder: (context, index) {
                      final p = _platformMetrics[index];
                      return _buildPlatformMetricCard(p, isDark);
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Top Performing Social Content Section
              _buildTopPostsSection(isDark),

              const SizedBox(height: 24),

              // Social Engagement & AI Response Inbox
              SocialInboxWidget(
                messages: _socialMessages,
                onApproveReply: _handleApproveReply,
                onConvertToLead: _handleConvertToLead,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformMetricCard(SocialPlatformMetric p, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: p.platform.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(p.platform.icon, color: p.platform.color, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.platform.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.darkTextPrimary,
                        ),
                      ),
                      Text(
                        '${p.postFrequency.toStringAsFixed(1)} posts / week',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${p.engagementRate.toStringAsFixed(1)}% ER',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatCell('Followers', '${(p.followers / 1000).toStringAsFixed(1)}k', isDark),
              ),
              Expanded(
                child: _buildStatCell('30d Reach', '${(p.reach / 1000).toStringAsFixed(1)}k', isDark),
              ),
              Expanded(
                child: _buildStatCell('Total Views', '${(p.views / 1000).toStringAsFixed(1)}k', isDark),
              ),
              Expanded(
                child: _buildStatCell('Leads Gen.', '${p.leadsGenerated}', isDark),
              ),
            ],
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: (p.engagementRate / 10).clamp(0.0, 1.0),
            backgroundColor: isDark ? Colors.white10 : Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(p.platform.color),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCell(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.darkTextPrimary),
        ),
      ],
    );
  }

  Widget _buildTopPostsSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Performing Social Content & Video Showcase',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.darkTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'High-engagement Reels, YouTube Tours, and Pinterest interior pins driving CRM inquiries',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Viral Attribution',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._topPosts.map((post) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground.withValues(alpha: 0.5) : AppColors.lightBackground.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: post.platform.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(post.platform.icon, color: post.platform.color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.brandPrimary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                post.contentType.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brandPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                post.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : AppColors.darkTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _buildPostMetric(Icons.visibility_outlined, '${post.views} views', isDark),
                            const SizedBox(width: 14),
                            _buildPostMetric(Icons.thumb_up_outlined, '${post.likes} likes', isDark),
                            const SizedBox(width: 14),
                            _buildPostMetric(Icons.chat_bubble_outline_rounded, '${post.comments} comments', isDark),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${post.leadsGenerated}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const Text(
                          'CRM Leads',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPostMetric(IconData icon, String label, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

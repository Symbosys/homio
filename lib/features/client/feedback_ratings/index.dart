import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models/feedback_models.dart';
import 'widgets/feedback_history_card.dart';
import 'widgets/feedback_step_modal.dart';
import 'widgets/pending_feedback_card.dart';

/// Screen 1: FEEDBACK & RATINGS (/client/ratings & /client/feedback)
/// High-end customer portal rating & feedback center:
/// - Feedback Overview Counters (Pending, Submitted, Avg Rating Given)
/// - Pending Feedback actionable prompts for completed milestones & services
/// - 5-Step Mobile-first feedback submission dialog
/// - Feedback history list with verified badges & category breakdowns
/// - 100% Dark & Light mode compatible
class ClientFeedbackRatingsPage extends StatefulWidget {
  const ClientFeedbackRatingsPage({super.key});

  @override
  State<ClientFeedbackRatingsPage> createState() =>
      _ClientFeedbackRatingsPageState();
}

class _ClientFeedbackRatingsPageState extends State<ClientFeedbackRatingsPage> {
  final FeedbackRepository _repo = FeedbackRepository.instance;
  String _activeTab = 'All'; // 'All', 'Pending', 'History'

  @override
  void initState() {
    super.initState();
    _repo.changeNotifier.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _repo.changeNotifier.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isCompact(context);

    final pendingList = _repo.pendingPrompts;
    final historyList = _repo.submittedFeedback;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 20,
          ),
          children: [
            // Page Header Hero
            _buildPageHeader(isDark, isMobile),
            const SizedBox(height: 20),

            // Overview Metric Strip
            _buildMetricsOverview(isDark, isMobile),
            const SizedBox(height: 24),

            // Filter Tabs
            _buildFilterTabs(isDark),
            const SizedBox(height: 16),

            // Content based on tab
            if (_activeTab == 'Pending' || _activeTab == 'All') ...[
              if (pendingList.isNotEmpty) ...[
                _buildSectionTitle(
                  'Pending Feedback (${pendingList.length})',
                  'Actions awaiting your rating',
                  isDark,
                ),
                const SizedBox(height: 12),
                ...pendingList.map((prompt) {
                  return PendingFeedbackCard(
                    prompt: prompt,
                    onRatePressed: () => FeedbackStepModal.show(
                      context,
                      prompt: prompt,
                      onSubmitted: () => setState(() {}),
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ] else if (_activeTab == 'Pending') ...[
                _buildEmptyState('No pending feedback requests.', 'You are completely caught up!', isDark),
              ],
            ],

            if (_activeTab == 'History' || _activeTab == 'All') ...[
              _buildSectionTitle(
                'Feedback History (${historyList.length})',
                'Your verified sign-offs and reviews',
                isDark,
              ),
              const SizedBox(height: 12),
              if (historyList.isEmpty)
                _buildEmptyState('No submitted feedback yet.', 'Rate pending milestones to see your reviews here.', isDark)
              else
                ...historyList.map((item) => FeedbackHistoryCard(item: item)),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => FeedbackStepModal.show(
          context,
          onSubmitted: () => setState(() {}),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.star_rounded, size: 20),
        label: Text(
          'Rate Project',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildPageHeader(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.star_rate_rounded, color: Color(0xFFF59E0B), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR FEEDBACK & RATINGS',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Help us continuously improve your HOMIO experience.',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 15 : 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Rate designers, site supervisors, subcontractors, materials and completed milestones. Every rating directly affects our quality audits and warranty sign-offs.',
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.45,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsOverview(bool isDark, bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Pending',
            value: '${_repo.pendingCount}',
            subtitle: 'Reviews required',
            icon: Icons.pending_actions_rounded,
            color: const Color(0xFFF59E0B),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Submitted',
            value: '${_repo.submittedCount}',
            subtitle: 'Logged reviews',
            icon: Icons.check_circle_outline_rounded,
            color: const Color(0xFF10B981),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Avg Rating',
            value: '${_repo.averageRating} ★',
            subtitle: 'Out of 5.0 score',
            icon: Icons.star_rounded,
            color: AppColors.primary,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(bool isDark) {
    final tabs = ['All', 'Pending', 'History'];
    return Row(
      children: tabs.map((tab) {
        final isSelected = _activeTab == tab;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(
              tab == 'Pending'
                  ? 'Pending (${_repo.pendingCount})'
                  : (tab == 'History' ? 'History (${_repo.submittedCount})' : tab),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
            selected: isSelected,
            onSelected: (_) => setState(() => _activeTab = tab),
            selectedColor: AppColors.primary,
            backgroundColor: isDark ? AppColors.darkCard : Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle, bool isDark) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.verified_outlined,
            size: 44,
            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

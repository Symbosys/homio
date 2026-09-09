import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';
import '../widgets/after_sales_header.dart';
import '../widgets/feedback_submission_modal.dart';

class CustomerFeedbackPage extends StatefulWidget {
  const CustomerFeedbackPage({super.key});

  @override
  State<CustomerFeedbackPage> createState() => _CustomerFeedbackPageState();
}

class _CustomerFeedbackPageState extends State<CustomerFeedbackPage> {
  final List<CustomerFeedback> _feedbacks = List.from(AfterSalesMockData.customerFeedbacks);
  String _searchQuery = '';
  String _selectedRatingFilter = 'ALL'; // ALL, 5_STAR, 4_STAR, 3_STAR, UNDER_3
  String _selectedResolutionFilter = 'ALL'; // ALL, RESOLVED, UNRESOLVED, ESCALATED

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final filteredFeedbacks = _feedbacks.where((fb) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = fb.customerName.toLowerCase().contains(q) ||
            fb.projectName.toLowerCase().contains(q) ||
            (fb.serviceRequestId?.toLowerCase().contains(q) ?? false) ||
            fb.feedbackNotes.toLowerCase().contains(q);
        if (!matches) return false;
      }
      if (_selectedRatingFilter != 'ALL') {
        if (_selectedRatingFilter == '5_STAR' && fb.overallRating < 5.0) return false;
        if (_selectedRatingFilter == '4_STAR' && (fb.overallRating < 4.0 || fb.overallRating >= 5.0)) return false;
        if (_selectedRatingFilter == '3_STAR' && (fb.overallRating < 3.0 || fb.overallRating >= 4.0)) return false;
        if (_selectedRatingFilter == 'UNDER_3' && fb.overallRating >= 3.0) return false;
      }
      if (_selectedResolutionFilter != 'ALL') {
        if (_selectedResolutionFilter == 'RESOLVED' && !fb.isResolved) return false;
        if (_selectedResolutionFilter == 'UNRESOLVED' && fb.isResolved) return false;
        if (_selectedResolutionFilter == 'ESCALATED' && !fb.escalatedToManager) return false;
      }
      return true;
    }).toList();

    // CSAT Score Calculations
    final double avgOverall = _feedbacks.isEmpty
        ? 0.0
        : _feedbacks.map((e) => e.overallRating).reduce((a, b) => a + b) / _feedbacks.length;
    final double avgQuality = _feedbacks.isEmpty
        ? 0.0
        : _feedbacks.map((e) => e.qualityScore).reduce((a, b) => a + b) / _feedbacks.length;
    final double avgTimeliness = _feedbacks.isEmpty
        ? 0.0
        : _feedbacks.map((e) => e.timelinessScore).reduce((a, b) => a + b) / _feedbacks.length;
    final double avgProfessionalism = _feedbacks.isEmpty
        ? 0.0
        : _feedbacks.map((e) => e.professionalismScore).reduce((a, b) => a + b) / _feedbacks.length;
    final double avgComm = _feedbacks.isEmpty
        ? 0.0
        : _feedbacks.map((e) => e.communicationScore).reduce((a, b) => a + b) / _feedbacks.length;

    final int escalatedCount = _feedbacks.where((e) => e.escalatedToManager && !e.isResolved).length;
    final int resolvedCount = _feedbacks.where((e) => e.isResolved).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          AfterSalesHeader(
            title: 'Customer Feedback & CSAT',
            subtitle: '5-Pillar Service Quality Scores, Customer Reviews & Escalation Action Log',
            activeTab: 'Customer Feedback',
            trailing: ElevatedButton.icon(
              onPressed: () => _openFeedbackModal(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Log Customer Feedback'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                if (escalatedCount > 0)
                  _buildEscalationNotice(escalatedCount, isDark),
                const SizedBox(height: 16),
                _buildCSATScoreboard(
                  avgOverall: avgOverall,
                  avgQuality: avgQuality,
                  avgTimeliness: avgTimeliness,
                  avgProfessionalism: avgProfessionalism,
                  avgComm: avgComm,
                  totalReviews: _feedbacks.length,
                  resolvedCount: resolvedCount,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textPrimaryColor: textPrimaryColor,
                  textSecondaryColor: textSecondaryColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                _buildFilterBar(
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textPrimaryColor: textPrimaryColor,
                  textSecondaryColor: textSecondaryColor,
                  textMutedColor: textMutedColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                if (filteredFeedbacks.isEmpty)
                  _buildEmptyState(
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    textPrimaryColor: textPrimaryColor,
                    textSecondaryColor: textSecondaryColor,
                    textMutedColor: textMutedColor,
                  )
                else
                  ...filteredFeedbacks.map((fb) => _buildFeedbackCard(
                        fb,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        isDark: isDark,
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEscalationNotice(int count, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF450A0A).withValues(alpha: 0.6) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF991B1B) : const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.25 : 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Critical Escalation Alert: $count Low-Score Customer Review${count > 1 ? 's' : ''} Require Immediate Attention',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Reviews with ratings under 3.0 are auto-escalated to Service Ops Lead and require personal callback within 4 hours.',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFF87171) : const Color(0xFFB91C1C),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedRatingFilter = 'UNDER_3';
                _selectedResolutionFilter = 'UNRESOLVED';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('View Unresolved', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildCSATScoreboard({
    required double avgOverall,
    required double avgQuality,
    required double avgTimeliness,
    required double avgProfessionalism,
    required double avgComm,
    required int totalReviews,
    required int resolvedCount,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Quality Performance (CSAT)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimaryColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Calculated in real-time across completed service visits and handovers',
                    style: TextStyle(fontSize: 12, color: textSecondaryColor),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.35) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? const Color(0xFF2563EB).withValues(alpha: 0.5) : const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.rate_review_outlined, size: 14, color: Color(0xFF38BDF8)),
                    const SizedBox(width: 6),
                    Text(
                      '$totalReviews Verified Reviews',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 750;
              return isNarrow
                  ? Column(
                      children: [
                        _buildOverallScoreCard(avgOverall, borderColor, isDark),
                        const SizedBox(height: 16),
                        _buildPillarBreakdown(avgQuality, avgTimeliness, avgProfessionalism, avgComm, textPrimaryColor, isDark),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildOverallScoreCard(avgOverall, borderColor, isDark)),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 7,
                          child: _buildPillarBreakdown(avgQuality, avgTimeliness, avgProfessionalism, avgComm, textPrimaryColor, isDark),
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScoreCard(double score, Color borderColor, bool isDark) {
    Color scoreColor = const Color(0xFF16A34A);
    String status = 'Excellent';
    if (score < 3.0) {
      scoreColor = const Color(0xFFEF4444);
      status = 'Needs Attention';
    } else if (score < 4.0) {
      scoreColor = const Color(0xFFF59E0B);
      status = 'Satisfactory';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            score.toStringAsFixed(1),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: scoreColor, height: 1.0),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < score.floor()
                    ? Icons.star_rounded
                    : (index < score ? Icons.star_half_rounded : Icons.star_border_rounded),
                color: const Color(0xFFF59E0B),
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scoreColor.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(color: scoreColor, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarBreakdown(
    double quality,
    double timeliness,
    double prof,
    double comm,
    Color textPrimaryColor,
    bool isDark,
  ) {
    return Column(
      children: [
        _buildPillarRow('Workmanship Quality', quality, Icons.verified_outlined, const Color(0xFF38BDF8), textPrimaryColor, isDark),
        const SizedBox(height: 10),
        _buildPillarRow('Punctuality & Timeliness', timeliness, Icons.schedule_rounded, const Color(0xFF10B981), textPrimaryColor, isDark),
        const SizedBox(height: 10),
        _buildPillarRow('Technician Professionalism', prof, Icons.badge_outlined, const Color(0xFFA855F7), textPrimaryColor, isDark),
        const SizedBox(height: 10),
        _buildPillarRow('Communication & Clarity', comm, Icons.chat_bubble_outline_rounded, const Color(0xFFF59E0B), textPrimaryColor, isDark),
      ],
    );
  }

  Widget _buildPillarRow(String label, double score, IconData icon, Color color, Color textPrimaryColor, bool isDark) {
    final double percent = (score / 5.0).clamp(0.0, 1.0);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 170,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimaryColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${score.toStringAsFixed(1)} / 5.0',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }

  Widget _buildFilterBar({
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color textMutedColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 260,
            height: 38,
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(fontSize: 13, color: textPrimaryColor),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: 'Search customer, project, notes...',
                hintStyle: TextStyle(fontSize: 12, color: textMutedColor),
                prefixIcon: Icon(Icons.search, size: 16, color: textSecondaryColor),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
            ),
          ),
          _buildFilterChip('All Ratings', 'ALL', _selectedRatingFilter, (v) => setState(() => _selectedRatingFilter = v), isDark),
          _buildFilterChip('5 Stars ★★★★★', '5_STAR', _selectedRatingFilter, (v) => setState(() => _selectedRatingFilter = v), isDark),
          _buildFilterChip('4 Stars ★★★★', '4_STAR', _selectedRatingFilter, (v) => setState(() => _selectedRatingFilter = v), isDark),
          _buildFilterChip('3 Stars ★★★', '3_STAR', _selectedRatingFilter, (v) => setState(() => _selectedRatingFilter = v), isDark),
          _buildFilterChip('Critical (<3.0) ⚠️', 'UNDER_3', _selectedRatingFilter, (v) => setState(() => _selectedRatingFilter = v), isDark),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _selectedResolutionFilter,
            dropdownColor: surfaceColor,
            underline: const SizedBox(),
            iconEnabledColor: textSecondaryColor,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor),
            items: const [
              DropdownMenuItem(value: 'ALL', child: Text('All Follow-up States')),
              DropdownMenuItem(value: 'UNRESOLVED', child: Text('Pending Follow-up')),
              DropdownMenuItem(value: 'RESOLVED', child: Text('Resolved / Closed')),
              DropdownMenuItem(value: 'ESCALATED', child: Text('Escalated to Mgmt')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _selectedResolutionFilter = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String current, Function(String) onSelect, bool isDark) {
    final bool isSelected = current == value;
    return InkWell(
      onTap: () => onSelect(value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary : const Color(0xFF1E293B))
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(
    CustomerFeedback fb, {
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required bool isDark,
  }) {
    final bool isCritical = fb.overallRating < 3.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCritical ? (isDark ? const Color(0xFFDC2626) : const Color(0xFFFCA5A5)) : borderColor,
          width: isCritical ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isCritical
                ? const Color(0xFFDC2626).withValues(alpha: isDark ? 0.15 : 0.05)
                : Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isCritical
                            ? (isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2))
                            : (isDark ? const Color(0xFF312E81) : const Color(0xFFE0E7FF)),
                        child: Text(
                          fb.customerName.substring(0, 1),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: isCritical
                                ? (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626))
                                : (isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA)),
                          ),
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
                                  fb.customerName,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimaryColor),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    fb.serviceRequestId ?? 'CSAT',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${fb.projectName} • Logged on ${fb.createdAt.day}/${fb.createdAt.month}/${fb.createdAt.year}',
                              style: TextStyle(fontSize: 12, color: textSecondaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < fb.overallRating.floor()
                              ? Icons.star_rounded
                              : (index < fb.overallRating ? Icons.star_half_rounded : Icons.star_border_rounded),
                          color: const Color(0xFFF59E0B),
                          size: 18,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${fb.overallRating.toStringAsFixed(1)} / 5.0',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isCritical ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                fb.feedbackNotes,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildScoreChip('Quality', fb.qualityScore, textPrimaryColor, textSecondaryColor),
                _buildScoreChip('Timeliness', fb.timelinessScore, textPrimaryColor, textSecondaryColor),
                _buildScoreChip('Professionalism', fb.professionalismScore, textPrimaryColor, textSecondaryColor),
                _buildScoreChip('Communication', fb.communicationScore, textPrimaryColor, textSecondaryColor),
                _buildScoreChip('Resolution', fb.resolutionScore, textPrimaryColor, textSecondaryColor),
              ],
            ),
            if (fb.escalatedToManager || fb.isResolved) ...[
              Divider(height: 24, color: borderColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (fb.escalatedToManager)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF450A0A).withValues(alpha: 0.6) : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: isDark ? const Color(0xFF991B1B) : const Color(0xFFFECACA)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.priority_high_rounded, size: 14, color: Color(0xFFEF4444)),
                              const SizedBox(width: 4),
                              Text(
                                'Escalated to Service Lead',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (fb.escalatedToManager) const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: fb.isResolved
                              ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.6) : const Color(0xFFF0FDF4))
                              : (isDark ? const Color(0xFF451A03).withValues(alpha: 0.6) : const Color(0xFFFFFBEB)),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: fb.isResolved
                                ? (isDark ? const Color(0xFF047857) : const Color(0xFFBBF7D0))
                                : (isDark ? const Color(0xFFB45309) : const Color(0xFFFDE68A)),
                          ),
                        ),
                        child: Text(
                          fb.isResolved ? 'Follow-up Closed' : 'Action In Progress',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: fb.isResolved
                                ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF15803D))
                                : (isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309)),
                          ),
                        ),
                      ),
                      if (fb.resolutionNotes != null && fb.resolutionNotes!.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Text(
                          'Action Note: "${fb.resolutionNotes}"',
                          style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: textSecondaryColor),
                        ),
                      ],
                    ],
                  ),
                  if (!fb.isResolved)
                    OutlinedButton.icon(
                      onPressed: () => _markResolved(fb),
                      icon: const Icon(Icons.check_circle_outline, size: 14),
                      label: const Text('Mark Resolved', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF10B981),
                        side: const BorderSide(color: Color(0xFF10B981)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreChip(String title, double score, Color textPrimaryColor, Color textSecondaryColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$title: ', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
        Text(
          '${score.toStringAsFixed(1)}/5',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textPrimaryColor),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color textMutedColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(48),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.rate_review_outlined, size: 48, color: textMutedColor),
          const SizedBox(height: 12),
          Text(
            'No Customer Reviews Found',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimaryColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your search query or CSAT rating filter.',
            style: TextStyle(fontSize: 13, color: textSecondaryColor),
          ),
        ],
      ),
    );
  }

  void _markResolved(CustomerFeedback fb) {
    setState(() {
      final index = _feedbacks.indexWhere((item) => item.id == fb.id);
      if (index != -1) {
        _feedbacks[index] = fb.copyWith(
          isResolved: true,
          resolutionNotes: 'Service Supervisor completed follow-up verification call.',
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feedback for ${fb.customerName} marked as resolved.'),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
  }

  void _openFeedbackModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => FeedbackSubmissionModal(
        onFeedbackSubmitted: (newFeedback) {
          setState(() {
            _feedbacks.insert(0, newFeedback);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Feedback from ${newFeedback.customerName} saved successfully.'),
              backgroundColor: const Color(0xFF16A34A),
            ),
          );
        },
      ),
    );
  }
}

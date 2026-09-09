import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/rating_submission_modal.dart';

class LabourRatingsPage extends StatefulWidget {
  const LabourRatingsPage({super.key});

  @override
  State<LabourRatingsPage> createState() => _LabourRatingsPageState();
}

class _LabourRatingsPageState extends State<LabourRatingsPage> {
  final List<LabourRatingRecord> _ratings = List.from(LabourMockData.ratingsList);
  String _selectedRoleFilter = 'All Reviews';

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final avgQuality = _ratings.map((r) => r.qualityScore).reduce((a, b) => a + b) / _ratings.length;
    final avgTimeline = _ratings.map((r) => r.timelineScore).reduce((a, b) => a + b) / _ratings.length;
    final avgBehaviour = _ratings.map((r) => r.behaviourScore).reduce((a, b) => a + b) / _ratings.length;
    final avgReliability = _ratings.map((r) => r.reliabilityScore).reduce((a, b) => a + b) / _ratings.length;
    final avgOverall = _ratings.map((r) => r.overallScore).reduce((a, b) => a + b) / _ratings.length;

    var filtered = _ratings.where((r) {
      if (_selectedRoleFilter != 'All Reviews' && r.reviewerRole != _selectedRoleFilter) {
        return false;
      }
      return true;
    }).toList();

    final alertRatings = _ratings.where((r) => r.isAlertTriggered).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Workforce Performance & CSAT Ratings',
              subtitle: '4-pillar multi-dimensional scoring across Quality, Timeline, Behaviour, and Reliability, with automated low-rating alert escalations.',
              activeTab: 'Ratings & Performance',
              trailing: ElevatedButton.icon(
                onPressed: () => _openAddRatingModal(context),
                icon: const Icon(Icons.star_rate_rounded, size: 18),
                label: const Text('Add Verified Rating'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 4-Pillar Scorecard Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildScoreBox('Craftsmanship & Quality', '${avgQuality.toStringAsFixed(2)} ★', 'Finish, Accuracy, Tolerances', const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildScoreBox('Timeline & Punctuality', '${avgTimeline.toStringAsFixed(2)} ★', 'On-time start & delivery', const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildScoreBox('Conduct & Behaviour', '${avgBehaviour.toStringAsFixed(2)} ★', 'Professionalism & Site Manners', const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildScoreBox('Site Reliability', '${avgReliability.toStringAsFixed(2)} ★', 'Attendance & SOP Compliance', const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildScoreBox('Craftsmanship & Quality', '${avgQuality.toStringAsFixed(2)} ★', 'Finish, Accuracy, Tolerances', const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildScoreBox('Timeline & Punctuality', '${avgTimeline.toStringAsFixed(2)} ★', 'On-time start & delivery', const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildScoreBox('Conduct & Behaviour', '${avgBehaviour.toStringAsFixed(2)} ★', 'Professionalism & Site Manners', const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildScoreBox('Site Reliability', '${avgReliability.toStringAsFixed(2)} ★', 'Attendance & SOP Compliance', const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Low-Rating Alerts Banner (if any)
                  if (alertRatings.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AUTOMATED LOW-RATING ALERTS (Escalated to Operations)',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.red),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${alertRatings.length} worker review(s) fell below the minimum quality SLA threshold (<3.0 ★). Dispatch privileges have been put under administrative review.',
                                  style: TextStyle(fontSize: 11, color: textSecondaryColor),
                                ),
                                const SizedBox(height: 10),
                                ...alertRatings.map((ar) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        Text('• ${ar.workerName} (${ar.trade.label}): ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: textPrimaryColor)),
                                        Text('${ar.overallScore} ★ - "${ar.reviewNotes}"', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Filter Chips (All, Customer, Supervisor, Manager)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('All Reviews'),
                            selected: _selectedRoleFilter == 'All Reviews',
                            onSelected: (_) => setState(() => _selectedRoleFilter = 'All Reviews'),
                            selectedColor: AppColors.primary.withValues(alpha: 0.15),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Customer Feedback'),
                            selected: _selectedRoleFilter == 'Customer',
                            onSelected: (_) => setState(() => _selectedRoleFilter = 'Customer'),
                            selectedColor: AppColors.primary.withValues(alpha: 0.15),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Supervisor Reviews'),
                            selected: _selectedRoleFilter == 'Site Supervisor',
                            onSelected: (_) => setState(() => _selectedRoleFilter = 'Site Supervisor'),
                            selectedColor: AppColors.primary.withValues(alpha: 0.15),
                          ),
                        ],
                      ),
                      Text(
                        'Overall Platform CSAT: ${avgOverall.toStringAsFixed(2)} / 5.0 ★',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.amber),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Reviews List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: item.isAlertTriggered ? Colors.red.withValues(alpha: 0.3) : borderColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: item.trade.color.withValues(alpha: 0.15),
                                  child: Icon(item.trade.icon, size: 18, color: item.trade.color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(item.workerName, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: textPrimaryColor)),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: item.trade.color.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(item.trade.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: item.trade.color)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Rated by ${item.reviewerName} (${item.reviewerRole}) • Job: ${item.bookingNumber}',
                                        style: TextStyle(fontSize: 11, color: textSecondaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${item.overallScore.toStringAsFixed(1)} ★',
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.amber),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Reviewer remarks
                            Text(
                              '"${item.reviewNotes}"',
                              style: TextStyle(fontSize: 13, color: textPrimaryColor, fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 14),

                            // 4 Pillar Scores breakdown chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _buildScoreChip('Quality: ${item.qualityScore}★', const Color(0xFF10B981)),
                                _buildScoreChip('Timeline: ${item.timelineScore}★', const Color(0xFF3B82F6)),
                                _buildScoreChip('Behaviour: ${item.behaviourScore}★', const Color(0xFF8B5CF6)),
                                _buildScoreChip('Reliability: ${item.reliabilityScore}★', const Color(0xFFF59E0B)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBox(String title, String value, String subtitle, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textMuted)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 10, color: textMuted)),
        ],
      ),
    );
  }

  Widget _buildScoreChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }

  void _openAddRatingModal(BuildContext context) {
    if (LabourMockData.activeBookings.isNotEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => RatingSubmissionModal(
          booking: LabourMockData.activeBookings.first,
          onRatingSubmitted: (newRating) {
            setState(() {
              _ratings.insert(0, newRating);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Rating of ${newRating.overallScore.toStringAsFixed(1)} ★ recorded for ${newRating.workerName}')),
            );
          },
        ),
      );
    }
  }
}

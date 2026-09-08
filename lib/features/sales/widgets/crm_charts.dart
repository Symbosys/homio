import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Interactive Funnel Chart displaying stages and conversion drop-offs
class CrmFunnelChart extends StatelessWidget {
  final Map<String, int> funnelCounts;
  final ValueChanged<String>? onStageTapped;

  const CrmFunnelChart({
    super.key,
    required this.funnelCounts,
    this.onStageTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final stages = [
      {'key': 'new_enquiry', 'label': 'New Enquiry', 'color': const Color(0xFF3B82F6), 'count': funnelCounts['new_enquiry'] ?? 124},
      {'key': 'qualified', 'label': 'Qualified', 'color': const Color(0xFF8B5CF6), 'count': funnelCounts['qualified'] ?? 82},
      {'key': 'meeting_done', 'label': 'Meeting Done', 'color': const Color(0xFF0EA5E9), 'count': funnelCounts['meeting_done'] ?? 45},
      {'key': 'booked_client', 'label': 'Booked Client', 'color': const Color(0xFF10B981), 'count': funnelCounts['booked_client'] ?? 18},
    ];

    final maxCount = (stages.first['count'] as int).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Funnel Velocity',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                'Top of Funnel: ${stages.first['count']} Leads',
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < stages.length; i++) ...[
            _buildFunnelStageBar(
              stage: stages[i],
              maxCount: maxCount,
              isDark: isDark,
              conversionFromPrev: i > 0
                  ? ((stages[i]['count'] as int) / (stages[i - 1]['count'] as int) * 100).toStringAsFixed(1)
                  : null,
            ),
            if (i < stages.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildFunnelStageBar({
    required Map<String, dynamic> stage,
    required double maxCount,
    required bool isDark,
    String? conversionFromPrev,
  }) {
    final count = stage['count'] as int;
    final color = stage['color'] as Color;
    final ratio = (count / maxCount).clamp(0.18, 1.0);

    return InkWell(
      onTap: onStageTapped != null ? () => onStageTapped!(stage['key'] as String) : null,
      borderRadius: AppRadius.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    stage['label'] as String,
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                children: [
                  if (conversionFromPrev != null)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$conversionFromPrev% pass',
                        style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                      ),
                    ),
                  Text(
                    '$count Leads',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 22,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                      borderRadius: AppRadius.sm,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 22,
                    width: constraints.maxWidth * ratio,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.85), color],
                      ),
                      borderRadius: AppRadius.sm,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(ratio * 100).toInt()}%',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Pipeline Lead Distribution Donut Representation
class CrmPipelineDistributionChart extends StatelessWidget {
  final Map<String, int> distributionCounts;

  const CrmPipelineDistributionChart({
    super.key,
    required this.distributionCounts,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      {'name': 'Qualified', 'color': const Color(0xFF8B5CF6), 'count': distributionCounts['Qualified'] ?? 82},
      {'name': 'Meeting Done', 'color': const Color(0xFF0EA5E9), 'count': distributionCounts['Meeting Done'] ?? 45},
      {'name': 'Booked Client', 'color': const Color(0xFF10B981), 'count': distributionCounts['Booked Client'] ?? 18},
      {'name': 'Not Responding', 'color': const Color(0xFFF59E0B), 'count': distributionCounts['Not Responding'] ?? 28},
      {'name': 'Not Qualified', 'color': const Color(0xFF6B7280), 'count': distributionCounts['Not Qualified'] ?? 34},
      {'name': 'Not Interested', 'color': const Color(0xFFEF4444), 'count': distributionCounts['Not Interested'] ?? 12},
    ];

    final total = categories.fold<int>(0, (sum, item) => sum + (item['count'] as int));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pipeline Distribution',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                'Total: $total Leads',
                style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Multi-segmented bar representing distribution
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 16,
              child: Row(
                children: categories.map((cat) {
                  final count = cat['count'] as int;
                  final flex = count > 0 ? count : 1;
                  return Expanded(
                    flex: flex,
                    child: Container(
                      color: cat['color'] as Color,
                      margin: const EdgeInsets.symmetric(horizontal: 0.5),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend with percentage and counts
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: categories.map((cat) {
              final count = cat['count'] as int;
              final percent = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0';
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: cat['color'] as Color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${cat['name']}: ',
                    style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                  Text(
                    '$count ($percent%)',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Trend Chart: Leads Ingested vs Closed Bookings Over Time
class CrmLeadsVsBookingsLineChart extends StatelessWidget {
  const CrmLeadsVsBookingsLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final leads = [18, 24, 22, 30, 26, 32, 19];
    final bookings = [2, 3, 2, 4, 3, 5, 2];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Leads Ingestion vs Bookings (7 Days)',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  _legendDot(const Color(0xFF3B82F6), 'Leads (171)'),
                  const SizedBox(width: 12),
                  _legendDot(const Color(0xFF10B981), 'Bookings (21)'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(days.length, (i) {
                final leadHeight = (leads[i] / 35.0) * 110;
                final bookingHeight = (bookings[i] / 6.0) * 80;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 14,
                          height: leadHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 14,
                          height: bookingHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      days[i],
                      style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

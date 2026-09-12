import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// An accessible, touch-optimized 5-star rating input with descriptive text labels.
class RatingStarsInput extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double starSize;
  final bool showLabel;
  final bool isReadOnly;
  final MainAxisAlignment alignment;

  const RatingStarsInput({
    super.key,
    required this.value,
    this.onChanged,
    this.starSize = 32,
    this.showLabel = true,
    this.isReadOnly = false,
    this.alignment = MainAxisAlignment.start,
  });

  static String getLabelForScore(double score) {
    if (score <= 1.5) return 'Very Poor';
    if (score <= 2.5) return 'Poor';
    if (score <= 3.5) return 'Average';
    if (score <= 4.5) return 'Good';
    return 'Excellent';
  }

  static Color getColorForScore(double score) {
    if (score <= 1.5) return const Color(0xFFEF4444);
    if (score <= 2.5) return const Color(0xFFF97316);
    if (score <= 3.5) return const Color(0xFFF59E0B);
    if (score <= 4.5) return const Color(0xFF10B981);
    return const Color(0xFF059669);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = getColorForScore(value);

    return Column(
      crossAxisAlignment: alignment == MainAxisAlignment.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: alignment,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starNumber = index + 1.0;
            final isFilled = value >= starNumber;
            final isHalf = value >= (starNumber - 0.5) && !isFilled;

            final iconData = isFilled
                ? Icons.star_rounded
                : (isHalf ? Icons.star_half_rounded : Icons.star_outline_rounded);

            final iconColor = isFilled || isHalf
                ? const Color(0xFFF59E0B)
                : (isDark ? AppColors.darkBorder : Colors.grey.shade300);

            if (isReadOnly) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(iconData, size: starSize, color: iconColor),
              );
            }

            return Semantics(
              label: '$starNumber out of 5 stars: ${getLabelForScore(starNumber)}',
              button: true,
              child: InkWell(
                onTap: onChanged != null ? () => onChanged!(starNumber) : null,
                borderRadius: BorderRadius.circular(starSize / 2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Icon(iconData, size: starSize, color: iconColor),
                ),
              ),
            );
          }),
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: activeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} / 5 — ${getLabelForScore(value)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: activeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

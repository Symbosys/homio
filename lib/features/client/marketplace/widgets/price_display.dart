import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Price tag with discount badge and unit symbol
class PriceDisplay extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final String? unitSuffix;
  final double fontSize;

  const PriceDisplay({
    super.key,
    required this.price,
    this.originalPrice,
    this.unitSuffix,
    this.fontSize = 18,
  });

  bool get isDiscounted => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!isDiscounted || originalPrice == null || originalPrice! <= 0) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        // Active Price
        Text(
          '₹${price.toStringAsFixed(0)}${unitSuffix != null ? ' $unitSuffix' : ''}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF10B981),
            letterSpacing: -0.3,
          ),
        ),

        // Original Price Strikethrough
        if (isDiscounted) ...[
          Text(
            '₹${originalPrice!.toStringAsFixed(0)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: fontSize * 0.75,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.lineThrough,
              color: textMuted,
            ),
          ),

          // Discount Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$discountPercent% OFF',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF10B981),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

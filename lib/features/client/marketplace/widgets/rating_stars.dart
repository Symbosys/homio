import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clean star rating display with review count
class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double starSize;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.star_rounded,
          color: Color(0xFFF59E0B),
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF59E0B),
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}

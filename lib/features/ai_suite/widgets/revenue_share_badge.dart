import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RevenueShareBadge extends StatelessWidget {
  final double platformPercent;
  final double designerPercent;
  final bool isCompact;

  const RevenueShareBadge({
    super.key,
    this.platformPercent = 50.0,
    this.designerPercent = 50.0,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2E1065) : const Color(0xFFF3E8FF),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xFFA855F7).withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.handshake_rounded, size: 13, color: Color(0xFF9333EA)),
            const SizedBox(width: 4),
            Text(
              '50-50 Revenue Split',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFFD8B4FE) : const Color(0xFF6B21A8),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.balance_rounded,
              size: 16,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'COMMERCIAL REVENUE SHARING',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Platform ${platformPercent.toInt()}% • Designer ${designerPercent.toInt()}% Guaranteed',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

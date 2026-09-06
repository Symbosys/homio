import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

/// Live countdown urgency badge displaying time remaining before discount expires.
class UrgencyCountdownBadge extends StatelessWidget {
  final DateTime expiryDate;
  final bool isCompact;

  const UrgencyCountdownBadge({
    super.key,
    required this.expiryDate,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isExpired = now.isAfter(expiryDate);
    final difference = expiryDate.difference(now);

    final Color badgeColor = isExpired
        ? AppColors.error
        : difference.inHours < 24
            ? const Color(0xFFEA580C) // Urgent Orange
            : AppColors.warning;

    String timeString;
    if (isExpired) {
      timeString = 'Expired';
    } else if (difference.inDays > 0) {
      timeString = '${difference.inDays}d ${difference.inHours % 24}h left';
    } else if (difference.inHours > 0) {
      timeString = '${difference.inHours}h ${difference.inMinutes % 60}m left';
    } else {
      timeString = '${difference.inMinutes}m left';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 6 : 8, vertical: isCompact ? 2 : 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired ? Icons.timer_off_rounded : Icons.timer_rounded,
            size: isCompact ? 12 : 14,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            timeString,
            style: GoogleFonts.inter(
              fontSize: isCompact ? 10 : 11,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}

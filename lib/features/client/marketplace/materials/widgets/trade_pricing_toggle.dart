import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';

/// Interactive switch between Retail vs Verified Trade B2B Pricing
class TradePricingToggle extends StatelessWidget {
  final bool isTradePricingEnabled;
  final ValueChanged<bool> onToggle;

  const TradePricingToggle({
    super.key,
    required this.isTradePricingEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isTradePricingEnabled ? const Color(0xFF3B82F6) : border,
          width: isTradePricingEnabled ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isTradePricingEnabled
                  ? const Color(0xFF3B82F6).withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.badge_rounded,
              size: 16,
              color: isTradePricingEnabled ? const Color(0xFF3B82F6) : textMuted,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Trade Pricing',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isTradePricingEnabled ? const Color(0xFF3B82F6) : textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SAVE UP TO 25%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                isTradePricingEnabled ? 'HOMIO Verified Contractor Rates' : 'Standard Retail Pricing',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Switch(
            value: isTradePricingEnabled,
            onChanged: onToggle,
            activeThumbColor: const Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }
}

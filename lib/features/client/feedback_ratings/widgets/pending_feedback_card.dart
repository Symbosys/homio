import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/feedback_models.dart';

/// A card highlighting an action requiring customer feedback
class PendingFeedbackCard extends StatelessWidget {
  final PendingFeedbackPrompt prompt;
  final VoidCallback onRatePressed;

  const PendingFeedbackCard({
    super.key,
    required this.prompt,
    required this.onRatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isCompact(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: prompt.isUrgent
              ? const Color(0xFFF59E0B).withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
          width: prompt.isUrgent ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.lg,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored side indicator strip
              Container(
                width: 6,
                color: prompt.badgeColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header tag & date
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: prompt.badgeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(prompt.icon, size: 13, color: prompt.badgeColor),
                                const SizedBox(width: 5),
                                Text(
                                  prompt.categoryLabel,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                    color: prompt.badgeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (prompt.isUrgent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'AWAITING YOUR REVIEW',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFF59E0B),
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          Text(
                            prompt.date,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Title
                      Text(
                        prompt.title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        prompt.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Action button row
                      if (isMobile)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: onRatePressed,
                            icon: const Icon(Icons.star_rounded, size: 18),
                            label: Text(
                              prompt.targetType == 'Labour' ? 'Rate Service' : 'Rate Experience',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: prompt.badgeColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                              elevation: 0,
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            if (prompt.providerName != null) ...[
                              Icon(
                                Icons.person_outline_rounded,
                                size: 15,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                prompt.providerName!,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: onRatePressed,
                              icon: const Icon(Icons.star_rounded, size: 16),
                              label: Text(
                                prompt.targetType == 'Labour' ? 'Rate Service' : 'Rate Experience',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: prompt.badgeColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

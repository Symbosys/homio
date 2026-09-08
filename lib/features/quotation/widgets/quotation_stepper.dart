import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Horizontal multi-step progress stepper with completed, active, and upcoming indicators.
class QuotationStepper extends StatelessWidget {
  final int currentStep;
  final List<String> stepTitles;
  final ValueChanged<int>? onStepTapped;

  const QuotationStepper({
    super.key,
    required this.currentStep,
    required this.stepTitles,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < stepTitles.length; i++) ...[
              if (i > 0)
                Container(
                  width: 24,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  color: i <= currentStep
                      ? AppColors.primary
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              _buildStepItem(context, isDark, i),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, bool isDark, int index) {
    final isCompleted = index < currentStep;
    final isActive = index == currentStep;

    Color badgeColor;
    Color textColor;
    Widget iconOrNumber;

    if (isCompleted) {
      badgeColor = AppColors.success;
      textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
      iconOrNumber = const Icon(Icons.check_rounded, size: 12, color: Colors.white);
    } else if (isActive) {
      badgeColor = AppColors.primary;
      textColor = AppColors.primary;
      iconOrNumber = Text(
        '${index + 1}',
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
      );
    } else {
      badgeColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
      textColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
      iconOrNumber = Text(
        '${index + 1}',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      );
    }

    return InkWell(
      onTap: onStepTapped != null ? () => onStepTapped!(index) : null,
      borderRadius: AppRadius.sm,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: iconOrNumber,
            ),
            const SizedBox(width: 6),
            Text(
              stepTitles[index],
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : (isCompleted ? FontWeight.w600 : FontWeight.w500),
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

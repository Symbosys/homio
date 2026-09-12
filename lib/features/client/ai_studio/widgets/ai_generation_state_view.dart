import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class AiGenerationStep {
  final String title;
  final String description;
  final bool isCompleted;
  final bool isActive;

  const AiGenerationStep({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isActive = false,
  });
}

class AiGenerationStateView extends StatelessWidget {
  final String toolTitle;
  final String currentOperation;
  final List<AiGenerationStep> steps;
  final VoidCallback? onCancel;

  const AiGenerationStateView({
    super.key,
    required this.toolTitle,
    required this.currentOperation,
    required this.steps,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        constraints: const Box640(),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.xl,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Spinner with glowing indicator
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentOperation,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'HOMIO AI Engine is executing real-time spatial synthesis & material rendering.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.getTextSecondary(context),
              ),
            ),
            const SizedBox(height: 24),
            // Discrete execution pipeline steps
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark ? const Color(0xFF263554) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: steps.map((step) => _buildStepRow(context, step)).toList(),
              ),
            ),
            if (onCancel != null) ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close_rounded, size: 16),
                label: Text(
                  'Abort Generation',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(BuildContext context, AiGenerationStep step) {
    Color iconColor;
    Widget leadingWidget;

    if (step.isCompleted) {
      iconColor = AppColors.success;
      leadingWidget = const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success);
    } else if (step.isActive) {
      iconColor = AppColors.primaryLight;
      leadingWidget = const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryLight),
      );
    } else {
      iconColor = AppColors.getTextMuted(context);
      leadingWidget = Icon(Icons.radio_button_unchecked_rounded, size: 18, color: iconColor);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: step.isActive ? FontWeight.w700 : FontWeight.w500,
                    color: step.isActive
                        ? AppColors.getTextPrimary(context)
                        : (step.isCompleted
                            ? AppColors.getTextSecondary(context)
                            : AppColors.getTextMuted(context)),
                  ),
                ),
                if (step.isActive)
                  Text(
                    step.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.primaryLight,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Box640 extends BoxConstraints {
  const Box640() : super(maxWidth: 580);
}

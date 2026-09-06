import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

/// Modern geometric vector-like logo for Homio SaaS platform.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 38.0,
    this.showTag = true,
    this.onTap,
  });

  final double size;
  final bool showTag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    final logo = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Geometric Gradient Icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.layers_rounded,
              color: Colors.white,
              size: size * 0.58,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Logo Text
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Homio',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: size * 0.56,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                if (showTag) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primaryMutedDark : AppColors.primaryMuted,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark
                            ? AppColors.primaryLight.withValues(alpha: 0.3)
                            : AppColors.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'WORKSPACE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Text(
              'Unified Business OS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );

    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: logo,
        ),
      );
    }

    return logo;
  }
}

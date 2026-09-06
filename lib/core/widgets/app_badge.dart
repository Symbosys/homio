import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.icon,
    this.color = AppColors.primary,
    this.isPill = true,
  });

  final String label;
  final IconData? icon;
  final Color color;
  final bool isPill;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    final bg = isDark
        ? color.withValues(alpha: 0.16)
        : color.withValues(alpha: 0.1);
    final border = color.withValues(alpha: isDark ? 0.35 : 0.25);
    final textCol = isDark
        ? (color == AppColors.primary ? AppColors.primaryLight : color)
        : color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(isPill ? 999 : 6),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textCol),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: textCol,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

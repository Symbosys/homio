import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// KPI Metric Card with clean borders, accent icons, and responsive layout.
class QuotationMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final String? changePercent;
  final bool isPositive;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool isSelected;

  const QuotationMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.accentColor = AppColors.primary,
    this.changePercent,
    this.isPositive = true,
    this.onTap,
    this.tooltip,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? accentColor.withValues(alpha: isDark ? 0.15 : 0.08)
            : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isSelected
              ? accentColor
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isSelected ? 1.5 : 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(icon, size: 14, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ),
          if (subtitle != null || changePercent != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                if (changePercent != null) ...[
                  Icon(
                    isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    size: 12,
                    color: isPositive ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    changePercent!,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                if (subtitle != null)
                  Expanded(
                    child: Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    if (tooltip != null) {
      card = Tooltip(
        message: tooltip!,
        child: card,
      );
    }

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: AppRadius.md,
        child: card,
      );
    }

    return card;
  }
}

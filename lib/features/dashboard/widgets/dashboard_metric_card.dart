import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/dashboard_models.dart';

/// Compact, high-density KPI metric card for Owner Dashboard.
class DashboardMetricCard extends StatelessWidget {
  final DashboardKpiMetric metric;
  final VoidCallback? onTap;

  const DashboardMetricCard({
    super.key,
    required this.metric,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.md,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Title + Icon Box
            Row(
              children: [
                Expanded(
                  child: Text(
                    metric.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: metric.color.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Icon(
                    metric.icon,
                    color: metric.color,
                    size: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Middle Row: Big Stat Value
            Text(
              metric.value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),

            // Bottom Row: Trend Pill + Subtitle
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: metric.isPositive
                        ? const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.1)
                        : const Color(0xFFEF4444).withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: AppRadius.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        metric.isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: metric.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        size: 11,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        metric.changeText,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: metric.isPositive
                              ? (isDark ? const Color(0xFF34D399) : const Color(0xFF059669))
                              : (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626)),
                        ),
                      ),
                    ],
                  ),
                ),
                if (metric.subtitle != null) ...[
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      metric.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

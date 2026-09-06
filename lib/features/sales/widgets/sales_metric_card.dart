import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/sales_models.dart';

/// Compact, high-density KPI Metric Card for Homio Sales & CRM.
class SalesMetricCard extends StatelessWidget {
  final SalesKpiMetric metric;

  const SalesMetricCard({
    super.key,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Title + Icon Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  metric.title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: metric.color.withValues(alpha: isDark ? 0.18 : 0.12),
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(
                  metric.icon,
                  size: 13.5,
                  color: metric.color,
                ),
              ),
            ],
          ),

          // Middle Row: Primary Value
          Text(
            metric.value,
            style: GoogleFonts.inter(
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),

          // Bottom Row: Delta / Trend badge + Subtitle
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1),
                decoration: BoxDecoration(
                  color: (metric.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      metric.isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 10,
                      color: metric.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      metric.changeText,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: metric.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
              if (metric.subtitle != null) ...[
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    metric.subtitle!,
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

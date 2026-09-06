import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Standardized responsive header component for Quotation & Estimation screens.
class QuotationHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? primaryAction;
  final List<Widget>? additionalFilters;
  final VoidCallback? onRefresh;

  const QuotationHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.primaryAction,
    this.additionalFilters,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleRow(isDark),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...?additionalFilters,
                    if (onRefresh != null) _buildRefreshButton(isDark),
                    ?primaryAction,
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildTitleRow(isDark)),
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (additionalFilters != null) ...[
                      ...additionalFilters!,
                      const SizedBox(width: 8),
                    ],
                    if (onRefresh != null) ...[
                      _buildRefreshButton(isDark),
                      const SizedBox(width: 8),
                    ],
                    ?primaryAction,
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildTitleRow(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: AppRadius.sm,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.2),
              width: 0.8,
            ),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshButton(bool isDark) {
    return IconButton(
      icon: Icon(
        Icons.refresh_rounded,
        size: 18,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
      onPressed: onRefresh,
      tooltip: 'Refresh data',
      splashRadius: 18,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
    );
  }
}

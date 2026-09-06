import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/reports_models.dart';

/// Top Header component for Reports screens with Title, Subtitle, Date filter, and Actions.
class ReportHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final ReportDateFilter activeFilter;
  final ValueChanged<ReportDateFilter> onFilterChanged;
  final VoidCallback? onRefresh;
  final Widget? primaryAction;
  final List<Widget>? additionalFilters;

  const ReportHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.activeFilter,
    required this.onFilterChanged,
    this.onRefresh,
    this.primaryAction,
    this.additionalFilters,
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
                    _buildDateFilterDropdown(isDark),
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
                    _buildDateFilterDropdown(isDark),
                    if (additionalFilters != null) ...[
                      const SizedBox(width: 8),
                      ...?additionalFilters,
                    ],
                    if (onRefresh != null) ...[
                      const SizedBox(width: 8),
                      _buildRefreshButton(isDark),
                    ],
                    if (primaryAction != null) ...[
                      const SizedBox(width: 8),
                      primaryAction!,
                    ],
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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 1.5),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
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

  Widget _buildDateFilterDropdown(bool isDark) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportDateFilter>(
          value: activeFilter,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
          dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.sm,
          items: ReportDateFilter.values.map((filter) {
            return DropdownMenuItem<ReportDateFilter>(
              value: filter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(filter.label),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onFilterChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildRefreshButton(bool isDark) {
    return IconButton(
      onPressed: onRefresh,
      icon: const Icon(Icons.refresh_rounded, size: 15),
      tooltip: 'Refresh Metrics',
      style: IconButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        padding: const EdgeInsets.all(7),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.sm,
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
    );
  }
}

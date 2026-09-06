import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/dashboard_models.dart';

/// Compact, crisp enterprise header for Dashboard screens.
/// Features clean breadcrumbs, date filter dropdown (Today / Week / Month / Custom),
/// manual refresh action, and customizable primary action buttons.
class DashboardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final DashboardDateFilter activeFilter;
  final ValueChanged<DashboardDateFilter>? onFilterChanged;
  final VoidCallback? onRefresh;
  final Widget? primaryAction;

  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.activeFilter = DashboardDateFilter.today,
    this.onFilterChanged,
    this.onRefresh,
    this.primaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitleRow(isDark),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                _buildControlsRow(context, isDark, isMobile: true),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildTitleRow(isDark)),
                const SizedBox(width: 14),
                _buildControlsRow(context, isDark, isMobile: false),
              ],
            ),
    );
  }

  Widget _buildTitleRow(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: AppRadius.sm,
            border: Border.all(
              color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.4 : 0.2),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlsRow(BuildContext context, bool isDark, {required bool isMobile}) {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        // Date Filter Selector Menu
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.sm,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DashboardDateFilter>(
              value: activeFilter,
              icon: Icon(
                Icons.calendar_today_rounded,
                size: 13,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
              ),
              dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
              borderRadius: AppRadius.md,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
              ),
              onChanged: (val) {
                if (val != null && onFilterChanged != null) {
                  onFilterChanged!(val);
                }
              },
              items: DashboardDateFilter.values.map((f) {
                return DropdownMenuItem<DashboardDateFilter>(
                  value: f,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(f.label),
                      const SizedBox(width: 6),
                      Text(
                        '(${f.dateRangeDisplay})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Refresh Action Button
        if (onRefresh != null)
          InkWell(
            onTap: onRefresh,
            borderRadius: AppRadius.sm,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.sm,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Icon(
                Icons.refresh_rounded,
                size: 15,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
              ),
            ),
          ),

        // Primary Action Widget if supplied
        ?primaryAction,
      ],
    );
  }
}

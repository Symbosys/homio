import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/dashboard_enums.dart';

/// Enterprise Dashboard Header component.
/// Displays dynamic greeting with user profile, date filter, RBAC scope filter,
/// animated refresh button, and context-sensitive action slot.
class DashboardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String userName;
  final DashboardDateFilter activeDateFilter;
  final DashboardScopeFilter activeScopeFilter;
  final ValueChanged<DashboardDateFilter>? onDateFilterChanged;
  final ValueChanged<DashboardScopeFilter>? onScopeFilterChanged;
  final VoidCallback? onRefresh;
  final String lastUpdatedText;
  final Widget? primaryAction;
  final bool showScopeFilter;

  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.userName = 'Vikram Malhotra',
    this.activeDateFilter = DashboardDateFilter.today,
    this.activeScopeFilter = DashboardScopeFilter.myWork,
    this.onDateFilterChanged,
    this.onScopeFilterChanged,
    this.onRefresh,
    this.lastUpdatedText = 'Just now',
    this.primaryAction,
    this.showScopeFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 20,
        vertical: isMobile ? 12 : 14,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitleRow(isDark),
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: AppRadius.sm,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.2),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
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
      alignment: isMobile ? WrapAlignment.start : WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        // Date Filter Selector Menu
        Container(
          height: 34,
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
              value: activeDateFilter,
              icon: Icon(
                Icons.calendar_today_rounded,
                size: 13,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
              ),
              dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
              borderRadius: AppRadius.md,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
              ),
              onChanged: (val) {
                if (val != null) {
                  if (val == DashboardDateFilter.custom) {
                    _showCustomRangePicker(context);
                  } else if (onDateFilterChanged != null) {
                    onDateFilterChanged!(val);
                  }
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
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
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

        // Scope Filter Menu (My Work / Team / Organization)
        if (showScopeFilter)
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<DashboardScopeFilter>(
                value: activeScopeFilter,
                icon: Icon(
                  Icons.group_work_outlined,
                  size: 14,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                ),
                dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                borderRadius: AppRadius.md,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
                ),
                onChanged: (val) {
                  if (val != null && onScopeFilterChanged != null) {
                    onScopeFilterChanged!(val);
                  }
                },
                items: DashboardScopeFilter.values.map((s) {
                  return DropdownMenuItem<DashboardScopeFilter>(
                    value: s,
                    child: Text(s.label),
                  );
                }).toList(),
              ),
            ),
          ),

        // Refresh Action Button with tooltip
        if (onRefresh != null)
          Tooltip(
            message: 'Refresh telemetry (Updated $lastUpdatedText)',
            child: InkWell(
              onTap: onRefresh,
              borderRadius: AppRadius.sm,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Icon(
                  Icons.refresh_rounded,
                  size: 16,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
            ),
          ),

        // Primary Action Widget if supplied
        ?primaryAction,
      ],
    );
  }

  void _showCustomRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2027, 12, 31),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
    );
    if (picked != null && onDateFilterChanged != null) {
      onDateFilterChanged!(DashboardDateFilter.custom);
    }
  }
}

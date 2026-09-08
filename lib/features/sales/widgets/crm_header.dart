import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

enum CrmDateRangeFilter {
  today,
  thisWeek,
  thisMonth,
  thisQuarter,
  customRange,
}

extension CrmDateRangeFilterExt on CrmDateRangeFilter {
  String get label {
    switch (this) {
      case CrmDateRangeFilter.today:
        return 'Today';
      case CrmDateRangeFilter.thisWeek:
        return 'This Week';
      case CrmDateRangeFilter.thisMonth:
        return 'This Month';
      case CrmDateRangeFilter.thisQuarter:
        return 'This Quarter';
      case CrmDateRangeFilter.customRange:
        return 'Custom Range';
    }
  }
}

enum CrmScopeFilter {
  myWork,
  myTeam,
  organization,
}

extension CrmScopeFilterExt on CrmScopeFilter {
  String get label {
    switch (this) {
      case CrmScopeFilter.myWork:
        return 'My Work';
      case CrmScopeFilter.myTeam:
        return 'My Team';
      case CrmScopeFilter.organization:
        return 'Organization';
    }
  }
}

class CrmHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final CrmDateRangeFilter activeDateFilter;
  final CrmScopeFilter activeScopeFilter;
  final String? activeLeadList;
  final List<String>? leadListOptions;
  final ValueChanged<CrmDateRangeFilter>? onDateFilterChanged;
  final ValueChanged<CrmScopeFilter>? onScopeFilterChanged;
  final ValueChanged<String>? onLeadListChanged;
  final VoidCallback? onRefresh;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final List<Widget>? actionButtons;
  final String? scope;
  final ValueChanged<String>? onScopeChanged;

  const CrmHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.people_alt_rounded,
    this.activeDateFilter = CrmDateRangeFilter.thisMonth,
    this.activeScopeFilter = CrmScopeFilter.myWork,
    this.activeLeadList,
    this.leadListOptions,
    this.onDateFilterChanged,
    this.onScopeFilterChanged,
    this.onLeadListChanged,
    this.onRefresh,
    this.primaryAction,
    this.secondaryAction,
    this.actionButtons,
    this.scope,
    this.onScopeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleRow(isDark),
                const SizedBox(height: 12),
                _buildFilterControls(context, isDark, isMobile: true),
                if (actionButtons != null && actionButtons!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: actionButtons!),
                ] else if (primaryAction != null || secondaryAction != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (secondaryAction != null) Expanded(child: secondaryAction!),
                      if (secondaryAction != null && primaryAction != null) const SizedBox(width: 8),
                      if (primaryAction != null) Expanded(child: primaryAction!),
                    ],
                  ),
                ],
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildTitleRow(isDark)),
                const SizedBox(width: 12),
                _buildFilterControls(context, isDark, isMobile: false),
                if (actionButtons != null && actionButtons!.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  ...actionButtons!,
                ],
                if (secondaryAction != null) ...[
                  const SizedBox(width: 8),
                  secondaryAction!,
                ],
                if (primaryAction != null) ...[
                  const SizedBox(width: 8),
                  primaryAction!,
                ],
              ],
            ),
    );
  }

  Widget _buildTitleRow(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: AppRadius.sm,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
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

  Widget _buildFilterControls(BuildContext context, bool isDark, {required bool isMobile}) {
    final borderDecoration = BoxDecoration(
      color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
      borderRadius: AppRadius.sm,
      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
    );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // 1. Date Range Dropdown
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: borderDecoration,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CrmDateRangeFilter>(
              value: activeDateFilter,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
              dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              items: CrmDateRangeFilter.values.map((f) {
                return DropdownMenuItem(
                  value: f,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(f.label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) onDateFilterChanged?.call(val);
              },
            ),
          ),
        ),

        // 2. Scope Filter (My Work / Team / Org)
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: borderDecoration,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CrmScopeFilter>(
              value: activeScopeFilter,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
              dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              items: CrmScopeFilter.values.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people_outline_rounded, size: 13, color: Color(0xFF0EA5E9)),
                      const SizedBox(width: 6),
                      Text(s.label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) onScopeFilterChanged?.call(val);
              },
            ),
          ),
        ),

        // 3. Lead List Dropdown (if options provided)
        if (leadListOptions != null && leadListOptions!.isNotEmpty && onLeadListChanged != null)
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: borderDecoration,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: activeLeadList ?? leadListOptions!.first,
                isDense: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                dropdownColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                items: leadListOptions!.map((list) {
                  return DropdownMenuItem(
                    value: list,
                    child: Text(list),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) onLeadListChanged!(val);
                },
              ),
            ),
          ),

        // 4. Refresh Button
        IconButton.filledTonal(
          onPressed: onRefresh,
          iconSize: 15,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Refresh Telemetry',
        ),
      ],
    );
  }
}

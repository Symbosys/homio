import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/reports_models.dart';

/// Universal enterprise reporting control toolbar across all Reports & Analytics screens.
/// Features date range selection, custom date range dialog, comparison period selector,
/// filter drawer trigger with badge count, active filter chips, refresh, and export.
class ReportsControlsBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final ReportFilterState filterState;
  final ValueChanged<ReportFilterState> onFilterChanged;
  final VoidCallback onOpenFilterDrawer;
  final VoidCallback onExport;
  final VoidCallback? onRefresh;
  final VoidCallback? onSaveView;
  final Widget? additionalAction;

  const ReportsControlsBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.filterState,
    required this.onFilterChanged,
    required this.onOpenFilterDrawer,
    required this.onExport,
    this.onRefresh,
    this.onSaveView,
    this.additionalAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 768;
    final isCompact = width < 1100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Title + Desktop Actions
          if (isCompact) ...[
            _buildTitleRow(isDark),
            const SizedBox(height: 12),
            _buildControlsRow(context, isDark, isMobile),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildTitleRow(isDark)),
                const SizedBox(width: 16),
                Flexible(child: _buildControlsRow(context, isDark, isMobile)),
              ],
            ),
          ],

          // Active Filters Chip Row if filters are applied
          if (filterState.activeFiltersCount > 0) ...[
            const SizedBox(height: 10),
            _buildActiveFiltersRow(context, isDark),
          ],
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

  Widget _buildControlsRow(BuildContext context, bool isDark, bool isMobile) {
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDateRangeDropdown(context, isDark),
            const SizedBox(width: 8),
            _buildComparisonDropdown(isDark),
            const SizedBox(width: 8),
            _buildFiltersButton(isDark),
            const SizedBox(width: 8),
            if (onRefresh != null) ...[
              _buildRefreshButton(isDark),
              const SizedBox(width: 8),
            ],
            _buildExportButton(isDark),
            if (additionalAction != null) ...[
              const SizedBox(width: 8),
              additionalAction!,
            ],
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // 1. Date Range Dropdown
        _buildDateRangeDropdown(context, isDark),

        // 2. Comparison Period Dropdown
        _buildComparisonDropdown(isDark),

        // 3. Filters Drawer Trigger Button with Badge
        _buildFiltersButton(isDark),

        // 4. Refresh Button
        if (onRefresh != null) _buildRefreshButton(isDark),

        // 5. Export Action
        _buildExportButton(isDark),

        // 6. Save View Action
        if (onSaveView != null) _buildSaveViewButton(isDark),

        // 7. Additional Action
        ?additionalAction,
      ],
    );
  }

  Widget _buildDateRangeDropdown(BuildContext context, bool isDark) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportDateFilter>(
          value: filterState.dateFilter,
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
          items: ReportDateFilter.values.map((f) {
            return DropdownMenuItem<ReportDateFilter>(
              value: f,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(f.label),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              if (val == ReportDateFilter.custom) {
                _showCustomDateRangePicker(context);
              } else {
                onFilterChanged(filterState.copyWith(dateFilter: val));
              }
            }
          },
        ),
      ),
    );
  }

  void _showCustomDateRangePicker(BuildContext context) async {
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: filterState.customStartDate ?? now.subtract(const Duration(days: 30)),
      end: filterState.customEndDate ?? now,
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: initialRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onFilterChanged(
        filterState.copyWith(
          dateFilter: ReportDateFilter.custom,
          customStartDate: picked.start,
          customEndDate: picked.end,
        ),
      );
    }
  }

  Widget _buildComparisonDropdown(bool isDark) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportComparisonPeriod>(
          value: filterState.comparisonPeriod,
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
          items: ReportComparisonPeriod.values.map((p) {
            return DropdownMenuItem<ReportComparisonPeriod>(
              value: p,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.compare_arrows_rounded, size: 13, color: const Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  Text(p.label),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              onFilterChanged(filterState.copyWith(comparisonPeriod: val));
            }
          },
        ),
      ),
    );
  }

  Widget _buildFiltersButton(bool isDark) {
    final count = filterState.activeFiltersCount;
    return OutlinedButton.icon(
      onPressed: onOpenFilterDrawer,
      icon: Icon(
        Icons.tune_rounded,
        size: 14,
        color: count > 0 ? AppColors.primary : (isDark ? Colors.white : AppColors.lightTextPrimary),
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filters',
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.full,
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        side: BorderSide(
          color: count > 0
              ? AppColors.primary
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
    );
  }

  Widget _buildRefreshButton(bool isDark) {
    return IconButton(
      onPressed: onRefresh,
      icon: const Icon(Icons.refresh_rounded, size: 15),
      tooltip: 'Refresh Analytics',
      style: IconButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        padding: const EdgeInsets.all(7),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.sm,
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
    );
  }

  Widget _buildExportButton(bool isDark) {
    return ElevatedButton.icon(
      onPressed: onExport,
      icon: const Icon(Icons.file_download_outlined, size: 14),
      label: Text(
        'Export',
        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
    );
  }

  Widget _buildSaveViewButton(bool isDark) {
    return OutlinedButton.icon(
      onPressed: onSaveView,
      icon: const Icon(Icons.bookmark_border_rounded, size: 13),
      label: Text(
        'Save View',
        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
    );
  }

  Widget _buildActiveFiltersRow(BuildContext context, bool isDark) {
    final chips = <Widget>[];

    if (filterState.branch != 'All Branches') {
      chips.add(_buildFilterChip('Branch: ${filterState.branch}', () {
        onFilterChanged(filterState.copyWith(branch: 'All Branches'));
      }, isDark));
    }
    if (filterState.businessUnit != 'All Business Units') {
      chips.add(_buildFilterChip('BU: ${filterState.businessUnit}', () {
        onFilterChanged(filterState.copyWith(businessUnit: 'All Business Units'));
      }, isDark));
    }
    if (filterState.region != 'All Regions') {
      chips.add(_buildFilterChip('Region: ${filterState.region}', () {
        onFilterChanged(filterState.copyWith(region: 'All Regions'));
      }, isDark));
    }
    if (filterState.team != 'All Teams') {
      chips.add(_buildFilterChip('Team: ${filterState.team}', () {
        onFilterChanged(filterState.copyWith(team: 'All Teams'));
      }, isDark));
    }
    if (filterState.owner != 'All Owners') {
      chips.add(_buildFilterChip('Owner: ${filterState.owner}', () {
        onFilterChanged(filterState.copyWith(owner: 'All Owners'));
      }, isDark));
    }
    if (filterState.status != 'All Statuses') {
      chips.add(_buildFilterChip('Status: ${filterState.status}', () {
        onFilterChanged(filterState.copyWith(status: 'All Statuses'));
      }, isDark));
    }
    if (filterState.dateFilter == ReportDateFilter.custom &&
        filterState.customStartDate != null &&
        filterState.customEndDate != null) {
      final fmt = DateFormat('MMM d');
      final dateStr = '${fmt.format(filterState.customStartDate!)} - ${fmt.format(filterState.customEndDate!)}';
      chips.add(_buildFilterChip('Range: $dateStr', () {
        onFilterChanged(filterState.copyWith(dateFilter: ReportDateFilter.thisMonth));
      }, isDark));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            'Active Filters:',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(width: 8),
          ...chips,
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              onFilterChanged(const ReportFilterState());
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Clear All',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: AppRadius.full,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, size: 12, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

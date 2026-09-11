import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum OrgViewMode {
  table,
  cards,
  tree;

  String get label {
    switch (this) {
      case OrgViewMode.table:
        return 'Table';
      case OrgViewMode.cards:
        return 'Cards';
      case OrgViewMode.tree:
        return 'Tree';
    }
  }

  IconData get icon {
    switch (this) {
      case OrgViewMode.table:
        return Icons.table_chart_outlined;
      case OrgViewMode.cards:
        return Icons.grid_view_rounded;
      case OrgViewMode.tree:
        return Icons.account_tree_outlined;
    }
  }
}

class OrgToolbar extends StatelessWidget {
  final String searchHint;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onSearchClear;
  final OrgViewMode currentViewMode;
  final List<OrgViewMode> supportedViewModes;
  final ValueChanged<OrgViewMode>? onViewModeChanged;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onFilterPressed;
  final int activeFilterCount;
  final VoidCallback? onExportPressed;
  final VoidCallback? onRefresh;
  final Widget? customFilterWidget;

  const OrgToolbar({
    super.key,
    required this.searchHint,
    required this.searchQuery,
    required this.onSearchChanged,
    this.onSearchClear,
    this.currentViewMode = OrgViewMode.table,
    this.supportedViewModes = const [OrgViewMode.table, OrgViewMode.cards],
    this.onViewModeChanged,
    this.primaryActionLabel,
    this.primaryActionIcon = Icons.add_rounded,
    this.onPrimaryAction,
    this.onFilterPressed,
    this.activeFilterCount = 0,
    this.onExportPressed,
    this.onRefresh,
    this.customFilterWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 768;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Search, View Mode, Actions
          if (isCompact) ...[
            // Mobile: Stacked
            _buildSearchField(isDark),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (supportedViewModes.length > 1) _buildViewModeSwitcher(isDark),
                if (onFilterPressed != null) _buildFilterButton(isDark),
                if (onRefresh != null) _buildRefreshButton(isDark),
                if (onExportPressed != null) _buildExportButton(isDark),
                if (primaryActionLabel != null) _buildPrimaryButton(),
              ],
            ),
          ] else ...[
            // Desktop / Tablet: Flex Row
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildSearchField(isDark),
                ),
                const SizedBox(width: 12),
                if (supportedViewModes.length > 1) ...[
                  _buildViewModeSwitcher(isDark),
                  const SizedBox(width: 8),
                ],
                if (onFilterPressed != null) ...[
                  _buildFilterButton(isDark),
                  const SizedBox(width: 8),
                ],
                if (onExportPressed != null) ...[
                  _buildExportButton(isDark),
                  const SizedBox(width: 8),
                ],
                if (onRefresh != null) ...[
                  _buildRefreshButton(isDark),
                  const SizedBox(width: 8),
                ],
                if (primaryActionLabel != null) _buildPrimaryButton(),
              ],
            ),
          ],

          if (customFilterWidget != null) ...[
            const SizedBox(height: 12),
            customFilterWidget!,
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 18,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: searchQuery)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: searchQuery.length),
                ),
              onChanged: onSearchChanged,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkSubtext.withValues(alpha: 0.6) : AppColors.lightTextMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (searchQuery.isNotEmpty)
            GestureDetector(
              onTap: onSearchClear ?? () => onSearchChanged(''),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildViewModeSwitcher(bool isDark) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: supportedViewModes.map((mode) {
          final isSelected = mode == currentViewMode;
          return InkWell(
            onTap: () => onViewModeChanged?.call(mode),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    mode.icon,
                    size: 15,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mode.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterButton(bool isDark) {
    final hasActive = activeFilterCount > 0;
    return OutlinedButton.icon(
      onPressed: onFilterPressed,
      icon: Badge(
        isLabelVisible: hasActive,
        label: Text('$activeFilterCount'),
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.tune_rounded,
          size: 16,
          color: hasActive ? AppColors.primary : (isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary),
        ),
      ),
      label: Text(
        'Filters',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: hasActive ? AppColors.primary : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        side: BorderSide(
          color: hasActive ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildExportButton(bool isDark) {
    return OutlinedButton.icon(
      onPressed: onExportPressed,
      icon: Icon(
        Icons.download_rounded,
        size: 16,
        color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
      ),
      label: Text(
        'Export',
        style: TextStyle(
          fontSize: 13,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildRefreshButton(bool isDark) {
    return IconButton(
      onPressed: onRefresh,
      icon: const Icon(Icons.refresh_rounded, size: 18),
      tooltip: 'Refresh Records',
      color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(8),
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton.icon(
      onPressed: onPrimaryAction,
      icon: Icon(primaryActionIcon, size: 18, color: Colors.white),
      label: Text(
        primaryActionLabel!,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

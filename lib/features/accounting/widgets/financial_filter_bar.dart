// Homio CRM — Enterprise Financial Filter Toolbar

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FinancialFilterBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String searchHint;
  final String? selectedProject;
  final List<String> projectList;
  final ValueChanged<String?>? onProjectChanged;
  final String? activeFilterSummary;
  final VoidCallback? onClearFilters;
  final List<Widget>? extraActions;

  const FinancialFilterBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    this.searchHint = 'Search records by ID, customer, project, UTR, invoice...',
    this.selectedProject,
    this.projectList = const [],
    this.onProjectChanged,
    this.activeFilterSummary,
    this.onClearFilters,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Search Field
          SizedBox(
            width: 320,
            child: TextField(
              onChanged: onSearchChanged,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
            ),
          ),

          // Project Filter
          if (projectList.isNotEmpty && onProjectChanged != null)
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String?>(
                initialValue: selectedProject,
                decoration: InputDecoration(
                  labelText: 'Filter by Project',
                  labelStyle: const TextStyle(fontSize: 12),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All Projects'),
                  ),
                  ...projectList.map((p) => DropdownMenuItem<String?>(
                        value: p,
                        child: Text(p, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: onProjectChanged,
              ),
            ),

          // Active filter indicator & Clear button
          if (activeFilterSummary != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    activeFilterSummary!,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onClearFilters != null) ...[
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onClearFilters,
                    icon: const Icon(Icons.close_rounded, size: 14),
                    label: const Text('Reset', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ],
            ),

          // Additional Action slots
          ...?extraActions,
        ],
      ),
    );
  }
}

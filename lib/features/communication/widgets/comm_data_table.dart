// Homio CRM — Enterprise Communication Data Table

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CommDataColumn {
  final String label;
  final double? width;
  final bool isNumeric;
  final VoidCallback? onSort;
  final bool isSorted;
  final bool isAscending;

  const CommDataColumn({
    required this.label,
    this.width,
    this.isNumeric = false,
    this.onSort,
    this.isSorted = false,
    this.isAscending = true,
  });
}

class CommDataRow {
  final List<Widget> cells;
  final VoidCallback? onTap;
  final bool isSelected;

  const CommDataRow({
    required this.cells,
    this.onTap,
    this.isSelected = false,
  });
}

class CommDataTable extends StatelessWidget {
  final List<CommDataColumn> columns;
  final List<CommDataRow> rows;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final ValueChanged<int>? onPageChanged;
  final bool isLoading;
  final String emptyMessage;
  final IconData emptyIcon;

  const CommDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.pageSize = 10,
    this.onPageChanged,
    this.isLoading = false,
    this.emptyMessage = 'No communication records found matching your filters.',
    this.emptyIcon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (rows.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                emptyIcon,
                size: 48,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              const SizedBox(height: 12),
              Text(
                emptyMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      showCheckboxColumn: false,
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 64,
                      columnSpacing: 24,
                      horizontalMargin: 18,
                      headingRowColor: WidgetStatePropertyAll(
                        isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      ),
                      dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08);
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.04);
                        }
                        return isDark ? AppColors.darkSurface : AppColors.lightSurface;
                      }),
                      headingTextStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        letterSpacing: 0.3,
                      ),
                      columns: columns.map((col) {
                        final child = Text(col.label.toUpperCase());
                        return DataColumn(
                          label: col.width != null
                              ? SizedBox(width: col.width, child: child)
                              : child,
                          numeric: col.isNumeric,
                          onSort: col.onSort != null ? (colIdx, ascending) => col.onSort!() : null,
                        );
                      }).toList(),
                      rows: rows.map((row) {
                        return DataRow(
                          selected: row.isSelected,
                          onSelectChanged: row.onTap != null ? (_) => row.onTap!() : null,
                          cells: row.cells.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final cell = entry.value;
                            final col = idx < columns.length ? columns[idx] : null;

                            if (col?.width != null) {
                              return DataCell(
                                SizedBox(
                                  width: col!.width,
                                  child: cell,
                                ),
                              );
                            }
                            return DataCell(cell);
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (totalPages > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      border: Border(
                        top: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing ${((currentPage - 1) * pageSize) + 1}–${(currentPage * pageSize).clamp(0, totalItems)} of $totalItems entries',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left, size: 18),
                              onPressed: currentPage > 1 && onPageChanged != null
                                  ? () => onPageChanged!(currentPage - 1)
                                  : null,
                              tooltip: 'Previous page',
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$currentPage / $totalPages',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right, size: 18),
                              onPressed: currentPage < totalPages && onPageChanged != null
                                  ? () => onPageChanged!(currentPage + 1)
                                  : null,
                              tooltip: 'Next page',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class HrmsDataColumn {
  final String title;
  final double? width;
  final Alignment alignment;

  const HrmsDataColumn({
    required this.title,
    this.width,
    this.alignment = Alignment.centerLeft,
  });
}

class HrmsDataTable extends StatelessWidget {
  final List<HrmsDataColumn> columns;
  final List<List<Widget>> rows;
  final bool isLoading;
  final String emptyMessage;
  final IconData emptyIcon;
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final ValueChanged<int>? onPageChanged;

  const HrmsDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyMessage = 'No records found matching your filters.',
    this.emptyIcon = Icons.inbox_outlined,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalRecords = 0,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLoading)
            const LinearProgressIndicator(minHeight: 2)
          else
            const SizedBox(height: 2),

          // Scrollable Table Area
          if (rows.isEmpty && !isLoading)
            _buildEmptyState(isDark)
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 80,
                ),
                child: DataTable(
                  horizontalMargin: AppSpacing.md,
                  columnSpacing: AppSpacing.md,
                  headingRowHeight: 44,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 64,
                  headingRowColor: WidgetStateProperty.all(
                    isDark ? const Color(0xFF1A1F2C) : const Color(0xFFF8FAFC),
                  ),
                  columns: columns.map((col) {
                    return DataColumn(
                      label: Align(
                        alignment: col.alignment,
                        child: Text(
                          col.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  rows: rows.map((cells) {
                    return DataRow(
                      cells: cells.map((cell) => DataCell(cell)).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),

          // Pagination Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total $totalRecords records • Page $currentPage of $totalPages',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 20),
                      onPressed: currentPage > 1 ? () => onPageChanged?.call(currentPage - 1) : null,
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Previous Page',
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 20),
                      onPressed: currentPage < totalPages ? () => onPageChanged?.call(currentPage + 1) : null,
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Next Page',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
              shape: BoxShape.circle,
            ),
            child: Icon(
              emptyIcon,
              size: 36,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            emptyMessage,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

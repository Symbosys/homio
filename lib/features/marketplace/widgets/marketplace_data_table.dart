import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class MarketplaceDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool isLoading;
  final String emptyMessage;
  final IconData emptyIcon;
  final VoidCallback? onResetFilter;

  const MarketplaceDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyMessage = 'No marketplace records found matching current criteria.',
    this.emptyIcon = Icons.inbox_rounded,
    this.onResetFilter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return Container(
        height: 260,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131722) : Colors.white,
          borderRadius: AppRadius.md,
          border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
        ),
        child: const CircularProgressIndicator(strokeWidth: 2.5),
      );
    }

    if (rows.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131722) : Colors.white,
          borderRadius: AppRadius.md,
          border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(emptyIcon, size: 48, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            if (onResetFilter != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onResetFilter,
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: Text('Clear Filters & Refresh', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
              ),
            ],
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.md,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 800),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? const Color(0xFF1A202C) : const Color(0xFFF8FAFC),
              ),
              dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.hovered)) {
                  return isDark ? const Color(0xFF1E2538) : const Color(0xFFF1F5F9);
                }
                return null;
              }),
              horizontalMargin: AppSpacing.md,
              columnSpacing: 20,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 64,
              headingTextStyle: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      ),
    );
  }
}

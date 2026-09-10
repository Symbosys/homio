import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class MarketplaceFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final List<Widget> filterDropdowns;
  final int totalCount;
  final String entityLabel;
  final VoidCallback onClear;
  final Widget? trailingAction;

  const MarketplaceFilterBar({
    super.key,
    required this.searchController,
    this.searchHint = 'Search catalogue...',
    required this.onSearchChanged,
    this.filterDropdowns = const [],
    required this.totalCount,
    this.entityLabel = 'Records',
    required this.onClear,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.sm,
                    border: Border.all(
                      color: isDark ? const Color(0xFF262D40) : const Color(0xFFCBD5E1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, size: 18, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: onSearchChanged,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: searchHint,
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (searchController.text.isNotEmpty)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                          icon: const Icon(Icons.close_rounded, size: 16),
                          onPressed: () {
                            searchController.clear();
                            onSearchChanged('');
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '$totalCount $entityLabel',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (trailingAction != null) ...[
                const SizedBox(width: 8),
                trailingAction!,
              ],
            ],
          ),
          if (filterDropdowns.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...filterDropdowns,
                TextButton.icon(
                  onPressed: onClear,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xFFEF4444),
                  ),
                  icon: const Icon(Icons.filter_alt_off_rounded, size: 14),
                  label: Text('Reset Filters', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

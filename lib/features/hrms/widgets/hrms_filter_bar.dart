import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class FilterOption {
  final String label;
  final String value;
  final int? count;

  const FilterOption({
    required this.label,
    required this.value,
    this.count,
  });
}

class HrmsFilterBar extends StatelessWidget {
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final String selectedFilter;
  final List<FilterOption> filterOptions;
  final ValueChanged<String>? onFilterSelected;
  final Widget? trailing;
  final VoidCallback? onReset;

  const HrmsFilterBar({
    super.key,
    this.searchHint = 'Search records...',
    this.onSearchChanged,
    required this.selectedFilter,
    this.filterOptions = const [],
    this.onFilterSelected,
    this.trailing,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
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
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.md,
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: TextField(
                    onChanged: onSearchChanged,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: searchHint,
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    ),
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
          if (filterOptions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filterOptions.map((opt) {
                  final isSelected = opt.value == selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => onFilterSelected?.call(opt.value),
                      borderRadius: AppRadius.md,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12)
                              : (isDark ? const Color(0xFF1B202E) : const Color(0xFFF1F5F9)),
                          borderRadius: AppRadius.md,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              opt.label,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                            ),
                            if (opt.count != null) ...[
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08)),
                                  borderRadius: AppRadius.full,
                                ),
                                child: Text(
                                  opt.count.toString(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

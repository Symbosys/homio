import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Top banner/header for sub-module catalog pages with search input
class MarketplaceHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onClearSearch;
  final String searchHint;
  final List<Widget>? actionButtons;

  const MarketplaceHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.badgeColor,
    this.searchController,
    this.onSearchChanged,
    this.onClearSearch,
    this.searchHint = 'Search by title, brand, specs or tag...',
    this.actionButtons,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final accent = badgeColor ?? const Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Badge row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (badgeText != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: accent.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          badgeText!.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (actionButtons != null) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: actionButtons!,
                ),
              ],
            ],
          ),

          if (onSearchChanged != null) ...[
            const SizedBox(height: 16),
            // Search Input
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textPrimary),
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: textMuted),
                  prefixIcon: Icon(Icons.search_rounded, size: 20, color: textMuted),
                  suffixIcon: searchController?.text.isNotEmpty == true
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: onClearSearch,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

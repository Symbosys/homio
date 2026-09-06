import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Standardized responsive header component for Project Execution screens.
class ExecutionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? primaryAction;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final VoidCallback? onPrimaryAction;
  final List<Widget>? actions;
  final List<Widget>? additionalFilters;
  final VoidCallback? onRefresh;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;

  const ExecutionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.construction_rounded,
    this.primaryAction,
    this.primaryActionLabel,
    this.primaryActionIcon,
    this.onPrimaryAction,
    this.actions,
    this.additionalFilters,
    this.onRefresh,
    this.searchHint,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 800;

    final actionButton = primaryAction ??
        (primaryActionLabel != null && onPrimaryAction != null
            ? ElevatedButton.icon(
                onPressed: onPrimaryAction,
                icon: Icon(primaryActionIcon ?? Icons.add, size: 18),
                label: Text(
                  primaryActionLabel!,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              )
            : null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleRow(isDark),
                const SizedBox(height: 12),
                if (onSearchChanged != null) ...[
                  _buildSearchField(isDark),
                  const SizedBox(height: 10),
                ],
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...?additionalFilters,
                    ...?actions,
                    if (onRefresh != null) _buildRefreshButton(isDark),
                    ?actionButton,
                  ],
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildTitleRow(isDark)),
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onSearchChanged != null) ...[
                      SizedBox(width: 220, child: _buildSearchField(isDark)),
                      const SizedBox(width: 10),
                    ],
                    ...?additionalFilters,
                    if (additionalFilters != null) const SizedBox(width: 10),
                    ...?actions,
                    if (actions != null) const SizedBox(width: 10),
                    if (onRefresh != null) ...[
                      _buildRefreshButton(isDark),
                      const SizedBox(width: 10),
                    ],
                    ?actionButton,
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTitleRow(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: AppRadius.sm,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
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

  Widget _buildSearchField(bool isDark) {
    return SizedBox(
      height: 38,
      child: TextField(
        onChanged: onSearchChanged,
        style: GoogleFonts.inter(fontSize: 13),
        decoration: InputDecoration(
          hintText: searchHint ?? 'Search...',
          hintStyle: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          prefixIcon: const Icon(Icons.search, size: 18),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          filled: true,
          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
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
    );
  }

  Widget _buildRefreshButton(bool isDark) {
    return OutlinedButton(
      onPressed: onRefresh,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
      child: const Icon(Icons.refresh_rounded, size: 18),
    );
  }
}

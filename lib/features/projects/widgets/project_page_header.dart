import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Consistent page header used across all Projects module screens.
/// Supports title, subtitle, search, filters, primary CTA, view toggle, and export.
class ProjectPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? searchHint;
  final String? searchQuery;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAddPressed;
  final String? addLabel;
  final IconData addIcon;
  final List<Widget> actions;
  final List<Widget> filters;
  final Widget? trailing;

  const ProjectPageHeader({
    super.key,
    required this.title,
    this.subtitle = '',
    this.icon = Icons.folder_outlined,
    this.searchHint,
    this.searchQuery,
    this.onSearchChanged,
    this.onAddPressed,
    this.addLabel,
    this.addIcon = Icons.add_rounded,
    this.actions = const [],
    this.filters = const [],
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 24,
        vertical: isCompact ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          if (isCompact) ...[
            _buildCompactHeader(context, isDark),
          ] else ...[
            _buildDesktopHeader(context, isDark),
          ],
          // Filters row
          if (filters.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: filters,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
            ],
          ),
        ),
        if (onSearchChanged != null) ...[
          SizedBox(
            width: 260,
            height: 38,
            child: TextField(
              onChanged: onSearchChanged,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: searchHint ?? 'Search...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkSurfaceSubtle
                    : AppColors.lightSurfaceSubtle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        if (actions.isNotEmpty || onAddPressed != null || trailing != null)
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...actions,
                  if (onAddPressed != null) ...[
                    const SizedBox(width: 8),
                    _buildAddButton(isDark),
                  ],
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompactHeader(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            if (onAddPressed != null) _buildAddButton(isDark),
          ],
        ),
        if (onSearchChanged != null) ...[
          const SizedBox(height: 10),
          TextField(
            onChanged: onSearchChanged,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: searchHint ?? 'Search...',
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
              prefixIcon: Icon(Icons.search_rounded, size: 18,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              filled: true,
              fillColor: isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.lightSurfaceSubtle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddButton(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onAddPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(addIcon, color: Colors.white, size: 16),
              if (addLabel != null) ...[
                const SizedBox(width: 6),
                Text(
                  addLabel!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

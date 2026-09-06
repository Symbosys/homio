import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Responsive header for Designs & DAM screens with live search, project filter, and primary triggers.
class DesignHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final VoidCallback? onPrimaryAction;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final List<Widget>? actions;

  const DesignHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.primaryActionLabel,
    this.primaryActionIcon,
    this.onPrimaryAction,
    this.searchHint,
    this.onSearchChanged,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title, Subtitle, and Primary Actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (primaryActionLabel != null && onPrimaryAction != null) ...[
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: onPrimaryAction,
                    icon: Icon(primaryActionIcon ?? Icons.add, size: 18),
                    label: Text(primaryActionLabel!),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Row 2: Search Box & Optional Context Actions
            if (onSearchChanged != null || (actions != null && actions!.isNotEmpty))
              if (isWide)
                Row(
                  children: [
                    if (onSearchChanged != null)
                      Expanded(
                        child: _buildSearchBox(isDark),
                      ),
                    if (actions != null && actions!.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: actions!,
                      ),
                    ],
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (onSearchChanged != null) _buildSearchBox(isDark),
                    if (actions != null && actions!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: actions!,
                      ),
                    ],
                  ],
                ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBox(bool isDark) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: searchHint ?? 'Search drawings, renders, formats...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

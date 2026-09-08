import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProcurementPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onRefresh;
  final VoidCallback? onExport;
  final Widget? secondaryAction;

  const ProcurementPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.primaryActionLabel,
    this.primaryActionIcon,
    this.onPrimaryAction,
    this.onRefresh,
    this.onExport,
    this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (secondaryAction != null) ...[
            secondaryAction!,
            const SizedBox(width: 10),
          ],
          if (onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 20),
              tooltip: 'Refresh Records',
              onPressed: onRefresh,
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
            ),
          if (onExport != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.file_download_outlined, size: 20),
              tooltip: 'Export Data (CSV / Excel)',
              onPressed: onExport,
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
            ),
          ],
          if (primaryActionLabel != null && onPrimaryAction != null) ...[
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: onPrimaryAction,
              icon: Icon(primaryActionIcon ?? Icons.add_rounded, size: 18),
              label: Text(primaryActionLabel!),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

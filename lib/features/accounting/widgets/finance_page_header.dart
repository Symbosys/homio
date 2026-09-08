// Homio CRM — Enterprise Finance Page Header

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FinancePageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final VoidCallback? onPrimaryAction;
  final Widget? secondaryAction;
  final VoidCallback? onRefresh;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;
  final VoidCallback? onExportCsv;
  final String? dateRangeLabel;
  final VoidCallback? onSelectDateRange;

  const FinancePageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.primaryActionLabel,
    this.primaryActionIcon,
    this.onPrimaryAction,
    this.secondaryAction,
    this.onRefresh,
    this.onExportPdf,
    this.onExportExcel,
    this.onExportCsv,
    this.dateRangeLabel,
    this.onSelectDateRange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primaryDark.withValues(alpha: 0.3) : AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (dateRangeLabel != null)
                    OutlinedButton.icon(
                      onPressed: onSelectDateRange,
                      icon: const Icon(Icons.date_range_rounded, size: 16),
                      label: Text(dateRangeLabel!, style: const TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  if (onExportPdf != null || onExportExcel != null || onExportCsv != null)
                    PopupMenuButton<String>(
                      tooltip: 'Export Financial Data',
                      icon: const Icon(Icons.download_rounded, size: 18),
                      onSelected: (val) {
                        if (val == 'pdf') onExportPdf?.call();
                        if (val == 'excel') onExportExcel?.call();
                        if (val == 'csv') onExportCsv?.call();
                      },
                      itemBuilder: (context) => [
                        if (onExportPdf != null)
                          const PopupMenuItem(
                            value: 'pdf',
                            child: Row(
                              children: [
                                Icon(Icons.picture_as_pdf_outlined, size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Export PDF Statement', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        if (onExportExcel != null)
                          const PopupMenuItem(
                            value: 'excel',
                            child: Row(
                              children: [
                                Icon(Icons.table_view_outlined, size: 16, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Export Excel (.xlsx)', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        if (onExportCsv != null)
                          const PopupMenuItem(
                            value: 'csv',
                            child: Row(
                              children: [
                                Icon(Icons.description_outlined, size: 16, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Export CSV Data', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (onRefresh != null)
                    IconButton(
                      onPressed: onRefresh,
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      tooltip: 'Refresh Financial Records',
                      style: IconButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceElevated
                            : AppColors.lightSurfaceSubtle,
                      ),
                    ),
                  ?secondaryAction,
                  if (primaryActionLabel != null)
                    FilledButton.icon(
                      onPressed: onPrimaryAction,
                      icon: Icon(primaryActionIcon ?? Icons.add_rounded, size: 18),
                      label: Text(
                        primaryActionLabel!,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Homio CRM — Enterprise Communication Page Header

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CommPageHeader extends StatelessWidget {
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
  final List<Widget>? customActions;

  const CommPageHeader({
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
    this.customActions,
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
                  color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (dateRangeLabel != null)
                    OutlinedButton.icon(
                      onPressed: onSelectDateRange,
                      icon: const Icon(Icons.date_range_outlined, size: 16),
                      label: Text(
                        dateRangeLabel!,
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        side: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                    ),
                  if (onRefresh != null)
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: onRefresh,
                      tooltip: 'Refresh feed',
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  if (onExportCsv != null || onExportExcel != null || onExportPdf != null)
                    PopupMenuButton<String>(
                      tooltip: 'Export data',
                      icon: Icon(
                        Icons.download_outlined,
                        size: 20,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      onSelected: (val) {
                        if (val == 'csv' && onExportCsv != null) onExportCsv!();
                        if (val == 'excel' && onExportExcel != null) onExportExcel!();
                        if (val == 'pdf' && onExportPdf != null) onExportPdf!();
                      },
                      itemBuilder: (context) => [
                        if (onExportCsv != null)
                          const PopupMenuItem(
                            value: 'csv',
                            child: Row(
                              children: [
                                Icon(Icons.table_chart_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Export CSV'),
                              ],
                            ),
                          ),
                        if (onExportExcel != null)
                          const PopupMenuItem(
                            value: 'excel',
                            child: Row(
                              children: [
                                Icon(Icons.grid_on_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Export Excel'),
                              ],
                            ),
                          ),
                        if (onExportPdf != null)
                          const PopupMenuItem(
                            value: 'pdf',
                            child: Row(
                              children: [
                                Icon(Icons.picture_as_pdf_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Export PDF Report'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ...?customActions,
                  ?secondaryAction,
                  if (primaryActionLabel != null)
                    ElevatedButton.icon(
                      onPressed: onPrimaryAction,
                      icon: Icon(primaryActionIcon ?? Icons.add, size: 16),
                      label: Text(primaryActionLabel!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
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

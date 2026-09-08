// Homio CRM — Finance Command Center "Needs Attention" Action Strip

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FinanceAttentionItem {
  final String title;
  final String amount;
  final String count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FinanceAttentionItem({
    required this.title,
    required this.amount,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class FinanceCommandCenter extends StatelessWidget {
  final List<FinanceAttentionItem> items;

  const FinanceCommandCenter({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.bolt_rounded, size: 16, color: AppColors.error),
              ),
              const SizedBox(width: 10),
              Text(
                'NEEDS ATTENTION — FINANCIAL COMMAND CENTER',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: AppColors.error,
                ),
              ),
              const Spacer(),
              Text(
                'Live Operational Priority Alerts',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: items.map((itm) {
                  return SizedBox(
                    width: isNarrow ? (constraints.maxWidth - 12) / 2 : (constraints.maxWidth - 48) / items.length,
                    child: InkWell(
                      onTap: itm.onTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: itm.color.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: itm.color.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: itm.color.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(itm.icon, size: 16, color: itm.color),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itm.count,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                      color: itm.color,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    itm.title,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    itm.amount,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, size: 16, color: itm.color.withValues(alpha: 0.7)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

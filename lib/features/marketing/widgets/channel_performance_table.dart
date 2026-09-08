import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../domain/marketing_enums.dart';
import '../domain/marketing_models.dart';

class ChannelPerformanceTable extends StatelessWidget {
  final List<ChannelPerformanceItem> items;
  final ValueChanged<ChannelPerformanceItem>? onChannelTap;

  const ChannelPerformanceTable({
    super.key,
    required this.items,
    this.onChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Channel Performance & Unit Economics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.darkTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ad Spend, CPL (Spend/Leads), CAC (Spend/Bookings), and ROI across channels',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Real-Time Attribution',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
              ),
              columnSpacing: 24,
              horizontalMargin: 20,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 56,
              columns: const [
                DataColumn(label: Text('Channel', style: TextStyle(fontWeight: FontWeight.w700))),
                DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.w700))),
                DataColumn(label: Text('Ad Spend', style: TextStyle(fontWeight: FontWeight.w700)), numeric: true),
                DataColumn(label: Text('Leads', style: TextStyle(fontWeight: FontWeight.w700)), numeric: true),
                DataColumn(label: Text('CPL', style: TextStyle(fontWeight: FontWeight.w700)), numeric: true),
                DataColumn(label: Text('Bookings', style: TextStyle(fontWeight: FontWeight.w700)), numeric: true),
                DataColumn(label: Text('CAC', style: TextStyle(fontWeight: FontWeight.w700)), numeric: true),
                DataColumn(label: Text('Conv. Rate', style: TextStyle(fontWeight: FontWeight.w700)), numeric: true),
                DataColumn(label: Text('Revenue', style: TextStyle(fontWeight: FontWeight.w700)), numeric: true),
                DataColumn(label: Text('ROI', style: TextStyle(fontWeight: FontWeight.w700)), numeric: true),
              ],
              rows: items.map((item) {
                final roiColor = item.roiPercent >= 200
                    ? const Color(0xFF10B981)
                    : (item.roiPercent >= 100 ? const Color(0xFF3B82F6) : const Color(0xFFEAB308));

                return DataRow(
                  onSelectChanged: onChannelTap != null ? (_) => onChannelTap!(item) : null,
                  cells: [
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item.channel.icon, size: 18, color: AppColors.brandPrimary),
                          const SizedBox(width: 8),
                          Text(
                            item.channel.label,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (item.channel.isPaid ? const Color(0xFF8B5CF6) : const Color(0xFF10B981))
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.channel.isPaid ? 'PAID' : 'ORGANIC',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: item.channel.isPaid ? const Color(0xFF8B5CF6) : const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(item.spendFormatted, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text('${item.leadsGenerated}', style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(
                      Text(
                        item.cplFormatted,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: item.cpl > 600 ? const Color(0xFFEF4444) : (item.cpl == 0 ? Colors.green : null),
                        ),
                      ),
                    ),
                    DataCell(Text('${item.conversions}', style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text(item.cacFormatted, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text('${item.conversionRate.toStringAsFixed(1)}%')),
                    DataCell(Text(item.revenueFormatted, style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: roiColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.spend == 0 ? 'N/A' : '${item.roiPercent.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: roiColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';

class CustomerOperationsSummaryModal extends StatelessWidget {
  final CustomerOperationsSummary summary;

  const CustomerOperationsSummaryModal({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 680,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person_pin_circle_rounded,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Operations Ledger Summary',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Client: ${summary.customerName} • ${summary.projectName}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Material Breakdown
            _buildCategoryRow(
              title: 'Material Procurement Bills',
              icon: Icons.inventory_2_outlined,
              color: const Color(0xFF3B82F6),
              total: summary.materialTotal,
              paid: summary.materialPaid,
              due: summary.materialDue,
              isDark: isDark,
            ),
            const SizedBox(height: 12),

            // Labour Breakdown
            _buildCategoryRow(
              title: 'Site Labour & Subcontractor Wages',
              icon: Icons.engineering_outlined,
              color: const Color(0xFF10B981),
              total: summary.labourTotal,
              paid: summary.labourPaid,
              due: summary.labourDue,
              isDark: isDark,
            ),
            const SizedBox(height: 12),

            // Fees Breakdown
            _buildCategoryRow(
              title: 'Supervision & Consulting Fees',
              icon: Icons.assignment_turned_in_outlined,
              color: const Color(0xFF8B5CF6),
              total: summary.feesTotal,
              paid: summary.feesPaid,
              due: summary.feesDue,
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // Overall Total Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTotalItem(
                    'TOTAL PROJECT BILLS',
                    '₹${summary.totalBills.toStringAsFixed(0)}',
                    isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  _buildTotalItem(
                    'RECEIVED SO FAR',
                    '₹${summary.totalReceived.toStringAsFixed(0)}',
                    AppColors.success,
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  _buildTotalItem(
                    'OUTSTANDING BALANCE',
                    '₹${summary.totalOutstanding.toStringAsFixed(0)}',
                    AppColors.error,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Footer action
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow({
    required String title,
    required IconData icon,
    required Color color,
    required double total,
    required double paid,
    required double due,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.08) : color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                Text(
                  'Total Invoiced: ₹${total.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Paid: ₹${paid.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
              Text(
                'Due: ₹${due.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }
}

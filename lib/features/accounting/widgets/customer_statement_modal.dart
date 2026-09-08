// Homio CRM — Customer Account Statement Generator Modal

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';

class CustomerStatementModal extends StatelessWidget {
  final CustomerLedgerDetailModel ledger;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onDownloadExcel;
  final VoidCallback? onShareWhatsApp;

  const CustomerStatementModal({
    super.key,
    required this.ledger,
    this.onDownloadPdf,
    this.onDownloadExcel,
    this.onShareWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 820,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statement Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STATEMENT OF ACCOUNT',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      ledger.customerName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Project: ${ledger.activeProjectName} (${ledger.contractModel})',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            const Divider(height: 24),

            // Summary Metric Highlights
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric('Total Contract', '₹${ledger.totalContractValue.toStringAsFixed(0)}', isDark),
                  _buildMetric('Invoiced', '₹${ledger.totalInvoiced.toStringAsFixed(0)}', isDark),
                  _buildMetric('Collected', '₹${ledger.totalCollected.toStringAsFixed(0)}', isDark, color: AppColors.success),
                  _buildMetric('Outstanding Due', '₹${ledger.totalOutstanding.toStringAsFixed(0)}', isDark, color: AppColors.error),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Ledger Transaction History Table
            Text(
              'TRANSACTION LEDGER BREAKDOWN',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 240,
              child: ledger.transactions.isEmpty
                  ? const Center(child: Text('No historical ledger transactions logged yet.'))
                  : ListView.separated(
                      itemCount: ledger.transactions.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final tx = ledger.transactions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tx.description, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                    Text('Ref: ${tx.reference} (${tx.type})', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  tx.debit > 0 ? '₹${tx.debit.toStringAsFixed(0)}' : '—',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  tx.credit > 0 ? '₹${tx.credit.toStringAsFixed(0)}' : '—',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 12, color: AppColors.success),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '₹${tx.balance.toStringAsFixed(0)}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    onShareWhatsApp?.call();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Statement shared with ${ledger.customerName} via WhatsApp')),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF22C55E)),
                  label: const Text('WhatsApp Statement', style: TextStyle(fontSize: 12)),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    onDownloadExcel?.call();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Exported Excel ledger for ${ledger.customerName}')),
                    );
                  },
                  icon: const Icon(Icons.table_view_outlined, size: 16, color: Colors.green),
                  label: const Text('Excel (.xlsx)', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () {
                    onDownloadPdf?.call();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Generated PDF Statement for ${ledger.customerName}')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                  label: const Text('Download PDF', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, bool isDark, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }
}

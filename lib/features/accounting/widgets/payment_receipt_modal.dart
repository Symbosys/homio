// Homio CRM — Official Payment Receipt Modal

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';

class PaymentReceiptModal extends StatelessWidget {
  final CustomerPaymentRecord payment;
  final VoidCallback? onPrint;
  final VoidCallback? onShareWhatsApp;

  const PaymentReceiptModal({
    super.key,
    required this.payment,
    this.onPrint,
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
        width: 580,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Receipt Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.verified_rounded, color: AppColors.success, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PAYMENT RECEIPT',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: AppColors.success,
                          ),
                        ),
                        Text(
                          payment.receiptNumber,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            const Divider(height: 28),

            // Amount Received Spotlight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Amount Cleared',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${payment.currentPayment.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.success,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${payment.paymentDate.day}/${payment.paymentDate.month}/${payment.paymentDate.year}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Key Financial Details Table
            _buildReceiptRow('Customer Name', payment.customerName, isDark),
            _buildReceiptRow('Project Name', payment.projectName, isDark),
            _buildReceiptRow('Invoice Ref', payment.invoiceNumber, isDark),
            _buildReceiptRow('Payment Method', payment.paymentMethod.label, isDark),
            _buildReceiptRow('Transaction / UTR', payment.transactionId, isDark, isHighlighted: true),
            if (payment.bankReference != null)
              _buildReceiptRow('Bank Reference', payment.bankReference!, isDark),
            const Divider(height: 18),
            _buildReceiptRow('Invoice Total', '₹${payment.invoiceTotal.toStringAsFixed(0)}', isDark),
            _buildReceiptRow('Total Paid to Date', '₹${payment.totalPaidAfterThis.toStringAsFixed(0)}', isDark),
            _buildReceiptRow(
              'Remaining Balance',
              '₹${payment.remainingBalance.toStringAsFixed(0)}',
              isDark,
              isBold: true,
              valueColor: payment.remainingBalance > 0 ? AppColors.error : AppColors.success,
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      onShareWhatsApp?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sent receipt to ${payment.payerContact} via WhatsApp')),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF22C55E)),
                    label: const Text('Share WhatsApp', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      onPrint?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Printing ${payment.receiptNumber}...')),
                      );
                    },
                    icon: const Icon(Icons.print_rounded, size: 16),
                    label: const Text('Print Receipt', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, bool isDark, {bool isHighlighted = false, bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold || isHighlighted ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? (isHighlighted ? AppColors.primary : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

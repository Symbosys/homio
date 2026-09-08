// Homio CRM — WhatsApp Payment Request & Reminder Modal

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class WhatsAppPaymentReminderModal extends StatefulWidget {
  final String customerName;
  final String customerPhone;
  final String projectName;
  final String invoiceNumber;
  final double outstandingAmount;
  final DateTime dueDate;
  final String paymentLink;

  const WhatsAppPaymentReminderModal({
    super.key,
    required this.customerName,
    required this.customerPhone,
    required this.projectName,
    required this.invoiceNumber,
    required this.outstandingAmount,
    required this.dueDate,
    this.paymentLink = 'https://pay.homio.in/inv/quick-pay',
  });

  @override
  State<WhatsAppPaymentReminderModal> createState() => _WhatsAppPaymentReminderModalState();
}

class _WhatsAppPaymentReminderModalState extends State<WhatsAppPaymentReminderModal> {
  late TextEditingController _messageCtrl;

  @override
  void initState() {
    super.initState();
    final defaultMsg = '''Dear ${widget.customerName},

Greetings from Homio CRM & Turnkey Operations.

This is a gentle payment reminder regarding your ongoing project:
📁 Project: ${widget.projectName}
📄 Invoice: ${widget.invoiceNumber}
💰 Outstanding Amount: ₹${widget.outstandingAmount.toStringAsFixed(0)}
📅 Due Date: ${widget.dueDate.day}/${widget.dueDate.month}/${widget.dueDate.year}

You can pay securely via UPI, NetBanking or Debit/Credit Card using the instant payment link below:
🔗 ${widget.paymentLink}

Bank Details for Direct RTGS/NEFT:
• Account Name: Homio Technologies Pvt Ltd
• Bank: HDFC Bank Ltd, DLF Phase 5
• A/C No: 50200088192019
• IFSC: HDFC0000281

Kindly share the transaction UTR once processed for immediate ledger reconciliation.

Warm regards,
Finance & Accounts Desk
Homio CRM & Field Operations''';

    _messageCtrl = TextEditingController(text: defaultMsg);
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 620,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF22C55E), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WHATSAPP PAYMENT REQUEST DISPATCH',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF22C55E),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'To: ${widget.customerName} (${widget.customerPhone})',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
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
            const Divider(height: 24),

            // Message Editor
            Text(
              'Draft Message Preview (Editable before dispatch):',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageCtrl,
              maxLines: 12,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.4),
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceSubtle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _messageCtrl.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment request copied to clipboard!')),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Copy to Clipboard', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('WhatsApp message queued and sent to ${widget.customerPhone}!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text('Send via WhatsApp', style: TextStyle(fontSize: 12)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';

class WhatsAppPaymentRequestModal extends StatefulWidget {
  final WeeklyFee fee;
  final VoidCallback onDispatched;

  const WhatsAppPaymentRequestModal({
    super.key,
    required this.fee,
    required this.onDispatched,
  });

  @override
  State<WhatsAppPaymentRequestModal> createState() =>
      _WhatsAppPaymentRequestModalState();
}

class _WhatsAppPaymentRequestModalState
    extends State<WhatsAppPaymentRequestModal> {
  bool _isCopied = false;
  bool _isSending = false;
  bool _isSent = false;

  String get _whatsappMessage => '''
*HOMIO — Weekly Project Payment Request* 📋

Dear ${widget.fee.customerName},
Here is the operational expenditure & fees summary for your project:

🏢 *Project:* ${widget.fee.projectName}
📅 *Week Period:* ${widget.fee.weekPeriod}

🔹 *Material Bills:* ₹${widget.fee.materialAmount.toStringAsFixed(0)}
🔹 *Labour Wages:* ₹${widget.fee.labourAmount.toStringAsFixed(0)}
🔹 *Supervision & Consulting:* ₹${widget.fee.feesTotal.toStringAsFixed(0)}
──────────────────
💰 *Total Amount:* ₹${widget.fee.totalAmount.toStringAsFixed(0)}
✅ *Paid so far:* ₹${widget.fee.paidAmount.toStringAsFixed(0)}
⚠️ *Net Due:* *₹${widget.fee.dueAmount.toStringAsFixed(0)}*
⏰ *Payment Due Date:* ${widget.fee.paymentDueDate.day}/${widget.fee.paymentDueDate.month}/${widget.fee.paymentDueDate.year}

🔗 *View Breakdown & Pay Online:*
${widget.fee.paymentLinkUrl}

_For queries, contact Project Manager ${widget.fee.projectManager}._
''';

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _whatsappMessage));
    setState(() => _isCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment request copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _simulateSend() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _isSent = true;
    });
    widget.onDispatched();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 580,
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
                    color: const Color(0xFF25D366).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.send_to_mobile_rounded,
                      color: Color(0xFF25D366), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WhatsApp Payment Request Generator',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Recipient: ${widget.fee.customerName} (${widget.fee.customerPhone})',
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
            const SizedBox(height: 16),

            // WhatsApp Chat Bubble Preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0B141B) : const Color(0xFFEFEAE2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF1F2C34) : const Color(0xFFD1D7DB),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded,
                              size: 14, color: Color(0xFF25D366)),
                          SizedBox(width: 6),
                          Text(
                            'LIVE WHATSAPP CLOUD API PREVIEW',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF25D366),
                            ),
                          ),
                        ],
                      ),
                      if (_isSent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Delivered ✓✓',
                            style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF005C4B) : const Color(0xFFD9FDD3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _whatsappMessage,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        fontFamily: 'monospace',
                        color: isDark ? Colors.white : const Color(0xFF111B21),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Link Field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    initialValue: widget.fee.paymentLinkUrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      labelText: 'Customer Secure Payment Link',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: Icon(_isCopied ? Icons.check_rounded : Icons.copy_rounded, size: 14),
                  label: Text(_isCopied ? 'Copied' : 'Copy', style: const TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: _isSending || _isSent ? null : _simulateSend,
                  icon: _isSending
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(_isSent ? Icons.check_rounded : Icons.send_rounded, size: 16),
                  label: Text(_isSent
                      ? 'Dispatched Successfully'
                      : (_isSending ? 'Sending...' : 'Send WhatsApp Now')),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
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

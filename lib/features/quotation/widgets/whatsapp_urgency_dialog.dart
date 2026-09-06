import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Modal dialog showing the 24-hour urgency WhatsApp bot template preview & manual trigger action.
class WhatsAppUrgencyDialog extends StatefulWidget {
  final Quotation quotation;
  final VoidCallback onDispatched;

  const WhatsAppUrgencyDialog({
    super.key,
    required this.quotation,
    required this.onDispatched,
  });

  @override
  State<WhatsAppUrgencyDialog> createState() => _WhatsAppUrgencyDialogState();
}

class _WhatsAppUrgencyDialogState extends State<WhatsAppUrgencyDialog> {
  bool _isSending = false;
  late final TextEditingController _msgController;

  @override
  void initState() {
    super.initState();
    final discountStr = '₹${widget.quotation.discountAmount.toStringAsFixed(0)}';
    final qNum = widget.quotation.quoteNumber;
    _msgController = TextEditingController(
      text: '🚨 *URGENT 24-HOUR NOTICE: EARLY BIRD PRICING EXPIRING*\n\n'
          'Dear ${widget.quotation.clientName},\n\n'
          'Your exclusive ${widget.quotation.discountPercent.toStringAsFixed(0)}% booking discount worth *$discountStr* on *${widget.quotation.projectTitle}* (Quote: $qNum) expires in less than 24 hours!\n\n'
          '🔒 *Lock your preferential rates & priority delivery slot now:*\n'
          '👉 https://homio.design/approve/$qNum\n\n'
          'Warm regards,\n'
          '${widget.quotation.designerName}\n'
          'Homio Design Studio',
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lg,
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.15),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(Icons.chat_bubble_rounded, size: 18, color: Color(0xFF25D366)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WhatsApp 24h Urgency Dispatcher',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            'Automated Closing Urgency Bot (TC-QUOT-001)',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Message Preview Box (Simulating WhatsApp bubble)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recipient: ${widget.quotation.clientName} (${widget.quotation.clientPhone})',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '24h Urgency Trigger',
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // WhatsApp bubble preview
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F2618) : const Color(0xFFDCF8C6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF25D366).withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: TextField(
                      controller: _msgController,
                      maxLines: 8,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF25D366)),
                      const SizedBox(width: 4),
                      Text(
                        'Meta Approved Template: homio_discount_urgency_alert',
                        style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF25D366), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Dismiss'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isSending
                        ? null
                        : () {
                            setState(() => _isSending = true);
                            final navigator = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);
                            final phone = widget.quotation.clientPhone;
                            Future.delayed(const Duration(milliseconds: 600), () {
                              if (!mounted) return;
                              widget.onDispatched();
                              navigator.pop();
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('WhatsApp urgency alert dispatched to $phone'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            });
                          },
                    icon: _isSending
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded, size: 16),
                    label: Text(_isSending ? 'Dispatching...' : 'Dispatch Now via WhatsApp API'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

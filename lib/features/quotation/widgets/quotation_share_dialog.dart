import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Share & Dispatch dialog supporting WhatsApp, Email, Web Link, and PDF download.
class QuotationShareDialog extends StatefulWidget {
  final Quotation quotation;
  final VoidCallback? onDispatched;

  const QuotationShareDialog({
    super.key,
    required this.quotation,
    this.onDispatched,
  });

  @override
  State<QuotationShareDialog> createState() => _QuotationShareDialogState();
}

class _QuotationShareDialogState extends State<QuotationShareDialog> {
  late TextEditingController _waMsgCtrl;
  late TextEditingController _emailMsgCtrl;
  bool _copied = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _waMsgCtrl = TextEditingController(
      text:
          '✨ Dear ${widget.quotation.clientName}, your personalized interior quotation for ${widget.quotation.projectTitle} (Quote #${widget.quotation.quoteNumber}) has been prepared by Homio Design Studio.\n\nTotal Estimate: ₹${widget.quotation.grandTotal.toStringAsFixed(0)}\nDiscount Lock-In Valid Until: ${widget.quotation.discountExpiryDate.day}/${widget.quotation.discountExpiryDate.month}/${widget.quotation.discountExpiryDate.year}\n\nView Your Interactive Proposal Online:\nhttps://homio.in/q/${widget.quotation.quoteNumber}',
    );

    _emailMsgCtrl = TextEditingController(
      text:
          'Dear ${widget.quotation.clientName},\n\nThank you for choosing Homio. Attached please find the detailed Bill of Quantities (BOQ) and 3D specifications for ${widget.quotation.projectTitle}.\n\nPlease review your estimate and feel free to reach out to ${widget.quotation.designerName} for any adjustments.\n\nWarm regards,\nHomio Operations Team',
    );
  }

  @override
  void dispose() {
    _waMsgCtrl.dispose();
    _emailMsgCtrl.dispose();
    super.dispose();
  }

  void _simulateSend(String channel) async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isSending = false);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quotation dispatched via $channel to ${widget.quotation.clientName}'),
        backgroundColor: AppColors.success,
      ),
    );
    widget.onDispatched?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final webLink = 'https://homio.in/q/${widget.quotation.quoteNumber}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Padding(
          padding: const EdgeInsets.all(24),
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
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.share_rounded, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dispatch Proposal',
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${widget.quotation.quoteNumber} • ${widget.quotation.clientName}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Web Link Quick Copy Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                  borderRadius: AppRadius.sm,
                ),
                child: Row(
                  children: [
                    Icon(Icons.link_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        webLink,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: webLink));
                        setState(() => _copied = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _copied = false);
                        });
                      },
                      icon: Icon(_copied ? Icons.check_rounded : Icons.copy_rounded, size: 12),
                      label: Text(_copied ? 'Copied' : 'Copy Link', style: const TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // WhatsApp Preview Section
              Text(
                'WhatsApp Message Dispatch',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _waMsgCtrl,
                maxLines: 4,
                style: GoogleFonts.inter(fontSize: 11),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 18),

              // Actions Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isSending ? null : () => _simulateSend('Email'),
                      icon: const Icon(Icons.email_outlined, size: 14),
                      label: const Text('Send Email', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isSending ? null : () => _simulateSend('WhatsApp Business'),
                      icon: const Icon(Icons.send_rounded, size: 14),
                      label: Text(
                        _isSending ? 'Sending...' : 'Send WhatsApp',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

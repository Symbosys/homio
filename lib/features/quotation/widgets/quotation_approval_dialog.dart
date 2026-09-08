import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Internal commercial approval modal for discounts & high-value proposals.
class QuotationApprovalDialog extends StatefulWidget {
  final Quotation quotation;
  final ValueChanged<QuotationApproval> onApprovalResolved;

  const QuotationApprovalDialog({
    super.key,
    required this.quotation,
    required this.onApprovalResolved,
  });

  @override
  State<QuotationApprovalDialog> createState() => _QuotationApprovalDialogState();
}

class _QuotationApprovalDialogState extends State<QuotationApprovalDialog> {
  final TextEditingController _commentCtrl = TextEditingController();
  final String _approverName = 'Sameer Sen';
  final String _approverRole = 'VP of Design & Commercials';

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _resolve(ApprovalStatus status) {
    final approval = QuotationApproval(
      id: 'AP-${DateTime.now().millisecondsSinceEpoch}',
      approverName: _approverName,
      approverRole: _approverRole,
      status: status,
      comments: _commentCtrl.text.isNotEmpty ? _commentCtrl.text : 'Approved under standard review criteria.',
      requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
      respondedAt: DateTime.now(),
    );
    widget.onApprovalResolved(approval);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHighDiscount = widget.quotation.discountPercent > 10.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
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
                          color: AppColors.warning.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.rate_review_rounded, size: 18, color: AppColors.warning),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Commercial Review & Sign-Off',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quotation Summary Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 0.8,
                  ),
                ),
                child: Column(
                  children: [
                    _buildRow('Quote Number', widget.quotation.quoteNumber, isDark),
                    const SizedBox(height: 4),
                    _buildRow('Client & Project', '${widget.quotation.clientName} • ${widget.quotation.projectTitle}', isDark),
                    const SizedBox(height: 4),
                    _buildRow('Grand Total', '₹${widget.quotation.grandTotal.toStringAsFixed(0)}', isDark, isHighlight: true),
                    const SizedBox(height: 4),
                    _buildRow(
                      'Requested Discount',
                      '${widget.quotation.discountPercent.toStringAsFixed(1)}% (₹${widget.quotation.discountAmount.toStringAsFixed(0)})',
                      isDark,
                      textColor: isHighDiscount ? AppColors.error : AppColors.primary,
                    ),
                  ],
                ),
              ),
              if (isHighDiscount) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Discount exceeds the 10% standard threshold. Vice President sign-off required.',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),

              Text('Reviewer Notes / Feedback', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _commentCtrl,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Enter review feedback or approval conditions...',
                  hintStyle: GoogleFonts.inter(fontSize: 11),
                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _resolve(ApprovalStatus.rejected),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () => _resolve(ApprovalStatus.approved),
                    icon: const Icon(Icons.check_rounded, size: 14),
                    label: const Text('Approve Proposal'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
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

  Widget _buildRow(String label, String value, bool isDark, {bool isHighlight = false, Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isHighlight ? 12 : 11,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            color: textColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }
}

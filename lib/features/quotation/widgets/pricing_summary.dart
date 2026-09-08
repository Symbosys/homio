import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Sticky financial pricing summary panel for builder and detail views.
class PricingSummary extends StatelessWidget {
  final double grossSubtotal;
  final double discountAmount;
  final double discountPercent;
  final double taxableAmount;
  final double gstPercent;
  final double gstAmount;
  final double grandTotal;
  final double? amountPaid;
  final VoidCallback? onProceed;
  final String? actionLabel;

  const PricingSummary({
    super.key,
    required this.grossSubtotal,
    required this.discountAmount,
    this.discountPercent = 0.0,
    required this.taxableAmount,
    this.gstPercent = 18.0,
    required this.gstAmount,
    required this.grandTotal,
    this.amountPaid,
    this.onProceed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final balanceDue = amountPaid != null ? (grandTotal - amountPaid!).clamp(0.0, double.infinity) : grandTotal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Financial Summary',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _buildLineItem('Gross Subtotal', '₹${grossSubtotal.toStringAsFixed(0)}', isDark),
          const SizedBox(height: 6),
          if (discountAmount > 0) ...[
            _buildLineItem(
              'Early Bird Discount (${discountPercent > 0 ? '${discountPercent.toStringAsFixed(1)}%' : 'Fixed'})',
              '-₹${discountAmount.toStringAsFixed(0)}',
              isDark,
              textColor: AppColors.error,
            ),
            const SizedBox(height: 6),
          ],
          _buildLineItem('Taxable Amount', '₹${taxableAmount.toStringAsFixed(0)}', isDark),
          const SizedBox(height: 6),
          _buildLineItem('GST (${gstPercent.toStringAsFixed(0)}%)', '₹${gstAmount.toStringAsFixed(0)}', isDark),
          const Divider(height: 16),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '₹${grandTotal.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          if (amountPaid != null && amountPaid! > 0) ...[
            const SizedBox(height: 8),
            _buildLineItem('Amount Paid', '₹${amountPaid!.toStringAsFixed(0)}', isDark, textColor: AppColors.success),
            const SizedBox(height: 4),
            _buildLineItem('Balance Due', '₹${balanceDue.toStringAsFixed(0)}', isDark, isBold: true),
          ],

          if (onProceed != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onProceed,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
                child: Text(
                  actionLabel ?? 'Save & Continue',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLineItem(String label, String value, bool isDark, {Color? textColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: textColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }
}

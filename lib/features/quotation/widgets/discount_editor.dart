import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Discount and urgency lock-in configuration editor.
class DiscountEditor extends StatefulWidget {
  final double grossSubtotal;
  final DiscountType discountType;
  final double discountPercent;
  final double fixedDiscountAmount;
  final DateTime discountExpiryDate;
  final void Function({
    required DiscountType type,
    required double percent,
    required double fixedAmount,
    required DateTime expiryDate,
  }) onDiscountChanged;

  const DiscountEditor({
    super.key,
    required this.grossSubtotal,
    required this.discountType,
    required this.discountPercent,
    required this.fixedDiscountAmount,
    required this.discountExpiryDate,
    required this.onDiscountChanged,
  });

  @override
  State<DiscountEditor> createState() => _DiscountEditorState();
}

class _DiscountEditorState extends State<DiscountEditor> {
  late DiscountType _type;
  late TextEditingController _valCtrl;
  late DateTime _expiry;
  String _reason = 'Early Bird Booking Waiver';

  static const List<String> discountReasons = [
    'Early Bird Booking Waiver',
    'Festive Launch Promotion',
    'Architect / Channel Partner Referral',
    'Volume Commitment (Full Home)',
    'Management Goodwill Discretion',
  ];

  @override
  void initState() {
    super.initState();
    _type = widget.discountType;
    _valCtrl = TextEditingController(
      text: _type == DiscountType.percentage
          ? (widget.discountPercent > 0 ? widget.discountPercent.toString() : '0')
          : (widget.fixedDiscountAmount > 0 ? widget.fixedDiscountAmount.toString() : '0'),
    );
    _expiry = widget.discountExpiryDate;
  }

  @override
  void dispose() {
    _valCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    final v = double.tryParse(_valCtrl.text) ?? 0.0;
    widget.onDiscountChanged(
      type: _type,
      percent: _type == DiscountType.percentage ? v : 0.0,
      fixedAmount: _type == DiscountType.fixedAmount ? v : 0.0,
      expiryDate: _expiry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final val = double.tryParse(_valCtrl.text) ?? 0.0;
    final calculatedDiscount = _type == DiscountType.percentage
        ? widget.grossSubtotal * (val / 100.0)
        : val;
    final finalAmount = (widget.grossSubtotal - calculatedDiscount).clamp(0.0, double.infinity);

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
              Icon(Icons.percent_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Discount & Urgency Pricing Lock-in',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Segmented Button for Type
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<DiscountType>(
              segments: const [
                ButtonSegment<DiscountType>(
                  value: DiscountType.percentage,
                  label: Text('Percentage (%)'),
                  icon: Icon(Icons.percent_rounded, size: 16),
                ),
                ButtonSegment<DiscountType>(
                  value: DiscountType.fixedAmount,
                  label: Text('Flat Amount (₹)'),
                  icon: Icon(Icons.currency_rupee_rounded, size: 16),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _type = newSelection.first;
                  _valCtrl.text = _type == DiscountType.percentage ? '5.0' : '50000';
                });
                _notify();
              },
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _valCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) {
                    setState(() {});
                    _notify();
                  },
                  decoration: InputDecoration(
                    labelText: _type == DiscountType.percentage ? 'Discount %' : 'Discount Amount (₹)',
                    labelStyle: GoogleFonts.inter(fontSize: 12),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  initialValue: _reason,
                  decoration: InputDecoration(
                    labelText: 'Commercial Reason',
                    labelStyle: GoogleFonts.inter(fontSize: 12),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                  items: discountReasons
                      .map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _reason = v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Expiry Date Selection
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              const SizedBox(width: 8),
              Text(
                'Price-Lock Validity Expiry:',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _expiry,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) {
                    setState(() => _expiry = picked);
                    _notify();
                  }
                },
                icon: const Icon(Icons.edit_calendar_rounded, size: 13),
                label: Text(
                  '${_expiry.day}/${_expiry.month}/${_expiry.year}',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Summary callout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.06),
              borderRadius: AppRadius.sm,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gross BOQ: ₹${widget.grossSubtotal.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    Text(
                      'Client Discount: -₹${calculatedDiscount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Revised Net Taxable:',
                      style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    Text(
                      '₹${finalAmount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

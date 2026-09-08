import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Payment milestone schedule editor with 100% percentage validation.
class PaymentScheduleEditor extends StatefulWidget {
  final double totalPayableAmount;
  final List<PaymentMilestone> initialSchedule;
  final ValueChanged<List<PaymentMilestone>> onScheduleChanged;

  const PaymentScheduleEditor({
    super.key,
    required this.totalPayableAmount,
    required this.initialSchedule,
    required this.onScheduleChanged,
  });

  @override
  State<PaymentScheduleEditor> createState() => _PaymentScheduleEditorState();
}

class _PaymentScheduleEditorState extends State<PaymentScheduleEditor> {
  late List<PaymentMilestone> _milestones;

  @override
  void initState() {
    super.initState();
    _milestones = widget.initialSchedule.isNotEmpty
        ? List.from(widget.initialSchedule)
        : _getDefaultSchedule(widget.totalPayableAmount);
  }

  List<PaymentMilestone> _getDefaultSchedule(double total) {
    return [
      PaymentMilestone(
        id: 'PM-01',
        title: 'Booking Advance',
        percentage: 10.0,
        amount: total * 0.10,
        triggerEvent: 'On signing of estimate',
      ),
      PaymentMilestone(
        id: 'PM-02',
        title: 'Factory Production Kickoff',
        percentage: 40.0,
        amount: total * 0.40,
        triggerEvent: 'After 2D/3D design approval and site civil clearance',
      ),
      PaymentMilestone(
        id: 'PM-03',
        title: 'Material Dispatch to Site',
        percentage: 40.0,
        amount: total * 0.40,
        triggerEvent: 'On dispatch of finished woodwork from factory',
      ),
      PaymentMilestone(
        id: 'PM-04',
        title: 'Final Handover & Snag Close',
        percentage: 10.0,
        amount: total * 0.10,
        triggerEvent: 'Post snag rectification and virtual signoff',
      ),
    ];
  }

  void _applyPreset(List<double> percentages, List<String> titles, List<String> triggers) {
    setState(() {
      _milestones = List.generate(percentages.length, (i) {
        return PaymentMilestone(
          id: 'PM-${DateTime.now().millisecondsSinceEpoch}-$i',
          title: titles[i],
          percentage: percentages[i],
          amount: widget.totalPayableAmount * (percentages[i] / 100.0),
          triggerEvent: triggers[i],
        );
      });
    });
    widget.onScheduleChanged(_milestones);
  }

  void _recalcAmounts() {
    setState(() {
      _milestones = _milestones.map((m) {
        return m.copyWith(amount: widget.totalPayableAmount * (m.percentage / 100.0));
      }).toList();
    });
    widget.onScheduleChanged(_milestones);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalPercent = _milestones.fold(0.0, (sum, m) => sum + m.percentage);
    final isValid = (totalPercent - 100.0).abs() < 0.01;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.payments_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Payment Milestone Schedule',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              // Preset chips
              Wrap(
                spacing: 6,
                children: [
                  _buildPresetButton('10-40-40-10', () {
                    _applyPreset(
                      [10.0, 40.0, 40.0, 10.0],
                      ['Advance', 'Production', 'Dispatch', 'Handover'],
                      ['Booking signoff', 'Factory start', 'Site dispatch', 'Snag close'],
                    );
                  }, isDark),
                  _buildPresetButton('20-30-30-20', () {
                    _applyPreset(
                      [20.0, 30.0, 30.0, 20.0],
                      ['Advance', 'Carcass', 'Finishing', 'Handover'],
                      ['Agreement', 'Carcass frame', 'Shutters & Polish', 'Final handover'],
                    );
                  }, isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Total validation banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isValid
                  ? AppColors.success.withValues(alpha: isDark ? 0.15 : 0.08)
                  : AppColors.error.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isValid ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                      size: 14,
                      color: isValid ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isValid
                          ? 'Total allocation equals exactly 100%'
                          : 'Allocation is ${totalPercent.toStringAsFixed(1)}% (Must equal 100%)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isValid ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Total: ₹${widget.totalPayableAmount.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Milestones list
          ..._milestones.asMap().entries.map((entry) {
            final idx = entry.key;
            final m = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
                borderRadius: AppRadius.sm,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Text(
                      '${idx + 1}',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.title,
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          m.triggerEvent,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: TextFormField(
                      initialValue: m.percentage.toStringAsFixed(0),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                      decoration: InputDecoration(
                        suffixText: '%',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        border: OutlineInputBorder(borderRadius: AppRadius.sm),
                      ),
                      onChanged: (val) {
                        final p = double.tryParse(val) ?? 0.0;
                        setState(() {
                          _milestones[idx] = m.copyWith(
                            percentage: p,
                            amount: widget.totalPayableAmount * (p / 100.0),
                          );
                        });
                        widget.onScheduleChanged(_milestones);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Text(
                      '₹${m.amount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (_milestones.length > 2)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded, size: 16, color: AppColors.error),
                      onPressed: () {
                        setState(() {
                          _milestones.removeAt(idx);
                        });
                        _recalcAmounts();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            );
          }),

          const SizedBox(height: 6),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _milestones.add(
                  PaymentMilestone(
                    id: 'PM-${DateTime.now().millisecondsSinceEpoch}',
                    title: 'New Milestone',
                    percentage: 10.0,
                    amount: widget.totalPayableAmount * 0.10,
                    triggerEvent: 'Stage completion',
                  ),
                );
              });
              _recalcAmounts();
            },
            icon: const Icon(Icons.add_rounded, size: 14),
            label: Text('Add Milestone Stage', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(String label, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.sm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.5),
          borderRadius: AppRadius.sm,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

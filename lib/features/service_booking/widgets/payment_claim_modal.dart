import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class PaymentClaimModal extends StatefulWidget {
  final ServiceBooking booking;
  final Function(PaymentClaim claim) onClaimSubmitted;

  const PaymentClaimModal({
    super.key,
    required this.booking,
    required this.onClaimSubmitted,
  });

  @override
  State<PaymentClaimModal> createState() => _PaymentClaimModalState();
}

class _PaymentClaimModalState extends State<PaymentClaimModal> {
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _workSummaryCtrl = TextEditingController();
  String _billingPeriod = 'Milestone Completion';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _amountCtrl.text = widget.booking.balanceDue.toInt().toString();
    _workSummaryCtrl.text = 'Completed ${widget.booking.workTitle} with 100% daily checklist items signed by supervisor.';
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _workSummaryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.request_quote_rounded, color: Color(0xFF10B981), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SUBMIT LABOUR PAYMENT CLAIM',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.booking.bookingNumber} • ${widget.booking.tradesmanName}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Financial Ledger Breakdown
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _buildRow('Total Deal Value:', '₹${widget.booking.dealValue.toInt()}', textPrimaryColor, textSecondaryColor),
                    const SizedBox(height: 6),
                    _buildRow('Advance Paid:', '₹${widget.booking.advancePaid.toInt()}', const Color(0xFF10B981), textSecondaryColor),
                    const SizedBox(height: 6),
                    _buildRow('Platform Commission (10%):', '₹${widget.booking.platformCommission.toInt()}', textSecondaryColor, textSecondaryColor),
                    const Divider(height: 16),
                    _buildRow('Balance Dues Claimable:', '₹${widget.booking.balanceDue.toInt()}', const Color(0xFF3B82F6), textSecondaryColor, isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Billing Period Dropdown
              Text('Billing Period / Milestone *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _billingPeriod,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: backgroundColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: const [
                  DropdownMenuItem(value: 'Milestone Completion', child: Text('Milestone Completion (Full Balance)')),
                  DropdownMenuItem(value: 'Weekly Shift Settlement', child: Text('Weekly Shift Settlement (Partial)')),
                  DropdownMenuItem(value: 'Overtime & Emergency Callout', child: Text('Overtime & Emergency Callout')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _billingPeriod = val);
                },
              ),
              const SizedBox(height: 14),

              // Amount Claimed
              Text('Amount Claimed (₹) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: backgroundColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 14),

              // Work Completed Summary
              Text('Work Completed Summary *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
              const SizedBox(height: 6),
              TextField(
                controller: _workSummaryCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Brief summary of milestones delivered...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: backgroundColor,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Action
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          final nav = Navigator.of(context);
                          setState(() => _isSubmitting = true);
                          Future.delayed(const Duration(milliseconds: 400), () {
                            final claim = PaymentClaim(
                              id: 'CLM-${DateTime.now().millisecondsSinceEpoch}',
                              bookingId: widget.booking.id,
                              bookingNumber: widget.booking.bookingNumber,
                              workerId: widget.booking.tradesmanId,
                              workerName: widget.booking.tradesmanName,
                              workSummary: _workSummaryCtrl.text.trim(),
                              billingPeriod: _billingPeriod,
                              amountClaimed: double.tryParse(_amountCtrl.text.trim()) ?? widget.booking.balanceDue,
                              status: 'Submitted',
                              submittedDate: DateTime.now(),
                              supervisorConfirmation: 'Awaiting Supervisor Approval',
                            );
                            widget.onClaimSubmitted(claim);
                            nav.pop();
                          });
                        },
                  icon: _isSubmitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(_isSubmitting ? 'TRANSMITTING CLAIM...' : 'SUBMIT PAYMENT CLAIM'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color textColor, Color labelColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: labelColor)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.w800 : FontWeight.w700, color: textColor)),
      ],
    );
  }
}

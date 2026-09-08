// Homio CRM — Client Promise to Pay Recording Modal

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';

class PromiseToPayModal extends StatefulWidget {
  final String customerName;
  final String projectName;
  final String invoiceNumber;
  final double defaultAmount;
  final String customerContact;
  final ValueChanged<PromiseToPay>? onSaved;

  const PromiseToPayModal({
    super.key,
    required this.customerName,
    required this.projectName,
    required this.invoiceNumber,
    required this.defaultAmount,
    required this.customerContact,
    this.onSaved,
  });

  @override
  State<PromiseToPayModal> createState() => _PromiseToPayModalState();
}

class _PromiseToPayModalState extends State<PromiseToPayModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _ownerCtrl;
  DateTime _promiseDate = DateTime.now().add(const Duration(days: 3));
  DateTime _followUpDate = DateTime.now().add(const Duration(days: 4));

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(text: widget.defaultAmount.toStringAsFixed(0));
    _notesCtrl = TextEditingController(text: 'Client confirmed payment post banking hours via RTGS.');
    _ownerCtrl = TextEditingController(text: 'Kavita Roy (Finance Lead)');
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    _ownerCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final promise = PromiseToPay(
        id: 'PTP-${DateTime.now().millisecondsSinceEpoch}',
        customerName: widget.customerName,
        projectName: widget.projectName,
        invoiceNumber: widget.invoiceNumber,
        promiseDate: _promiseDate,
        promisedAmount: double.tryParse(_amountCtrl.text) ?? widget.defaultAmount,
        customerContact: widget.customerContact,
        collectionOwner: _ownerCtrl.text,
        followUpDate: _followUpDate,
        notes: _notesCtrl.text,
        status: PromiseToPayStatus.promised,
      );
      widget.onSaved?.call(promise);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 540,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: _formKey,
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
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.handshake_outlined, color: AppColors.warning, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RECORD PROMISE TO PAY',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            widget.customerName,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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

              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Promised Amount (₹) *',
                  prefixText: '₹ ',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter amount' : null,
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _promiseDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );
                        if (picked != null) setState(() => _promiseDate = picked);
                      },
                      icon: const Icon(Icons.calendar_today_rounded, size: 14),
                      label: Text('Promised: ${_promiseDate.day}/${_promiseDate.month}/${_promiseDate.year}', style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _followUpDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );
                        if (picked != null) setState(() => _followUpDate = picked);
                      },
                      icon: const Icon(Icons.alarm_rounded, size: 14),
                      label: Text('Followup: ${_followUpDate.day}/${_followUpDate.month}/${_followUpDate.year}', style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _ownerCtrl,
                decoration: const InputDecoration(
                  labelText: 'Collection Owner / Rep *',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Client Call Notes & Commitment Context',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: const Text('Save Commitment'),
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

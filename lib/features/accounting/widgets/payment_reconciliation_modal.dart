// Homio CRM — Bank Payment Reconciliation Modal

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';

class PaymentReconciliationModal extends StatefulWidget {
  final List<ReconciliationItem> items;
  final ValueChanged<ReconciliationItem>? onReconciled;

  const PaymentReconciliationModal({
    super.key,
    required this.items,
    this.onReconciled,
  });

  @override
  State<PaymentReconciliationModal> createState() => _PaymentReconciliationModalState();
}

class _PaymentReconciliationModalState extends State<PaymentReconciliationModal> {
  late List<ReconciliationItem> _list;

  @override
  void initState() {
    super.initState();
    _list = List.from(widget.items);
  }

  void _markReconciled(ReconciliationItem item) {
    setState(() {
      final idx = _list.indexWhere((i) => i.id == item.id);
      if (idx != -1) {
        final updated = ReconciliationItem(
          id: item.id,
          systemPaymentRef: item.systemPaymentRef,
          bankUtrRef: item.bankUtrRef,
          paymentDate: item.paymentDate,
          amount: item.amount,
          customerName: item.customerName,
          bankAccount: item.bankAccount,
          isReconciled: true,
          reconciledAt: DateTime.now(),
        );
        _list[idx] = updated;
        widget.onReconciled?.call(updated);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment ${item.systemPaymentRef} reconciled against UTR ${item.bankUtrRef}!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 840,
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
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.sync_alt_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BANK STATEMENT RECONCILIATION WORKSPACE',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Match CRM transactions with Bank UTR credits',
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

            // Items List
            SizedBox(
              height: 380,
              child: ListView.separated(
                itemCount: _list.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _list[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      children: [
                        Icon(
                          item.isReconciled ? Icons.check_circle_rounded : Icons.pending_rounded,
                          color: item.isReconciled ? AppColors.success : AppColors.warning,
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.customerName,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                              Text(
                                'CRM Ref: ${item.systemPaymentRef} • Bank UTR: ${item.bankUtrRef}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                                ),
                              ),
                              Text(
                                'Account: ${item.bankAccount}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${item.amount.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                              Text(
                                '${item.paymentDate.day}/${item.paymentDate.month}/${item.paymentDate.year}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        if (item.isReconciled)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Reconciled',
                              style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                          )
                        else
                          FilledButton.tonal(
                            onPressed: () => _markReconciled(item),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            child: const Text('Match & Clear', style: TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

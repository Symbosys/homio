// Homio CRM — Unified Financial Status Badge

import 'package:flutter/material.dart';
import '../models/accounting_models.dart';

class FinancialStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const FinancialStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  factory FinancialStatusBadge.fromInvoice(InvoiceStatus status) {
    IconData ic = Icons.circle;
    switch (status) {
      case InvoiceStatus.draft:
        ic = Icons.edit_note_rounded;
        break;
      case InvoiceStatus.issued:
        ic = Icons.send_rounded;
        break;
      case InvoiceStatus.partiallyPaid:
        ic = Icons.pie_chart_outline_rounded;
        break;
      case InvoiceStatus.paid:
        ic = Icons.check_circle_rounded;
        break;
      case InvoiceStatus.overdue:
        ic = Icons.warning_amber_rounded;
        break;
      case InvoiceStatus.cancelled:
        ic = Icons.cancel_outlined;
        break;
    }
    return FinancialStatusBadge(label: status.label, color: status.color, icon: ic);
  }

  factory FinancialStatusBadge.fromPayment(PaymentStatus status) {
    return FinancialStatusBadge(label: status.label, color: status.color, icon: Icons.payment_rounded);
  }

  factory FinancialStatusBadge.fromExpense(ExpenseStatus status) {
    return FinancialStatusBadge(label: status.label, color: status.color, icon: Icons.receipt_rounded);
  }

  factory FinancialStatusBadge.fromVendorPayment(VendorPaymentStatus status) {
    return FinancialStatusBadge(label: status.label, color: status.color, icon: Icons.store_mall_directory_rounded);
  }

  factory FinancialStatusBadge.fromLabourPayment(LabourPaymentStatus status) {
    return FinancialStatusBadge(label: status.label, color: status.color, icon: Icons.engineering_rounded);
  }

  factory FinancialStatusBadge.fromCommission(CommissionStatus status) {
    return FinancialStatusBadge(label: status.label, color: status.color, icon: Icons.monetization_on_outlined);
  }

  factory FinancialStatusBadge.fromRisk(CollectionRisk risk) {
    return FinancialStatusBadge(label: risk.label, color: risk.color, icon: Icons.shield_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

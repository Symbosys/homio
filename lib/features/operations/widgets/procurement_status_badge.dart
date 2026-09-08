import 'package:flutter/material.dart';
import '../models/operations_models.dart';

class ProcurementStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool isFilled;

  const ProcurementStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.isFilled = false,
  });

  factory ProcurementStatusBadge.materialRequest(MaterialRequestStatus status) {
    return ProcurementStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
    );
  }

  factory ProcurementStatusBadge.vendorRfq(VendorRfqStatus status) {
    return ProcurementStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
    );
  }

  factory ProcurementStatusBadge.vendorQuotation(VendorQuotationStatus status) {
    return ProcurementStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
    );
  }

  factory ProcurementStatusBadge.purchaseOrder(PurchaseOrderStatus status) {
    return ProcurementStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
    );
  }

  factory ProcurementStatusBadge.dispatch(MaterialDispatchStatus status) {
    return ProcurementStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
    );
  }

  factory ProcurementStatusBadge.designPayment(DesignPaymentStatus status) {
    return ProcurementStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
    );
  }

  factory ProcurementStatusBadge.weeklyFee(WeeklyFeeStatus status) {
    return ProcurementStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
    );
  }

  factory ProcurementStatusBadge.itemCondition(MaterialItemCondition condition) {
    return ProcurementStatusBadge(
      label: condition.label,
      color: condition.color,
      isFilled: true,
    );
  }

  factory ProcurementStatusBadge.priority(RequestPriority priority) {
    return ProcurementStatusBadge(
      label: priority.label,
      color: priority.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isFilled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.18)
            : color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 0.9,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

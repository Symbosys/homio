import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_enums.dart';

class MarketplaceStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool isSmall;

  const MarketplaceStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.isSmall = false,
  });

  factory MarketplaceStatusBadge.publication(ProductPublicationStatus status, {bool isSmall = false}) {
    return MarketplaceStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
      isSmall: isSmall,
    );
  }

  factory MarketplaceStatusBadge.verification(PropertyVerificationStatus status, {bool isSmall = false}) {
    return MarketplaceStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
      isSmall: isSmall,
    );
  }

  factory MarketplaceStatusBadge.listing(ListingStatus status, {bool isSmall = false}) {
    return MarketplaceStatusBadge(
      label: status.label,
      color: status.color,
      isSmall: isSmall,
    );
  }

  factory MarketplaceStatusBadge.order(OrderStatus status, {bool isSmall = false}) {
    return MarketplaceStatusBadge(
      label: status.label,
      color: status.color,
      icon: status.icon,
      isSmall: isSmall,
    );
  }

  factory MarketplaceStatusBadge.payment(PaymentStatus status, {bool isSmall = false}) {
    return MarketplaceStatusBadge(
      label: status.label,
      color: status.color,
      isSmall: isSmall,
    );
  }

  factory MarketplaceStatusBadge.delivery(DeliveryStatus status, {bool isSmall = false}) {
    return MarketplaceStatusBadge(
      label: status.label,
      color: status.color,
      isSmall: isSmall,
    );
  }

  factory MarketplaceStatusBadge.orderType(OrderType type, {bool isSmall = false}) {
    return MarketplaceStatusBadge(
      label: type.label,
      color: type.color,
      icon: type.icon,
      isSmall: isSmall,
    );
  }

  factory MarketplaceStatusBadge.review(ReviewStatus status, {bool isSmall = false}) {
    return MarketplaceStatusBadge(
      label: status.label,
      color: status.color,
      isSmall: isSmall,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 6 : 8,
        vertical: isSmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 10 : 12, color: color),
            const SizedBox(width: 4),
          ] else ...[
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isSmall ? 10 : 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

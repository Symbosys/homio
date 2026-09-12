import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/marketplace_enums.dart';

/// Interactive vertical/horizontal timeline tracking order shipment lifecycle
class OrderStatusTimeline extends StatelessWidget {
  final MarketplaceOrderStatus currentStatus;

  const OrderStatusTimeline({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (MarketplaceOrderStatus.placed, 'Order Placed', 'Payment verified'),
      (MarketplaceOrderStatus.confirmed, 'Confirmed', 'Warehouse notified'),
      (MarketplaceOrderStatus.processing, 'Packing', 'Quality inspection'),
      (MarketplaceOrderStatus.dispatched, 'Dispatched', 'In transit with courier'),
      (MarketplaceOrderStatus.delivered, 'Delivered', 'Signed & received'),
    ];

    final currentIndex = steps.indexWhere((s) => s.$1 == currentStatus);
    final activeIndex = currentIndex == -1 ? 0 : currentIndex;

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isPassed = index <= activeIndex;
        final isCurrent = index == activeIndex;
        final isLast = index == steps.length - 1;

        final stepColor = isCurrent
            ? const Color(0xFF10B981)
            : (isPassed ? const Color(0xFF10B981).withValues(alpha: 0.7) : Colors.grey.withValues(alpha: 0.4));

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicator and connecting line
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isPassed ? stepColor : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: stepColor, width: 2),
                  ),
                  child: Center(
                    child: isPassed
                        ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 32,
                    color: index < activeIndex ? const Color(0xFF10B981) : Colors.grey.withValues(alpha: 0.3),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Step Label & Subtitle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.$2,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                        color: isCurrent ? const Color(0xFF10B981) : (isPassed ? null : Colors.grey),
                      ),
                    ),
                    Text(
                      step.$3,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    if (!isLast) const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

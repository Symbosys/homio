import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/order_models.dart';
import '../../widgets/marketplace_bottom_sheet.dart';
import '../../widgets/spec_row.dart';
import 'order_status_timeline.dart';

/// Modal sheet displaying complete order tracking, invoice and item breakdown
class OrderDetailSheet extends StatelessWidget {
  final MarketplaceOrder order;

  const OrderDetailSheet({super.key, required this.order});

  static void show(BuildContext context, MarketplaceOrder order) {
    MarketplaceBottomSheet.show(
      context: context,
      title: 'Order #${order.orderNumber}',
      subtitle: 'Placed on ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
      headerTag: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: order.status.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          order.status.label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: order.status.color,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: OrderDetailSheet(order: order),
      bottomBar: _OrderBottomBar(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Tracking Status Timeline Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipment Progress',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              OrderStatusTimeline(currentStatus: order.status),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Items in this order
        Text(
          'Items in this Order (${order.items.length})',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        for (final item in order.items)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: border,
                      child: const Icon(Icons.broken_image_rounded, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      if (item.variantDescription != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.variantDescription!,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textMuted),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${item.quantity} × ${item.formattedUnitPrice}',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textMuted),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.formattedSubtotal,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),

        // Shipping & Carrier Details
        Text(
          'Fulfillment & Courier Logistics',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        SpecRow(label: 'Carrier Partner', value: order.trackingCarrier ?? 'HOMIO Logistics', icon: Icons.local_shipping_outlined),
        SpecRow(label: 'Tracking AWB', value: order.trackingNumber ?? 'Pending Assignment', icon: Icons.qr_code_2_rounded),
        SpecRow(label: 'Delivery Site Address', value: order.deliveryAddress, icon: Icons.place_outlined),
        SpecRow(label: 'Payment Transaction', value: order.paymentTransactionId, icon: Icons.receipt_outlined),

        const SizedBox(height: 20),

        // Financial Invoice Breakdown
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildBillRow('Items Subtotal', order.formattedSubtotal, textMuted),
              const SizedBox(height: 6),
              _buildBillRow('GST Tax', order.formattedTaxGst, textMuted),
              const SizedBox(height: 6),
              _buildBillRow('Freight / Delivery', order.formattedShipping, textMuted),
              const Divider(height: 16),
              _buildBillRow('Total Paid', order.formattedGrandTotal, textPrimary, isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillRow(String label, String value, Color textColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: textColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class _OrderBottomBar extends StatelessWidget {
  final MarketplaceOrder order;

  const _OrderBottomBar({required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF10B981),
                  content: Text('Downloading official GST Tax Invoice for ${order.orderNumber}...'),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 16),
            label: Text(
              'Tax GST Invoice',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF3B82F6),
                content: Text('Tracking ${order.trackingCarrier} AWB: ${order.trackingNumber}...'),
              ),
            );
          },
          icon: const Icon(Icons.my_location_rounded, size: 16),
          label: Text(
            'Live Courier Tracking',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

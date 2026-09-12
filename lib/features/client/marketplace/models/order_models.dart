import 'marketplace_enums.dart';

/// Single item inside an order
class MarketplaceOrderItem {
  final String id;
  final String productId;
  final String productTitle;
  final MarketplaceCategory category;
  final double unitPrice;
  final int quantity;
  final double subtotal;
  final String imageUrl;
  final String? variantDescription;

  const MarketplaceOrderItem({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.category,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    required this.imageUrl,
    this.variantDescription,
  });

  String get formattedUnitPrice => '₹${unitPrice.toStringAsFixed(0)}';
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(0)}';
}

/// Unified order document for physical items, digital assets & materials
class MarketplaceOrder {
  final String id;
  final String orderNumber;
  final DateTime createdAt;
  final MarketplaceOrderStatus status;
  final List<MarketplaceOrderItem> items;
  final double subtotal;
  final double taxGst;
  final double shippingCost;
  final double discountAmount;
  final double grandTotal;
  final String deliveryAddress;
  final String? trackingNumber;
  final String? trackingCarrier;
  final DateTime? estimatedDeliveryDate;
  final String? invoiceUrl;
  final String paymentMethod;
  final String paymentTransactionId;

  const MarketplaceOrder({
    required this.id,
    required this.orderNumber,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.taxGst,
    this.shippingCost = 0.0,
    this.discountAmount = 0.0,
    required this.grandTotal,
    required this.deliveryAddress,
    this.trackingNumber,
    this.trackingCarrier,
    this.estimatedDeliveryDate,
    this.invoiceUrl,
    required this.paymentMethod,
    required this.paymentTransactionId,
  });

  String get formattedGrandTotal => '₹${grandTotal.toStringAsFixed(0)}';
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(0)}';
  String get formattedTaxGst => '₹${taxGst.toStringAsFixed(0)}';
  String get formattedShipping => shippingCost == 0 ? 'FREE' : '₹${shippingCost.toStringAsFixed(0)}';
}

/// Labour & on-demand service appointment record
class LabourBookingRecord {
  final String id;
  final String bookingNumber;
  final String workerId;
  final String workerName;
  final String workerPhoto;
  final LabourTradeCategory trade;
  final String serviceTitle;
  final DateTime scheduledDate;
  final String timeSlot;
  final BookingStatus status;
  final double totalAmount;
  final String siteAddress;
  final String? specialInstructions;
  final DateTime createdAt;

  const LabourBookingRecord({
    required this.id,
    required this.bookingNumber,
    required this.workerId,
    required this.workerName,
    required this.workerPhoto,
    required this.trade,
    required this.serviceTitle,
    required this.scheduledDate,
    required this.timeSlot,
    required this.status,
    required this.totalAmount,
    required this.siteAddress,
    this.specialInstructions,
    required this.createdAt,
  });

  String get formattedTotal => '₹${totalAmount.toStringAsFixed(0)}';
}

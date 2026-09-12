import 'package:flutter/foundation.dart';
import '../models/marketplace_enums.dart';
import '../models/order_models.dart';
import '../models/marketplace_mock_data.dart';
import 'cart_service.dart';

/// Service managing customer transactions, orders and appointments
class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal() {
    _orders = List.from(MarketplaceMockData.orders);
    _labourBookings = List.from(MarketplaceMockData.labourBookings);
  }

  late List<MarketplaceOrder> _orders;
  late List<LabourBookingRecord> _labourBookings;

  List<MarketplaceOrder> get orders => List.unmodifiable(_orders);
  List<LabourBookingRecord> get labourBookings => List.unmodifiable(_labourBookings);

  MarketplaceOrder placeOrderFromCart({
    required CartService cart,
    required String deliveryAddress,
    required String paymentMethod,
  }) {
    final orderId = 'ord-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final orderNumber = 'HOM-2026-${DateTime.now().millisecondsSinceEpoch % 10000}';

    final orderItems = cart.items
        .map((c) => MarketplaceOrderItem(
              id: 'item-${DateTime.now().millisecondsSinceEpoch % 1000}-${c.productId}',
              productId: c.productId,
              productTitle: c.title,
              category: c.category,
              unitPrice: c.unitPrice,
              quantity: c.quantity,
              subtotal: c.subtotal,
              imageUrl: c.imageUrl,
              variantDescription: c.variant,
            ))
        .toList();

    final newOrder = MarketplaceOrder(
      id: orderId,
      orderNumber: orderNumber,
      createdAt: DateTime.now(),
      status: MarketplaceOrderStatus.placed,
      items: orderItems,
      subtotal: cart.subtotal,
      taxGst: cart.gstTax,
      shippingCost: cart.shippingFee,
      discountAmount: 0.0,
      grandTotal: cart.grandTotal,
      deliveryAddress: deliveryAddress,
      trackingNumber: 'HOM-EXP-${DateTime.now().millisecondsSinceEpoch % 100000}',
      trackingCarrier: 'HOMIO Express Surface',
      estimatedDeliveryDate: DateTime.now().add(const Duration(days: 4)),
      invoiceUrl: 'https://homio.in/invoices/$orderNumber.pdf',
      paymentMethod: paymentMethod,
      paymentTransactionId: 'TXN-HOM-${DateTime.now().millisecondsSinceEpoch}',
    );

    _orders.insert(0, newOrder);
    cart.clearCart();
    notifyListeners();
    return newOrder;
  }

  LabourBookingRecord bookLabourService({
    required String workerId,
    required String workerName,
    required String workerPhoto,
    required LabourTradeCategory trade,
    required String serviceTitle,
    required DateTime scheduledDate,
    required String timeSlot,
    required double totalAmount,
    required String siteAddress,
    String? specialInstructions,
  }) {
    final bookingNumber = 'HOM-SRV-${DateTime.now().millisecondsSinceEpoch % 10000}';
    final newBooking = LabourBookingRecord(
      id: 'lbk-${DateTime.now().millisecondsSinceEpoch % 100000}',
      bookingNumber: bookingNumber,
      workerId: workerId,
      workerName: workerName,
      workerPhoto: workerPhoto,
      trade: trade,
      serviceTitle: serviceTitle,
      scheduledDate: scheduledDate,
      timeSlot: timeSlot,
      status: BookingStatus.requested,
      totalAmount: totalAmount,
      siteAddress: siteAddress,
      specialInstructions: specialInstructions,
      createdAt: DateTime.now(),
    );

    _labourBookings.insert(0, newBooking);
    notifyListeners();
    return newBooking;
  }
}

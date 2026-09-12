import 'package:flutter/foundation.dart';
import '../models/marketplace_enums.dart';

/// Item stored in client shopping cart
class CartItem {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double unitPrice;
  final MarketplaceCategory category;
  final String? variant;
  int quantity;
  final MaterialUnit? unit;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPrice,
    required this.category,
    this.variant,
    this.quantity = 1,
    this.unit,
  });

  double get subtotal => unitPrice * quantity;
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(0)}';
  String get formattedUnitPrice => '₹${unitPrice.toStringAsFixed(0)}${unit != null ? ' / ${unit!.symbol}' : ''}';
}

/// Global client shopping cart service
class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get itemCount => _items.values.fold(0, (sum, i) => sum + i.quantity);
  bool get isEmpty => _items.isEmpty;

  double get subtotal => _items.values.fold(0.0, (sum, i) => sum + i.subtotal);
  double get gstTax => subtotal * 0.18;
  double get shippingFee => subtotal > 5000 || _isOnlyDigital ? 0.0 : 250.0;
  double get grandTotal => subtotal + gstTax + shippingFee;

  bool get _isOnlyDigital =>
      _items.isNotEmpty && _items.values.every((i) => i.category == MarketplaceCategory.digitalProducts);

  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(0)}';
  String get formattedGstTax => '₹${gstTax.toStringAsFixed(0)}';
  String get formattedShipping => shippingFee == 0.0 ? 'FREE' : '₹${shippingFee.toStringAsFixed(0)}';
  String get formattedGrandTotal => '₹${grandTotal.toStringAsFixed(0)}';

  void addItem({
    required String productId,
    required String title,
    required String imageUrl,
    required double unitPrice,
    required MarketplaceCategory category,
    String? variant,
    int quantity = 1,
    MaterialUnit? unit,
  }) {
    final key = '$productId-${variant ?? 'std'}';
    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = CartItem(
        id: key,
        productId: productId,
        title: title,
        imageUrl: imageUrl,
        unitPrice: unitPrice,
        category: category,
        variant: variant,
        quantity: quantity,
        unit: unit,
      );
    }
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    if (!_items.containsKey(cartItemId)) return;
    if (newQuantity <= 0) {
      _items.remove(cartItemId);
    } else {
      _items[cartItemId]!.quantity = newQuantity;
    }
    notifyListeners();
  }

  void removeItem(String cartItemId) {
    if (_items.remove(cartItemId) != null) {
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

import 'marketplace_enums.dart';

/// Curated physical home decor items with affiliate or direct fulfilment
class HomeDecorItem {
  final String id;
  final String title;
  final String brand;
  final String description;
  final HomeDecorCategory category;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final Map<String, String> specifications;
  final String dimensions;
  final String material;
  final List<String> colorOptions;
  final bool inStock;
  final int stockCount;
  final bool isAffiliate;
  final AffiliatePlatform affiliatePlatform;
  final String? affiliateUrl;
  final int estimatedDeliveryDays;
  final bool isFeatured;
  final String designStyle;
  final String returnPolicy;

  const HomeDecorItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    this.specifications = const {},
    required this.dimensions,
    required this.material,
    this.colorOptions = const [],
    this.inStock = true,
    this.stockCount = 10,
    this.isAffiliate = false,
    this.affiliatePlatform = AffiliatePlatform.homioDirect,
    this.affiliateUrl,
    this.estimatedDeliveryDays = 4,
    this.isFeatured = false,
    required this.designStyle,
    this.returnPolicy = '7-day replacement guarantee',
  });

  bool get isDiscounted => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!isDiscounted || originalPrice == null || originalPrice! <= 0) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String? get formattedOriginalPrice => originalPrice != null ? '₹${originalPrice!.toStringAsFixed(0)}' : null;
}

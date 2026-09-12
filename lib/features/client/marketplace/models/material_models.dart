import 'marketplace_enums.dart';

/// Construction & interior materials with B2B trade pricing and MOQ
class MaterialItem {
  final String id;
  final String title;
  final String brand;
  final String manufacturer;
  final MaterialCategory category;
  final double retailPrice;
  final double tradePrice;
  final MaterialUnit unit;
  final int minimumOrderQuantity;
  final int leadTimeDays;
  final Map<String, String> technicalSpecs;
  final List<String> certifications;
  final List<String> imageUrls;
  final bool inStock;
  final int stockAvailable;
  final String hsnCode;
  final double gstPercent;
  final bool isVerifiedTradeGrade;
  final String originCity;
  final String description;

  const MaterialItem({
    required this.id,
    required this.title,
    required this.brand,
    required this.manufacturer,
    required this.category,
    required this.retailPrice,
    required this.tradePrice,
    required this.unit,
    required this.minimumOrderQuantity,
    this.leadTimeDays = 3,
    this.technicalSpecs = const {},
    this.certifications = const [],
    required this.imageUrls,
    this.inStock = true,
    this.stockAvailable = 500,
    required this.hsnCode,
    this.gstPercent = 18.0,
    this.isVerifiedTradeGrade = true,
    required this.originCity,
    required this.description,
  });

  int get tradeDiscountPercent {
    if (retailPrice <= tradePrice || retailPrice <= 0) return 0;
    return (((retailPrice - tradePrice) / retailPrice) * 100).round();
  }

  String get formattedRetailPrice => '₹${retailPrice.toStringAsFixed(0)} / ${unit.symbol}';
  String get formattedTradePrice => '₹${tradePrice.toStringAsFixed(0)} / ${unit.symbol}';
}

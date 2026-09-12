import 'marketplace_enums.dart';

/// Digital downloadable product (Vastu guides, CAD templates, BIM models, VR files)
class DigitalProductItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final DigitalProductCategory category;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final int downloadCount;
  final String fileFormat;
  final String fileSize;
  final List<String> compatibleSoftware;
  final List<String> previewImages;
  final String authorName;
  final String authorRole;
  final DateTime publishedDate;
  final String downloadUrl;
  final bool isFeatured;
  final List<String> tags;
  final List<String> inclusions;

  const DigitalProductItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.downloadCount,
    required this.fileFormat,
    required this.fileSize,
    required this.compatibleSoftware,
    required this.previewImages,
    required this.authorName,
    required this.authorRole,
    required this.publishedDate,
    required this.downloadUrl,
    this.isFeatured = false,
    this.tags = const [],
    this.inclusions = const [],
  });

  bool get isDiscounted => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!isDiscounted || originalPrice == null || originalPrice! <= 0) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String? get formattedOriginalPrice => originalPrice != null ? '₹${originalPrice!.toStringAsFixed(0)}' : null;
}

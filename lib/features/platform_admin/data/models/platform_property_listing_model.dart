class PlatformPropertyListingModel {
  final String id;
  final String title;
  final String slug;
  final String organizationId;
  final String organizationName;
  final String? categoryName;
  final String propertyType;
  final String intent;
  final String verificationStatus;
  final String bhk;
  final int bedrooms;
  final int bathrooms;
  final double carpetAreaSqft;
  final double price;
  final String locality;
  final String city;
  final String state;
  final String ownerName;
  final String ownerPhone;
  final String? ownerEmail;
  final double contactUnlockFee;
  final int contactUnlockDurationDays;
  final List<String> amenities;
  final String? coverImageUrl;
  final List<String> images;
  final DateTime? createdAt;

  const PlatformPropertyListingModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.organizationId,
    required this.organizationName,
    this.categoryName,
    required this.propertyType,
    required this.intent,
    required this.verificationStatus,
    required this.bhk,
    required this.bedrooms,
    required this.bathrooms,
    required this.carpetAreaSqft,
    required this.price,
    required this.locality,
    required this.city,
    required this.state,
    required this.ownerName,
    required this.ownerPhone,
    this.ownerEmail,
    this.contactUnlockFee = 0.0,
    this.contactUnlockDurationDays = 30,
    this.amenities = const [],
    this.coverImageUrl,
    this.images = const [],
    this.createdAt,
  });

  factory PlatformPropertyListingModel.fromJson(Map<String, dynamic> json) {
    final org = json['organization'] as Map<String, dynamic>?;
    final cat = json['category'] as Map<String, dynamic>?;

    return PlatformPropertyListingModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      organizationName: org?['name'] as String? ?? 'Unknown Organization',
      categoryName: cat?['name'] as String?,
      propertyType: json['propertyType'] as String? ?? 'APARTMENT',
      intent: json['intent'] as String? ?? 'SALE',
      verificationStatus: json['verificationStatus'] as String? ?? 'UNDER_REVIEW',
      bhk: json['bhk'] as String? ?? '2 BHK',
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 2,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 2,
      carpetAreaSqft: (json['carpetAreaSqft'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      locality: json['locality'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? 'Owner',
      ownerPhone: json['ownerPhone'] as String? ?? '',
      ownerEmail: json['ownerEmail'] as String?,
      contactUnlockFee: (json['contactUnlockFee'] as num?)?.toDouble() ?? 0.0,
      contactUnlockDurationDays: (json['contactUnlockDurationDays'] as num?)?.toInt() ?? 30,
      amenities: (json['amenities'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      coverImageUrl: () {
        final img = json['coverImageUrl'];
        if (img is Map<String, dynamic>) {
          return img['url'] as String?;
        }
        if (img is String && img.isNotEmpty) {
          return img;
        }
        return null;
      }(),
      images: () {
        final imgs = json['images'];
        if (imgs is List) {
          return imgs.map((e) {
            if (e is Map<String, dynamic>) {
              return e['url'] as String? ?? '';
            }
            return e.toString();
          }).where((url) => url.isNotEmpty).toList();
        }
        return const <String>[];
      }(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }
}

class PaginatedPlatformPropertiesResponse {
  final List<PlatformPropertyListingModel> items;
  final int total;
  final int page;
  final int limit;

  const PaginatedPlatformPropertiesResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedPlatformPropertiesResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List?) ?? [];
    return PaginatedPlatformPropertiesResponse(
      items: list.map((e) => PlatformPropertyListingModel.fromJson(e as Map<String, dynamic>)).toList(),
      total: (json['total'] as num?)?.toInt() ?? list.length,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );
  }
}

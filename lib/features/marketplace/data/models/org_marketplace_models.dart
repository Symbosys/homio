import '../../../platform_admin/data/models/platform_marketplace_category_model.dart';

String? _extractImageUrl(dynamic img) {
  if (img == null) return null;
  if (img is Map<String, dynamic>) {
    return img['url'] as String?;
  }
  if (img is String && img.isNotEmpty) {
    return img;
  }
  return null;
}

List<String> _extractImageList(dynamic list) {
  if (list == null || list is! List) return const [];
  return list
      .map((item) => _extractImageUrl(item))
      .where((url) => url != null && url.isNotEmpty)
      .cast<String>()
      .toList();
}

/// Digital Asset Product Model
class OrgDigitalProductModel {
  final String id;
  final String organizationId;
  final String categoryId;
  final String name;
  final String sku;
  final String urlSlug;
  final String? description;
  final List<String> tags;
  final String? authorName;
  final String fileUrl;
  final String fileFormat;
  final String? fileSize;
  final String? coverImageUrl;
  final List<String> previewImages;
  final int downloadLinkExpiryHours;
  final int maxDownloads;
  final double mrp;
  final double sellingPrice;
  final double taxRate;
  final String status;
  final bool isFeatured;
  final int totalSalesCount;
  final int totalPurchases;
  final double rating;
  final int reviewsCount;
  final double totalRevenueEarned;
  final PlatformMarketplaceCategoryModel? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrgDigitalProductModel({
    required this.id,
    required this.organizationId,
    required this.categoryId,
    required this.name,
    required this.sku,
    required this.urlSlug,
    this.description,
    this.tags = const [],
    this.authorName,
    required this.fileUrl,
    this.fileFormat = 'PDF',
    this.fileSize,
    this.coverImageUrl,
    this.previewImages = const [],
    this.downloadLinkExpiryHours = 48,
    this.maxDownloads = 5,
    this.mrp = 0.0,
    this.sellingPrice = 0.0,
    this.taxRate = 18.0,
    this.status = 'DRAFT',
    this.isFeatured = false,
    this.totalSalesCount = 0,
    this.totalPurchases = 0,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.totalRevenueEarned = 0.0,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory OrgDigitalProductModel.fromJson(Map<String, dynamic> json) {
    return OrgDigitalProductModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      urlSlug: json['urlSlug'] as String? ?? '',
      description: json['description'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      authorName: json['authorName'] as String?,
      fileUrl: json['fileUrl'] as String? ?? '',
      fileFormat: json['fileFormat'] as String? ?? 'PDF',
      fileSize: json['fileSize'] as String?,
      coverImageUrl: _extractImageUrl(json['coverImageUrl']),
      previewImages: _extractImageList(json['previewImages']),
      downloadLinkExpiryHours: (json['downloadLinkExpiryHours'] as num?)?.toInt() ?? 48,
      maxDownloads: (json['maxDownloads'] as num?)?.toInt() ?? 5,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 18.0,
      status: json['status'] as String? ?? 'DRAFT',
      isFeatured: json['isFeatured'] as bool? ?? false,
      totalSalesCount: (json['totalSalesCount'] as num?)?.toInt() ?? (json['totalPurchases'] as num?)?.toInt() ?? 0,
      totalPurchases: (json['totalPurchases'] as num?)?.toInt() ?? (json['totalSalesCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      totalRevenueEarned: (json['totalRevenueEarned'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? PlatformMarketplaceCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }
}

/// Home Decor & Furnishings Model
class OrgHomeDecorProductModel {
  final String id;
  final String organizationId;
  final String categoryId;
  final String ownershipType;
  final String? vendorId;
  final double? ownerCommissionRate;
  final String name;
  final String sku;
  final String? brandName;
  final String? description;
  final List<String> tags;
  final String? material;
  final String? color;
  final String? dimensions;
  final String? roomType;
  final String? coverImageUrl;
  final List<String> galleryUrls;
  final double mrp;
  final double sellingPrice;
  final double taxRate;
  final bool inStock;
  final int stockCount;
  final int minOrderQuantity;
  final bool sampleAvailable;
  final double samplePrice;
  final bool isAffiliateEnabled;
  final String? affiliatePartner;
  final String? affiliateUrl;
  final double commissionRate;
  final String status;
  final bool isFeatured;
  final int totalOrdersCount;
  final double totalRevenue;
  final PlatformMarketplaceCategoryModel? category;
  final OrgVendorModel? vendor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrgHomeDecorProductModel({
    required this.id,
    required this.organizationId,
    required this.categoryId,
    this.ownershipType = 'SELF_OWNED',
    this.vendorId,
    this.ownerCommissionRate,
    required this.name,
    required this.sku,
    this.brandName,
    this.description,
    this.tags = const [],
    this.material,
    this.color,
    this.dimensions,
    this.roomType,
    this.coverImageUrl,
    this.galleryUrls = const [],
    this.mrp = 0.0,
    this.sellingPrice = 0.0,
    this.taxRate = 18.0,
    this.inStock = true,
    this.stockCount = 0,
    this.minOrderQuantity = 1,
    this.sampleAvailable = false,
    this.samplePrice = 0.0,
    this.isAffiliateEnabled = false,
    this.affiliatePartner,
    this.affiliateUrl,
    this.commissionRate = 0.0,
    this.status = 'DRAFT',
    this.isFeatured = false,
    this.totalOrdersCount = 0,
    this.totalRevenue = 0.0,
    this.category,
    this.vendor,
    this.createdAt,
    this.updatedAt,
  });

  factory OrgHomeDecorProductModel.fromJson(Map<String, dynamic> json) {
    return OrgHomeDecorProductModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      ownershipType: json['ownershipType'] as String? ?? 'SELF_OWNED',
      vendorId: json['vendorId'] as String?,
      ownerCommissionRate: (json['ownerCommissionRate'] as num?)?.toDouble(),
      name: json['name'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      brandName: json['brandName'] as String?,
      description: json['description'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      material: json['material'] as String?,
      color: json['color'] as String?,
      dimensions: json['dimensions'] as String?,
      roomType: json['roomType'] as String?,
      coverImageUrl: _extractImageUrl(json['coverImageUrl']),
      galleryUrls: _extractImageList(json['galleryUrls']),
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 18.0,
      inStock: json['inStock'] as bool? ?? true,
      stockCount: (json['stockCount'] as num?)?.toInt() ?? 0,
      minOrderQuantity: (json['minOrderQuantity'] as num?)?.toInt() ?? 1,
      sampleAvailable: json['sampleAvailable'] as bool? ?? false,
      samplePrice: (json['samplePrice'] as num?)?.toDouble() ?? 0.0,
      isAffiliateEnabled: json['isAffiliateEnabled'] as bool? ?? false,
      affiliatePartner: json['affiliatePartner'] as String?,
      affiliateUrl: json['affiliateUrl'] as String?,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'DRAFT',
      isFeatured: json['isFeatured'] as bool? ?? false,
      totalOrdersCount: (json['totalOrdersCount'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? PlatformMarketplaceCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      vendor: json['vendor'] != null && json['vendor'] is Map<String, dynamic>
          ? OrgVendorModel.fromJson(json['vendor'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }
}

/// Real Estate Property Listing Model
class OrgPropertyListingModel {
  final String id;
  final String organizationId;
  final String? categoryId;
  final String title;
  final String slug;
  final String propertyType;
  final String intent;
  final String verificationStatus;
  final String bhk;
  final int bedrooms;
  final int bathrooms;
  final int balconies;
  final int carpetAreaSqft;
  final int? superBuiltUpSqft;
  final int? floorNumber;
  final int? totalFloors;
  final String furnishingStatus;
  final int coveredParkingSlots;
  final DateTime? availableFrom;
  final String? addressLine;
  final String locality;
  final String city;
  final String state;
  final String? pinCode;
  final double? latitude;
  final double? longitude;
  final double price;
  final double maintenanceMonthly;
  final bool isNegotiable;
  final double contactUnlockFee;
  final int contactUnlockDurationDays;
  final int totalContactUnlocks;
  final String ownerName;
  final String ownerPhone;
  final String? ownerEmail;
  final List<String> amenities;
  final String? description;
  final String? coverImageUrl;
  final List<String> images;
  final String status;
  final bool isFeatured;
  final int totalUnlocks;
  final double totalUnlockRevenue;
  final PlatformMarketplaceCategoryModel? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrgPropertyListingModel({
    required this.id,
    required this.organizationId,
    this.categoryId,
    required this.title,
    required this.slug,
    this.propertyType = 'APARTMENT',
    this.intent = 'SALE',
    this.verificationStatus = 'DRAFT',
    required this.bhk,
    this.bedrooms = 1,
    this.bathrooms = 1,
    this.balconies = 0,
    required this.carpetAreaSqft,
    this.superBuiltUpSqft,
    this.floorNumber,
    this.totalFloors,
    this.furnishingStatus = 'Unfurnished',
    this.coveredParkingSlots = 0,
    this.availableFrom,
    this.addressLine,
    required this.locality,
    required this.city,
    required this.state,
    this.pinCode,
    this.latitude,
    this.longitude,
    required this.price,
    this.maintenanceMonthly = 0.0,
    this.isNegotiable = true,
    this.contactUnlockFee = 500.0,
    this.contactUnlockDurationDays = 30,
    this.totalContactUnlocks = 0,
    required this.ownerName,
    required this.ownerPhone,
    this.ownerEmail,
    this.amenities = const [],
    this.description,
    this.coverImageUrl,
    this.images = const [],
    this.status = 'DRAFT',
    this.isFeatured = false,
    this.totalUnlocks = 0,
    this.totalUnlockRevenue = 0.0,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory OrgPropertyListingModel.fromJson(Map<String, dynamic> json) {
    return OrgPropertyListingModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      categoryId: json['categoryId'] as String?,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      propertyType: json['propertyType'] as String? ?? 'APARTMENT',
      intent: json['intent'] as String? ?? 'SALE',
      verificationStatus: json['verificationStatus'] as String? ?? 'DRAFT',
      bhk: json['bhk'] as String? ?? '2 BHK',
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 1,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 1,
      balconies: (json['balconies'] as num?)?.toInt() ?? 0,
      carpetAreaSqft: (json['carpetAreaSqft'] as num?)?.toInt() ?? 0,
      superBuiltUpSqft: (json['superBuiltUpSqft'] as num?)?.toInt(),
      floorNumber: (json['floorNumber'] as num?)?.toInt(),
      totalFloors: (json['totalFloors'] as num?)?.toInt(),
      furnishingStatus: json['furnishingStatus'] as String? ?? 'Unfurnished',
      coveredParkingSlots: (json['coveredParkingSlots'] as num?)?.toInt() ?? 0,
      availableFrom: json['availableFrom'] != null ? DateTime.tryParse(json['availableFrom'] as String) : null,
      addressLine: json['addressLine'] as String?,
      locality: json['locality'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pinCode: json['pinCode'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      maintenanceMonthly: (json['maintenanceMonthly'] as num?)?.toDouble() ?? 0.0,
      isNegotiable: json['isNegotiable'] as bool? ?? true,
      contactUnlockFee: (json['contactUnlockFee'] as num?)?.toDouble() ?? 500.0,
      contactUnlockDurationDays: (json['contactUnlockDurationDays'] as num?)?.toInt() ?? 30,
      totalContactUnlocks: (json['totalContactUnlocks'] as num?)?.toInt() ?? (json['totalUnlocks'] as num?)?.toInt() ?? 0,
      ownerName: json['ownerName'] as String? ?? '',
      ownerPhone: json['ownerPhone'] as String? ?? '',
      ownerEmail: json['ownerEmail'] as String?,
      amenities: (json['amenities'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      description: json['description'] as String?,
      coverImageUrl: _extractImageUrl(json['coverImageUrl']),
      images: _extractImageList(json['images']),
      status: json['status'] as String? ?? 'DRAFT',
      isFeatured: json['isFeatured'] as bool? ?? false,
      totalUnlocks: (json['totalUnlocks'] as num?)?.toInt() ?? (json['totalContactUnlocks'] as num?)?.toInt() ?? 0,
      totalUnlockRevenue: (json['totalUnlockRevenue'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? PlatformMarketplaceCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }
}

/// Wholesale Material Product Model
class OrgMaterialProductModel {
  final String id;
  final String organizationId;
  final String categoryId;
  final String ownershipType;
  final String? vendorId;
  final double? ownerCommissionRate;
  final String name;
  final String sku;
  final String? brandName;
  final String? description;
  final List<String> tags;
  final String? materialType;
  final String? grade;
  final String? dimensions;
  final String? thickness;
  final String? application;
  final String? coverImageUrl;
  final List<String> images;
  final String unitOfMeasure;
  final double wholesalePrice;
  final double retailPrice;
  final double taxRate;
  final int minOrderQuantity;
  final int stockAvailableUnits;
  final String status;
  final bool isFeatured;
  final double rating;
  final int ordersCount;
  final int totalOrders;
  final double totalVolumeSold;
  final PlatformMarketplaceCategoryModel? category;
  final OrgVendorModel? vendor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrgMaterialProductModel({
    required this.id,
    required this.organizationId,
    required this.categoryId,
    this.ownershipType = 'SELF_OWNED',
    this.vendorId,
    this.ownerCommissionRate,
    required this.name,
    required this.sku,
    this.brandName,
    this.description,
    this.tags = const [],
    this.materialType,
    this.grade,
    this.dimensions,
    this.thickness,
    this.application,
    this.coverImageUrl,
    this.images = const [],
    this.unitOfMeasure = 'PIECE',
    this.wholesalePrice = 0.0,
    this.retailPrice = 0.0,
    this.taxRate = 18.0,
    this.minOrderQuantity = 1,
    this.stockAvailableUnits = 0,
    this.status = 'DRAFT',
    this.isFeatured = false,
    this.rating = 0.0,
    this.ordersCount = 0,
    this.totalOrders = 0,
    this.totalVolumeSold = 0.0,
    this.category,
    this.vendor,
    this.createdAt,
    this.updatedAt,
  });

  factory OrgMaterialProductModel.fromJson(Map<String, dynamic> json) {
    return OrgMaterialProductModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      ownershipType: json['ownershipType'] as String? ?? 'SELF_OWNED',
      vendorId: json['vendorId'] as String?,
      ownerCommissionRate: (json['ownerCommissionRate'] as num?)?.toDouble(),
      name: json['name'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      brandName: json['brandName'] as String?,
      description: json['description'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      materialType: json['materialType'] as String?,
      grade: json['grade'] as String?,
      dimensions: json['dimensions'] as String?,
      thickness: json['thickness'] as String?,
      application: json['application'] as String?,
      coverImageUrl: _extractImageUrl(json['coverImageUrl']),
      images: _extractImageList(json['images']),
      unitOfMeasure: json['unitOfMeasure'] as String? ?? 'PIECE',
      wholesalePrice: (json['wholesalePrice'] as num?)?.toDouble() ?? 0.0,
      retailPrice: (json['retailPrice'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 18.0,
      minOrderQuantity: (json['minOrderQuantity'] as num?)?.toInt() ?? 1,
      stockAvailableUnits: (json['stockAvailableUnits'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'DRAFT',
      isFeatured: json['isFeatured'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ordersCount: (json['ordersCount'] as num?)?.toInt() ?? (json['totalOrders'] as num?)?.toInt() ?? 0,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? (json['ordersCount'] as num?)?.toInt() ?? 0,
      totalVolumeSold: (json['totalVolumeSold'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? PlatformMarketplaceCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      vendor: json['vendor'] != null && json['vendor'] is Map<String, dynamic>
          ? OrgVendorModel.fromJson(json['vendor'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }
}

/// Seller Category Registration Model
class OrgSellerCategoryModel {
  final String id;
  final String organizationId;
  final String categoryId;
  final bool isApproved;
  final double? commissionRate;
  final DateTime? approvedAt;
  final PlatformMarketplaceCategoryModel? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrgSellerCategoryModel({
    required this.id,
    required this.organizationId,
    required this.categoryId,
    this.isApproved = false,
    this.commissionRate,
    this.approvedAt,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory OrgSellerCategoryModel.fromJson(Map<String, dynamic> json) {
    return OrgSellerCategoryModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      isApproved: json['isApproved'] as bool? ?? false,
      commissionRate: (json['commissionRate'] as num?)?.toDouble(),
      approvedAt: json['approvedAt'] != null ? DateTime.tryParse(json['approvedAt'] as String) : null,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? PlatformMarketplaceCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }
}

/// Vendor / Supplier Model
class OrgVendorModel {
  final String id;
  final String organizationId;
  final String companyName;
  final String? legalName;
  final String contactPerson;
  final String email;
  final String phone;
  final String? address;
  final String? city;
  final String? state;
  final String? taxId;
  final double defaultCommissionRate;
  final String status;
  final int totalProducts;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrgVendorModel({
    required this.id,
    required this.organizationId,
    required this.companyName,
    this.legalName,
    required this.contactPerson,
    required this.email,
    required this.phone,
    this.address,
    this.city,
    this.state,
    this.taxId,
    this.defaultCommissionRate = 10.0,
    this.status = 'ACTIVE',
    this.totalProducts = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory OrgVendorModel.fromJson(Map<String, dynamic> json) {
    return OrgVendorModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      legalName: json['legalName'] as String?,
      contactPerson: json['contactPerson'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      taxId: json['taxId'] as String?,
      defaultCommissionRate: (json['defaultCommissionRate'] as num?)?.toDouble() ?? 10.0,
      status: json['status'] as String? ?? 'ACTIVE',
      totalProducts: (json['totalProducts'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }
}

import 'marketplace_enums.dart';

/// Hierarchy Master: Marketplace Category
class MarketplaceCategory {
  final String id;
  final String name;
  final String code;
  final MarketplaceType marketplaceType;
  final String description;
  final String iconCode;
  final String? imageUrl;
  final String slug;
  final int sortOrder;
  final bool isActive;
  final bool isFeatured;
  final List<MarketplaceSubcategory> subcategories;

  const MarketplaceCategory({
    required this.id,
    required this.name,
    required this.code,
    required this.marketplaceType,
    required this.description,
    required this.iconCode,
    this.imageUrl,
    required this.slug,
    required this.sortOrder,
    this.isActive = true,
    this.isFeatured = false,
    this.subcategories = const [],
  });

  MarketplaceCategory copyWith({
    String? id,
    String? name,
    String? code,
    MarketplaceType? marketplaceType,
    String? description,
    String? iconCode,
    String? imageUrl,
    String? slug,
    int? sortOrder,
    bool? isActive,
    bool? isFeatured,
    List<MarketplaceSubcategory>? subcategories,
  }) {
    return MarketplaceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      marketplaceType: marketplaceType ?? this.marketplaceType,
      description: description ?? this.description,
      iconCode: iconCode ?? this.iconCode,
      imageUrl: imageUrl ?? this.imageUrl,
      slug: slug ?? this.slug,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}

/// Hierarchy Master: Marketplace Subcategory
class MarketplaceSubcategory {
  final String id;
  final String categoryId;
  final String name;
  final String code;
  final String description;
  final List<String> productTypes;
  final bool isActive;

  const MarketplaceSubcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.code,
    required this.description,
    required this.productTypes,
    this.isActive = true,
  });
}

/// Brand Directory Entity
class MarketplaceBrand {
  final String id;
  final String name;
  final String code;
  final String logoUrl;
  final String description;
  final String website;
  final String countryOfOrigin;
  final String contactEmail;
  final bool isFeatured;
  final bool isActive;
  final int linkedProductCount;

  const MarketplaceBrand({
    required this.id,
    required this.name,
    required this.code,
    required this.logoUrl,
    required this.description,
    required this.website,
    required this.countryOfOrigin,
    required this.contactEmail,
    this.isFeatured = false,
    this.isActive = true,
    this.linkedProductCount = 0,
  });
}

// =============================================================================
// 1. DIGITAL STORE ENTITIES
// =============================================================================

class DigitalProductEntity {
  final String id;
  final String name;
  final String sku;
  final String productCode;
  final String categoryId;
  final String categoryName;
  final String subcategory;
  final String shortTitle;
  final String subtitle;
  final String shortDescription;
  final String fullDescription;
  final List<String> tags;
  final List<String> keywords;

  // Author & Credentials
  final String authorName;
  final String authorTitle;
  final String authorBio;
  final String authorPhotoUrl;
  final String authorOrganization;
  final String authorCredentials;
  final String authorWebsite;

  // Digital Content
  final String primaryFileUrl;
  final DigitalFileFormat fileFormat;
  final String fileSize;
  final int pageCount;
  final String version;
  final List<String> tableOfContents;
  final String previewExcerpt;
  final String coverImageUrl;
  final List<String> previewImageUrls;
  final String copyrightInfo;
  final String licenseInfo;

  // Pricing
  final double mrp;
  final double sellingPrice;
  final String discountType; // percentage, fixed
  final double discountValue;
  final double taxRate;
  final String currency;
  final double? promotionalPrice;
  final DateTime? promoStart;
  final DateTime? promoEnd;

  // Security & DRM
  final bool secureDownloadEnabled;
  final int downloadLinkExpiryHours;
  final int maxDownloads;
  final int downloadAccessDurationDays;
  final bool requireAuthentication;
  final bool watermarkEnabled;
  final String watermarkText;

  // SEO
  final String seoTitle;
  final String metaDescription;
  final String urlSlug;
  final String canonicalUrl;

  // Publishing & Metrics
  final ProductPublicationStatus publicationStatus;
  final ProductVisibility visibility;
  final bool isFeatured;
  final bool isBestseller;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
  final double rating;
  final int reviewsCount;
  final int totalPurchases;
  final int totalDownloads;
  final int failedDownloads;
  final double grossRevenue;

  const DigitalProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.productCode,
    required this.categoryId,
    required this.categoryName,
    required this.subcategory,
    required this.shortTitle,
    required this.subtitle,
    required this.shortDescription,
    required this.fullDescription,
    required this.tags,
    required this.keywords,
    required this.authorName,
    required this.authorTitle,
    required this.authorBio,
    required this.authorPhotoUrl,
    required this.authorOrganization,
    required this.authorCredentials,
    required this.authorWebsite,
    required this.primaryFileUrl,
    required this.fileFormat,
    required this.fileSize,
    required this.pageCount,
    required this.version,
    required this.tableOfContents,
    required this.previewExcerpt,
    required this.coverImageUrl,
    required this.previewImageUrls,
    required this.copyrightInfo,
    required this.licenseInfo,
    required this.mrp,
    required this.sellingPrice,
    required this.discountType,
    required this.discountValue,
    required this.taxRate,
    this.currency = 'INR',
    this.promotionalPrice,
    this.promoStart,
    this.promoEnd,
    this.secureDownloadEnabled = true,
    this.downloadLinkExpiryHours = 48,
    this.maxDownloads = 5,
    this.downloadAccessDurationDays = 365,
    this.requireAuthentication = true,
    this.watermarkEnabled = true,
    this.watermarkText = 'CONFIDENTIAL - HOMIO CRM LICENSED TO USER',
    required this.seoTitle,
    required this.metaDescription,
    required this.urlSlug,
    required this.canonicalUrl,
    this.publicationStatus = ProductPublicationStatus.published,
    this.visibility = ProductVisibility.public,
    this.isFeatured = false,
    this.isBestseller = false,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
    this.rating = 4.8,
    this.reviewsCount = 12,
    this.totalPurchases = 0,
    this.totalDownloads = 0,
    this.failedDownloads = 0,
    this.grossRevenue = 0.0,
  });

  double get discountPercent => mrp > 0 ? (((mrp - sellingPrice) / mrp) * 100).roundToDouble() : 0.0;

  DigitalProductEntity copyWith({
    String? id,
    String? name,
    String? sku,
    String? productCode,
    String? categoryId,
    String? categoryName,
    String? subcategory,
    String? shortTitle,
    String? subtitle,
    String? shortDescription,
    String? fullDescription,
    List<String>? tags,
    List<String>? keywords,
    String? authorName,
    String? authorTitle,
    String? authorBio,
    String? authorPhotoUrl,
    String? authorOrganization,
    String? authorCredentials,
    String? authorWebsite,
    String? primaryFileUrl,
    DigitalFileFormat? fileFormat,
    String? fileSize,
    int? pageCount,
    String? version,
    List<String>? tableOfContents,
    String? previewExcerpt,
    String? coverImageUrl,
    List<String>? previewImageUrls,
    String? copyrightInfo,
    String? licenseInfo,
    double? mrp,
    double? sellingPrice,
    String? discountType,
    double? discountValue,
    double? taxRate,
    String? currency,
    double? promotionalPrice,
    DateTime? promoStart,
    DateTime? promoEnd,
    bool? secureDownloadEnabled,
    int? downloadLinkExpiryHours,
    int? maxDownloads,
    int? downloadAccessDurationDays,
    bool? requireAuthentication,
    bool? watermarkEnabled,
    String? watermarkText,
    String? seoTitle,
    String? metaDescription,
    String? urlSlug,
    String? canonicalUrl,
    ProductPublicationStatus? publicationStatus,
    ProductVisibility? visibility,
    bool? isFeatured,
    bool? isBestseller,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    double? rating,
    int? reviewsCount,
    int? totalPurchases,
    int? totalDownloads,
    int? failedDownloads,
    double? grossRevenue,
  }) {
    return DigitalProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      productCode: productCode ?? this.productCode,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subcategory: subcategory ?? this.subcategory,
      shortTitle: shortTitle ?? this.shortTitle,
      subtitle: subtitle ?? this.subtitle,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      tags: tags ?? this.tags,
      keywords: keywords ?? this.keywords,
      authorName: authorName ?? this.authorName,
      authorTitle: authorTitle ?? this.authorTitle,
      authorBio: authorBio ?? this.authorBio,
      authorPhotoUrl: authorPhotoUrl ?? this.authorPhotoUrl,
      authorOrganization: authorOrganization ?? this.authorOrganization,
      authorCredentials: authorCredentials ?? this.authorCredentials,
      authorWebsite: authorWebsite ?? this.authorWebsite,
      primaryFileUrl: primaryFileUrl ?? this.primaryFileUrl,
      fileFormat: fileFormat ?? this.fileFormat,
      fileSize: fileSize ?? this.fileSize,
      pageCount: pageCount ?? this.pageCount,
      version: version ?? this.version,
      tableOfContents: tableOfContents ?? this.tableOfContents,
      previewExcerpt: previewExcerpt ?? this.previewExcerpt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      previewImageUrls: previewImageUrls ?? this.previewImageUrls,
      copyrightInfo: copyrightInfo ?? this.copyrightInfo,
      licenseInfo: licenseInfo ?? this.licenseInfo,
      mrp: mrp ?? this.mrp,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      taxRate: taxRate ?? this.taxRate,
      currency: currency ?? this.currency,
      promotionalPrice: promotionalPrice ?? this.promotionalPrice,
      promoStart: promoStart ?? this.promoStart,
      promoEnd: promoEnd ?? this.promoEnd,
      secureDownloadEnabled: secureDownloadEnabled ?? this.secureDownloadEnabled,
      downloadLinkExpiryHours: downloadLinkExpiryHours ?? this.downloadLinkExpiryHours,
      maxDownloads: maxDownloads ?? this.maxDownloads,
      downloadAccessDurationDays: downloadAccessDurationDays ?? this.downloadAccessDurationDays,
      requireAuthentication: requireAuthentication ?? this.requireAuthentication,
      watermarkEnabled: watermarkEnabled ?? this.watermarkEnabled,
      watermarkText: watermarkText ?? this.watermarkText,
      seoTitle: seoTitle ?? this.seoTitle,
      metaDescription: metaDescription ?? this.metaDescription,
      urlSlug: urlSlug ?? this.urlSlug,
      canonicalUrl: canonicalUrl ?? this.canonicalUrl,
      publicationStatus: publicationStatus ?? this.publicationStatus,
      visibility: visibility ?? this.visibility,
      isFeatured: isFeatured ?? this.isFeatured,
      isBestseller: isBestseller ?? this.isBestseller,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalDownloads: totalDownloads ?? this.totalDownloads,
      failedDownloads: failedDownloads ?? this.failedDownloads,
      grossRevenue: grossRevenue ?? this.grossRevenue,
    );
  }
}

class DigitalDownloadAttempt {
  final String id;
  final String orderId;
  final String customerName;
  final String customerEmail;
  final String digitalProductId;
  final String digitalProductTitle;
  final DateTime attemptedAt;
  final bool isSuccess;
  final String ipAddress;
  final String deviceClient;
  final DateTime linkExpiresAt;
  final String downloadToken;

  const DigitalDownloadAttempt({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.customerEmail,
    required this.digitalProductId,
    required this.digitalProductTitle,
    required this.attemptedAt,
    required this.isSuccess,
    required this.ipAddress,
    required this.deviceClient,
    required this.linkExpiresAt,
    required this.downloadToken,
  });
}

// =============================================================================
// 2. HOME DECOR & AFFILIATE ENTITIES
// =============================================================================

class HomeDecorProductEntity {
  final String id;
  final String name;
  final String sku;
  final String brandName;
  final String categoryId;
  final String categoryName;
  final String subcategory;
  final String collection;
  final String productType;
  final String shortDescription;
  final String fullDescription;
  final String coverImageUrl;
  final List<String> galleryUrls;
  final List<String> tags;

  // Specifications
  final String primaryMaterial;
  final String secondaryMaterial;
  final String colour;
  final String finish;
  final String texture;
  final String dimensions; // e.g. "72W x 36D x 30H inches"
  final String weight;
  final String roomType; // Living, Bedroom, Dining, Study
  final String careInstructions;
  final String warrantyPeriod;
  final String countryOfOrigin;

  // Pricing
  final double mrp;
  final double tradePrice;
  final double customerPrice;
  final double taxRate;
  final String currency;

  // Availability & Samples
  final bool inStock;
  final int leadTimeDays;
  final int minOrderQuantity;
  final bool sampleAvailable;
  final double samplePrice;
  final int sampleLeadTimeDays;

  // Affiliate Configuration
  final bool isAffiliateEnabled;
  final AffiliatePartner affiliatePartner;
  final String externalProductUrl;
  final String trackingUrl;
  final String campaignName;
  final CommissionType commissionType;
  final double commissionRate; // e.g. 8.5% or flat 500

  // Metrics
  final ProductPublicationStatus publicationStatus;
  final ProductVisibility visibility;
  final bool isFeatured;
  final bool isBestseller;
  final int viewsCount;
  final int affiliateClicksCount;
  final int uniqueClicksCount;
  final int conversionsCount;
  final double estimatedCommissionEarned;
  final double rating;
  final int reviewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HomeDecorProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.brandName,
    required this.categoryId,
    required this.categoryName,
    required this.subcategory,
    required this.collection,
    required this.productType,
    required this.shortDescription,
    required this.fullDescription,
    required this.coverImageUrl,
    required this.galleryUrls,
    required this.tags,
    required this.primaryMaterial,
    required this.secondaryMaterial,
    required this.colour,
    required this.finish,
    required this.texture,
    required this.dimensions,
    required this.weight,
    required this.roomType,
    required this.careInstructions,
    required this.warrantyPeriod,
    required this.countryOfOrigin,
    required this.mrp,
    required this.tradePrice,
    required this.customerPrice,
    required this.taxRate,
    this.currency = 'INR',
    this.inStock = true,
    this.leadTimeDays = 7,
    this.minOrderQuantity = 1,
    this.sampleAvailable = false,
    this.samplePrice = 0.0,
    this.sampleLeadTimeDays = 3,
    this.isAffiliateEnabled = true,
    required this.affiliatePartner,
    required this.externalProductUrl,
    required this.trackingUrl,
    required this.campaignName,
    this.commissionType = CommissionType.percentage,
    this.commissionRate = 8.5,
    this.publicationStatus = ProductPublicationStatus.published,
    this.visibility = ProductVisibility.public,
    this.isFeatured = false,
    this.isBestseller = false,
    this.viewsCount = 0,
    this.affiliateClicksCount = 0,
    this.uniqueClicksCount = 0,
    this.conversionsCount = 0,
    this.estimatedCommissionEarned = 0.0,
    this.rating = 4.7,
    this.reviewsCount = 8,
    required this.createdAt,
    required this.updatedAt,
  });

  double get discountPercent => mrp > 0 ? (((mrp - customerPrice) / mrp) * 100).roundToDouble() : 0.0;
  double get conversionRatePercent => affiliateClicksCount > 0 ? ((conversionsCount / affiliateClicksCount) * 100).roundToDouble() : 0.0;

  HomeDecorProductEntity copyWith({
    String? id,
    String? name,
    String? sku,
    String? brandName,
    String? categoryId,
    String? categoryName,
    String? subcategory,
    String? collection,
    String? productType,
    String? shortDescription,
    String? fullDescription,
    String? coverImageUrl,
    List<String>? galleryUrls,
    List<String>? tags,
    String? primaryMaterial,
    String? secondaryMaterial,
    String? colour,
    String? finish,
    String? texture,
    String? dimensions,
    String? weight,
    String? roomType,
    String? careInstructions,
    String? warrantyPeriod,
    String? countryOfOrigin,
    double? mrp,
    double? tradePrice,
    double? customerPrice,
    double? taxRate,
    String? currency,
    bool? inStock,
    int? leadTimeDays,
    int? minOrderQuantity,
    bool? sampleAvailable,
    double? samplePrice,
    int? sampleLeadTimeDays,
    bool? isAffiliateEnabled,
    AffiliatePartner? affiliatePartner,
    String? externalProductUrl,
    String? trackingUrl,
    String? campaignName,
    CommissionType? commissionType,
    double? commissionRate,
    ProductPublicationStatus? publicationStatus,
    ProductVisibility? visibility,
    bool? isFeatured,
    bool? isBestseller,
    int? viewsCount,
    int? affiliateClicksCount,
    int? uniqueClicksCount,
    int? conversionsCount,
    double? estimatedCommissionEarned,
    double? rating,
    int? reviewsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HomeDecorProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      brandName: brandName ?? this.brandName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subcategory: subcategory ?? this.subcategory,
      collection: collection ?? this.collection,
      productType: productType ?? this.productType,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      tags: tags ?? this.tags,
      primaryMaterial: primaryMaterial ?? this.primaryMaterial,
      secondaryMaterial: secondaryMaterial ?? this.secondaryMaterial,
      colour: colour ?? this.colour,
      finish: finish ?? this.finish,
      texture: texture ?? this.texture,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
      roomType: roomType ?? this.roomType,
      careInstructions: careInstructions ?? this.careInstructions,
      warrantyPeriod: warrantyPeriod ?? this.warrantyPeriod,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      mrp: mrp ?? this.mrp,
      tradePrice: tradePrice ?? this.tradePrice,
      customerPrice: customerPrice ?? this.customerPrice,
      taxRate: taxRate ?? this.taxRate,
      currency: currency ?? this.currency,
      inStock: inStock ?? this.inStock,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
      minOrderQuantity: minOrderQuantity ?? this.minOrderQuantity,
      sampleAvailable: sampleAvailable ?? this.sampleAvailable,
      samplePrice: samplePrice ?? this.samplePrice,
      sampleLeadTimeDays: sampleLeadTimeDays ?? this.sampleLeadTimeDays,
      isAffiliateEnabled: isAffiliateEnabled ?? this.isAffiliateEnabled,
      affiliatePartner: affiliatePartner ?? this.affiliatePartner,
      externalProductUrl: externalProductUrl ?? this.externalProductUrl,
      trackingUrl: trackingUrl ?? this.trackingUrl,
      campaignName: campaignName ?? this.campaignName,
      commissionType: commissionType ?? this.commissionType,
      commissionRate: commissionRate ?? this.commissionRate,
      publicationStatus: publicationStatus ?? this.publicationStatus,
      visibility: visibility ?? this.visibility,
      isFeatured: isFeatured ?? this.isFeatured,
      isBestseller: isBestseller ?? this.isBestseller,
      viewsCount: viewsCount ?? this.viewsCount,
      affiliateClicksCount: affiliateClicksCount ?? this.affiliateClicksCount,
      uniqueClicksCount: uniqueClicksCount ?? this.uniqueClicksCount,
      conversionsCount: conversionsCount ?? this.conversionsCount,
      estimatedCommissionEarned: estimatedCommissionEarned ?? this.estimatedCommissionEarned,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AffiliateClickEvent {
  final String id;
  final String productId;
  final String productTitle;
  final String brandName;
  final AffiliatePartner partner;
  final String campaignName;
  final DateTime clickedAt;
  final String visitorIp;
  final String destinationUrl;
  final bool isConverted;
  final double? orderValue;
  final double? commissionEarned;

  const AffiliateClickEvent({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.brandName,
    required this.partner,
    required this.campaignName,
    required this.clickedAt,
    required this.visitorIp,
    required this.destinationUrl,
    this.isConverted = false,
    this.orderValue,
    this.commissionEarned,
  });
}

// =============================================================================
// 3. PROPERTY MARKETPLACE ENTITIES
// =============================================================================

class PropertyListingEntity {
  final String id;
  final String title;
  final PropertyType propertyType;
  final ListingIntent intent;
  final PropertyVerificationStatus verificationStatus;
  final String verifiedByAdmin;
  final DateTime? verificationDate;
  final String? verificationNotes;

  // Specifications
  final String bhk; // 3 BHK, 4 BHK, Villa
  final int bedrooms;
  final int bathrooms;
  final int balconies;
  final int carpetAreaSqft;
  final int superBuiltUpSqft;
  final int floorNumber;
  final int totalFloors;
  final int propertyAgeYears;
  final String facingDirection; // North-East, East
  final String furnishingStatus; // Fully Furnished, Semi Furnished
  final int coveredParkingSlots;
  final bool hasPowerBackup;
  final bool hasLift;
  final bool hasGatedSecurity;
  final DateTime availableFrom;

  // Location & Coords
  final String addressLine1;
  final String addressLine2;
  final String locality;
  final String landmark;
  final String city;
  final String state;
  final String pinCode;
  final double latitude;
  final double longitude;
  final bool showExactLocationPublicly;

  // Commercials
  final double monthlyRent;
  final double securityDeposit;
  final double maintenanceMonthly;
  final double salePrice;
  final bool isNegotiable;
  final DateTime priceValidUntil;

  // Amenities & Highlights
  final List<String> amenities;
  final String shortDescription;
  final String fullDescription;
  final String architecturalHighlight;
  final String interiorHighlights;
  final String neighbourhoodNotes;

  // Media
  final String coverImageUrl;
  final List<String> galleryImageUrls;
  final List<String> floorPlanUrls;
  final String walkthroughVideoUrl;
  final String virtualTour3dUrl;

  // Protected Owner Dossier (Field-level restricted)
  final String ownerName;
  final String ownerMobileMasked;
  final String ownerMobileReal; // Protected internal
  final String ownerEmail;
  final String ownerType; // Individual Owner, Builder, NRI Investor
  final String ownerKycStatus; // Aadhaar Verified, Title Deed Confirmed
  final String ownerPreferredContactTime;
  final String internalAdminNotes;

  // Monetization & Stats
  final int totalContactUnlocks;
  final double grossUnlockRevenue;
  final int totalViewsCount;
  final int totalEnquiriesCount;
  final ProductPublicationStatus publicationStatus;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PropertyListingEntity({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.intent,
    this.verificationStatus = PropertyVerificationStatus.verified,
    this.verifiedByAdmin = 'Chief Property Verifier',
    this.verificationDate,
    this.verificationNotes,
    required this.bhk,
    required this.bedrooms,
    required this.bathrooms,
    required this.balconies,
    required this.carpetAreaSqft,
    required this.superBuiltUpSqft,
    required this.floorNumber,
    required this.totalFloors,
    required this.propertyAgeYears,
    required this.facingDirection,
    required this.furnishingStatus,
    required this.coveredParkingSlots,
    this.hasPowerBackup = true,
    this.hasLift = true,
    this.hasGatedSecurity = true,
    required this.availableFrom,
    required this.addressLine1,
    required this.addressLine2,
    required this.locality,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.latitude,
    required this.longitude,
    this.showExactLocationPublicly = false,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.maintenanceMonthly,
    this.salePrice = 0.0,
    this.isNegotiable = true,
    required this.priceValidUntil,
    required this.amenities,
    required this.shortDescription,
    required this.fullDescription,
    required this.architecturalHighlight,
    required this.interiorHighlights,
    required this.neighbourhoodNotes,
    required this.coverImageUrl,
    required this.galleryImageUrls,
    required this.floorPlanUrls,
    required this.walkthroughVideoUrl,
    required this.virtualTour3dUrl,
    required this.ownerName,
    required this.ownerMobileMasked,
    required this.ownerMobileReal,
    required this.ownerEmail,
    required this.ownerType,
    required this.ownerKycStatus,
    required this.ownerPreferredContactTime,
    required this.internalAdminNotes,
    this.totalContactUnlocks = 0,
    this.grossUnlockRevenue = 0.0,
    this.totalViewsCount = 0,
    this.totalEnquiriesCount = 0,
    this.publicationStatus = ProductPublicationStatus.published,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
  });

  PropertyListingEntity copyWith({
    String? id,
    String? title,
    PropertyType? propertyType,
    ListingIntent? intent,
    PropertyVerificationStatus? verificationStatus,
    String? verifiedByAdmin,
    DateTime? verificationDate,
    String? verificationNotes,
    String? bhk,
    int? bedrooms,
    int? bathrooms,
    int? balconies,
    int? carpetAreaSqft,
    int? superBuiltUpSqft,
    int? floorNumber,
    int? totalFloors,
    int? propertyAgeYears,
    String? facingDirection,
    String? furnishingStatus,
    int? coveredParkingSlots,
    bool? hasPowerBackup,
    bool? hasLift,
    bool? hasGatedSecurity,
    DateTime? availableFrom,
    String? addressLine1,
    String? addressLine2,
    String? locality,
    String? landmark,
    String? city,
    String? state,
    String? pinCode,
    double? latitude,
    double? longitude,
    bool? showExactLocationPublicly,
    double? monthlyRent,
    double? securityDeposit,
    double? maintenanceMonthly,
    double? salePrice,
    bool? isNegotiable,
    DateTime? priceValidUntil,
    List<String>? amenities,
    String? shortDescription,
    String? fullDescription,
    String? architecturalHighlight,
    String? interiorHighlights,
    String? neighbourhoodNotes,
    String? coverImageUrl,
    List<String>? galleryImageUrls,
    List<String>? floorPlanUrls,
    String? walkthroughVideoUrl,
    String? virtualTour3dUrl,
    String? ownerName,
    String? ownerMobileMasked,
    String? ownerMobileReal,
    String? ownerEmail,
    String? ownerType,
    String? ownerKycStatus,
    String? ownerPreferredContactTime,
    String? internalAdminNotes,
    int? totalContactUnlocks,
    double? grossUnlockRevenue,
    int? totalViewsCount,
    int? totalEnquiriesCount,
    ProductPublicationStatus? publicationStatus,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PropertyListingEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      propertyType: propertyType ?? this.propertyType,
      intent: intent ?? this.intent,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verifiedByAdmin: verifiedByAdmin ?? this.verifiedByAdmin,
      verificationDate: verificationDate ?? this.verificationDate,
      verificationNotes: verificationNotes ?? this.verificationNotes,
      bhk: bhk ?? this.bhk,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      balconies: balconies ?? this.balconies,
      carpetAreaSqft: carpetAreaSqft ?? this.carpetAreaSqft,
      superBuiltUpSqft: superBuiltUpSqft ?? this.superBuiltUpSqft,
      floorNumber: floorNumber ?? this.floorNumber,
      totalFloors: totalFloors ?? this.totalFloors,
      propertyAgeYears: propertyAgeYears ?? this.propertyAgeYears,
      facingDirection: facingDirection ?? this.facingDirection,
      furnishingStatus: furnishingStatus ?? this.furnishingStatus,
      coveredParkingSlots: coveredParkingSlots ?? this.coveredParkingSlots,
      hasPowerBackup: hasPowerBackup ?? this.hasPowerBackup,
      hasLift: hasLift ?? this.hasLift,
      hasGatedSecurity: hasGatedSecurity ?? this.hasGatedSecurity,
      availableFrom: availableFrom ?? this.availableFrom,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      locality: locality ?? this.locality,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      showExactLocationPublicly: showExactLocationPublicly ?? this.showExactLocationPublicly,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      maintenanceMonthly: maintenanceMonthly ?? this.maintenanceMonthly,
      salePrice: salePrice ?? this.salePrice,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      priceValidUntil: priceValidUntil ?? this.priceValidUntil,
      amenities: amenities ?? this.amenities,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      architecturalHighlight: architecturalHighlight ?? this.architecturalHighlight,
      interiorHighlights: interiorHighlights ?? this.interiorHighlights,
      neighbourhoodNotes: neighbourhoodNotes ?? this.neighbourhoodNotes,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      galleryImageUrls: galleryImageUrls ?? this.galleryImageUrls,
      floorPlanUrls: floorPlanUrls ?? this.floorPlanUrls,
      walkthroughVideoUrl: walkthroughVideoUrl ?? this.walkthroughVideoUrl,
      virtualTour3dUrl: virtualTour3dUrl ?? this.virtualTour3dUrl,
      ownerName: ownerName ?? this.ownerName,
      ownerMobileMasked: ownerMobileMasked ?? this.ownerMobileMasked,
      ownerMobileReal: ownerMobileReal ?? this.ownerMobileReal,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerType: ownerType ?? this.ownerType,
      ownerKycStatus: ownerKycStatus ?? this.ownerKycStatus,
      ownerPreferredContactTime: ownerPreferredContactTime ?? this.ownerPreferredContactTime,
      internalAdminNotes: internalAdminNotes ?? this.internalAdminNotes,
      totalContactUnlocks: totalContactUnlocks ?? this.totalContactUnlocks,
      grossUnlockRevenue: grossUnlockRevenue ?? this.grossUnlockRevenue,
      totalViewsCount: totalViewsCount ?? this.totalViewsCount,
      totalEnquiriesCount: totalEnquiriesCount ?? this.totalEnquiriesCount,
      publicationStatus: publicationStatus ?? this.publicationStatus,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Transaction record of monetized Owner Contact Unlock
class PropertyUnlockTransaction {
  final String id;
  final String customerId;
  final String customerName;
  final String customerMobile;
  final String customerEmail;
  final String propertyId;
  final String propertyTitle;
  final String propertyCity;
  final double unlockFee; // e.g. 500.0
  final double gstTaxAmount; // e.g. 90.0 (18%)
  final double totalPaid; // 590.0
  final PaymentStatus paymentStatus;
  final String paymentGatewayRef;
  final bool isUnlockedSuccessfully;
  final String deliveryStatusSms;
  final String deliveryStatusWhatsApp;
  final DateTime unlockedAt;
  final DateTime accessExpiresAt;
  final bool isRefunded;

  const PropertyUnlockTransaction({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.customerEmail,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyCity,
    required this.unlockFee,
    required this.gstTaxAmount,
    required this.totalPaid,
    this.paymentStatus = PaymentStatus.successful,
    required this.paymentGatewayRef,
    this.isUnlockedSuccessfully = true,
    this.deliveryStatusSms = 'DELIVERED',
    this.deliveryStatusWhatsApp = 'DELIVERED',
    required this.unlockedAt,
    required this.accessExpiresAt,
    this.isRefunded = false,
  });
}

// =============================================================================
// 4. MATERIALS PROCUREMENT ENTITIES
// =============================================================================

class SupplierAssociation {
  final String vendorId; // Homio Vendor Entity link
  final String vendorName;
  final String vendorCode;
  final double vendorRating;
  final String region;
  final double supplierPrice;
  final int leadTimeDays;
  final int minimumOrderQty;
  final bool isPreferred;
  final bool isPrimary;
  final DateTime lastUpdated;

  const SupplierAssociation({
    required this.vendorId,
    required this.vendorName,
    required this.vendorCode,
    required this.vendorRating,
    required this.region,
    required this.supplierPrice,
    required this.leadTimeDays,
    required this.minimumOrderQty,
    this.isPreferred = false,
    this.isPrimary = true,
    required this.lastUpdated,
  });
}

class MaterialProductEntity {
  final String id;
  final String name;
  final String sku;
  final String materialCode;
  final String categoryId;
  final String categoryName;
  final String subcategory;
  final String brandName;
  final String manufacturer;
  final String coverImageUrl;
  final String shortDescription;
  final String fullDescription;
  final List<String> tags;

  // Technical Specs
  final String materialType; // Gurjan Plywood, Italian Statuario, Brass Fitting
  final String grade; // BWP Grade 710, Premium Extra
  final String isStandardCertification; // IS:710, ISO 9001
  final String dimensions; // 8x4 ft x 18mm
  final String thickness; // 18 mm, 12 mm
  final String finish; // Suede, High Gloss, Polished
  final String colour;
  final String application; // Wardrobes, Flooring, Wet Areas
  final String careInstructions;
  final String warrantyPeriod;
  final String countryOfOrigin;

  // Commercials
  final MaterialUnit unitOfMeasure;
  final double wholesalePrice;
  final double retailMrp;
  final double tradePrice;
  final double taxRate;
  final String currency;

  // Ordering & Inventory
  final int minOrderQuantity;
  final int maxOrderQuantity;
  final int orderIncrement;
  final int stockAvailableUnits;
  final int leadTimeDays;
  final String deliveryZones; // Pan India, Metro NCR, South Hub
  final double deliveryChargesPerUnit;
  final bool preOrderEnabled;

  // Primary Supplier Link
  final SupplierAssociation primarySupplier;
  final List<SupplierAssociation> alternateSuppliers;

  // Status
  final ProductPublicationStatus publicationStatus;
  final ListingStatus inventoryStatus;
  final bool isFeatured;
  final double rating;
  final int ordersCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MaterialProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.materialCode,
    required this.categoryId,
    required this.categoryName,
    required this.subcategory,
    required this.brandName,
    required this.manufacturer,
    required this.coverImageUrl,
    required this.shortDescription,
    required this.fullDescription,
    required this.tags,
    required this.materialType,
    required this.grade,
    required this.isStandardCertification,
    required this.dimensions,
    required this.thickness,
    required this.finish,
    required this.colour,
    required this.application,
    required this.careInstructions,
    required this.warrantyPeriod,
    required this.countryOfOrigin,
    required this.unitOfMeasure,
    required this.wholesalePrice,
    required this.retailMrp,
    required this.tradePrice,
    required this.taxRate,
    this.currency = 'INR',
    required this.minOrderQuantity,
    this.maxOrderQuantity = 5000,
    this.orderIncrement = 1,
    required this.stockAvailableUnits,
    required this.leadTimeDays,
    required this.deliveryZones,
    this.deliveryChargesPerUnit = 0.0,
    this.preOrderEnabled = true,
    required this.primarySupplier,
    this.alternateSuppliers = const [],
    this.publicationStatus = ProductPublicationStatus.published,
    this.inventoryStatus = ListingStatus.active,
    this.isFeatured = false,
    this.rating = 4.9,
    this.ordersCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  double get contractorSavingsPercent => retailMrp > 0 ? (((retailMrp - wholesalePrice) / retailMrp) * 100).roundToDouble() : 0.0;

  MaterialProductEntity copyWith({
    String? id,
    String? name,
    String? sku,
    String? materialCode,
    String? categoryId,
    String? categoryName,
    String? subcategory,
    String? brandName,
    String? manufacturer,
    String? coverImageUrl,
    String? shortDescription,
    String? fullDescription,
    List<String>? tags,
    String? materialType,
    String? grade,
    String? isStandardCertification,
    String? dimensions,
    String? thickness,
    String? finish,
    String? colour,
    String? application,
    String? careInstructions,
    String? warrantyPeriod,
    String? countryOfOrigin,
    MaterialUnit? unitOfMeasure,
    double? wholesalePrice,
    double? retailMrp,
    double? tradePrice,
    double? taxRate,
    String? currency,
    int? minOrderQuantity,
    int? maxOrderQuantity,
    int? orderIncrement,
    int? stockAvailableUnits,
    int? leadTimeDays,
    String? deliveryZones,
    double? deliveryChargesPerUnit,
    bool? preOrderEnabled,
    SupplierAssociation? primarySupplier,
    List<SupplierAssociation>? alternateSuppliers,
    ProductPublicationStatus? publicationStatus,
    ListingStatus? inventoryStatus,
    bool? isFeatured,
    double? rating,
    int? ordersCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaterialProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      materialCode: materialCode ?? this.materialCode,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subcategory: subcategory ?? this.subcategory,
      brandName: brandName ?? this.brandName,
      manufacturer: manufacturer ?? this.manufacturer,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      tags: tags ?? this.tags,
      materialType: materialType ?? this.materialType,
      grade: grade ?? this.grade,
      isStandardCertification: isStandardCertification ?? this.isStandardCertification,
      dimensions: dimensions ?? this.dimensions,
      thickness: thickness ?? this.thickness,
      finish: finish ?? this.finish,
      colour: colour ?? this.colour,
      application: application ?? this.application,
      careInstructions: careInstructions ?? this.careInstructions,
      warrantyPeriod: warrantyPeriod ?? this.warrantyPeriod,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      retailMrp: retailMrp ?? this.retailMrp,
      tradePrice: tradePrice ?? this.tradePrice,
      taxRate: taxRate ?? this.taxRate,
      currency: currency ?? this.currency,
      minOrderQuantity: minOrderQuantity ?? this.minOrderQuantity,
      maxOrderQuantity: maxOrderQuantity ?? this.maxOrderQuantity,
      orderIncrement: orderIncrement ?? this.orderIncrement,
      stockAvailableUnits: stockAvailableUnits ?? this.stockAvailableUnits,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
      deliveryZones: deliveryZones ?? this.deliveryZones,
      deliveryChargesPerUnit: deliveryChargesPerUnit ?? this.deliveryChargesPerUnit,
      preOrderEnabled: preOrderEnabled ?? this.preOrderEnabled,
      primarySupplier: primarySupplier ?? this.primarySupplier,
      alternateSuppliers: alternateSuppliers ?? this.alternateSuppliers,
      publicationStatus: publicationStatus ?? this.publicationStatus,
      inventoryStatus: inventoryStatus ?? this.inventoryStatus,
      isFeatured: isFeatured ?? this.isFeatured,
      rating: rating ?? this.rating,
      ordersCount: ordersCount ?? this.ordersCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// =============================================================================
// 5. MARKETPLACE ORDER OPERATIONS ENTITIES
// =============================================================================

class MarketplaceOrderItem {
  final String id;
  final String productId;
  final String productName;
  final String productSku;
  final String productImageUrl;
  final OrderType itemType;
  final String? vendorId;
  final String? vendorName;
  final int quantity;
  final String unit; // pcs, sheets, licenses, unlock
  final double unitPrice;
  final double subtotal;
  final double taxAmount;
  final double totalPrice;
  final String itemNotes;
  final String fulfillmentStatus; // Pending, Assigned, Ready, PickedUp, Delivered

  const MarketplaceOrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.productImageUrl,
    required this.itemType,
    this.vendorId,
    this.vendorName,
    required this.quantity,
    this.unit = 'units',
    required this.unitPrice,
    required this.subtotal,
    required this.taxAmount,
    required this.totalPrice,
    this.itemNotes = '',
    this.fulfillmentStatus = 'Ready',
  });
}

class OrderTrackingEvent {
  final String id;
  final String eventName;
  final DateTime timestamp;
  final String location;
  final double? latitude;
  final double? longitude;
  final String? estimatedEta;
  final String executedBy;
  final String notes;

  const OrderTrackingEvent({
    required this.id,
    required this.eventName,
    required this.timestamp,
    required this.location,
    this.latitude,
    this.longitude,
    this.estimatedEta,
    required this.executedBy,
    required this.notes,
  });
}

class OrderRefundRecord {
  final String refundId;
  final double refundAmount;
  final String reason;
  final String refundStatus; // Requested, Approved, Processing, Completed, Failed
  final String gatewayReference;
  final DateTime requestedAt;
  final DateTime? processedAt;
  final String approvedBy;

  const OrderRefundRecord({
    required this.refundId,
    required this.refundAmount,
    required this.reason,
    required this.refundStatus,
    required this.gatewayReference,
    required this.requestedAt,
    this.processedAt,
    required this.approvedBy,
  });
}

class OrderCancellationRecord {
  final String reason;
  final String detailedNotes;
  final String cancelledBy;
  final DateTime cancelledAt;
  final bool isRefundInitiated;

  const OrderCancellationRecord({
    required this.reason,
    required this.detailedNotes,
    required this.cancelledBy,
    required this.cancelledAt,
    this.isRefundInitiated = true,
  });
}

class MarketplaceOrderEntity {
  final String id;
  final String orderNumber; // e.g. MKT-ORD-2026-00481
  final OrderType orderType;
  final String customerId; // Homio Customer Entity Link
  final String customerName;
  final String customerMobile;
  final String customerEmail;
  final String deliveryAddress;
  final String city;
  final String pinCode;

  final List<MarketplaceOrderItem> items;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final double paidAmount;
  final double outstandingAmount;
  final String currency;

  final OrderStatus orderStatus;
  final PaymentStatus paymentStatus;
  final DeliveryStatus deliveryStatus;

  // Vendor & Delivery Partner Assignment
  final String? assignedVendorId;
  final String? assignedVendorName;
  final DateTime? vendorAssignedAt;
  final DateTime? vendorConfirmedAt;
  final String? assignedDeliveryPartner;
  final String? deliveryPartnerContact;
  final DateTime? deliveryAssignedAt;
  final DateTime? estimatedDeliveryAt;
  final DateTime? actualDeliveredAt;

  // Payment Details
  final String paymentMethod; // Razorpay UPI, Net Banking, Credit Card, Trade Credit
  final String paymentGatewayRef;
  final DateTime? paymentCompletedAt;

  // Workflow Events & Logs
  final List<OrderTrackingEvent> trackingTimeline;
  final OrderRefundRecord? refundRecord;
  final OrderCancellationRecord? cancellationRecord;
  final String internalAdminNotes;

  final DateTime createdAt;
  final DateTime updatedAt;

  const MarketplaceOrderEntity({
    required this.id,
    required this.orderNumber,
    required this.orderType,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.customerEmail,
    required this.deliveryAddress,
    required this.city,
    required this.pinCode,
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.outstandingAmount,
    this.currency = 'INR',
    this.orderStatus = OrderStatus.placed,
    this.paymentStatus = PaymentStatus.successful,
    this.deliveryStatus = DeliveryStatus.unassigned,
    this.assignedVendorId,
    this.assignedVendorName,
    this.vendorAssignedAt,
    this.vendorConfirmedAt,
    this.assignedDeliveryPartner,
    this.deliveryPartnerContact,
    this.deliveryAssignedAt,
    this.estimatedDeliveryAt,
    this.actualDeliveredAt,
    required this.paymentMethod,
    required this.paymentGatewayRef,
    this.paymentCompletedAt,
    this.trackingTimeline = const [],
    this.refundRecord,
    this.cancellationRecord,
    this.internalAdminNotes = '',
    required this.createdAt,
    required this.updatedAt,
  });

  MarketplaceOrderEntity copyWith({
    String? id,
    String? orderNumber,
    OrderType? orderType,
    String? customerId,
    String? customerName,
    String? customerMobile,
    String? customerEmail,
    String? deliveryAddress,
    String? city,
    String? pinCode,
    List<MarketplaceOrderItem>? items,
    double? subtotal,
    double? discountAmount,
    double? taxAmount,
    double? totalAmount,
    double? paidAmount,
    double? outstandingAmount,
    String? currency,
    OrderStatus? orderStatus,
    PaymentStatus? paymentStatus,
    DeliveryStatus? deliveryStatus,
    String? assignedVendorId,
    String? assignedVendorName,
    DateTime? vendorAssignedAt,
    DateTime? vendorConfirmedAt,
    String? assignedDeliveryPartner,
    String? deliveryPartnerContact,
    DateTime? deliveryAssignedAt,
    DateTime? estimatedDeliveryAt,
    DateTime? actualDeliveredAt,
    String? paymentMethod,
    String? paymentGatewayRef,
    DateTime? paymentCompletedAt,
    List<OrderTrackingEvent>? trackingTimeline,
    OrderRefundRecord? refundRecord,
    OrderCancellationRecord? cancellationRecord,
    String? internalAdminNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MarketplaceOrderEntity(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderType: orderType ?? this.orderType,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerMobile: customerMobile ?? this.customerMobile,
      customerEmail: customerEmail ?? this.customerEmail,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      city: city ?? this.city,
      pinCode: pinCode ?? this.pinCode,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      outstandingAmount: outstandingAmount ?? this.outstandingAmount,
      currency: currency ?? this.currency,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      assignedVendorId: assignedVendorId ?? this.assignedVendorId,
      assignedVendorName: assignedVendorName ?? this.assignedVendorName,
      vendorAssignedAt: vendorAssignedAt ?? this.vendorAssignedAt,
      vendorConfirmedAt: vendorConfirmedAt ?? this.vendorConfirmedAt,
      assignedDeliveryPartner: assignedDeliveryPartner ?? this.assignedDeliveryPartner,
      deliveryPartnerContact: deliveryPartnerContact ?? this.deliveryPartnerContact,
      deliveryAssignedAt: deliveryAssignedAt ?? this.deliveryAssignedAt,
      estimatedDeliveryAt: estimatedDeliveryAt ?? this.estimatedDeliveryAt,
      actualDeliveredAt: actualDeliveredAt ?? this.actualDeliveredAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentGatewayRef: paymentGatewayRef ?? this.paymentGatewayRef,
      paymentCompletedAt: paymentCompletedAt ?? this.paymentCompletedAt,
      trackingTimeline: trackingTimeline ?? this.trackingTimeline,
      refundRecord: refundRecord ?? this.refundRecord,
      cancellationRecord: cancellationRecord ?? this.cancellationRecord,
      internalAdminNotes: internalAdminNotes ?? this.internalAdminNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// =============================================================================
// 6. APPROVALS, REVIEWS, MEDIA & GOVERNANCE
// =============================================================================

class MarketplaceApprovalItem {
  final String id;
  final ApprovalEntityType entityType;
  final String entityId;
  final String entityTitle;
  final String categoryName;
  final String submittedByName;
  final DateTime submittedAt;
  final String currentStatus; // Pending, InReview, Approved, Rejected, ChangesRequested
  final String reviewerName;
  final String priority; // High, Normal, Urgent
  final String missingInformation;
  final String? rejectionReason;
  final String? requiredChanges;

  const MarketplaceApprovalItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.entityTitle,
    required this.categoryName,
    required this.submittedByName,
    required this.submittedAt,
    this.currentStatus = 'Pending',
    required this.reviewerName,
    this.priority = 'Normal',
    this.missingInformation = 'None. All fields validated.',
    this.rejectionReason,
    this.requiredChanges,
  });
}

class MarketplaceReviewEntity {
  final String id;
  final String customerName;
  final String customerEmail;
  final String entityType; // Digital, Decor, Material, Property
  final String entityId;
  final String entityTitle;
  final String? orderId;
  final double rating;
  final String reviewTitle;
  final String reviewText;
  final bool isVerifiedPurchase;
  final DateTime submittedAt;
  final ReviewStatus status;
  final String? adminResponse;

  const MarketplaceReviewEntity({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.entityType,
    required this.entityId,
    required this.entityTitle,
    this.orderId,
    required this.rating,
    required this.reviewTitle,
    required this.reviewText,
    this.isVerifiedPurchase = true,
    required this.submittedAt,
    this.status = ReviewStatus.approved,
    this.adminResponse,
  });
}

class MarketplaceMediaItem {
  final String id;
  final String fileName;
  final String fileType; // Image, Video, PDF, 3D
  final String fileSize;
  final String fileUrl;
  final String linkedEntityType;
  final String linkedEntityTitle;
  final String uploadedBy;
  final DateTime uploadedAt;

  const MarketplaceMediaItem({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.fileUrl,
    required this.linkedEntityType,
    required this.linkedEntityTitle,
    required this.uploadedBy,
    required this.uploadedAt,
  });
}

/// Dynamic Configuration & Rules Engine
class MarketplaceConfig {
  final double propertyUnlockFee; // ₹500 default
  final double propertyUnlockGstRate; // 18% default
  final int propertyUnlockValidityDays; // 30 days default
  final bool notifyOwnerOnUnlock;
  final bool notifyCustomerViaWhatsapp;
  final int digitalDownloadLinkExpiryHours; // 48 hours default
  final int digitalMaxDownloads; // 5 downloads default
  final double defaultAffiliateCommissionRate; // 8.5%
  final int materialDeliverySlaDays; // 5 days
  final int maxOrderCancellationHours; // 24 hours
  final String supportContactEmail;
  final String supportContactPhone;

  const MarketplaceConfig({
    this.propertyUnlockFee = 500.0,
    this.propertyUnlockGstRate = 18.0,
    this.propertyUnlockValidityDays = 30,
    this.notifyOwnerOnUnlock = true,
    this.notifyCustomerViaWhatsapp = true,
    this.digitalDownloadLinkExpiryHours = 48,
    this.digitalMaxDownloads = 5,
    this.defaultAffiliateCommissionRate = 8.5,
    this.materialDeliverySlaDays = 5,
    this.maxOrderCancellationHours = 24,
    this.supportContactEmail = 'marketplace@homio.in',
    this.supportContactPhone = '+91 80 4567 8900',
  });

  MarketplaceConfig copyWith({
    double? propertyUnlockFee,
    double? propertyUnlockGstRate,
    int? propertyUnlockValidityDays,
    bool? notifyOwnerOnUnlock,
    bool? notifyCustomerViaWhatsapp,
    int? digitalDownloadLinkExpiryHours,
    int? digitalMaxDownloads,
    double? defaultAffiliateCommissionRate,
    int? materialDeliverySlaDays,
    int? maxOrderCancellationHours,
    String? supportContactEmail,
    String? supportContactPhone,
  }) {
    return MarketplaceConfig(
      propertyUnlockFee: propertyUnlockFee ?? this.propertyUnlockFee,
      propertyUnlockGstRate: propertyUnlockGstRate ?? this.propertyUnlockGstRate,
      propertyUnlockValidityDays: propertyUnlockValidityDays ?? this.propertyUnlockValidityDays,
      notifyOwnerOnUnlock: notifyOwnerOnUnlock ?? this.notifyOwnerOnUnlock,
      notifyCustomerViaWhatsapp: notifyCustomerViaWhatsapp ?? this.notifyCustomerViaWhatsapp,
      digitalDownloadLinkExpiryHours: digitalDownloadLinkExpiryHours ?? this.digitalDownloadLinkExpiryHours,
      digitalMaxDownloads: digitalMaxDownloads ?? this.digitalMaxDownloads,
      defaultAffiliateCommissionRate: defaultAffiliateCommissionRate ?? this.defaultAffiliateCommissionRate,
      materialDeliverySlaDays: materialDeliverySlaDays ?? this.materialDeliverySlaDays,
      maxOrderCancellationHours: maxOrderCancellationHours ?? this.maxOrderCancellationHours,
      supportContactEmail: supportContactEmail ?? this.supportContactEmail,
      supportContactPhone: supportContactPhone ?? this.supportContactPhone,
    );
  }
}

class MarketplaceAuditRecord {
  final String id;
  final String userName;
  final String userRole;
  final MarketplaceAuditAction action;
  final String entityName;
  final String entityId;
  final DateTime timestamp;
  final String oldValue;
  final String newValue;
  final String reason;
  final String ipAddress;

  const MarketplaceAuditRecord({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.action,
    required this.entityName,
    required this.entityId,
    required this.timestamp,
    required this.oldValue,
    required this.newValue,
    required this.reason,
    this.ipAddress = '192.168.1.104',
  });
}

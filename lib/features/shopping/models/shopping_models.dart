import 'package:flutter/material.dart';

/// Categories for proprietary digital guides & handbooks
enum GuideCategory {
  vastu(label: 'Vastu Shastra', icon: Icons.explore_rounded, color: Color(0xFFF59E0B)),
  interiorStyling(label: 'Interior Styling', icon: Icons.palette_rounded, color: Color(0xFF8B5CF6)),
  materials(label: 'Material Guide', icon: Icons.category_rounded, color: Color(0xFF10B981)),
  contractorPlaybook(label: 'Contractor Playbook', icon: Icons.construction_rounded, color: Color(0xFF3B82F6)),
  kitchenErgonomics(label: 'Kitchen Ergonomics', icon: Icons.kitchen_rounded, color: Color(0xFFEC4899));

  final String label;
  final IconData icon;
  final Color color;

  const GuideCategory({
    required this.label,
    required this.icon,
    required this.color,
  });
}

/// Categories for curated home decor items (affiliates)
enum DecorCategory {
  furniture(label: 'Luxury Furniture', icon: Icons.chair_rounded),
  lighting(label: 'Lighting & Chandeliers', icon: Icons.light_rounded),
  wallArt(label: 'Wall Art & Sculptures', icon: Icons.image_rounded),
  softFurnishings(label: 'Soft Furnishings & Rugs', icon: Icons.curtains_rounded),
  decorAccents(label: 'Artifacts & Accents', icon: Icons.spa_rounded);

  final String label;
  final IconData icon;

  const DecorCategory({
    required this.label,
    required this.icon,
  });
}

/// Categories for wholesale construction & interior finish materials
enum MaterialCategory {
  plywoodBoards(label: 'Plywood & Boards', icon: Icons.layers_rounded),
  tilesMarble(label: 'Tiles & Italian Marble', icon: Icons.grid_view_rounded),
  hardwareFittings(label: 'Architectural Hardware', icon: Icons.hardware_rounded),
  paintsFinishes(label: 'Luxury Paints & Wall Finishes', icon: Icons.format_paint_rounded),
  electricals(label: 'Designer Switches & Automation', icon: Icons.electrical_services_rounded);

  final String label;
  final IconData icon;

  const MaterialCategory({
    required this.label,
    required this.icon,
  });
}

/// Property structural type
enum PropertyType {
  luxuryApartment(label: 'Luxury Apartment', icon: Icons.apartment_rounded),
  penthouse(label: 'Duplex Penthouse', icon: Icons.location_city_rounded),
  builderFloor(label: 'Independent Builder Floor', icon: Icons.domain_rounded),
  villa(label: 'Gated Luxury Villa', icon: Icons.home_work_rounded),
  commercialOffice(label: 'Commercial Studio / Office', icon: Icons.business_rounded);

  final String label;
  final IconData icon;

  const PropertyType({
    required this.label,
    required this.icon,
  });
}

/// Property listing transaction intent
enum ListingIntent {
  rent(label: 'For Rent', color: Color(0xFF10B981)),
  sale(label: 'For Resale', color: Color(0xFF3B82F6));

  final String label;
  final Color color;

  const ListingIntent({
    required this.label,
    required this.color,
  });
}

/// Listing lifecycle status for Admin Management
enum ListingStatus {
  active(label: 'Active Listing', color: Color(0xFF10B981)),
  draft(label: 'Draft / In Review', color: Color(0xFFF59E0B)),
  rented(label: 'Rented / Sold', color: Color(0xFF6B7280)),
  archived(label: 'Archived', color: Color(0xFFEF4444));

  final String label;
  final Color color;

  const ListingStatus({required this.label, required this.color});
}

/// Digital Product / Guide Book Model
class DigitalProduct {
  final String id;
  final String title;
  final String subtitle;
  final GuideCategory category;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewsCount;
  final int pageCount;
  final String fileSize;
  final String coverImageUrl;
  final String description;
  final List<String> chapters;
  final List<String> sampleSnippets;
  final String authorName;
  final String authorTitle;
  final int downloadsCount;
  final String downloadUrl;
  final List<String> tags;
  bool isPurchased;
  ListingStatus status;
  int totalSalesCount;
  double grossRevenue;
  final DateTime? dateAdded;

  DigitalProduct({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.pageCount,
    required this.fileSize,
    required this.coverImageUrl,
    required this.description,
    required this.chapters,
    required this.sampleSnippets,
    required this.authorName,
    required this.authorTitle,
    required this.downloadsCount,
    required this.downloadUrl,
    required this.tags,
    this.isPurchased = false,
    this.status = ListingStatus.active,
    this.totalSalesCount = 0,
    this.grossRevenue = 0.0,
    this.dateAdded,
  });

  double get discountPercent => ((originalPrice - price) / originalPrice * 100).roundToDouble();
}

/// Home Decor Showcase Item (Monetized via Affiliate Redirection)
class DecorItem {
  final String id;
  final String title;
  final DecorCategory category;
  final String brand;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final String affiliatePartner; // Amazon, Pepperfry, Urban Ladder, West Elm
  final String affiliateUrl;
  final double commissionPercent;
  final bool inStock;
  final Map<String, String> specifications;
  final int leadTimeDays;
  ListingStatus status;
  int clickCount;
  double estimatedCommissionEarned;
  final DateTime? dateAdded;

  DecorItem({
    required this.id,
    required this.title,
    required this.category,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.affiliatePartner,
    required this.affiliateUrl,
    required this.commissionPercent,
    required this.inStock,
    required this.specifications,
    required this.leadTimeDays,
    this.status = ListingStatus.active,
    this.clickCount = 0,
    this.estimatedCommissionEarned = 0.0,
    this.dateAdded,
  });

  double get discountPercent => ((originalPrice - price) / originalPrice * 100).roundToDouble();
}

/// Direct In-App Wholesale Material Catalogue Item
class MaterialItem {
  final String id;
  final String name;
  final String brand;
  final MaterialCategory category;
  final String tradeUnit; // Per Sheet, Per Sq.Ft, Per Box, Per Drum
  double wholesalePrice;
  double retailMrp;
  final int minOrderQuantity;
  final String stockAvailable;
  final String specSheetUrl;
  final String supplierName;
  final String supplierCity;
  final int deliveryDays;
  final double rating;
  final String imageUrl;
  final List<String> keyFeatures;
  ListingStatus status;
  DateTime? lastPriceUpdated;

  MaterialItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.tradeUnit,
    required this.wholesalePrice,
    required this.retailMrp,
    required this.minOrderQuantity,
    required this.stockAvailable,
    required this.specSheetUrl,
    required this.supplierName,
    required this.supplierCity,
    required this.deliveryDays,
    required this.rating,
    required this.imageUrl,
    required this.keyFeatures,
    this.status = ListingStatus.active,
    this.lastPriceUpdated,
  });

  double get savingsPercent => ((retailMrp - wholesalePrice) / retailMrp * 100).roundToDouble();
}

/// Verified Rental & Resale Property Listing (Rs. 500 Paywall)
class PropertyListing {
  final String id;
  final String title;
  final PropertyType propertyType;
  final ListingIntent intent;
  final double monthlyRent;
  final double securityDeposit;
  final double salePrice;
  final int bedrooms;
  final int bathrooms;
  final int superAreaSqft;
  final int carpetAreaSqft;
  final String floorInfo;
  final String furnishing; // Fully Furnished, Semi Furnished, Luxury Designer
  final String societyName;
  final String address;
  final String city;
  final String zone;
  final List<String> images;
  final String walkthroughVideoUrl;
  final List<String> amenities;
  final bool isVerified;
  final String ownerName;
  final String ownerMaskedPhone;
  final String ownerRealPhone;
  final String ownerEmail;
  bool isUnlocked;
  final DateTime dateListed;
  ListingStatus status;
  int totalUnlocks;
  double grossUnlockRevenue;
  int leadInquiries;

  PropertyListing({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.intent,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.salePrice,
    required this.bedrooms,
    required this.bathrooms,
    required this.superAreaSqft,
    required this.carpetAreaSqft,
    required this.floorInfo,
    required this.furnishing,
    required this.societyName,
    required this.address,
    required this.city,
    required this.zone,
    required this.images,
    required this.walkthroughVideoUrl,
    required this.amenities,
    required this.isVerified,
    required this.ownerName,
    required this.ownerMaskedPhone,
    required this.ownerRealPhone,
    required this.ownerEmail,
    this.isUnlocked = false,
    required this.dateListed,
    this.status = ListingStatus.active,
    this.totalUnlocks = 0,
    this.grossUnlockRevenue = 0.0,
    this.leadInquiries = 0,
  });
}

/// Record of Rs. 500 owner unlock transaction
class PropertyUnlockRecord {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String unlockedByName;
  final String unlockedByPhone;
  final double paidAmount;
  final DateTime unlockedAt;
  final String transactionId;
  final String ownerName;
  final String ownerPhone;

  PropertyUnlockRecord({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.unlockedByName,
    required this.unlockedByPhone,
    required this.paidAmount,
    required this.unlockedAt,
    required this.transactionId,
    required this.ownerName,
    required this.ownerPhone,
  });
}

/// Digital Guide Purchase Transaction
class DigitalOrderRecord {
  final String id;
  final String productId;
  final String productTitle;
  final double amountPaid;
  final DateTime purchasedAt;
  final String customerName;
  final String customerPhone;
  final String downloadToken;

  DigitalOrderRecord({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.amountPaid,
    required this.purchasedAt,
    required this.customerName,
    required this.customerPhone,
    required this.downloadToken,
  });
}

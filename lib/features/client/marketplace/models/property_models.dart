import 'marketplace_enums.dart';

/// Premium verified property listing with gated owner contact unlock
class PropertyItem {
  final String id;
  final String title;
  final String locality;
  final String city;
  final String state;
  final double price; // Monthly rent or total sale price
  final String priceSuffix; // e.g. '/month' or 'Crores'
  final PropertyListingType listingType;
  final PropertyCategory category;
  final int bedrooms;
  final int bathrooms;
  final int carpetAreaSqFt;
  final int superAreaSqFt;
  final String furnishingStatus;
  final int parkingSpots;
  final String availableFrom;
  final List<String> imageUrls;
  final String? floorPlanUrl;
  final bool isVastuCompliant;
  final String vastuFacing;
  final String reraNumber;
  final bool isHomioVerified;
  final double unlockFee;
  final bool isUnlocked;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final List<String> amenities;
  final String description;
  final double latitude;
  final double longitude;

  const PropertyItem({
    required this.id,
    required this.title,
    required this.locality,
    required this.city,
    required this.state,
    required this.price,
    required this.priceSuffix,
    required this.listingType,
    required this.category,
    required this.bedrooms,
    required this.bathrooms,
    required this.carpetAreaSqFt,
    required this.superAreaSqFt,
    required this.furnishingStatus,
    this.parkingSpots = 1,
    required this.availableFrom,
    required this.imageUrls,
    this.floorPlanUrl,
    this.isVastuCompliant = true,
    this.vastuFacing = 'East Facing',
    required this.reraNumber,
    this.isHomioVerified = true,
    this.unlockFee = 500.0,
    this.isUnlocked = false,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    this.amenities = const [],
    required this.description,
    this.latitude = 12.9716,
    this.longitude = 77.5946,
  });

  String get formattedPrice {
    if (listingType == PropertyListingType.rental) {
      return '₹${price.toStringAsFixed(0)}$priceSuffix';
    } else {
      if (price >= 10000000) {
        return '₹${(price / 10000000).toStringAsFixed(2)} Cr';
      } else {
        return '₹${(price / 100000).toStringAsFixed(2)} Lakhs';
      }
    }
  }

  String get formattedArea => '$carpetAreaSqFt sq.ft carpet ($superAreaSqFt built-up)';
  String get fullAddress => '$locality, $city, $state';

  PropertyItem copyWith({
    bool? isUnlocked,
  }) {
    return PropertyItem(
      id: id,
      title: title,
      locality: locality,
      city: city,
      state: state,
      price: price,
      priceSuffix: priceSuffix,
      listingType: listingType,
      category: category,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      carpetAreaSqFt: carpetAreaSqFt,
      superAreaSqFt: superAreaSqFt,
      furnishingStatus: furnishingStatus,
      parkingSpots: parkingSpots,
      availableFrom: availableFrom,
      imageUrls: imageUrls,
      floorPlanUrl: floorPlanUrl,
      isVastuCompliant: isVastuCompliant,
      vastuFacing: vastuFacing,
      reraNumber: reraNumber,
      isHomioVerified: isHomioVerified,
      unlockFee: unlockFee,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      ownerName: ownerName,
      ownerPhone: ownerPhone,
      ownerEmail: ownerEmail,
      amenities: amenities,
      description: description,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

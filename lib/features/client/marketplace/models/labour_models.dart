import 'marketplace_enums.dart';

/// Verified tradesman profile for on-demand booking
class LabourWorkerProfile {
  final String id;
  final String name;
  final LabourTradeCategory trade;
  final LabourSkillLevel skillLevel;
  final double dailyWage;
  final double hourlyRate;
  final double rating;
  final int reviewCount;
  final int jobsCompleted;
  final int yearsExperience;
  final String city;
  final String locality;
  final String photoUrl;
  final bool isBackgroundVerified;
  final bool isPoliceVerified;
  final bool isInsuranceCovered;
  final List<String> languages;
  final List<String> toolsOwned;
  final List<String> certifications;
  final String availabilityStatus;
  final String bio;
  final String phone;

  const LabourWorkerProfile({
    required this.id,
    required this.name,
    required this.trade,
    required this.skillLevel,
    required this.dailyWage,
    required this.hourlyRate,
    required this.rating,
    required this.reviewCount,
    required this.jobsCompleted,
    required this.yearsExperience,
    required this.city,
    required this.locality,
    required this.photoUrl,
    this.isBackgroundVerified = true,
    this.isPoliceVerified = true,
    this.isInsuranceCovered = true,
    this.languages = const ['English', 'Hindi'],
    this.toolsOwned = const [],
    this.certifications = const [],
    this.availabilityStatus = 'Available Immediately',
    required this.bio,
    this.phone = '+91 98765 43210',
  });

  String get formattedDailyWage => '₹${dailyWage.toStringAsFixed(0)} / day';
  String get formattedHourlyRate => '₹${hourlyRate.toStringAsFixed(0)} / hr';
}

/// Standardized fixed-scope service booking package
class LabourServicePackage {
  final String id;
  final String title;
  final LabourTradeCategory trade;
  final String shortDescription;
  final List<String> scopeChecklist;
  final double fixedPrice;
  final int estimatedHours;
  final bool isPopular;
  final List<String> inclusions;
  final List<String> exclusions;
  final String warrantyPeriod;

  const LabourServicePackage({
    required this.id,
    required this.title,
    required this.trade,
    required this.shortDescription,
    required this.scopeChecklist,
    required this.fixedPrice,
    required this.estimatedHours,
    this.isPopular = false,
    this.inclusions = const [],
    this.exclusions = const [],
    this.warrantyPeriod = '30-Day Workmanship Warranty',
  });

  String get formattedPrice => '₹${fixedPrice.toStringAsFixed(0)}';
}

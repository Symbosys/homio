import 'package:flutter/material.dart';

// ============================================================================
// 1. AI WALLET & COMMERCIAL 50-50 REVENUE SPLIT MODEL
// ============================================================================

class AiWalletModel {
  int totalTokens;
  int freeDoubtQueriesRemaining;
  double platformCommissionRate;
  double designerRevenueShareRate;
  final List<AiRevenueSplitRecord> transactionHistory;

  AiWalletModel({
    this.totalTokens = 350,
    this.freeDoubtQueriesRemaining = 3,
    this.platformCommissionRate = 50.0,
    this.designerRevenueShareRate = 50.0,
    List<AiRevenueSplitRecord>? transactionHistory,
  }) : transactionHistory = transactionHistory ?? [];
}

enum RevenueSplitType {
  roomRenderDebit('4K AI Room Render', 100.0),
  walkthroughVideoDebit('3D Walkthrough Video', 250.0),
  doubtSolverDebit('Expert Doubt Query', 50.0),
  videoConsultationDebit('30-Min Video Consultation', 300.0);

  final String label;
  final double defaultAmount;
  const RevenueSplitType(this.label, this.defaultAmount);
}

class AiRevenueSplitRecord {
  final String id;
  final RevenueSplitType type;
  final double totalAmount;
  final double platformShare;
  final double designerShare;
  final String designerName;
  final String clientName;
  final DateTime timestamp;
  final String status;

  AiRevenueSplitRecord({
    required this.id,
    required this.type,
    required this.totalAmount,
    required this.platformShare,
    required this.designerShare,
    required this.designerName,
    required this.clientName,
    required this.timestamp,
    this.status = 'Settled (50-50)',
  });
}

// ============================================================================
// 2. ROOM GENERATOR & 3D VIDEO MODELS
// ============================================================================

enum AiRoomType {
  livingRoom('Living Room', Icons.weekend_rounded),
  masterBedroom('Master Bedroom', Icons.bed_rounded),
  modularKitchen('Modular Kitchen', Icons.countertops_rounded),
  bathroomVanity('Bathroom & Vanity', Icons.bathtub_rounded),
  balconyLounge('Balcony Lounge', Icons.deck_rounded),
  diningArea('Dining Area', Icons.table_restaurant_rounded),
  commercialOffice('Home Office / Studio', Icons.work_rounded);

  final String label;
  final IconData icon;
  const AiRoomType(this.label, this.icon);
}

enum AiDesignTheme {
  modernMinimalist(
    'Modern Minimalist',
    'Fluted wood louvers, concealed linear LEDs, clean symmetry & warm greige tones',
  ),
  scandinavian(
    'Scandinavian',
    'Light oak carpentry, breezy whites, linen textures & cozy boucle accents',
  ),
  neoClassical(
    'Neo-Classical',
    'Geometric wall mouldings, champagne brass profiles, marble trims & symmetry',
  ),
  luxuryContemporary(
    'Luxury Contemporary',
    'Bookmatched Italian marble wall, dark smoked veneers & warm cove glow',
  ),
  industrialLoft(
    'Industrial Loft',
    'Exposed dark concrete, black steel grids, Edison filaments & aged leather',
  ),
  bohemian(
    'Bohemian Eclectic',
    'Natural rattan, earthy terracotta accents, lush greenery & woven textiles',
  ),
  japandi(
    'Japandi Organic',
    'Wabi-sabi plaster walls, low-profile slatted timber, stone basins & muted earth',
  );

  final String label;
  final String desc;
  const AiDesignTheme(this.label, this.desc);
}

enum AiLightingCondition {
  daylight(
    'Daylight Natural',
    '5500K bright sunbeams pouring through panoramic glazing',
    Icons.wb_sunny_rounded,
  ),
  warmEvening(
    'Warm Ambient',
    '3000K golden architectural illumination with recessed cove LEDs',
    Icons.nightlight_round,
  ),
  studioBright(
    'Studio Focus',
    '4000K balanced commercial luminaire with crisp shadow lines',
    Icons.highlight_rounded,
  ),
  nightMoody(
    'Night Moody',
    '2700K moody accent lighting with focused spotlights on feature walls',
    Icons.bedtime_rounded,
  );

  final String label;
  final String desc;
  final IconData icon;
  const AiLightingCondition(this.label, this.desc, this.icon);
}

enum AiColorPalette {
  warmNeutrals('Warm Neutrals', [Color(0xFFF5EBE0), Color(0xFFD6CCC2), Color(0xFFE3D5CA)]),
  lightPastels('Light Pastels', [Color(0xFFE8F0FE), Color(0xFFF3E8FF), Color(0xFFFEF3C7)]),
  vibrantJewel('Vibrant Jewel Tones', [Color(0xFF0F766E), Color(0xFF7E22CE), Color(0xFFB45309)]),
  earthyTerracotta('Earthy Terracotta', [Color(0xFF9C4136), Color(0xFFC06C4E), Color(0xFFD99B6A)]),
  monochromeDark('Monochrome Charcoal', [Color(0xFF1E293B), Color(0xFF334155), Color(0xFF64748B)]);

  final String label;
  final List<Color> sampleColors;
  const AiColorPalette(this.label, this.sampleColors);
}

class BoqSpecificationItem {
  final String category;
  final String itemName;
  final String materialSpec;
  final String quantity;
  final double unitCost;
  final double totalCost;

  BoqSpecificationItem({
    required this.category,
    required this.itemName,
    required this.materialSpec,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
  });
}

class AiRoomGenerationItem {
  final String id;
  final String title;
  final AiRoomType roomType;
  final AiDesignTheme theme;
  final AiLightingCondition lighting;
  final AiColorPalette colorPalette;
  final String prompt;
  final String rawPhotoUrl;
  final String renderPhotoUrl;
  final String videoWalkthroughUrl;
  double splitSliderPosition; // 0.0 to 1.0 for interactive before/after
  final List<BoqSpecificationItem> boqItems;
  final DateTime createdAt;
  final String designerAssigned;
  final double renderCost;

  AiRoomGenerationItem({
    required this.id,
    required this.title,
    required this.roomType,
    required this.theme,
    required this.lighting,
    required this.colorPalette,
    required this.prompt,
    required this.rawPhotoUrl,
    required this.renderPhotoUrl,
    required this.videoWalkthroughUrl,
    this.splitSliderPosition = 0.5,
    required this.boqItems,
    required this.createdAt,
    this.designerAssigned = 'Pooja Hegde (Senior Interior Architect)',
    this.renderCost = 100.0,
  });
}

// ============================================================================
// 3. AI VASTU SHASTRA 16-ZONE & REMEDIES MODELS
// ============================================================================

enum VastuZoneStatus {
  auspicious('Auspicious', Color(0xFF10B981)),
  minorImbalance('Minor Imbalance', Color(0xFFF59E0B)),
  severeDosha('Severe Defect (Dosha)', Color(0xFFEF4444)),
  remedied('Cured via Non-Demolition Remedy', Color(0xFF8B5CF6));

  final String label;
  final Color color;
  const VastuZoneStatus(this.label, this.color);
}

class VastuZoneDetail {
  final String zoneCode; // e.g., 'NE', 'NNE', 'E', etc.
  final String zoneName; // e.g., 'North-East (Ishanya)'
  final double degreeStart;
  final double degreeEnd;
  final String element; // Water, Fire, Earth, Air, Space
  final String rulingDeity;
  final String recommendedColor;
  final String currentRoomPlacement;
  final VastuZoneStatus status;
  final String diagnosticNotes;
  final String remedyAdvice;

  VastuZoneDetail({
    required this.zoneCode,
    required this.zoneName,
    required this.degreeStart,
    required this.degreeEnd,
    required this.element,
    required this.rulingDeity,
    required this.recommendedColor,
    required this.currentRoomPlacement,
    required this.status,
    required this.diagnosticNotes,
    required this.remedyAdvice,
  });
}

class VastuRemedyItem {
  final String title;
  final String targetedDosha;
  final String nonDemolitionMethod; // e.g. 'Copper energy strip installed flush in flooring threshold'
  final String materialUsed;
  final double estimatedCost;
  final bool isApplied;

  VastuRemedyItem({
    required this.title,
    required this.targetedDosha,
    required this.nonDemolitionMethod,
    required this.materialUsed,
    required this.estimatedCost,
    this.isApplied = false,
  });
}

class VastuAuditReport {
  final String id;
  final String projectName;
  final String clientName;
  final String floorPlanImageUrl;
  final double northOrientationDegrees;
  final int overallComplianceScore; // 0 to 100
  final List<VastuZoneDetail> zones;
  final List<VastuRemedyItem> recommendedRemedies;
  final DateTime auditedAt;

  VastuAuditReport({
    required this.id,
    required this.projectName,
    required this.clientName,
    required this.floorPlanImageUrl,
    required this.northOrientationDegrees,
    required this.overallComplianceScore,
    required this.zones,
    required this.recommendedRemedies,
    required this.auditedAt,
  });
}

// ============================================================================
// 4. AI BUDGET & MATERIAL COST ESTIMATOR MODELS
// ============================================================================

enum FurnitureItemType {
  modularWardrobe('Modular Wardrobe (Hinged / Sliding)', Icons.door_sliding_rounded),
  modularKitchen('Modular Kitchen (L-Shape / Island / Parallel)', Icons.countertops_rounded),
  tvUnit('TV Entertainment Console & Fluted Panelling', Icons.tv_rounded),
  bathroomVanity('Bathroom Vanity Counter & Under-Sink Storage', Icons.bathtub_rounded),
  crockeryUnit('Dining Room Crockery Display & Bar Unit', Icons.wine_bar_rounded),
  falseCeiling('Architectural False Ceiling with Cove Framing', Icons.roofing_rounded),
  wallPanelling('Acoustic Fluted Wall Panelling / Louvers', Icons.grid_view_rounded);

  final String label;
  final IconData icon;
  const FurnitureItemType(this.label, this.icon);
}

enum SubstrateType {
  commercialMr('Commercial MR Plywood (IS 303)', 'Moisture resistant core for dry zone storage', 75.0),
  bwrGrade('BWR Grade Plywood (Boiling Water Resistant)', 'Synthetic resin bonded for semi-wet zones', 95.0),
  bwpMarine('BWP Marine Grade Plywood (IS 710)', '100% waterproof gurjan core for wet kitchens/toilets', 130.0),
  hdhmrBoard('HDHMR Board (Action TESA / Century)', 'High density moisture resistant termite-proof engineered board', 110.0);

  final String label;
  final String desc;
  final double ratePerSqFt;
  const SubstrateType(this.label, this.desc, this.ratePerSqFt);
}

enum FinishType {
  matteLaminate('0.8mm / 1.0mm Matte Laminate', 'Scratch resistant anti-reflective surface', 65.0),
  acrylicHighGloss('High Gloss Acrylic Sheet (2.0mm)', 'Mirror glass luster & seamless edge banding', 160.0),
  naturalVeneer('Natural Wood Veneer + PU Polish', 'Exotic walnut/teak grain with 6-coat polyurethane', 280.0),
  puDecoPaint('PU / Deco Paint Spray Finish', 'Velvet satin architectural spray lacquer', 210.0);

  final String label;
  final String desc;
  final double ratePerSqFt;
  const FinishType(this.label, this.desc, this.ratePerSqFt);
}

enum HardwareTier {
  standardSoftClose('Standard Soft-Close Hinges & Channels', 'Reliable smooth closing tested to 50k cycles', 25.0),
  telescopicHeavy('Telescopic Ball-Bearing Drawer Slides', 'Heavy duty 45kg load bearing drawer runners', 45.0),
  hydraulicLift('Bi-Fold Hydraulic Lift-Ups & Tandem Boxes', 'Effortless top-opening overhead cabinet access', 80.0),
  premiumEuropean('Premium European Fittings (Blum / Hafele / Hettich)', 'Lifetime warranty silent motion dampers & organizers', 140.0);

  final String label;
  final String desc;
  final double ratePerSqFt;
  const HardwareTier(this.label, this.desc, this.ratePerSqFt);
}

class BrandRecommendation {
  final String category;
  final String brandName;
  final String tagline;
  final String qualityGrade;
  final String warrantyYears;
  final String marketShare;
  final String logoText;
  final Color brandColor;

  BrandRecommendation({
    required this.category,
    required this.brandName,
    required this.tagline,
    required this.qualityGrade,
    required this.warrantyYears,
    required this.marketShare,
    required this.logoText,
    required this.brandColor,
  });
}

class VendorContactCard {
  final String vendorName;
  final String companyName;
  final String cityRegion;
  final String phone;
  final String wholesaleDiscount;
  final double rating;
  final bool isVerified;
  final List<String> authorizedBrands;

  VendorContactCard({
    required this.vendorName,
    required this.companyName,
    required this.cityRegion,
    required this.phone,
    required this.wholesaleDiscount,
    required this.rating,
    this.isVerified = true,
    required this.authorizedBrands,
  });
}

class BudgetCalculationResult {
  final FurnitureItemType itemType;
  final double widthFeet;
  final double heightFeet;
  final double depthFeet;
  final int quantity;
  final SubstrateType substrate;
  final FinishType finish;
  final HardwareTier hardware;
  final double surfaceAreaSqFt;
  final double substrateCost;
  final double finishCost;
  final double hardwareCost;
  final double labourCarpentryCost;
  final double adhesivesAndConsumablesCost;
  final double estimatedTotalCost;
  final List<BrandRecommendation> top3Brands;
  final List<VendorContactCard> verifiedVendors;

  BudgetCalculationResult({
    required this.itemType,
    required this.widthFeet,
    required this.heightFeet,
    required this.depthFeet,
    required this.quantity,
    required this.substrate,
    required this.finish,
    required this.hardware,
    required this.surfaceAreaSqFt,
    required this.substrateCost,
    required this.finishCost,
    required this.hardwareCost,
    required this.labourCarpentryCost,
    required this.adhesivesAndConsumablesCost,
    required this.estimatedTotalCost,
    required this.top3Brands,
    required this.verifiedVendors,
  });
}

// ============================================================================
// 5. AI EXPERT DOUBT SOLVER MODELS (FREEMIUM: 3 FREE + RS. 50 / QUESTION)
// ============================================================================

enum DoubtCategory {
  materialQuality('Material Durability & Standards', Icons.inventory_2_rounded),
  rateCards('Prevailing Market Rates & Labour', Icons.currency_rupee_rounded),
  waterproofing('Waterproofing & Plumbing Snags', Icons.water_drop_rounded),
  structuralCeiling('Structural & False Ceiling Snags', Icons.architecture_rounded),
  vastuGuidelines('Vastu & Spatial Compliance', Icons.compass_calibration_rounded);

  final String label;
  final IconData icon;
  const DoubtCategory(this.label, this.icon);
}

class DoubtQueryMessage {
  final String id;
  final bool isFromUser;
  final String content;
  final DateTime timestamp;
  final DoubtCategory? category;
  final bool isPaidQuery;
  final double cost;
  final List<String>? actionChecklist;
  final String? mistakeSavedAmountNote;

  DoubtQueryMessage({
    required this.id,
    required this.isFromUser,
    required this.content,
    required this.timestamp,
    this.category,
    this.isPaidQuery = false,
    this.cost = 0.0,
    this.actionChecklist,
    this.mistakeSavedAmountNote,
  });
}

// ============================================================================
// 6. ON-DEMAND 30-MIN VIDEO CONSULTATION (RS. 300 / SESSION)
// ============================================================================

enum DesignerAvailability {
  online('Online Now (Instant Connect)', Color(0xFF10B981)),
  inCall('In Consultation (Next in 15m)', Color(0xFFF59E0B)),
  offline('Offline (Schedule Slot)', Color(0xFF94A3B8));

  final String label;
  final Color color;
  const DesignerAvailability(this.label, this.color);
}

class DesignerConsultant {
  final String id;
  final String name;
  final String title;
  final String qualification;
  final double rating;
  final int totalConsultations;
  final int yearsExperience;
  final DesignerAvailability availability;
  final String avatarUrl;
  final List<String> specializations;
  final double sessionFee; // Flat Rs. 300

  DesignerConsultant({
    required this.id,
    required this.name,
    required this.title,
    required this.qualification,
    required this.rating,
    required this.totalConsultations,
    required this.yearsExperience,
    required this.availability,
    required this.avatarUrl,
    required this.specializations,
    this.sessionFee = 300.0,
  });

  DesignerConsultant copyWith({
    String? id,
    String? name,
    String? title,
    String? qualification,
    double? rating,
    int? totalConsultations,
    int? yearsExperience,
    DesignerAvailability? availability,
    String? avatarUrl,
    List<String>? specializations,
    double? sessionFee,
  }) {
    return DesignerConsultant(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      qualification: qualification ?? this.qualification,
      rating: rating ?? this.rating,
      totalConsultations: totalConsultations ?? this.totalConsultations,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      availability: availability ?? this.availability,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      specializations: specializations ?? this.specializations,
      sessionFee: sessionFee ?? this.sessionFee,
    );
  }
}

class BookedConsultationSession {
  final String id;
  final String clientName;
  final String clientPhone;
  final DesignerConsultant expert;
  final DateTime scheduledTime;
  final double feePaid;
  final String status; // 'In Progress', 'Scheduled', 'Completed'
  final String meetingLink;

  BookedConsultationSession({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.expert,
    required this.scheduledTime,
    required this.feePaid,
    this.status = 'Scheduled',
    this.meetingLink = 'https://meet.homio.ai/room-consult-30',
  });
}

class WhiteboardStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  WhiteboardStroke({
    required this.points,
    required this.color,
    this.strokeWidth = 3.0,
  });
}

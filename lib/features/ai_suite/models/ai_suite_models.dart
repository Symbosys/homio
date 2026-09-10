import 'package:flutter/material.dart';

// ============================================================================
// 1. COMMERCIAL CONFIG & AUDIT MODELS
// ============================================================================

class AiCommercialConfig {
  double doubtQueryFee;
  int freeDoubtQueriesQuota;
  double consultation30MinFee;
  double platformRevenueSharePercent;
  double designerRevenueSharePercent;
  int roomDesignCreditCost;
  int vastuAnalysisCreditCost;
  int budgetEstimateCreditCost;
  double propertyContactUnlockFee;
  int walkthroughVideoCreditCost;

  // Getters & Setters for commercial aliases
  double get platformSharePercent => platformRevenueSharePercent;
  set platformSharePercent(double v) => platformRevenueSharePercent = v;

  double get designerSharePercent => designerRevenueSharePercent;
  set designerSharePercent(double v) => designerRevenueSharePercent = v;

  double get videoConsultationFee => consultation30MinFee;
  set videoConsultationFee(double v) => consultation30MinFee = v;

  int get roomRenderCreditCost => roomDesignCreditCost;
  set roomRenderCreditCost(int v) => roomDesignCreditCost = v;

  int get vastuCreditCost => vastuAnalysisCreditCost;
  set vastuCreditCost(int v) => vastuAnalysisCreditCost = v;

  int get freeDoubtQueriesCount => freeDoubtQueriesQuota;
  set freeDoubtQueriesCount(int v) => freeDoubtQueriesQuota = v;

  AiCommercialConfig({
    this.doubtQueryFee = 50.0,
    int? freeDoubtQueriesQuota,
    int? freeDoubtQueriesCount,
    double? consultation30MinFee,
    double? videoConsultationFee,
    double? platformRevenueSharePercent,
    double? platformSharePercent,
    double? designerRevenueSharePercent,
    double? designerSharePercent,
    int? roomDesignCreditCost,
    int? roomRenderCreditCost,
    int? vastuAnalysisCreditCost,
    int? vastuCreditCost,
    this.budgetEstimateCreditCost = 5,
    this.propertyContactUnlockFee = 500.0,
    this.walkthroughVideoCreditCost = 25,
  })  : freeDoubtQueriesQuota = freeDoubtQueriesQuota ?? freeDoubtQueriesCount ?? 3,
        consultation30MinFee = consultation30MinFee ?? videoConsultationFee ?? 300.0,
        platformRevenueSharePercent = platformRevenueSharePercent ?? platformSharePercent ?? 50.0,
        designerRevenueSharePercent = designerRevenueSharePercent ?? designerSharePercent ?? 50.0,
        roomDesignCreditCost = roomDesignCreditCost ?? roomRenderCreditCost ?? 10,
        vastuAnalysisCreditCost = vastuAnalysisCreditCost ?? vastuCreditCost ?? 15;

  AiCommercialConfig copyWith({
    double? doubtQueryFee,
    int? freeDoubtQueriesQuota,
    double? consultation30MinFee,
    double? platformRevenueSharePercent,
    double? designerRevenueSharePercent,
    int? roomDesignCreditCost,
    int? vastuAnalysisCreditCost,
    int? budgetEstimateCreditCost,
    double? propertyContactUnlockFee,
    int? walkthroughVideoCreditCost,
  }) {
    return AiCommercialConfig(
      doubtQueryFee: doubtQueryFee ?? this.doubtQueryFee,
      freeDoubtQueriesQuota: freeDoubtQueriesQuota ?? this.freeDoubtQueriesQuota,
      consultation30MinFee: consultation30MinFee ?? this.consultation30MinFee,
      platformRevenueSharePercent: platformRevenueSharePercent ?? this.platformRevenueSharePercent,
      designerRevenueSharePercent: designerRevenueSharePercent ?? this.designerRevenueSharePercent,
      roomDesignCreditCost: roomDesignCreditCost ?? this.roomDesignCreditCost,
      vastuAnalysisCreditCost: vastuAnalysisCreditCost ?? this.vastuAnalysisCreditCost,
      budgetEstimateCreditCost: budgetEstimateCreditCost ?? this.budgetEstimateCreditCost,
      propertyContactUnlockFee: propertyContactUnlockFee ?? this.propertyContactUnlockFee,
      walkthroughVideoCreditCost: walkthroughVideoCreditCost ?? this.walkthroughVideoCreditCost,
    );
  }
}

class AiAuditRecord {
  final String id;
  final String action;
  final String user;
  final String entity;
  final String previousValue;
  final String newValue;
  final DateTime timestamp;
  final String reason;

  AiAuditRecord({
    required this.id,
    required this.action,
    required this.user,
    required this.entity,
    required this.previousValue,
    required this.newValue,
    required this.timestamp,
    required this.reason,
  });
}

// ============================================================================
// 2. WALLET, CREDITS & TRANSACTIONS
// ============================================================================

class CreditPackage {
  final String id;
  final String title;
  final int credits;
  final double price;
  final int bonusCredits;
  final String validity;
  final bool isPopular;
  final String description;
  final String tagline;

  const CreditPackage({
    required this.id,
    required this.title,
    required this.credits,
    required this.price,
    this.bonusCredits = 0,
    this.validity = '365 Days',
    this.isPopular = false,
    required this.description,
    String? tagline,
  }) : tagline = tagline ?? description;

  int get totalCredits => credits + bonusCredits;
  double get effectiveCostPerCredit => price / totalCredits;
}

enum WalletTransactionType {
  purchase('Credit Purchase', Icons.add_card_rounded),
  roomDebit('Room Designer', Icons.bedroom_parent_outlined),
  vastuDebit('Vastu Analysis', Icons.explore_outlined),
  budgetDebit('Budget Estimate', Icons.calculate_outlined),
  doubtDebit('Doubt Solver Query', Icons.psychology_outlined),
  doubtSolverDebit('Doubt Solver Query', Icons.psychology_outlined),
  consultationDebit('Designer Video Call', Icons.video_camera_front_outlined),
  refund('Credit Refund', Icons.replay_rounded),
  bonus('Promotional Bonus', Icons.card_giftcard_rounded),
  adjustment('Admin Adjustment', Icons.tune_rounded);

  final String label;
  final IconData icon;
  const WalletTransactionType(this.label, this.icon);
}

class WalletTransaction {
  final String id;
  final DateTime date;
  final String title;
  final WalletTransactionType type;
  final int credits;
  final double rupeeAmount;
  final String status;
  final String referenceId;
  final String? clientName;
  final String? designerName;
  final double platformShare;
  final double designerShare;

  const WalletTransaction({
    required this.id,
    required this.date,
    required this.title,
    required this.type,
    required this.credits,
    required this.rupeeAmount,
    this.status = 'Completed',
    required this.referenceId,
    this.clientName,
    this.designerName,
    this.platformShare = 0.0,
    this.designerShare = 0.0,
  });
}

// ============================================================================
// 3. GPU ASYNCHRONOUS JOBS QUEUE
// ============================================================================

enum AiJobStatus {
  queued('Queued', Color(0xFF64748B), Icons.hourglass_top_rounded),
  processing('Processing', Color(0xFF3B82F6), Icons.sync_rounded),
  completed('Completed', Color(0xFF10B981), Icons.check_circle_outline_rounded),
  failed('Failed', Color(0xFFEF4444), Icons.error_outline_rounded),
  refunded('Refunded', Color(0xFF8B5CF6), Icons.replay_rounded),
  cancelled('Cancelled', Color(0xFF94A3B8), Icons.cancel_outlined);

  final String label;
  final Color color;
  final IconData icon;
  const AiJobStatus(this.label, this.color, this.icon);
}

class AiJobEntity {
  final String id;
  final String productType;
  final String title;
  final String user;
  final DateTime createdAt;
  DateTime? startedAt;
  DateTime? completedAt;
  AiJobStatus status;
  final int creditsCharged;
  final String prompt;
  String? failureReason;
  int retryCount;

  AiJobEntity({
    required this.id,
    required this.productType,
    required this.title,
    required this.user,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.status = AiJobStatus.completed,
    required this.creditsCharged,
    required this.prompt,
    this.failureReason,
    this.retryCount = 0,
  });

  Duration? get duration => completedAt != null && startedAt != null
      ? completedAt!.difference(startedAt!)
      : null;

  String get clientName => user;
  String? get errorReason => failureReason;
}

// ============================================================================
// 4. ROOM DESIGNER DOMAIN MODELS
// ============================================================================

enum AiRoomType {
  livingRoom('Living Room', Icons.weekend_rounded),
  bedroom('Bedroom', Icons.bed_rounded),
  masterBedroom('Master Bedroom', Icons.king_bed_rounded),
  kidsBedroom('Kids Bedroom', Icons.child_care_rounded),
  diningRoom('Dining Room', Icons.table_restaurant_rounded),
  kitchen('Kitchen', Icons.countertops_rounded),
  bathroom('Bathroom', Icons.bathtub_rounded),
  homeOffice('Home Office', Icons.work_rounded),
  balcony('Balcony', Icons.deck_rounded),
  entrance('Entrance Foyer', Icons.door_front_door_rounded),
  poojaRoom('Pooja Room', Icons.temple_hindu_rounded),
  wardrobeArea('Wardrobe Area', Icons.checkroom_rounded),
  commercialSpace('Commercial Space', Icons.store_rounded),
  other('Other (Custom)', Icons.category_rounded);

  final String label;
  final IconData icon;
  const AiRoomType(this.label, this.icon);
}

enum AiLightingMode {
  day('Day (Bright Ambient)', Icons.wb_sunny_rounded),
  night('Night (Concealed Warm LEDs)', Icons.nightlight_round),
  warm('Warm (3000K Golden Glow)', Icons.wb_incandescent_rounded),
  neutral('Neutral (4000K Natural White)', Icons.lightbulb_outline_rounded),
  cool('Cool (6000K Daylight White)', Icons.wb_cloudy_rounded),
  natural('Natural Sunlight Streams', Icons.filter_drama_rounded),
  custom('Custom Balanced Lighting', Icons.tune_rounded);

  final String label;
  final IconData icon;
  const AiLightingMode(this.label, this.icon);
}

enum AiDesignStyle {
  modern('Modern', 'Clean lines, minimalism, flush storage, neutral palettes'),
  contemporary('Contemporary', 'Curved accents, soft lighting, marble trims, textured fabrics'),
  minimal('Minimalist', 'Clutter-free, functional elegance, monotone tones, hidden handles'),
  classical('Classical Neo-Classic', 'Wall mouldings, wainscoting, gold brass trims, chandeliers'),
  luxury('Luxury Italian', 'Bookmatched marble, smoked veneer, warm cove lighting, brass accents'),
  scandinavian('Scandinavian', 'Light oak wood, pastel textiles, airy whites, boucle seating'),
  industrial('Industrial Loft', 'Exposed brick/concrete, black metal framing, Edison lamps'),
  traditional('Traditional Indian', 'Carved teak, brass urlis, jali partitions, rich jewel tones'),
  indianContemporary('Indian Contemporary', 'Fusion of ethnic brass motifs with sleek modern modularity'),
  japandi('Japandi', 'Japanese wabi-sabi simplicity fused with Scandinavian warmth'),
  rustic('Rustic Farmhouse', 'Rough-hewn timber, textured plaster, terracotta, earthy comfort'),
  other('Custom Concept', 'User-defined bespoke aesthetic moodboard');

  final String label;
  final String description;
  const AiDesignStyle(this.label, this.description);
}

enum AiColorPalette {
  light('Light & Airy', [Color(0xFFFFFFFF), Color(0xFFF8FAFC), Color(0xFFE2E8F0)]),
  neutral('Neutral Greige', [Color(0xFFF5F5F0), Color(0xFFE5E5DE), Color(0xFFD6D6CB)]),
  vibrant('Vibrant Accents', [Color(0xFF3B82F6), Color(0xFFF59E0B), Color(0xFF10B981)]),
  earthy('Earthy Terracotta', [Color(0xFFC27D5B), Color(0xFF8C533E), Color(0xFFEED7C5)]),
  monochrome('Monochrome Slate', [Color(0xFF0F172A), Color(0xFF475569), Color(0xFFCBD5E1)]),
  pastel('Pastel Serene', [Color(0xFFE0F2FE), Color(0xFFFCE7F3), Color(0xFFFEF3C7)]),
  custom('Custom Hex Palette', [Color(0xFF7C3AED), Color(0xFFEC4899), Color(0xFFF59E0B)]);

  final String label;
  final List<Color> sampleColors;
  const AiColorPalette(this.label, this.sampleColors);
}

class AiMaterialSpecItem {
  final String category;
  final String suggestedMaterial;
  final String specification;
  final double quantity;
  final String unit;

  const AiMaterialSpecItem({
    required this.category,
    required this.suggestedMaterial,
    required this.specification,
    required this.quantity,
    required this.unit,
  });
}

class AiRoomDesignEntity {
  final String id;
  final String title;
  final String projectName;
  final AiRoomType roomType;
  final String? customRoomType;
  final AiLightingMode lighting;
  final AiDesignStyle style;
  final AiColorPalette colorPalette;
  final String customRequirements;
  final double carpetAreaSqFt;
  final String originalImageUrl;
  final String generatedImageUrl;
  final DateTime createdAt;
  final int creditsUsed;
  final bool isSaved;
  final Map<String, bool> advancedSettings;
  final List<AiMaterialSpecItem> preliminarySpecs;

  const AiRoomDesignEntity({
    required this.id,
    required this.title,
    required this.projectName,
    required this.roomType,
    this.customRoomType,
    required this.lighting,
    required this.style,
    required this.colorPalette,
    required this.customRequirements,
    required this.carpetAreaSqFt,
    required this.originalImageUrl,
    required this.generatedImageUrl,
    required this.createdAt,
    required this.creditsUsed,
    this.isSaved = false,
    this.advancedSettings = const {},
    this.preliminarySpecs = const [],
  });

  AiRoomDesignEntity copyWith({
    String? id,
    String? title,
    String? projectName,
    AiRoomType? roomType,
    String? customRoomType,
    AiLightingMode? lighting,
    AiDesignStyle? style,
    AiColorPalette? colorPalette,
    String? customRequirements,
    double? carpetAreaSqFt,
    String? originalImageUrl,
    String? generatedImageUrl,
    DateTime? createdAt,
    int? creditsUsed,
    bool? isSaved,
    Map<String, bool>? advancedSettings,
    List<AiMaterialSpecItem>? preliminarySpecs,
  }) {
    return AiRoomDesignEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      projectName: projectName ?? this.projectName,
      roomType: roomType ?? this.roomType,
      customRoomType: customRoomType ?? this.customRoomType,
      lighting: lighting ?? this.lighting,
      style: style ?? this.style,
      colorPalette: colorPalette ?? this.colorPalette,
      customRequirements: customRequirements ?? this.customRequirements,
      carpetAreaSqFt: carpetAreaSqFt ?? this.carpetAreaSqFt,
      originalImageUrl: originalImageUrl ?? this.originalImageUrl,
      generatedImageUrl: generatedImageUrl ?? this.generatedImageUrl,
      createdAt: createdAt ?? this.createdAt,
      creditsUsed: creditsUsed ?? this.creditsUsed,
      isSaved: isSaved ?? this.isSaved,
      advancedSettings: advancedSettings ?? this.advancedSettings,
      preliminarySpecs: preliminarySpecs ?? this.preliminarySpecs,
    );
  }
}

// ============================================================================
// 5. VASTU CONSULTANT DOMAIN MODELS
// ============================================================================

enum VastuDirection {
  north('North (Kuber - Wealth)', 0.0),
  northeast('North-East / Ishanya (Water - Clarity & Puja)', 45.0),
  east('East / Indra (Social Connectivity)', 90.0),
  southeast('South-East / Agneya (Fire - Kitchen & Vitality)', 135.0),
  south('South / Yama (Fame & Relaxation)', 180.0),
  southwest('South-West / Nairutya (Earth - Master Bedroom & Stability)', 225.0),
  west('West / Varuna (Air - Profit & Gains)', 270.0),
  northwest('North-West / Vayavya (Movement & Guests)', 315.0);

  final String label;
  final double angleDegrees;
  const VastuDirection(this.label, this.angleDegrees);
}

class VastuZoneRecord {
  final String zone;
  final String element;
  final String currentCondition;
  final String assessment;
  final String recommendedAction;
  final String priority;

  const VastuZoneRecord({
    required this.zone,
    required this.element,
    required this.currentCondition,
    required this.assessment,
    required this.recommendedAction,
    this.priority = 'Medium',
  });
}

class VastuColorRecommendation {
  final String color;
  final String suggestedRoom;
  final String reason;

  const VastuColorRecommendation({
    required this.color,
    required this.suggestedRoom,
    required this.reason,
  });
}

class VastuFurniturePlacement {
  final String furniture;
  final String recommendedDirection;
  final String placement;
  final String notes;

  const VastuFurniturePlacement({
    required this.furniture,
    required this.recommendedDirection,
    required this.placement,
    required this.notes,
  });
}

class VastuRemedy {
  final String issue;
  final String recommendedRemedy;
  final String priority;
  final String implementationNote;

  const VastuRemedy({
    required this.issue,
    required this.recommendedRemedy,
    required this.priority,
    required this.implementationNote,
  });
}

class AiVastuReportEntity {
  final String id;
  final String projectName;
  final String propertyType;
  final double plotAreaSqFt;
  final double builtUpAreaSqFt;
  final int totalFloors;
  final int bedrooms;
  final int bathrooms;
  final VastuDirection entranceDirection;
  final VastuDirection kitchenDirection;
  final double northCalibratedDegrees;
  final int overallScore;
  final List<String> positiveObservations;
  final List<String> areasRequiringAttention;
  final List<VastuZoneRecord> zoneRecords;
  final List<VastuColorRecommendation> colorRecommendations;
  final List<VastuFurniturePlacement> furniturePlacements;
  final List<VastuRemedy> remedies;
  final DateTime createdAt;
  final int creditsUsed;
  final String floorPlanImageUrl;

  const AiVastuReportEntity({
    required this.id,
    required this.projectName,
    required this.propertyType,
    required this.plotAreaSqFt,
    required this.builtUpAreaSqFt,
    required this.totalFloors,
    required this.bedrooms,
    required this.bathrooms,
    required this.entranceDirection,
    required this.kitchenDirection,
    required this.northCalibratedDegrees,
    required this.overallScore,
    required this.positiveObservations,
    required this.areasRequiringAttention,
    required this.zoneRecords,
    required this.colorRecommendations,
    required this.furniturePlacements,
    required this.remedies,
    required this.createdAt,
    required this.creditsUsed,
    required this.floorPlanImageUrl,
  });
}

// ============================================================================
// 6. BUDGET CALCULATOR DOMAIN MODELS
// ============================================================================

class AiBudgetBoqItem {
  final String item;
  final String specification;
  final double quantity;
  final String unit;
  final double estimatedRate;
  final double estimatedAmount;

  const AiBudgetBoqItem({
    required this.item,
    required this.specification,
    required this.quantity,
    required this.unit,
    required this.estimatedRate,
    required this.estimatedAmount,
  });
}

class RecommendedBrandItem {
  final String brand;
  final String materialName;
  final String qualityTier;
  final String priceRange;
  final String vendorName;
  final double vendorRating;
  final String warranty;

  const RecommendedBrandItem({
    required this.brand,
    required this.materialName,
    required this.qualityTier,
    required this.priceRange,
    required this.vendorName,
    required this.vendorRating,
    required this.warranty,
  });
}

class AiBudgetEstimateEntity {
  final String id;
  final String title;
  final String projectName;
  final String room;
  final String furnitureType;
  final double width;
  final double height;
  final double depth;
  final String unit;
  final String coreMaterial;
  final String thickness;
  final String finish;
  final String hardware;
  final String budgetTier;
  final bool includeInstallation;
  final bool includeDelivery;
  final bool includeLabour;
  final bool includeGst;
  final double materialCost;
  final double labourCost;
  final double hardwareCost;
  final double finishCost;
  final double installationCost;
  final double subtotal;
  final double gstAmount;
  final double totalEstimate;
  final List<AiBudgetBoqItem> boqItems;
  final List<RecommendedBrandItem> recommendedBrands;
  final DateTime createdAt;

  const AiBudgetEstimateEntity({
    required this.id,
    required this.title,
    required this.projectName,
    required this.room,
    required this.furnitureType,
    required this.width,
    required this.height,
    required this.depth,
    required this.unit,
    required this.coreMaterial,
    required this.thickness,
    required this.finish,
    required this.hardware,
    required this.budgetTier,
    required this.includeInstallation,
    required this.includeDelivery,
    required this.includeLabour,
    required this.includeGst,
    required this.materialCost,
    required this.labourCost,
    required this.hardwareCost,
    required this.finishCost,
    required this.installationCost,
    required this.subtotal,
    required this.gstAmount,
    required this.totalEstimate,
    required this.boqItems,
    required this.recommendedBrands,
    required this.createdAt,
  });
}

// ============================================================================
// 7. DOUBT SOLVER DOMAIN MODELS
// ============================================================================

class AiDoubtMessage {
  final String id;
  final bool isUser;
  final String text;
  final DateTime timestamp;
  final List<String>? sources;
  final List<String>? followUpChips;
  final bool isPaid;
  final double feeCharged;

  const AiDoubtMessage({
    required this.id,
    required this.isUser,
    required this.text,
    required this.timestamp,
    this.sources,
    this.followUpChips,
    this.isPaid = false,
    this.feeCharged = 0.0,
  });
}

class AiDoubtConversationEntity {
  final String id;
  final String title;
  final String projectContext;
  final String roomContext;
  final DateTime updatedAt;
  final List<AiDoubtMessage> messages;
  final int totalQuestions;
  final int creditsConsumed;

  const AiDoubtConversationEntity({
    required this.id,
    required this.title,
    required this.projectContext,
    required this.roomContext,
    required this.updatedAt,
    required this.messages,
    required this.totalQuestions,
    required this.creditsConsumed,
  });
}

// ============================================================================
// 8. DESIGNER VIDEO CALLS DOMAIN MODELS
// ============================================================================

class DesignerProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final String specialization;
  final int experienceYears;
  final double rating;
  final int consultationsCount;
  final List<String> languages;
  final double consultationFee;
  final int durationMinutes;
  final String bio;
  final List<String> availableSlots;

  const DesignerProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.specialization,
    required this.experienceYears,
    required this.rating,
    required this.consultationsCount,
    required this.languages,
    required this.consultationFee,
    this.durationMinutes = 30,
    required this.bio,
    required this.availableSlots,
  });
}

class ConsultationBookingEntity {
  final String id;
  final DesignerProfile designer;
  final String clientName;
  final String clientPhone;
  final String clientEmail;
  final String projectName;
  final String consultationType;
  final DateTime scheduledDate;
  final String timeSlot;
  final int durationMinutes;
  final String topic;
  final String description;
  final double fee;
  final double platformShare;
  final double designerShare;
  final String meetingStatus;
  final String paymentStatus;
  final String meetingUrl;
  final List<String> attachments;
  final int? ratingGiven;
  final String? feedbackText;

  const ConsultationBookingEntity({
    required this.id,
    required this.designer,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.projectName,
    required this.consultationType,
    required this.scheduledDate,
    required this.timeSlot,
    this.durationMinutes = 30,
    required this.topic,
    required this.description,
    required this.fee,
    required this.platformShare,
    required this.designerShare,
    this.meetingStatus = 'Scheduled',
    this.paymentStatus = 'Paid',
    required this.meetingUrl,
    this.attachments = const [],
    this.ratingGiven,
    this.feedbackText,
  });
}

// ============================================================================
// 9. COMPANION WIDGET MODELS & LEGACY COMPATIBILITY
// ============================================================================

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

enum DesignerAvailability {
  online('Online Now', Color(0xFF10B981)),
  busy('In Call', Color(0xFFF59E0B)),
  offline('Next Slot 4 PM', Color(0xFF64748B));

  final String label;
  final Color color;
  const DesignerAvailability(this.label, this.color);
}

class DesignerConsultant {
  final String id;
  final String name;
  final String title;
  final String qualification;
  final int yearsExperience;
  final String avatarUrl;
  final double rating;
  final int totalConsultations;
  final List<String> specializations;
  final double consultationFee;
  final int callDurationMinutes;
  final String bio;
  final DesignerAvailability availability;

  double get sessionFee => consultationFee;

  const DesignerConsultant({
    required this.id,
    required this.name,
    required this.title,
    this.qualification = 'B.Arch (NID Ahmedabad) • CoA Registered',
    this.yearsExperience = 8,
    required this.avatarUrl,
    required this.rating,
    required this.totalConsultations,
    required this.specializations,
    required this.consultationFee,
    this.callDurationMinutes = 30,
    required this.bio,
    this.availability = DesignerAvailability.online,
  });
}

class BookedConsultationSession {
  final String id;
  final String clientName;
  final String clientPhone;
  final DesignerConsultant expert;
  final DateTime scheduledTime;
  final double feePaid;
  final String status;

  BookedConsultationSession({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.expert,
    required this.scheduledTime,
    required this.feePaid,
    required this.status,
  });
}

enum DoubtCategory {
  materialQuality('Materials & Specs', Icons.category_rounded),
  waterproofing('Waterproofing & Plumbing', Icons.water_drop_rounded),
  vastuGuidelines('Vastu Guidelines', Icons.explore_rounded),
  costEstimates('Cost & Rates', Icons.calculate_rounded),
  contractorStandards('Contractor Quality', Icons.engineering_rounded);

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
  final List<String>? actionChecklist;
  final double? costDeducted;
  final String? contractorTip;
  final String? specSummary;
  final List<String>? relevantProductTags;
  final String? mistakeSavedAmountNote;

  DoubtQueryMessage({
    required this.id,
    required this.isFromUser,
    required this.content,
    required this.timestamp,
    this.category,
    this.isPaidQuery = false,
    this.actionChecklist,
    this.costDeducted,
    this.contractorTip,
    this.specSummary,
    this.relevantProductTags,
    this.mistakeSavedAmountNote,
  });
}

enum VastuZoneStatus {
  balanced('Balanced', Color(0xFF10B981)),
  critical('Defective', Color(0xFFEF4444)),
  mildIssue('Needs Remedy', Color(0xFFF59E0B)),
  neutral('Neutral', Color(0xFF6366F1));

  final String label;
  final Color color;
  const VastuZoneStatus(this.label, this.color);
}

class VastuZoneDetail {
  final String zoneCode;
  final String name;
  final String element;
  final String deity;
  final VastuZoneStatus status;
  final String currentUsage;
  final String recommendedRemedy;
  final String remedyPriority;

  const VastuZoneDetail({
    required this.zoneCode,
    required this.name,
    required this.element,
    required this.deity,
    required this.status,
    required this.currentUsage,
    required this.recommendedRemedy,
    this.remedyPriority = 'Medium',
  });
}

class BrandRecommendation {
  final String brandName;
  final String logoText;
  final Color brandColor;
  final String qualityGrade;
  final String tagline;
  final String warrantyYears;
  final String marketShare;

  const BrandRecommendation({
    required this.brandName,
    required this.logoText,
    required this.brandColor,
    required this.qualityGrade,
    required this.tagline,
    required this.warrantyYears,
    required this.marketShare,
  });
}

class VendorContactCard {
  final String companyName;
  final String vendorName;
  final String cityRegion;
  final String wholesaleDiscount;
  final double rating;
  final String phone;

  const VendorContactCard({
    required this.companyName,
    required this.vendorName,
    required this.cityRegion,
    required this.wholesaleDiscount,
    required this.rating,
    required this.phone,
  });
}

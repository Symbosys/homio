import 'package:flutter/material.dart';

// ============================================================================
// 1. AI WALLET & TOKENS MODEL
// ============================================================================

class AiWallet {
  int totalTokens;
  int freeDoubtQueriesLeft;
  final String assignedDesigner;
  final double designerRevenueSharePercent;

  AiWallet({
    this.totalTokens = 240,
    this.freeDoubtQueriesLeft = 2,
    this.assignedDesigner = 'Pooja Hegde',
    this.designerRevenueSharePercent = 50.0,
  });
}

// ============================================================================
// 2. 50/50 ROOM GENERATOR MODEL
// ============================================================================

enum RoomType {
  livingRoom('Living Room', Icons.weekend_rounded),
  masterBedroom('Master Bedroom', Icons.bed_rounded),
  modularKitchen('Modular Kitchen', Icons.countertops_rounded),
  balconyLounge('Balcony Lounge', Icons.deck_rounded);

  final String label;
  final IconData icon;
  const RoomType(this.label, this.icon);
}

enum DesignTheme {
  modernMinimalist('Modern Minimalist', 'Sleek fluted wood, concealed linear LEDs & neutral tones'),
  scandinavian('Scandinavian', 'Light oak carpentry, airy whites & cozy boucle accents'),
  neoClassical('Neo-Classical', 'Subtle wall mouldings, brushed brass profiles & marble trims'),
  luxuryContemporary('Luxury Contemporary', 'Italian marble wall, dark veneers & champagne accents');

  final String label;
  final String desc;
  const DesignTheme(this.label, this.desc);
}

enum LightingCondition {
  daylight('Daylight Natural', '5500K bright sunbeams', Icons.wb_sunny_rounded),
  warmEvening('Warm Ambient', '3000K golden evening glow', Icons.nightlight_round),
  studioBright('Studio Focus', '4000K balanced architectural', Icons.highlight_rounded);

  final String label;
  final String desc;
  final IconData icon;
  const LightingCondition(this.label, this.desc, this.icon);
}

class AiRoomGeneration {
  final String id;
  final String title;
  final RoomType roomType;
  final DesignTheme theme;
  final LightingCondition lighting;
  final String colorPalette;
  final String prompt;
  final String rawPhotoUrl;
  final String renderPhotoUrl;
  double splitPosition; // 0.0 to 1.0 for before/after comparison
  final int boqItemsCount;
  final String createdAt;
  final List<String> boqMaterials;

  AiRoomGeneration({
    required this.id,
    required this.title,
    required this.roomType,
    required this.theme,
    required this.lighting,
    required this.colorPalette,
    required this.prompt,
    required this.rawPhotoUrl,
    required this.renderPhotoUrl,
    this.splitPosition = 0.5,
    required this.boqItemsCount,
    required this.createdAt,
    required this.boqMaterials,
  });
}

// ============================================================================
// 3. VASTU CHAKRA & REMEDIES MODEL
// ============================================================================

enum VastuStatus {
  auspicious('Auspicious', Color(0xFF10B981)),
  minorDosha('Minor Imbalance', Color(0xFFF59E0B)),
  remedied('Remedy Active', Color(0xFF6366F1));

  final String label;
  final Color color;
  const VastuStatus(this.label, this.color);
}

class VastuChakraZone {
  final String id;
  final String zoneName;
  final String deityRuling;
  final String element;
  final Color elementColor;
  final String degrees;
  int score;
  final String currentUsage;
  VastuStatus status;
  final String doshaDetail;
  final String nonDemolitionRemedy;
  bool isRemedyApplied;

  VastuChakraZone({
    required this.id,
    required this.zoneName,
    required this.deityRuling,
    required this.element,
    required this.elementColor,
    required this.degrees,
    required this.score,
    required this.currentUsage,
    required this.status,
    required this.doshaDetail,
    required this.nonDemolitionRemedy,
    this.isRemedyApplied = false,
  });
}

// ============================================================================
// 4. FURNITURE BUDGET ESTIMATOR MODEL
// ============================================================================

enum FurnitureCategory {
  modularWardrobe('3-Door Modular Wardrobe', Icons.door_sliding_rounded),
  islandKitchen('Island Modular Kitchen', Icons.kitchen_rounded),
  luxuryTvUnit('Luxury TV Wall Console', Icons.tv_rounded),
  hydraulicKingBed('King Bed with Hydraulic Storage', Icons.bed_rounded),
  bathroomVanity('Floating Bathroom Vanity', Icons.wash_rounded);

  final String label;
  final IconData icon;
  const FurnitureCategory(this.label, this.icon);
}

enum SubstrateGrade {
  commercialMr('Commercial MR Ply (IS 303)', 1.0, 'Moisture resistant core for dry bedroom areas'),
  bwrGrade('BWR Water Resistant (IS 303)', 1.25, 'Boiling water resistant, phenol bonded'),
  bwpMarine('BWP Marine Ply (IS 710)', 1.55, '100% 72-hour boiling waterproof, zero borer'),
  hdhmrBoard('HDHMR Board (Action TESA)', 1.35, 'High density moisture resistant, laser edge band');

  final String label;
  final double costMultiplier;
  final String spec;
  const SubstrateGrade(this.label, this.costMultiplier, this.spec);
}

enum SurfaceFinish {
  matteLaminate('1.0mm Anti-Fingerprint Matte Laminate', 1.0, 'Merino / CenturyLaminates'),
  acrylicGloss('1.5mm High-Gloss Anti-Scratch Acrylic', 1.45, 'Rehau / Senosan Austria'),
  naturalVeneer('Natural Teak Wood Veneer with PU Polish', 2.10, 'Decowood / Greenlam Veneers'),
  puPainted('Italian PU / Duco High-Satin Polish', 1.85, 'Sirca / ICA Italian Coatings');

  final String label;
  final double costMultiplier;
  final String brandRef;
  const SurfaceFinish(this.label, this.costMultiplier, this.brandRef);
}

enum HardwarePackage {
  standardSoftClose('Standard Soft-Close Hinge (Ebco)', 1.0),
  germanPremium('German Soft-Close Sensys (Hettich / Hafele)', 1.35),
  hydraulicTandem('Full Tandem Box + Hydraulic Lift-up (Blum)', 1.80);

  final String label;
  final double multiplier;
  const HardwarePackage(this.label, this.multiplier);
}

// ============================================================================
// 5. TECHNICAL DOUBT SOLVER MODEL & CHATBOT THREADS
// ============================================================================

enum DoubtVerdict {
  recommended('Recommended & Verified', Color(0xFF10B981), Icons.check_circle_rounded),
  useWithCaution('Use with Caution', Color(0xFFF59E0B), Icons.warning_rounded),
  avoidHazard('High Risk • Avoid on Site', Color(0xFFEF4444), Icons.cancel_rounded);

  final String label;
  final Color color;
  final IconData icon;
  const DoubtVerdict(this.label, this.color, this.icon);
}

class AiDoubtQuery {
  final String id;
  final String question;
  final String category;
  final DoubtVerdict verdict;
  final String technicalAdvice;
  final String costSavingImpact;
  final String isCodeRef;
  final String timestamp;
  final bool isFreeQuestion;

  AiDoubtQuery({
    required this.id,
    required this.question,
    required this.category,
    required this.verdict,
    required this.technicalAdvice,
    required this.costSavingImpact,
    required this.isCodeRef,
    required this.timestamp,
    required this.isFreeQuestion,
  });
}

// ============================================================================
// 6. CHATBOT CONVERSATIONAL MODELS (ChatGPT/Claude Style)
// ============================================================================

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final String timestamp;
  final DoubtVerdict? verdict;
  final String? customVerdictLabel;
  final String? recommendedSpec;
  final String? criticalDetail;
  final String? isCodeRef;
  final String? costSavingImpact;
  final List<String> attachments;
  final bool isHelpful;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.verdict,
    this.customVerdictLabel,
    this.recommendedSpec,
    this.criticalDetail,
    this.isCodeRef,
    this.costSavingImpact,
    this.attachments = const [],
    this.isHelpful = true,
  });
}

class ChatSession {
  final String id;
  final String title;
  final String lastMessagePreview;
  final String timestamp;
  final int messageCount;
  final List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.lastMessagePreview,
    required this.timestamp,
    required this.messageCount,
    required this.messages,
  });
}

// ============================================================================
// 7. COMPREHENSIVE VASTU ANALYSIS MODELS
// ============================================================================

enum VastuDirection {
  north('North', 'Kuber Zone • Wealth, Liquidity & Growth', Icons.arrow_upward_rounded),
  northEast('North-East', 'Ishan Zone • Spirituality, Clarity & Water', Icons.north_east_rounded),
  east('East', 'Indra Zone • Social Connectivity & Health', Icons.arrow_forward_rounded),
  southEast('South-East', 'Agni Zone • Cashflow, Digestion & Kitchen', Icons.south_east_rounded),
  south('South', 'Yama Zone • Rest, Relaxation & Fame', Icons.arrow_downward_rounded),
  southWest('South-West', 'Nairutya Zone • Stability, Relationships & Master Suite', Icons.south_west_rounded),
  west('West', 'Varuna Zone • Profits, Gains & Skill Retention', Icons.arrow_back_rounded),
  northWest('North-West', 'Vayu Zone • Support, Banking & Movement', Icons.north_west_rounded);

  final String label;
  final String significance;
  final IconData icon;
  const VastuDirection(this.label, this.significance, this.icon);
}

class VastuAnalysisResult {
  final int overallScore;
  final String grade;
  final String summary;
  final Map<String, double> elementalBalances; // Jal, Vayu, Agni, Prithvi, Akash
  final List<String> primaryRecommendations;

  const VastuAnalysisResult({
    required this.overallScore,
    required this.grade,
    required this.summary,
    required this.elementalBalances,
    required this.primaryRecommendations,
  });
}

// ============================================================================
// 8. AI BUDGET ESTIMATOR ADVANCED MODELS
// ============================================================================

class BudgetScopePreset {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String defaultDescription;
  final FurnitureCategory defaultCategory;
  final double defaultWidth;
  final double defaultHeight;

  const BudgetScopePreset({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.defaultDescription,
    required this.defaultCategory,
    required this.defaultWidth,
    required this.defaultHeight,
  });
}

class AiBudgetAnalysisResult {
  final double estimatedTotal;
  final double totalLow;
  final double totalHigh;
  final double coreCarpentryCost;
  final double surfaceFacadeCost;
  final double hardwareCost;
  final double laborCost;
  final double contingencyCost;
  final double valueEngineeringSavings;
  final List<String> strategicRecommendations;
  final String aiReasoningSummary;

  const AiBudgetAnalysisResult({
    required this.estimatedTotal,
    required this.totalLow,
    required this.totalHigh,
    required this.coreCarpentryCost,
    required this.surfaceFacadeCost,
    required this.hardwareCost,
    required this.laborCost,
    required this.contingencyCost,
    required this.valueEngineeringSavings,
    required this.strategicRecommendations,
    required this.aiReasoningSummary,
  });
}

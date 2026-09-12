enum VastuStatus {
  optimal('Optimal / High Energy', 0xFF10B981),
  moderate('Moderate / Acceptable', 0xFF3B82F6),
  defect('Defect / Remedy Needed', 0xFFEF4444);

  final String label;
  final int colorHex;
  const VastuStatus(this.label, this.colorHex);
}

class VastuZoneResult {
  final String direction; // 'North-East (Ishanya)', 'South-East (Agneya)', etc.
  final String governingElement; // 'Water / Jal', 'Fire / Agni', 'Earth / Prithvi', etc.
  final String currentRoomPlacement; // 'Kitchen', 'Master Bedroom', 'Pooja Room'
  final VastuStatus status;
  final int compliancePercent;
  final String energyAnalysis;
  final List<String> nonDestructiveRemedies;

  const VastuZoneResult({
    required this.direction,
    required this.governingElement,
    required this.currentRoomPlacement,
    required this.status,
    required this.compliancePercent,
    required this.energyAnalysis,
    required this.nonDestructiveRemedies,
  });
}

class VastuAnalysisReport {
  final String id;
  final String propertyTitle;
  final int overallScore; // 0 - 100
  final String chakraLevel; // 'High Harmonious', 'Balanced with Minor Adjustments', 'Remedy Required'
  final String primaryDosha;
  final String floorPlanImageUrl;
  final List<VastuZoneResult> zones;
  final List<String> topPriorityRecommendations;
  final DateTime analyzedAt;

  const VastuAnalysisReport({
    required this.id,
    required this.propertyTitle,
    required this.overallScore,
    required this.chakraLevel,
    required this.primaryDosha,
    required this.floorPlanImageUrl,
    required this.zones,
    required this.topPriorityRecommendations,
    required this.analyzedAt,
  });
}

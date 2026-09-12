/// Contextual project information linked to the AI Studio session.
/// Enables AI tools to autofill room sizes, styles, themes, and budgets.
class AiProjectContext {
  final String id;
  final String projectName;
  final String unitType; // '3BHK', '4BHK Penthouse', 'Luxury Villa', etc.
  final double carpetAreaSqFt;
  final String currentStage; // 'Concept', 'False Ceiling', 'Carpentry', 'Finishing'
  final String preferredTheme; // 'Modern Minimalist', 'Japandi Luxury', 'Neo-Classical', etc.
  final double allocatedBudget;
  final String city;
  final String clientName;

  const AiProjectContext({
    required this.id,
    required this.projectName,
    required this.unitType,
    required this.carpetAreaSqFt,
    required this.currentStage,
    required this.preferredTheme,
    required this.allocatedBudget,
    required this.city,
    required this.clientName,
  });

  factory AiProjectContext.mockDefault() {
    return const AiProjectContext(
      id: 'PRJ-2026-0891',
      projectName: 'Aura Heights Residence (3BHK)',
      unitType: '3BHK Premium Apartment',
      carpetAreaSqFt: 1850.0,
      currentStage: 'False Ceiling & Electrical',
      preferredTheme: 'Japandi Warm Minimalist',
      allocatedBudget: 2450000.0,
      city: 'Bengaluru',
      clientName: 'Rahul Sharma',
    );
  }

  AiProjectContext copyWith({
    String? id,
    String? projectName,
    String? unitType,
    double? carpetAreaSqFt,
    String? currentStage,
    String? preferredTheme,
    double? allocatedBudget,
    String? city,
    String? clientName,
  }) {
    return AiProjectContext(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      unitType: unitType ?? this.unitType,
      carpetAreaSqFt: carpetAreaSqFt ?? this.carpetAreaSqFt,
      currentStage: currentStage ?? this.currentStage,
      preferredTheme: preferredTheme ?? this.preferredTheme,
      allocatedBudget: allocatedBudget ?? this.allocatedBudget,
      city: city ?? this.city,
      clientName: clientName ?? this.clientName,
    );
  }
}

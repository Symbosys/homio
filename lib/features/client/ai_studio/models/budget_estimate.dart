class BudgetScopeItem {
  final String categoryName; // 'Kitchen Modular Units', 'Wardrobes & Storage', 'False Ceiling & Cove', etc.
  final double amount;
  final double percentage;
  final String specifications;

  const BudgetScopeItem({
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.specifications,
  });
}

class BudgetPackageOption {
  final String id;
  final String title; // 'Standard Modern', 'Premium HDHMR + Acrylic', 'Ultra-Luxury Veneer & PU'
  final String targetSegment; // 'Budget Conscious / Rental', 'Homeowner Preferred', 'High-End Luxury'
  final double totalCost;
  final double perSqFtRate;
  final int warrantyYears;
  final List<String> highlightPoints;
  final List<BudgetScopeItem> scopeBreakdown;

  const BudgetPackageOption({
    required this.id,
    required this.title,
    required this.targetSegment,
    required this.totalCost,
    required this.perSqFtRate,
    required this.warrantyYears,
    required this.highlightPoints,
    required this.scopeBreakdown,
  });
}

class BudgetCalculationResult {
  final String id;
  final double carpetAreaSqFt;
  final String bhkConfiguration;
  final List<BudgetPackageOption> packageComparisons;
  final String recommendedPackageId;
  final List<String> savingsOpportunities;
  final DateTime calculatedAt;

  const BudgetCalculationResult({
    required this.id,
    required this.carpetAreaSqFt,
    required this.bhkConfiguration,
    required this.packageComparisons,
    required this.recommendedPackageId,
    required this.savingsOpportunities,
    required this.calculatedAt,
  });
}

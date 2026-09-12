enum MaterialCategory {
  carcassCore('Carcass & Core Wood', 'BWP Marine Ply, HDHMR, MR Grade Plywood'),
  surfaceFinish('Surface Finishes', '1mm Acrylic, Anti-scratch Laminate, Natural Veneer'),
  hardwareFittings('Hardware & Hinges', 'Soft-close hinges, tandem boxes, gas lifts'),
  countertops('Countertops & Wall Cladding', 'Quartz, Kalinga Stone, Nano White, Granite'),
  paintsPolishes('Paints & Wall Finishes', 'PU Polish, Luxury Emulsion, Microcement, Lime Wash'),
  flooring('Flooring & Tiles', 'GVT Vitrified Tiles, Engineered Hardwood, SPC Flooring'),
  softFurnishings('Soft Furnishings & Fabrics', 'Velvet, Linen Sheers, Blackout Drapes, Boucle');

  final String label;
  final String examples;
  const MaterialCategory(this.label, this.examples);
}

class MaterialSpecificationItem {
  final String id;
  final MaterialCategory category;
  final String productName;
  final String brand;
  final String gradeOrCode;
  final String applicationArea; // 'Kitchen Base Cabinets', 'Master Wardrobe Shutters'
  final String durabilityLevel; // 'Extreme High Moisture', 'Heavy Commercial', 'Standard Residential'
  final double costPerUnit;
  final String unit; // 'sq.ft', 'pair', 'slab', 'ltr'
  final int warrantyYears;
  final String maintenanceTips;
  final List<String> alternativeBrands;
  final bool isEcoCertified;
  final bool isSavedToProjectBOQ;

  const MaterialSpecificationItem({
    required this.id,
    required this.category,
    required this.productName,
    required this.brand,
    required this.gradeOrCode,
    required this.applicationArea,
    required this.durabilityLevel,
    required this.costPerUnit,
    required this.unit,
    required this.warrantyYears,
    required this.maintenanceTips,
    this.alternativeBrands = const [],
    this.isEcoCertified = true,
    this.isSavedToProjectBOQ = false,
  });

  MaterialSpecificationItem copyWith({
    String? id,
    MaterialCategory? category,
    String? productName,
    String? brand,
    String? gradeOrCode,
    String? applicationArea,
    String? durabilityLevel,
    double? costPerUnit,
    String? unit,
    int? warrantyYears,
    String? maintenanceTips,
    List<String>? alternativeBrands,
    bool? isEcoCertified,
    bool? isSavedToProjectBOQ,
  }) {
    return MaterialSpecificationItem(
      id: id ?? this.id,
      category: category ?? this.category,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      gradeOrCode: gradeOrCode ?? this.gradeOrCode,
      applicationArea: applicationArea ?? this.applicationArea,
      durabilityLevel: durabilityLevel ?? this.durabilityLevel,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      unit: unit ?? this.unit,
      warrantyYears: warrantyYears ?? this.warrantyYears,
      maintenanceTips: maintenanceTips ?? this.maintenanceTips,
      alternativeBrands: alternativeBrands ?? this.alternativeBrands,
      isEcoCertified: isEcoCertified ?? this.isEcoCertified,
      isSavedToProjectBOQ: isSavedToProjectBOQ ?? this.isSavedToProjectBOQ,
    );
  }
}

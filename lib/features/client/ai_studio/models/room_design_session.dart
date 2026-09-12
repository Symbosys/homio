enum RoomDesignStatus {
  draft,
  generating,
  completed,
  failed,
}

enum RoomType {
  livingRoom('Living Room', 'Sofa, TV unit, console, ambient cove lights'),
  masterBedroom('Master Bedroom', 'King bed, fluted panel headboard, walk-in wardrobe'),
  modularKitchen('Modular Kitchen', 'Island counter, quartz backsplash, profile lighting'),
  kidsBedroom('Kids Bedroom', 'Study nook, bunk/day bed, vibrant storage'),
  diningRoom('Dining Area', '6-seater marble top, pendant chandelier, crockery unit'),
  poojaRoom('Pooja Room', 'Carved teak backdrop, brass accents, warm ambient glow'),
  homeOffice('Home Office / Study', 'Ergonomic desk, soundproof paneling, floating shelves'),
  balconyGarden('Balcony / Terrace', 'Decking tiles, vertical green wall, wicker lounge');

  final String label;
  final String description;
  const RoomType(this.label, this.description);
}

class RoomDesignSession {
  final String id;
  final String title;
  final RoomType roomType;
  final double lengthFt;
  final double widthFt;
  final double ceilingHeightFt;
  final String styleTheme; // 'Japandi', 'Modern Scandinavian', 'Contemporary Luxury', etc.
  final List<String> colorPaletteHex;
  final String lightingMood; // 'Warm Ambient 3000K', 'Daylight Clean 4500K', 'Dramatic Accent'
  final String woodFinish; // 'Smoked Oak', 'Natural Teak', 'Bleached Ash', etc.
  final String hardwareMetal; // 'Brushed Brass', 'Matte Black', 'Rose Gold'
  final List<String> mustHaveElements;
  final String budgetBand; // 'Essential (₹1.5L - ₹3L)', 'Premium (₹3L - ₹6L)', 'Ultra-Luxury (₹6L+)'
  final String? baseUploadImageUrl; // Original photo if uploaded
  final String? renderedImageUrl; // AI 3D visualization
  final List<String> alternativeRenderUrls;
  final List<String> specifiedMaterials;
  final double estimatedCostLow;
  final double estimatedCostHigh;
  final String vastuComplianceSummary;
  final RoomDesignStatus status;
  final DateTime createdAt;

  const RoomDesignSession({
    required this.id,
    required this.title,
    required this.roomType,
    required this.lengthFt,
    required this.widthFt,
    required this.ceilingHeightFt,
    required this.styleTheme,
    required this.colorPaletteHex,
    required this.lightingMood,
    required this.woodFinish,
    required this.hardwareMetal,
    this.mustHaveElements = const [],
    required this.budgetBand,
    this.baseUploadImageUrl,
    this.renderedImageUrl,
    this.alternativeRenderUrls = const [],
    this.specifiedMaterials = const [],
    this.estimatedCostLow = 0,
    this.estimatedCostHigh = 0,
    this.vastuComplianceSummary = '',
    this.status = RoomDesignStatus.draft,
    required this.createdAt,
  });

  double get floorAreaSqFt => lengthFt * widthFt;

  RoomDesignSession copyWith({
    String? id,
    String? title,
    RoomType? roomType,
    double? lengthFt,
    double? widthFt,
    double? ceilingHeightFt,
    String? styleTheme,
    List<String>? colorPaletteHex,
    String? lightingMood,
    String? woodFinish,
    String? hardwareMetal,
    List<String>? mustHaveElements,
    String? budgetBand,
    String? baseUploadImageUrl,
    String? renderedImageUrl,
    List<String>? alternativeRenderUrls,
    List<String>? specifiedMaterials,
    double? estimatedCostLow,
    double? estimatedCostHigh,
    String? vastuComplianceSummary,
    RoomDesignStatus? status,
    DateTime? createdAt,
  }) {
    return RoomDesignSession(
      id: id ?? this.id,
      title: title ?? this.title,
      roomType: roomType ?? this.roomType,
      lengthFt: lengthFt ?? this.lengthFt,
      widthFt: widthFt ?? this.widthFt,
      ceilingHeightFt: ceilingHeightFt ?? this.ceilingHeightFt,
      styleTheme: styleTheme ?? this.styleTheme,
      colorPaletteHex: colorPaletteHex ?? this.colorPaletteHex,
      lightingMood: lightingMood ?? this.lightingMood,
      woodFinish: woodFinish ?? this.woodFinish,
      hardwareMetal: hardwareMetal ?? this.hardwareMetal,
      mustHaveElements: mustHaveElements ?? this.mustHaveElements,
      budgetBand: budgetBand ?? this.budgetBand,
      baseUploadImageUrl: baseUploadImageUrl ?? this.baseUploadImageUrl,
      renderedImageUrl: renderedImageUrl ?? this.renderedImageUrl,
      alternativeRenderUrls: alternativeRenderUrls ?? this.alternativeRenderUrls,
      specifiedMaterials: specifiedMaterials ?? this.specifiedMaterials,
      estimatedCostLow: estimatedCostLow ?? this.estimatedCostLow,
      estimatedCostHigh: estimatedCostHigh ?? this.estimatedCostHigh,
      vastuComplianceSummary: vastuComplianceSummary ?? this.vastuComplianceSummary,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

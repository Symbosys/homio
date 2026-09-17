class PlanFeatureModel {
  final String? id;
  final int maxUser;
  final int maxEmployee;

  const PlanFeatureModel({
    this.id,
    this.maxUser = 5,
    this.maxEmployee = 10,
  });

  factory PlanFeatureModel.fromJson(Map<String, dynamic> json) {
    return PlanFeatureModel(
      id: json['id'] as String?,
      maxUser: (json['maxUser'] as num?)?.toInt() ?? 5,
      maxEmployee: (json['maxEmployee'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxUser': maxUser,
      'maxEmployee': maxEmployee,
    };
  }
}

class PlatformPlanModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final double priceMonthly;
  final double priceYearly;
  final String currency;
  final Map<String, dynamic> features;
  final bool isActive;
  final int sortOrder;
  final PlanFeatureModel? planFeature;
  final int subscriptionsCount;

  const PlatformPlanModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.priceMonthly,
    required this.priceYearly,
    this.currency = 'INR',
    this.features = const {},
    this.isActive = true,
    this.sortOrder = 0,
    this.planFeature,
    this.subscriptionsCount = 0,
  });

  factory PlatformPlanModel.fromJson(Map<String, dynamic> json) {
    return PlatformPlanModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      priceMonthly: double.tryParse(json['priceMonthly']?.toString() ?? '0') ?? 0.0,
      priceYearly: double.tryParse(json['priceYearly']?.toString() ?? '0') ?? 0.0,
      currency: json['currency'] as String? ?? 'INR',
      features: json['features'] is Map ? Map<String, dynamic>.from(json['features'] as Map) : {},
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      planFeature: json['planFeature'] != null && json['planFeature'] is Map
          ? PlanFeatureModel.fromJson(json['planFeature'] as Map<String, dynamic>)
          : null,
      subscriptionsCount: (json['_count']?['subscriptions'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'description': description,
      'priceMonthly': priceMonthly,
      'priceYearly': priceYearly,
      'currency': currency,
      'features': features,
      'isActive': isActive,
      'sortOrder': sortOrder,
      if (planFeature != null) 'planFeature': planFeature!.toJson(),
    };
  }
}

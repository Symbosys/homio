class ActiveSubscriptionModel {
  final String id;
  final String status;
  final String billingCycle;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime? trialEndsAt;
  final String planId;
  final String planName;
  final String planSlug;
  final double priceMonthly;
  final double priceYearly;
  final int maxUser;
  final int maxEmployee;

  const ActiveSubscriptionModel({
    required this.id,
    required this.status,
    required this.billingCycle,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.trialEndsAt,
    required this.planId,
    required this.planName,
    required this.planSlug,
    required this.priceMonthly,
    required this.priceYearly,
    this.maxUser = 5,
    this.maxEmployee = 10,
  });

  factory ActiveSubscriptionModel.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'] as Map<String, dynamic>? ?? {};
    final limits = plan['limits'] as Map<String, dynamic>? ??
        (plan['planFeature'] as Map<String, dynamic>?) ??
        {};

    return ActiveSubscriptionModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
      billingCycle: json['billingCycle'] as String? ?? 'MONTHLY',
      currentPeriodStart: json['currentPeriodStart'] != null
          ? DateTime.tryParse(json['currentPeriodStart'].toString())
          : null,
      currentPeriodEnd: json['currentPeriodEnd'] != null
          ? DateTime.tryParse(json['currentPeriodEnd'].toString())
          : null,
      trialEndsAt: json['trialEndsAt'] != null
          ? DateTime.tryParse(json['trialEndsAt'].toString())
          : null,
      planId: plan['id'] as String? ?? '',
      planName: plan['name'] as String? ?? 'Standard',
      planSlug: plan['slug'] as String? ?? 'standard',
      priceMonthly: double.tryParse(plan['priceMonthly']?.toString() ?? '0') ?? 0.0,
      priceYearly: double.tryParse(plan['priceYearly']?.toString() ?? '0') ?? 0.0,
      maxUser: (limits['maxUser'] as num?)?.toInt() ?? 5,
      maxEmployee: (limits['maxEmployee'] as num?)?.toInt() ?? 10,
    );
  }
}

class PlatformOrgModel {
  final String id;
  final String name;
  final String slug;
  final String? legalName;
  final String? email;
  final String? phone;
  final String? website;
  final String? logoUrl;
  final String? taxId;
  final String? city;
  final String? state;
  final String country;
  final String currency;
  final String status;
  final DateTime? createdAt;
  final ActiveSubscriptionModel? activeSubscription;
  final int totalUsers;

  const PlatformOrgModel({
    required this.id,
    required this.name,
    required this.slug,
    this.legalName,
    this.email,
    this.phone,
    this.website,
    this.logoUrl,
    this.taxId,
    this.city,
    this.state,
    this.country = 'IN',
    this.currency = 'INR',
    this.status = 'ACTIVE',
    this.createdAt,
    this.activeSubscription,
    this.totalUsers = 0,
  });

  String get code => slug;

  factory PlatformOrgModel.fromJson(Map<String, dynamic> json) {
    return PlatformOrgModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      legalName: json['legalName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      logoUrl: json['logoUrl'] is Map
          ? (json['logoUrl']['url'] as String?)
          : json['logoUrl'] as String?,
      taxId: json['taxId'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String? ?? 'IN',
      currency: json['currency'] as String? ?? 'INR',
      status: json['status'] as String? ?? 'ACTIVE',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      activeSubscription: json['activeSubscription'] != null &&
              json['activeSubscription'] is Map
          ? ActiveSubscriptionModel.fromJson(
              json['activeSubscription'] as Map<String, dynamic>)
          : null,
      totalUsers: (json['totalUsers'] as num?)?.toInt() ??
          (json['_count']?['users'] as num?)?.toInt() ??
          0,
    );
  }
}

class PaginatedOrganizationsResponse {
  final List<PlatformOrgModel> org;
  final int totalOrg;
  final int totalPage;
  final int currentPage;
  final int count;

  const PaginatedOrganizationsResponse({
    required this.org,
    required this.totalOrg,
    required this.totalPage,
    required this.currentPage,
    required this.count,
  });

  factory PaginatedOrganizationsResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['org'] as List?) ?? (json['organizations'] as List?) ?? [];
    return PaginatedOrganizationsResponse(
      org: list.map((item) => PlatformOrgModel.fromJson(item as Map<String, dynamic>)).toList(),
      totalOrg: (json['totalOrg'] as num?)?.toInt() ?? list.length,
      totalPage: (json['totalPage'] as num?)?.toInt() ?? 1,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      count: (json['count'] as num?)?.toInt() ?? list.length,
    );
  }
}

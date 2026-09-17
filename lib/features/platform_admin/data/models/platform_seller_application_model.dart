class PlatformSellerApplicationModel {
  final String id;
  final String organizationId;
  final String organizationName;
  final String categoryId;
  final String categoryName;
  final String marketplaceType;
  final bool isApproved;
  final bool isActive;
  final double? commissionRate;
  final DateTime? createdAt;

  const PlatformSellerApplicationModel({
    required this.id,
    required this.organizationId,
    required this.organizationName,
    required this.categoryId,
    required this.categoryName,
    required this.marketplaceType,
    required this.isApproved,
    required this.isActive,
    this.commissionRate,
    this.createdAt,
  });

  factory PlatformSellerApplicationModel.fromJson(Map<String, dynamic> json) {
    final org = json['organization'] as Map<String, dynamic>?;
    final cat = json['category'] as Map<String, dynamic>?;

    return PlatformSellerApplicationModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      organizationName: org?['name'] as String? ?? 'Unknown Organization',
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: cat?['name'] as String? ?? 'Unknown Category',
      marketplaceType: json['marketplaceType'] as String? ?? 'OTHER',
      isApproved: json['isApproved'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      commissionRate: (json['commissionRate'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }
}

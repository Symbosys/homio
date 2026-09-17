class PlatformMarketplaceCategoryModel {
  final String id;
  final String name;
  final String code;
  final String slug;
  final String marketplaceType;
  final String? description;
  final String? icon;
  final String? imageUrl;
  final int sortOrder;
  final String? parentId;
  final bool isActive;
  final int itemCount;
  final List<PlatformMarketplaceCategoryModel> children;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlatformMarketplaceCategoryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.slug,
    required this.marketplaceType,
    this.description,
    this.icon,
    this.imageUrl,
    this.sortOrder = 0,
    this.parentId,
    this.isActive = true,
    this.itemCount = 0,
    this.children = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory PlatformMarketplaceCategoryModel.fromJson(Map<String, dynamic> json) {
    int parsedItemCount = 0;
    final count = json['_count'];
    if (count is Map<String, dynamic>) {
      final d = (count['digitalProducts'] as num?)?.toInt() ?? 0;
      final h = (count['homeDecorProducts'] as num?)?.toInt() ?? 0;
      final p = (count['propertyListings'] as num?)?.toInt() ?? 0;
      final m = (count['materialProducts'] as num?)?.toInt() ?? 0;
      parsedItemCount = d + h + p + m;
    }

    return PlatformMarketplaceCategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      marketplaceType: json['marketplaceType'] as String? ?? 'OTHER',
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      imageUrl: () {
        final img = json['imageUrl'];
        if (img is Map<String, dynamic>) {
          return img['url'] as String?;
        }
        if (img is String && img.isNotEmpty) {
          return img;
        }
        return null;
      }(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      parentId: json['parentId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      itemCount: parsedItemCount,
      children: (json['children'] as List?)
              ?.map((e) => PlatformMarketplaceCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'slug': slug,
      'marketplaceType': marketplaceType,
      'description': description,
      'icon': icon,
      'imageUrl': imageUrl,
      'sortOrder': sortOrder,
      'parentId': parentId,
      'isActive': isActive,
    };
  }

  PlatformMarketplaceCategoryModel copyWith({
    String? id,
    String? name,
    String? code,
    String? slug,
    String? marketplaceType,
    String? description,
    String? icon,
    String? imageUrl,
    int? sortOrder,
    String? parentId,
    bool? isActive,
    int? itemCount,
    List<PlatformMarketplaceCategoryModel>? children,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlatformMarketplaceCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      slug: slug ?? this.slug,
      marketplaceType: marketplaceType ?? this.marketplaceType,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      itemCount: itemCount ?? this.itemCount,
      children: children ?? this.children,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

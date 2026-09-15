library;

/// Data models representing backend User, Role, and Permission entities

class UserRoleItem {
  final String id;
  final String name;
  final String slug;

  UserRoleItem({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory UserRoleItem.fromJson(Map<String, dynamic> json) {
    return UserRoleItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
  };
}

class UserApiItem {
  final String id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? phone;
  final String? avatarUrl;
  final String status;
  final String userType;
  final DateTime? emailVerifiedAt;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<UserRoleItem> roles;

  UserApiItem({
    required this.id,
    required this.email,
    required this.firstName,
    this.lastName,
    this.phone,
    this.avatarUrl,
    required this.status,
    required this.userType,
    this.emailVerifiedAt,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
  });

  String get fullName => lastName != null && lastName!.isNotEmpty
      ? '$firstName $lastName'
      : firstName;

  factory UserApiItem.fromJson(Map<String, dynamic> json) {
    List<UserRoleItem> rolesList = [];
    if (json['roles'] is List) {
      rolesList = (json['roles'] as List).map((r) {
        if (r['role'] is Map<String, dynamic>) {
          return UserRoleItem.fromJson(r['role'] as Map<String, dynamic>);
        }
        return UserRoleItem.fromJson(r as Map<String, dynamic>);
      }).toList();
    }

    return UserApiItem(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      userType: json['userType'] as String? ?? 'USER',
      emailVerifiedAt: json['emailVerifiedAt'] != null
          ? DateTime.tryParse(json['emailVerifiedAt'].toString())
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      roles: rolesList,
    );
  }
}

class PermissionApiItem {
  final String id;
  final String name;
  final String slug;
  final String resource;
  final String action;
  final String? description;

  PermissionApiItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.resource,
    required this.action,
    this.description,
  });

  factory PermissionApiItem.fromJson(Map<String, dynamic> json) {
    return PermissionApiItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      resource: json['resource'] as String? ?? '',
      action: json['action'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'resource': resource,
    'action': action,
    'description': description,
  };
}

class RoleApiItem {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final bool isSystem;
  final bool isActive;
  final int userCount;
  final List<PermissionApiItem> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoleApiItem({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.isSystem,
    required this.isActive,
    required this.userCount,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoleApiItem.fromJson(Map<String, dynamic> json) {
    List<PermissionApiItem> permList = [];
    if (json['permissions'] is List) {
      permList = (json['permissions'] as List).map((p) {
        if (p['permission'] is Map<String, dynamic>) {
          return PermissionApiItem.fromJson(p['permission'] as Map<String, dynamic>);
        }
        return PermissionApiItem.fromJson(p as Map<String, dynamic>);
      }).toList();
    }

    int uCount = 0;
    if (json['_count'] is Map && json['_count']['users'] != null) {
      uCount = int.tryParse(json['_count']['users'].toString()) ?? 0;
    }

    return RoleApiItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      isSystem: json['isSystem'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      userCount: uCount,
      permissions: permList,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class PaginatedUsersResponse {
  final List<UserApiItem> users;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginatedUsersResponse({
    required this.users,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedUsersResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final usersList = (data['users'] as List? ?? [])
        .map((u) => UserApiItem.fromJson(u as Map<String, dynamic>))
        .toList();

    final pagination = data['pagination'] as Map<String, dynamic>? ?? {};

    return PaginatedUsersResponse(
      users: usersList,
      total: pagination['total'] as int? ?? usersList.length,
      page: pagination['page'] as int? ?? 1,
      limit: pagination['limit'] as int? ?? 10,
      totalPages: pagination['totalPages'] as int? ?? 1,
    );
  }
}

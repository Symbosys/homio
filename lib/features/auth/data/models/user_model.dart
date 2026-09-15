class RoleModel {
  final String id;
  final String name;
  final String slug;

  const RoleModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? phone;
  final String? avatarUrl;
  final String userType; // 'ADMIN' | 'USER'
  final String status;
  final List<RoleModel> roles;
  final List<String> permissions;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    this.lastName,
    this.phone,
    this.avatarUrl,
    required this.userType,
    required this.status,
    this.roles = const [],
    this.permissions = const [],
  });

  String get fullName {
    if (lastName != null && lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }
    return firstName;
  }

  bool get isAdmin => userType == 'ADMIN';
  bool get isUser => userType == 'USER';

  bool hasPermission(String permission) => permissions.contains(permission);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse roles
    List<RoleModel> parsedRoles = [];
    if (json['roles'] != null && json['roles'] is List) {
      for (final r in json['roles'] as List) {
        if (r is Map<String, dynamic>) {
          if (r['role'] is Map<String, dynamic>) {
            parsedRoles.add(RoleModel.fromJson(r['role'] as Map<String, dynamic>));
          } else {
            parsedRoles.add(RoleModel.fromJson(r));
          }
        }
      }
    }

    // Parse permissions (can be list of strings or list of permission objects)
    List<String> parsedPermissions = [];
    if (json['permissions'] != null && json['permissions'] is List) {
      for (final p in json['permissions'] as List) {
        if (p is String) {
          parsedPermissions.add(p);
        } else if (p is Map<String, dynamic>) {
          final permObj = p['permission'];
          if (permObj is Map<String, dynamic> && permObj['name'] != null) {
            parsedPermissions.add(permObj['name'] as String);
          } else if (p['name'] != null) {
            parsedPermissions.add(p['name'] as String);
          }
        }
      }
    }

    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      userType: json['userType'] as String? ?? 'USER',
      status: json['status'] as String? ?? 'ACTIVE',
      roles: parsedRoles,
      permissions: parsedPermissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'userType': userType,
      'status': status,
      'roles': roles.map((r) => r.toJson()).toList(),
      'permissions': permissions,
    };
  }
}

import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints/user.dart';
import '../models/user_management_models.dart';

class UserRepository {
  final Dio _dio;

  UserRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  // ==========================================
  // USERS MANAGEMENT API CALLS
  // ==========================================

  /// Fetch paginated users list with optional search & filters
  Future<PaginatedUsersResponse> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? userType,
    String? roleId,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (userType != null && userType.isNotEmpty) {
        queryParams['userType'] = userType;
      }
      if (roleId != null && roleId.isNotEmpty) {
        queryParams['roleId'] = roleId;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }
      if (sortOrder != null && sortOrder.isNotEmpty) {
        queryParams['sortOrder'] = sortOrder;
      }

      final response = await _dio.get(
        UserEndpoints.users,
        queryParameters: queryParams,
      );

      return PaginatedUsersResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Fetch single user details by ID
  Future<UserApiItem> getUserById(String id) async {
    try {
      final response = await _dio.get(UserEndpoints.userById(id));
      final data = response.data['data'] as Map<String, dynamic>;
      return UserApiItem.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Create a new user record
  Future<UserApiItem> createUser({
    required String email,
    required String password,
    required String firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    String status = 'ACTIVE',
    String userType = 'USER',
    List<String>? roleIds,
  }) async {
    try {
      final payload = <String, dynamic>{
        'email': email.trim().toLowerCase(),
        'password': password,
        'firstName': firstName.trim(),
        'status': status,
        'userType': userType,
      };

      if (lastName != null && lastName.trim().isNotEmpty) {
        payload['lastName'] = lastName.trim();
      }
      if (phone != null && phone.trim().isNotEmpty) {
        payload['phone'] = phone.trim();
      }
      if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
        payload['avatarUrl'] = avatarUrl.trim();
      }
      if (roleIds != null && roleIds.isNotEmpty) {
        payload['roleIds'] = roleIds;
      }

      final response = await _dio.post(
        UserEndpoints.users,
        data: payload,
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return UserApiItem.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Update an existing user's details
  Future<UserApiItem> updateUser(
    String id, {
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    String? status,
    String? userType,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (firstName != null) payload['firstName'] = firstName.trim();
      if (lastName != null) payload['lastName'] = lastName.trim();
      if (phone != null) payload['phone'] = phone.trim();
      if (avatarUrl != null) payload['avatarUrl'] = avatarUrl.trim();
      if (status != null) payload['status'] = status;
      if (userType != null) payload['userType'] = userType;

      final response = await _dio.patch(
        UserEndpoints.userById(id),
        data: payload,
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return UserApiItem.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Soft-delete user
  Future<String> deleteUser(String id) async {
    try {
      final response = await _dio.delete(UserEndpoints.userById(id));
      return response.data['message'] as String? ?? 'User deleted successfully';
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Reset password for user
  Future<String> resetPassword(String id, String newPassword) async {
    try {
      final response = await _dio.post(
        UserEndpoints.resetPassword(id),
        data: {'newPassword': newPassword},
      );
      return response.data['message'] as String? ?? 'Password reset successfully';
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Assign roles to user
  Future<void> assignRoles(String id, List<String> roleIds) async {
    try {
      await _dio.post(
        UserEndpoints.assignRoles(id),
        data: {'roleIds': roleIds},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Assign permission overrides to user
  Future<void> assignPermissions(
    String id,
    List<Map<String, String>> permissions,
  ) async {
    try {
      await _dio.post(
        UserEndpoints.assignPermissions(id),
        data: {'permissions': permissions},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ==========================================
  // ROLES MANAGEMENT API CALLS
  // ==========================================

  /// Fetch all system roles
  Future<List<RoleApiItem>> getRoles({
    String? search,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (isActive != null) {
        queryParams['isActive'] = isActive.toString();
      }

      final response = await _dio.get(
        UserEndpoints.roles,
        queryParameters: queryParams,
      );

      final dataList = response.data['data'] as List? ?? [];
      return dataList.map((r) => RoleApiItem.fromJson(r as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Fetch role details by ID
  Future<RoleApiItem> getRoleById(String id) async {
    try {
      final response = await _dio.get(UserEndpoints.roleById(id));
      final data = response.data['data'] as Map<String, dynamic>;
      return RoleApiItem.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Create a new role
  Future<RoleApiItem> createRole({
    required String name,
    String? slug,
    String? description,
    bool isActive = true,
    List<String>? permissionIds,
  }) async {
    try {
      final payload = <String, dynamic>{
        'name': name.trim(),
        'isActive': isActive,
      };

      if (slug != null && slug.trim().isNotEmpty) {
        payload['slug'] = slug.trim();
      }
      if (description != null && description.trim().isNotEmpty) {
        payload['description'] = description.trim();
      }
      if (permissionIds != null && permissionIds.isNotEmpty) {
        payload['permissionIds'] = permissionIds;
      }

      final response = await _dio.post(
        UserEndpoints.roles,
        data: payload,
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return RoleApiItem.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Update an existing role
  Future<RoleApiItem> updateRole(
    String id, {
    String? name,
    String? slug,
    String? description,
    bool? isActive,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (name != null) payload['name'] = name.trim();
      if (slug != null) payload['slug'] = slug.trim();
      if (description != null) payload['description'] = description.trim();
      if (isActive != null) payload['isActive'] = isActive;

      final response = await _dio.patch(
        UserEndpoints.roleById(id),
        data: payload,
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return RoleApiItem.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Delete a role
  Future<String> deleteRole(String id) async {
    try {
      final response = await _dio.delete(UserEndpoints.roleById(id));
      return response.data['message'] as String? ?? 'Role deleted successfully';
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Assign/update permissions for a role
  Future<RoleApiItem> assignRolePermissions(
    String roleId,
    List<String> permissionIds,
  ) async {
    try {
      final response = await _dio.post(
        UserEndpoints.rolePermissions(roleId),
        data: {'permissionIds': permissionIds},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return RoleApiItem.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ==========================================
  // PERMISSIONS MANAGEMENT API CALLS
  // ==========================================

  /// Fetch all system permissions
  Future<List<PermissionApiItem>> getPermissions({
    String? resource,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (resource != null && resource.trim().isNotEmpty) {
        queryParams['resource'] = resource.trim();
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final response = await _dio.get(
        UserEndpoints.permissions,
        queryParameters: queryParams,
      );

      final dataList = response.data['data'] as List? ?? [];
      return dataList.map((p) => PermissionApiItem.fromJson(p as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}

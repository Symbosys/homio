import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../../core/utils/query_cache_utils.dart';
import '../../../../core/utils/toast_service.dart';
import '../../data/models/user_management_models.dart';
import '../../data/repositories/user_repository.dart';

abstract class UserQueryKeys {
  static const String usersList = 'users_list';
  static const String rolesList = 'roles_list';
  static const String permissionsList = 'permissions_list';

  static String userDetail(String id) => 'user_detail_$id';
  static String roleDetail(String id) => 'role_detail_$id';
}

class UserQueries {
  final UserRepository _repository;

  UserQueries({UserRepository? repository})
      : _repository = repository ?? UserRepository();

  // ==========================================
  // QUERIES
  // ==========================================

  /// Query to fetch paginated users list
  Query<PaginatedUsersResponse> getUsersQuery({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? userType,
    String? roleId,
    String? sortBy,
    String? sortOrder,
  }) {
    final queryKey = '${UserQueryKeys.usersList}_${page}_${search ?? ''}_${status ?? ''}_${roleId ?? ''}_${userType ?? ''}';

    return Query<PaginatedUsersResponse>(
      key: queryKey,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getUsers(
        page: page,
        limit: limit,
        search: search,
        status: status,
        userType: userType,
        roleId: roleId,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ),
    );
  }

  /// Query to fetch system roles list
  Query<List<RoleApiItem>> getRolesQuery({
    String? search,
    bool? isActive,
  }) {
    final queryKey = '${UserQueryKeys.rolesList}_${search ?? ''}_${isActive ?? ''}';

    return Query<List<RoleApiItem>>(
      key: queryKey,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 10),
      ),
      queryFn: () => _repository.getRoles(
        search: search,
        isActive: isActive,
      ),
    );
  }

  /// Query to fetch system permissions list
  Query<List<PermissionApiItem>> getPermissionsQuery({
    String? resource,
    String? search,
  }) {
    final queryKey = '${UserQueryKeys.permissionsList}_${resource ?? ''}_${search ?? ''}';

    return Query<List<PermissionApiItem>>(
      key: queryKey,
      config: QueryConfig(
        staleDuration: const Duration(minutes: 5),
        cacheDuration: const Duration(hours: 1),
      ),
      queryFn: () => _repository.getPermissions(
        resource: resource,
        search: search,
      ),
    );
  }

  // ==========================================
  // MUTATIONS (USERS)
  // ==========================================

  /// Invalidate and immediately refetch all user queries
  void invalidateUsersCache() =>
      QueryCacheUtils.invalidateAndRefetch(UserQueryKeys.usersList);

  /// Invalidate and immediately refetch all role queries and user queries
  void invalidateRolesCache() => QueryCacheUtils.invalidateAndRefetchMultiple([
        UserQueryKeys.rolesList,
        UserQueryKeys.usersList,
      ]);

  /// Mutation: Create user
  Mutation<UserApiItem, ({
    String email,
    String password,
    String firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    String status,
    String userType,
    List<String>? roleIds,
  })> getCreateUserMutation({void Function(UserApiItem user)? onCreated}) {
    return Mutation<UserApiItem, ({
      String email,
      String password,
      String firstName,
      String? lastName,
      String? phone,
      String? avatarUrl,
      String status,
      String userType,
      List<String>? roleIds,
    })>(
      mutationFn: (args) => _repository.createUser(
        email: args.email,
        password: args.password,
        firstName: args.firstName,
        lastName: args.lastName,
        phone: args.phone,
        avatarUrl: args.avatarUrl,
        status: args.status,
        userType: args.userType,
        roleIds: args.roleIds,
      ),
      onSuccess: (user, _) {
        invalidateUsersCache();
        ToastService.showSuccess('User ${user.fullName} created successfully!');
        if (onCreated != null) onCreated(user);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update user
  Mutation<UserApiItem, ({
    String id,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    String? status,
    String? userType,
  })> getUpdateUserMutation({void Function(UserApiItem user)? onUpdated}) {
    return Mutation<UserApiItem, ({
      String id,
      String? firstName,
      String? lastName,
      String? phone,
      String? avatarUrl,
      String? status,
      String? userType,
    })>(
      mutationFn: (args) => _repository.updateUser(
        args.id,
        firstName: args.firstName,
        lastName: args.lastName,
        phone: args.phone,
        avatarUrl: args.avatarUrl,
        status: args.status,
        userType: args.userType,
      ),
      onSuccess: (user, _) {
        invalidateUsersCache();
        ToastService.showSuccess('User ${user.fullName} updated successfully.');
        if (onUpdated != null) onUpdated(user);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Delete / soft-delete user
  Mutation<String, String> getDeleteUserMutation({void Function(String id)? onDeleted}) {
    return Mutation<String, String>(
      mutationFn: (id) => _repository.deleteUser(id),
      onSuccess: (msg, id) {
        invalidateUsersCache();
        ToastService.showSuccess(msg.isNotEmpty ? msg : 'User deleted successfully.');
        if (onDeleted != null) onDeleted(id);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Reset user password
  Mutation<String, ({String id, String newPassword})> getResetPasswordMutation() {
    return Mutation<String, ({String id, String newPassword})>(
      mutationFn: (args) => _repository.resetPassword(args.id, args.newPassword),
      onSuccess: (msg, _) {
        ToastService.showSuccess(msg.isNotEmpty ? msg : 'Password reset successfully.');
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Assign roles to user
  Mutation<void, ({String id, List<String> roleIds})> getAssignUserRolesMutation({void Function()? onAssigned}) {
    return Mutation<void, ({String id, List<String> roleIds})>(
      mutationFn: (args) => _repository.assignRoles(args.id, args.roleIds),
      onSuccess: (_, _) {
        invalidateUsersCache();
        ToastService.showSuccess('User roles assigned successfully.');
        if (onAssigned != null) onAssigned();
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  // ==========================================
  // MUTATIONS (ROLES)
  // ==========================================

  /// Mutation: Create role
  Mutation<RoleApiItem, ({
    String name,
    String? slug,
    String? description,
    bool isActive,
    List<String>? permissionIds,
  })> getCreateRoleMutation({void Function(RoleApiItem role)? onCreated}) {
    return Mutation<RoleApiItem, ({
      String name,
      String? slug,
      String? description,
      bool isActive,
      List<String>? permissionIds,
    })>(
      mutationFn: (args) => _repository.createRole(
        name: args.name,
        slug: args.slug,
        description: args.description,
        isActive: args.isActive,
        permissionIds: args.permissionIds,
      ),
      onSuccess: (role, _) {
        invalidateRolesCache();
        ToastService.showSuccess('Role "${role.name}" created successfully!');
        if (onCreated != null) onCreated(role);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update role
  Mutation<RoleApiItem, ({
    String id,
    String? name,
    String? slug,
    String? description,
    bool? isActive,
  })> getUpdateRoleMutation({void Function(RoleApiItem role)? onUpdated}) {
    return Mutation<RoleApiItem, ({
      String id,
      String? name,
      String? slug,
      String? description,
      bool? isActive,
    })>(
      mutationFn: (args) => _repository.updateRole(
        args.id,
        name: args.name,
        slug: args.slug,
        description: args.description,
        isActive: args.isActive,
      ),
      onSuccess: (role, _) {
        invalidateRolesCache();
        ToastService.showSuccess('Role "${role.name}" updated successfully.');
        if (onUpdated != null) onUpdated(role);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Delete role
  Mutation<String, String> getDeleteRoleMutation({void Function(String id)? onDeleted}) {
    return Mutation<String, String>(
      mutationFn: (id) => _repository.deleteRole(id),
      onSuccess: (msg, id) {
        invalidateRolesCache();
        ToastService.showSuccess(msg.isNotEmpty ? msg : 'Role deleted successfully.');
        if (onDeleted != null) onDeleted(id);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Assign permissions to role
  Mutation<RoleApiItem, ({String roleId, List<String> permissionIds})> getAssignRolePermissionsMutation({void Function(RoleApiItem role)? onAssigned}) {
    return Mutation<RoleApiItem, ({String roleId, List<String> permissionIds})>(
      mutationFn: (args) => _repository.assignRolePermissions(args.roleId, args.permissionIds),
      onSuccess: (role, _) {
        invalidateRolesCache();
        ToastService.showSuccess('Permissions for "${role.name}" updated successfully!');
        if (onAssigned != null) onAssigned(role);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }
}

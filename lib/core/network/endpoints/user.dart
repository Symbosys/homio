/// User, Role & Permission Module Endpoints
abstract class UserEndpoints {
  // Authentication
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // User Management
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static String resetPassword(String id) => '/users/$id/reset-password';
  static String assignRoles(String id) => '/users/$id/roles';
  static String assignPermissions(String id) => '/users/$id/permissions';

  // Role Management
  static const String roles = '/roles';
  static String roleById(String id) => '/roles/$id';
  static String rolePermissions(String id) => '/roles/$id/permissions';

  // System Permissions
  static const String permissions = '/permissions';
}


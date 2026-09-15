/// User & Authentication Module Endpoints
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
}

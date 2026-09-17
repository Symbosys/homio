/// Platform Admin Module Endpoints (SaaS Platform Owner)
abstract class PlatformEndpoints {
  // Subscription Plans
  static const String plans = '/platform/subscriptions';
  static String planById(String id) => '/platform/subscriptions/$id';
  static String togglePlanStatus(String id) => '/platform/subscriptions/$id/toggle-status';

  // Organizations
  static const String organizations = '/platform/organizations';
  static const String onboard = '/platform/organizations/onboard';
  static String organizationById(String id) => '/platform/organizations/$id';
  static String organizationStatus(String id) => '/platform/organizations/$id/status';
  static String organizationSubscription(String id) => '/platform/organizations/$id/subscription';
}

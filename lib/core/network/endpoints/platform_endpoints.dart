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

  // Marketplace Governance
  static const String marketplaceCategories = '/marketplace/categories';
  static const String marketplaceCategoryTree = '/marketplace/categories/tree';
  static String marketplaceCategoryById(String id) => '/marketplace/categories/$id';

  static const String marketplaceProperties = '/marketplace/properties';
  static String verifyProperty(String id) => '/marketplace/properties/$id/verification';

  static const String marketplaceSellerCategories = '/marketplace/seller-categories';
  static String reviewSellerCategory(String id) => '/marketplace/seller-categories/$id/status';
}

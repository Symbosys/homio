abstract class MarketplaceEndpoints {
  // Categories (Public / Taxonomy)
  static const String categories = '/marketplace/categories';
  static const String categoryTree = '/marketplace/categories/tree';
  static String categoryById(String id) => '/marketplace/categories/$id';

  // Digital Products
  static const String digitalProducts = '/marketplace/digital-products';
  static String digitalProductById(String id) => '/marketplace/digital-products/$id';

  // Home Decor
  static const String homeDecor = '/marketplace/home-decor';
  static String homeDecorById(String id) => '/marketplace/home-decor/$id';

  // Real Estate Properties
  static const String properties = '/marketplace/properties';
  static String propertyById(String id) => '/marketplace/properties/$id';

  // Building Materials
  static const String materials = '/marketplace/materials';
  static String materialById(String id) => '/marketplace/materials/$id';

  // Seller Category Intent & Approvals
  static const String sellerCategories = '/marketplace/seller-categories';
  static String sellerCategoryById(String id) => '/marketplace/seller-categories/$id';

  // Vendors & Suppliers
  static const String vendors = '/marketplace/vendors';
  static String vendorById(String id) => '/marketplace/vendors/$id';
}

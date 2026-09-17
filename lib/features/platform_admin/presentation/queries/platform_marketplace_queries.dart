import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../../core/utils/query_cache_utils.dart';
import '../../../../core/utils/toast_service.dart';
import '../../data/models/platform_marketplace_category_model.dart';
import '../../data/models/platform_property_listing_model.dart';
import '../../data/models/platform_seller_application_model.dart';
import '../../data/repositories/platform_marketplace_repository.dart';

abstract class PlatformMarketplaceQueryKeys {
  static const String categories = 'platform_marketplace_categories';
  static const String categoryTree = 'platform_marketplace_category_tree';
  static const String properties = 'platform_marketplace_properties';
  static const String sellerApplications = 'platform_marketplace_seller_apps';
}

typedef CreateCategoryParams = ({
  Map<String, dynamic> data,
  List<int>? imageBytes,
  String? imageFileName,
});

typedef UpdateCategoryParams = ({
  String id,
  Map<String, dynamic> data,
  List<int>? imageBytes,
  String? imageFileName,
});

class PlatformMarketplaceQueries {
  final PlatformMarketplaceRepository _repo;

  PlatformMarketplaceQueries({PlatformMarketplaceRepository? repo})
      : _repo = repo ?? PlatformMarketplaceRepository();

  // ===========================================================================
  // CACHE INVALIDATIONS
  // ===========================================================================

  void invalidateCategoriesCache() {
    QueryCacheUtils.invalidateAndRefetch(PlatformMarketplaceQueryKeys.categories);
    QueryCacheUtils.invalidateAndRefetch(PlatformMarketplaceQueryKeys.categoryTree);
  }

  void invalidatePropertiesCache() {
    QueryCacheUtils.invalidateAndRefetch(PlatformMarketplaceQueryKeys.properties);
  }

  void invalidateSellerApplicationsCache() {
    QueryCacheUtils.invalidateAndRefetch(PlatformMarketplaceQueryKeys.sellerApplications);
  }

  // ===========================================================================
  // QUERIES
  // ===========================================================================

  /// Query to fetch categories optionally filtered by marketplace vertical
  Query<List<PlatformMarketplaceCategoryModel>> getCategoriesQuery({String? marketplaceType}) {
    final queryKey = '${PlatformMarketplaceQueryKeys.categories}_${marketplaceType ?? 'ALL'}';

    return Query<List<PlatformMarketplaceCategoryModel>>(
      key: queryKey,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getCategories(marketplaceType: marketplaceType),
    );
  }

  /// Query to fetch hierarchical category tree
  Query<List<PlatformMarketplaceCategoryModel>> getCategoryTreeQuery() {
    return Query<List<PlatformMarketplaceCategoryModel>>(
      key: PlatformMarketplaceQueryKeys.categoryTree,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getCategoryTree(),
    );
  }

  /// Query to fetch properties for verification
  Query<PaginatedPlatformPropertiesResponse> getPropertiesQuery({
    String? verificationStatus,
    int page = 1,
    int limit = 20,
    String? search,
  }) {
    final queryKey =
        '${PlatformMarketplaceQueryKeys.properties}_${verificationStatus ?? 'ALL'}_${page}_${limit}_${search ?? ''}';

    return Query<PaginatedPlatformPropertiesResponse>(
      key: queryKey,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getProperties(
        verificationStatus: verificationStatus,
        page: page,
        limit: limit,
        search: search,
      ),
    );
  }

  /// Query to fetch seller applications
  Query<List<PlatformSellerApplicationModel>> getSellerApplicationsQuery({
    bool? isApproved,
    int page = 1,
    int limit = 20,
  }) {
    final queryKey =
        '${PlatformMarketplaceQueryKeys.sellerApplications}_${isApproved ?? 'ALL'}_${page}_$limit';

    return Query<List<PlatformSellerApplicationModel>>(
      key: queryKey,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getSellerApplications(
        isApproved: isApproved,
        page: page,
        limit: limit,
      ),
    );
  }

  // ===========================================================================
  // MUTATIONS
  // ===========================================================================

  /// Mutation: Create a marketplace category
  Mutation<PlatformMarketplaceCategoryModel, CreateCategoryParams> getCreateCategoryMutation({
    void Function(PlatformMarketplaceCategoryModel category)? onCreated,
  }) {
    return Mutation<PlatformMarketplaceCategoryModel, CreateCategoryParams>(
      mutationFn: (args) => _repo.createCategory(
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (category, args) {
        invalidateCategoriesCache();
        ToastService.showSuccess('Category "${category.name}" created successfully!');
        onCreated?.call(category);
      },
      onError: (args, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update a category
  Mutation<PlatformMarketplaceCategoryModel, UpdateCategoryParams> getUpdateCategoryMutation({
    void Function(PlatformMarketplaceCategoryModel category)? onUpdated,
  }) {
    return Mutation<PlatformMarketplaceCategoryModel, UpdateCategoryParams>(
      mutationFn: (args) => _repo.updateCategory(
        args.id,
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (category, args) {
        invalidateCategoriesCache();
        ToastService.showSuccess('Category "${category.name}" updated successfully!');
        onUpdated?.call(category);
      },
      onError: (args, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Delete a category
  Mutation<void, String> getDeleteCategoryMutation({
    void Function()? onDeleted,
  }) {
    return Mutation<void, String>(
      mutationFn: (id) => _repo.deleteCategory(id),
      onSuccess: (_, id) {
        invalidateCategoriesCache();
        ToastService.showSuccess('Category deleted successfully!');
        onDeleted?.call();
      },
      onError: (id, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Verify/Reject property
  Mutation<void, ({String id, String status})> getVerifyPropertyMutation({
    void Function()? onVerified,
  }) {
    return Mutation<void, ({String id, String status})>(
      mutationFn: (args) => _repo.verifyProperty(args.id, args.status),
      onSuccess: (_, args) {
        invalidatePropertiesCache();
        final label = args.status == 'VERIFIED' ? 'Verified' : 'Rejected';
        ToastService.showSuccess('Property status updated to $label.');
        onVerified?.call();
      },
      onError: (args, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Review seller category application
  Mutation<void, ({String id, bool isApproved, double? commissionRate})>
      getReviewSellerApplicationMutation({
    void Function()? onReviewed,
  }) {
    return Mutation<void, ({String id, bool isApproved, double? commissionRate})>(
      mutationFn: (args) => _repo.reviewSellerApplication(
        args.id,
        args.isApproved,
        args.commissionRate,
      ),
      onSuccess: (_, args) {
        invalidateSellerApplicationsCache();
        final action = args.isApproved ? 'Approved' : 'Rejected';
        ToastService.showSuccess('Seller application $action successfully.');
        onReviewed?.call();
      },
      onError: (args, error, fallback) {
        ToastService.showError(error);
      },
    );
  }
}

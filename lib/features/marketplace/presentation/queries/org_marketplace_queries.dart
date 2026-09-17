import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../../core/utils/query_cache_utils.dart';
import '../../../../core/utils/toast_service.dart';
import '../../../platform_admin/data/models/platform_marketplace_category_model.dart';
import '../../data/models/org_marketplace_models.dart';
import '../../data/repositories/org_marketplace_repository.dart';

abstract class OrgMarketplaceQueryKeys {
  static const String categories = 'org_marketplace_categories';
  static const String digitalProducts = 'org_marketplace_digital_products';
  static const String homeDecor = 'org_marketplace_home_decor';
  static const String properties = 'org_marketplace_properties';
  static const String materials = 'org_marketplace_materials';
  static const String sellerCategories = 'org_marketplace_seller_categories';
  static const String vendors = 'org_marketplace_vendors';
}

typedef CreateItemParams = ({
  Map<String, dynamic> data,
  List<int>? imageBytes,
  String? imageFileName,
});

typedef UpdateItemParams = ({
  String id,
  Map<String, dynamic> data,
  List<int>? imageBytes,
  String? imageFileName,
});

class OrgMarketplaceQueries {
  final OrgMarketplaceRepository _repo;

  OrgMarketplaceQueries({OrgMarketplaceRepository? repo})
      : _repo = repo ?? OrgMarketplaceRepository();

  // ===========================================================================
  // CACHE INVALIDATIONS
  // ===========================================================================

  void invalidateDigitalProductsCache() {
    QueryCacheUtils.invalidateAndRefetch(OrgMarketplaceQueryKeys.digitalProducts);
  }

  void invalidateHomeDecorCache() {
    QueryCacheUtils.invalidateAndRefetch(OrgMarketplaceQueryKeys.homeDecor);
  }

  void invalidatePropertiesCache() {
    QueryCacheUtils.invalidateAndRefetch(OrgMarketplaceQueryKeys.properties);
  }

  void invalidateMaterialsCache() {
    QueryCacheUtils.invalidateAndRefetch(OrgMarketplaceQueryKeys.materials);
  }

  void invalidateSellerCategoriesCache() {
    QueryCacheUtils.invalidateAndRefetch(OrgMarketplaceQueryKeys.sellerCategories);
  }

  void invalidateVendorsCache() {
    QueryCacheUtils.invalidateAndRefetch(OrgMarketplaceQueryKeys.vendors);
  }

  // ===========================================================================
  // QUERIES
  // ===========================================================================

  Query<List<PlatformMarketplaceCategoryModel>> getCategoriesQuery({String? marketplaceType}) {
    final key = '${OrgMarketplaceQueryKeys.categories}_${marketplaceType ?? 'ALL'}';
    return Query<List<PlatformMarketplaceCategoryModel>>(
      key: key,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getCategories(marketplaceType: marketplaceType),
    );
  }

  Query<List<OrgDigitalProductModel>> getDigitalProductsQuery({String? categoryId, String? search}) {
    final key = '${OrgMarketplaceQueryKeys.digitalProducts}_${categoryId ?? 'ALL'}_${search ?? ''}';
    return Query<List<OrgDigitalProductModel>>(
      key: key,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getDigitalProducts(categoryId: categoryId, search: search),
    );
  }

  Query<List<OrgHomeDecorProductModel>> getHomeDecorQuery({String? categoryId, String? search}) {
    final key = '${OrgMarketplaceQueryKeys.homeDecor}_${categoryId ?? 'ALL'}_${search ?? ''}';
    return Query<List<OrgHomeDecorProductModel>>(
      key: key,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getHomeDecor(categoryId: categoryId, search: search),
    );
  }

  Query<List<OrgPropertyListingModel>> getPropertiesQuery({String? categoryId, String? city, String? search}) {
    final key = '${OrgMarketplaceQueryKeys.properties}_${categoryId ?? 'ALL'}_${city ?? 'ALL'}_${search ?? ''}';
    return Query<List<OrgPropertyListingModel>>(
      key: key,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getProperties(categoryId: categoryId, city: city, search: search),
    );
  }

  Query<List<OrgMaterialProductModel>> getMaterialsQuery({String? categoryId, String? search}) {
    final key = '${OrgMarketplaceQueryKeys.materials}_${categoryId ?? 'ALL'}_${search ?? ''}';
    return Query<List<OrgMaterialProductModel>>(
      key: key,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getMaterials(categoryId: categoryId, search: search),
    );
  }

  Query<List<OrgSellerCategoryModel>> getSellerCategoriesQuery() {
    return Query<List<OrgSellerCategoryModel>>(
      key: OrgMarketplaceQueryKeys.sellerCategories,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getSellerCategories(),
    );
  }

  Query<List<OrgVendorModel>> getVendorsQuery() {
    return Query<List<OrgVendorModel>>(
      key: OrgMarketplaceQueryKeys.vendors,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 15),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repo.getVendors(),
    );
  }

  // ===========================================================================
  // MUTATIONS: DIGITAL PRODUCTS
  // ===========================================================================

  Mutation<OrgDigitalProductModel, CreateItemParams> getCreateDigitalProductMutation({
    void Function(OrgDigitalProductModel product)? onCreated,
  }) {
    return Mutation<OrgDigitalProductModel, CreateItemParams>(
      mutationFn: (args) => _repo.createDigitalProduct(
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (res, args) {
        invalidateDigitalProductsCache();
        ToastService.showSuccess('Digital product "${res.name}" created successfully!');
        onCreated?.call(res);
      },
      onError: (args, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<OrgDigitalProductModel, UpdateItemParams> getUpdateDigitalProductMutation({
    void Function(OrgDigitalProductModel product)? onUpdated,
  }) {
    return Mutation<OrgDigitalProductModel, UpdateItemParams>(
      mutationFn: (args) => _repo.updateDigitalProduct(
        args.id,
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (res, args) {
        invalidateDigitalProductsCache();
        ToastService.showSuccess('Digital product "${res.name}" updated successfully!');
        onUpdated?.call(res);
      },
      onError: (args, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<void, String> getDeleteDigitalProductMutation({void Function()? onDeleted}) {
    return Mutation<void, String>(
      mutationFn: (id) => _repo.deleteDigitalProduct(id),
      onSuccess: (_, id) {
        invalidateDigitalProductsCache();
        ToastService.showSuccess('Digital product deleted successfully!');
        onDeleted?.call();
      },
      onError: (id, error, fallback) => ToastService.showError(error),
    );
  }

  // ===========================================================================
  // MUTATIONS: HOME DECOR
  // ===========================================================================

  Mutation<OrgHomeDecorProductModel, CreateItemParams> getCreateHomeDecorMutation({
    void Function(OrgHomeDecorProductModel product)? onCreated,
  }) {
    return Mutation<OrgHomeDecorProductModel, CreateItemParams>(
      mutationFn: (args) => _repo.createHomeDecor(
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (res, args) {
        invalidateHomeDecorCache();
        ToastService.showSuccess('Home decor product "${res.name}" created successfully!');
        onCreated?.call(res);
      },
      onError: (args, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<OrgHomeDecorProductModel, UpdateItemParams> getUpdateHomeDecorMutation({
    void Function(OrgHomeDecorProductModel product)? onUpdated,
  }) {
    return Mutation<OrgHomeDecorProductModel, UpdateItemParams>(
      mutationFn: (args) => _repo.updateHomeDecor(
        args.id,
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (res, args) {
        invalidateHomeDecorCache();
        ToastService.showSuccess('Home decor product "${res.name}" updated successfully!');
        onUpdated?.call(res);
      },
      onError: (args, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<void, String> getDeleteHomeDecorMutation({void Function()? onDeleted}) {
    return Mutation<void, String>(
      mutationFn: (id) => _repo.deleteHomeDecor(id),
      onSuccess: (_, id) {
        invalidateHomeDecorCache();
        ToastService.showSuccess('Home decor product deleted successfully!');
        onDeleted?.call();
      },
      onError: (id, error, fallback) => ToastService.showError(error),
    );
  }

  // ===========================================================================
  // MUTATIONS: PROPERTIES
  // ===========================================================================

  Mutation<OrgPropertyListingModel, CreateItemParams> getCreatePropertyMutation({
    void Function(OrgPropertyListingModel property)? onCreated,
  }) {
    return Mutation<OrgPropertyListingModel, CreateItemParams>(
      mutationFn: (args) => _repo.createProperty(
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (res, args) {
        invalidatePropertiesCache();
        ToastService.showSuccess('Property listing "${res.title}" created successfully!');
        onCreated?.call(res);
      },
      onError: (args, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<OrgPropertyListingModel, UpdateItemParams> getUpdatePropertyMutation({
    void Function(OrgPropertyListingModel property)? onUpdated,
  }) {
    return Mutation<OrgPropertyListingModel, UpdateItemParams>(
      mutationFn: (args) => _repo.updateProperty(
        args.id,
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (res, args) {
        invalidatePropertiesCache();
        ToastService.showSuccess('Property listing "${res.title}" updated successfully!');
        onUpdated?.call(res);
      },
      onError: (args, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<void, String> getDeletePropertyMutation({void Function()? onDeleted}) {
    return Mutation<void, String>(
      mutationFn: (id) => _repo.deleteProperty(id),
      onSuccess: (_, id) {
        invalidatePropertiesCache();
        ToastService.showSuccess('Property listing deleted successfully!');
        onDeleted?.call();
      },
      onError: (id, error, fallback) => ToastService.showError(error),
    );
  }

  // ===========================================================================
  // MUTATIONS: MATERIALS
  // ===========================================================================

  Mutation<OrgMaterialProductModel, CreateItemParams> getCreateMaterialMutation({
    void Function(OrgMaterialProductModel material)? onCreated,
  }) {
    return Mutation<OrgMaterialProductModel, CreateItemParams>(
      mutationFn: (args) => _repo.createMaterial(
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (res, args) {
        invalidateMaterialsCache();
        ToastService.showSuccess('Material product "${res.name}" created successfully!');
        onCreated?.call(res);
      },
      onError: (args, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<OrgMaterialProductModel, UpdateItemParams> getUpdateMaterialMutation({
    void Function(OrgMaterialProductModel material)? onUpdated,
  }) {
    return Mutation<OrgMaterialProductModel, UpdateItemParams>(
      mutationFn: (args) => _repo.updateMaterial(
        args.id,
        args.data,
        imageBytes: args.imageBytes,
        imageFileName: args.imageFileName,
      ),
      onSuccess: (res, args) {
        invalidateMaterialsCache();
        ToastService.showSuccess('Material product "${res.name}" updated successfully!');
        onUpdated?.call(res);
      },
      onError: (args, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<void, String> getDeleteMaterialMutation({void Function()? onDeleted}) {
    return Mutation<void, String>(
      mutationFn: (id) => _repo.deleteMaterial(id),
      onSuccess: (_, id) {
        invalidateMaterialsCache();
        ToastService.showSuccess('Material product deleted successfully!');
        onDeleted?.call();
      },
      onError: (id, error, fallback) => ToastService.showError(error),
    );
  }

  // ===========================================================================
  // MUTATIONS: SELLER CATEGORIES
  // ===========================================================================

  Mutation<OrgSellerCategoryModel, String> getRegisterCategoryIntentMutation({
    void Function(OrgSellerCategoryModel result)? onRegistered,
  }) {
    return Mutation<OrgSellerCategoryModel, String>(
      mutationFn: (categoryId) => _repo.registerCategoryIntent(categoryId),
      onSuccess: (res, categoryId) {
        invalidateSellerCategoriesCache();
        ToastService.showSuccess('Category authorization requested successfully!');
        onRegistered?.call(res);
      },
      onError: (categoryId, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<void, String> getRemoveCategoryIntentMutation({void Function()? onRemoved}) {
    return Mutation<void, String>(
      mutationFn: (id) => _repo.removeCategoryIntent(id),
      onSuccess: (_, id) {
        invalidateSellerCategoriesCache();
        ToastService.showSuccess('Category registration removed.');
        onRemoved?.call();
      },
      onError: (id, error, fallback) => ToastService.showError(error),
    );
  }

  // ===========================================================================
  // MUTATIONS: VENDORS
  // ===========================================================================

  Mutation<OrgVendorModel, Map<String, dynamic>> getCreateVendorMutation({
    void Function(OrgVendorModel vendor)? onCreated,
  }) {
    return Mutation<OrgVendorModel, Map<String, dynamic>>(
      mutationFn: (data) => _repo.createVendor(data),
      onSuccess: (res, data) {
        invalidateVendorsCache();
        ToastService.showSuccess('Vendor "${res.companyName}" added successfully!');
        onCreated?.call(res);
      },
      onError: (data, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<OrgVendorModel, ({String id, Map<String, dynamic> data})> getUpdateVendorMutation({
    void Function(OrgVendorModel vendor)? onUpdated,
  }) {
    return Mutation<OrgVendorModel, ({String id, Map<String, dynamic> data})>(
      mutationFn: (args) => _repo.updateVendor(args.id, args.data),
      onSuccess: (res, args) {
        invalidateVendorsCache();
        ToastService.showSuccess('Vendor "${res.companyName}" updated successfully!');
        onUpdated?.call(res);
      },
      onError: (args, error, fallback) => ToastService.showError(error),
    );
  }

  Mutation<void, String> getDeleteVendorMutation({void Function()? onDeleted}) {
    return Mutation<void, String>(
      mutationFn: (id) => _repo.deleteVendor(id),
      onSuccess: (_, id) {
        invalidateVendorsCache();
        ToastService.showSuccess('Vendor deleted successfully!');
        onDeleted?.call();
      },
      onError: (id, error, fallback) => ToastService.showError(error),
    );
  }
}

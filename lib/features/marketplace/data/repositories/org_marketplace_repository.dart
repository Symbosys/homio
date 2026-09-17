import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints/marketplace_endpoints.dart';
import '../../../platform_admin/data/models/platform_marketplace_category_model.dart';
import '../models/org_marketplace_models.dart';

class OrgMarketplaceRepository {
  final Dio _dio;

  OrgMarketplaceRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  // ===========================================================================
  // MASTER CATEGORIES (Dropdowns & Hierarchies)
  // ===========================================================================

  Future<List<PlatformMarketplaceCategoryModel>> getCategories({String? marketplaceType}) async {
    try {
      final response = await _dio.get(
        MarketplaceEndpoints.categories,
        queryParameters: {
          if (marketplaceType != null && marketplaceType != 'ALL') 'marketplaceType': marketplaceType,
        },
      );

      final data = response.data['data'];
      final List list;
      if (data is Map<String, dynamic> && data['items'] is List) {
        list = data['items'] as List;
      } else if (data is List) {
        list = data;
      } else {
        list = const [];
      }

      return list
          .map((item) => PlatformMarketplaceCategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ===========================================================================
  // DIGITAL PRODUCTS
  // ===========================================================================

  Future<List<OrgDigitalProductModel>> getDigitalProducts({
    String? categoryId,
    String? search,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        MarketplaceEndpoints.digitalProducts,
        queryParameters: {
          if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') 'categoryId': categoryId,
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'limit': limit,
        },
      );

      final data = response.data['data'];
      final List list = (data is Map<String, dynamic> && data['items'] is List)
          ? (data['items'] as List)
          : (data is List ? data : const []);

      return list.map((item) => OrgDigitalProductModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgDigitalProductModel> createDigitalProduct(
    Map<String, dynamic> data, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic payload = data;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['coverImage'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName ?? 'cover_image.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.post(MarketplaceEndpoints.digitalProducts, data: payload);
      return OrgDigitalProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgDigitalProductModel> updateDigitalProduct(
    String id,
    Map<String, dynamic> data, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic payload = data;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['coverImage'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName ?? 'cover_image.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.put(MarketplaceEndpoints.digitalProductById(id), data: payload);
      return OrgDigitalProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<void> deleteDigitalProduct(String id) async {
    try {
      await _dio.delete(MarketplaceEndpoints.digitalProductById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ===========================================================================
  // HOME DECOR PRODUCTS
  // ===========================================================================

  Future<List<OrgHomeDecorProductModel>> getHomeDecor({
    String? categoryId,
    String? search,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        MarketplaceEndpoints.homeDecor,
        queryParameters: {
          if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') 'categoryId': categoryId,
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'limit': limit,
        },
      );

      final data = response.data['data'];
      final List list = (data is Map<String, dynamic> && data['items'] is List)
          ? (data['items'] as List)
          : (data is List ? data : const []);

      return list.map((item) => OrgHomeDecorProductModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgHomeDecorProductModel> createHomeDecor(
    Map<String, dynamic> data, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic payload = data;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['coverImage'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName ?? 'decor_cover.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.post(MarketplaceEndpoints.homeDecor, data: payload);
      return OrgHomeDecorProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgHomeDecorProductModel> updateHomeDecor(
    String id,
    Map<String, dynamic> data, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic payload = data;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['coverImage'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName ?? 'decor_cover.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.put(MarketplaceEndpoints.homeDecorById(id), data: payload);
      return OrgHomeDecorProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<void> deleteHomeDecor(String id) async {
    try {
      await _dio.delete(MarketplaceEndpoints.homeDecorById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ===========================================================================
  // REAL ESTATE PROPERTY LISTINGS
  // ===========================================================================

  Future<List<OrgPropertyListingModel>> getProperties({
    String? categoryId,
    String? city,
    String? search,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        MarketplaceEndpoints.properties,
        queryParameters: {
          if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') 'categoryId': categoryId,
          if (city != null && city.isNotEmpty) 'city': city,
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'limit': limit,
        },
      );

      final data = response.data['data'];
      final List list = (data is Map<String, dynamic> && data['items'] is List)
          ? (data['items'] as List)
          : (data is List ? data : const []);

      return list.map((item) => OrgPropertyListingModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgPropertyListingModel> createProperty(
    Map<String, dynamic> data, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic payload = data;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['coverImage'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName ?? 'property_cover.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.post(MarketplaceEndpoints.properties, data: payload);
      return OrgPropertyListingModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgPropertyListingModel> updateProperty(
    String id,
    Map<String, dynamic> data, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic payload = data;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['coverImage'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName ?? 'property_cover.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.put(MarketplaceEndpoints.propertyById(id), data: payload);
      return OrgPropertyListingModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<void> deleteProperty(String id) async {
    try {
      await _dio.delete(MarketplaceEndpoints.propertyById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ===========================================================================
  // WHOLESALE BUILDING MATERIALS
  // ===========================================================================

  Future<List<OrgMaterialProductModel>> getMaterials({
    String? categoryId,
    String? search,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        MarketplaceEndpoints.materials,
        queryParameters: {
          if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') 'categoryId': categoryId,
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'limit': limit,
        },
      );

      final data = response.data['data'];
      final List list = (data is Map<String, dynamic> && data['items'] is List)
          ? (data['items'] as List)
          : (data is List ? data : const []);

      return list.map((item) => OrgMaterialProductModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgMaterialProductModel> createMaterial(
    Map<String, dynamic> data, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic payload = data;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['coverImage'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName ?? 'material_cover.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.post(MarketplaceEndpoints.materials, data: payload);
      return OrgMaterialProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgMaterialProductModel> updateMaterial(
    String id,
    Map<String, dynamic> data, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic payload = data;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['coverImage'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName ?? 'material_cover.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.put(MarketplaceEndpoints.materialById(id), data: payload);
      return OrgMaterialProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<void> deleteMaterial(String id) async {
    try {
      await _dio.delete(MarketplaceEndpoints.materialById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ===========================================================================
  // SELLER CATEGORIES (Registration & Intent)
  // ===========================================================================

  Future<List<OrgSellerCategoryModel>> getSellerCategories() async {
    try {
      final response = await _dio.get(MarketplaceEndpoints.sellerCategories);
      final data = response.data['data'];
      final List list = (data is Map<String, dynamic> && data['items'] is List)
          ? (data['items'] as List)
          : (data is List ? data : const []);

      return list.map((item) => OrgSellerCategoryModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgSellerCategoryModel> registerCategoryIntent(String categoryId) async {
    try {
      final response = await _dio.post(
        MarketplaceEndpoints.sellerCategories,
        data: {'categoryId': categoryId},
      );
      return OrgSellerCategoryModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<void> removeCategoryIntent(String id) async {
    try {
      await _dio.delete(MarketplaceEndpoints.sellerCategoryById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ===========================================================================
  // VENDORS
  // ===========================================================================

  Future<List<OrgVendorModel>> getVendors() async {
    try {
      final response = await _dio.get(MarketplaceEndpoints.vendors);
      final data = response.data['data'];
      final List list = (data is Map<String, dynamic> && data['items'] is List)
          ? (data['items'] as List)
          : (data is List ? data : const []);

      return list.map((item) => OrgVendorModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgVendorModel> createVendor(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(MarketplaceEndpoints.vendors, data: data);
      return OrgVendorModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<OrgVendorModel> updateVendor(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(MarketplaceEndpoints.vendorById(id), data: data);
      return OrgVendorModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<void> deleteVendor(String id) async {
    try {
      await _dio.delete(MarketplaceEndpoints.vendorById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}

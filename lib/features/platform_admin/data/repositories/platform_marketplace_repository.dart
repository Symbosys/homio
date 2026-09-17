import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints/platform_endpoints.dart';
import '../models/platform_marketplace_category_model.dart';
import '../models/platform_property_listing_model.dart';
import '../models/platform_seller_application_model.dart';

class PlatformMarketplaceRepository {
  final Dio _dio;

  PlatformMarketplaceRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  // ===========================================================================
  // CATEGORIES
  // ===========================================================================

  /// Get flat list of categories optionally filtered by marketplaceType
  Future<List<PlatformMarketplaceCategoryModel>> getCategories({String? marketplaceType}) async {
    try {
      final response = await _dio.get(
        PlatformEndpoints.marketplaceCategories,
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

  /// Get hierarchical category tree
  Future<List<PlatformMarketplaceCategoryModel>> getCategoryTree() async {
    try {
      final response = await _dio.get(PlatformEndpoints.marketplaceCategoryTree);
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

  /// Platform Admin: Create a new category
  Future<PlatformMarketplaceCategoryModel> createCategory(
    Map<String, dynamic> categoryData, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic postData;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final formData = FormData();
        for (final entry in categoryData.entries) {
          if (entry.value != null) {
            formData.fields.add(MapEntry(entry.key, entry.value.toString()));
          }
        }
        formData.files.add(MapEntry(
          'image',
          MultipartFile.fromBytes(imageBytes, filename: imageFileName ?? 'category_image.jpg'),
        ));
        postData = formData;
      } else {
        postData = categoryData;
      }

      final response = await _dio.post(
        PlatformEndpoints.marketplaceCategories,
        data: postData,
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return PlatformMarketplaceCategoryModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Platform Admin: Update category
  Future<PlatformMarketplaceCategoryModel> updateCategory(
    String id,
    Map<String, dynamic> categoryData, {
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      dynamic putData;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final formData = FormData();
        for (final entry in categoryData.entries) {
          if (entry.value != null) {
            formData.fields.add(MapEntry(entry.key, entry.value.toString()));
          }
        }
        formData.files.add(MapEntry(
          'image',
          MultipartFile.fromBytes(imageBytes, filename: imageFileName ?? 'category_image.jpg'),
        ));
        putData = formData;
      } else {
        putData = categoryData;
      }

      final response = await _dio.put(
        PlatformEndpoints.marketplaceCategoryById(id),
        data: putData,
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return PlatformMarketplaceCategoryModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Platform Admin: Delete category
  Future<void> deleteCategory(String id) async {
    try {
      await _dio.delete(PlatformEndpoints.marketplaceCategoryById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ===========================================================================
  // PROPERTY VERIFICATIONS
  // ===========================================================================

  /// Get properties with optional verification status filter
  Future<PaginatedPlatformPropertiesResponse> getProperties({
    String? verificationStatus,
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (verificationStatus != null && verificationStatus != 'ALL')
          'verificationStatus': verificationStatus,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _dio.get(
        PlatformEndpoints.marketplaceProperties,
        queryParameters: queryParams,
      );

      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null) {
        return const PaginatedPlatformPropertiesResponse(items: [], total: 0, page: 1, limit: 20);
      }
      return PaginatedPlatformPropertiesResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Platform Admin: Update property Homio official verification status
  Future<void> verifyProperty(String id, String verificationStatus) async {
    try {
      await _dio.patch(
        PlatformEndpoints.verifyProperty(id),
        data: {
          'verificationStatus': verificationStatus,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ===========================================================================
  // SELLER APPLICATIONS
  // ===========================================================================

  /// Get seller category applications
  Future<List<PlatformSellerApplicationModel>> getSellerApplications({
    bool? isApproved,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        PlatformEndpoints.marketplaceSellerCategories,
        queryParameters: {
          'page': page,
          'limit': limit,
          'isApproved': ?isApproved,
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
          .map((item) => PlatformSellerApplicationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Platform Admin: Review seller application (approve/reject & set commission)
  Future<void> reviewSellerApplication(
    String id,
    bool isApproved,
    double? commissionRate,
  ) async {
    try {
      await _dio.patch(
        PlatformEndpoints.reviewSellerCategory(id),
        data: {
          'isApproved': isApproved,
          'commissionRate': ?commissionRate,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}

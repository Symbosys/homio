import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints/platform_endpoints.dart';
import '../models/platform_org_model.dart';

class PlatformOrganizationRepository {
  final Dio _dio;

  PlatformOrganizationRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  /// Fetch paginated list of organizations
  Future<PaginatedOrganizationsResponse> getOrganizations({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
  }) async {
    try {
      final response = await _dio.get(
        PlatformEndpoints.organizations,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
          if (status != null && status != 'ALL') 'status': status,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return PaginatedOrganizationsResponse.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get single organization details
  Future<PlatformOrgModel> getOrganizationById(String id) async {
    try {
      final response = await _dio.get(PlatformEndpoints.organizationById(id));
      final data = response.data['data'] as Map<String, dynamic>;
      return PlatformOrgModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Onboard a new organization with plan, admin user, and optional logo
  Future<Map<String, dynamic>> onboardOrganization(
    Map<String, dynamic> payload, {
    List<int>? logoBytes,
    String? logoFileName,
  }) async {
    try {
      dynamic postData;
      if (logoBytes != null && logoBytes.isNotEmpty) {
        final formData = FormData();
        if (payload['organization'] != null) {
          formData.fields.add(MapEntry('organization', jsonEncode(payload['organization'])));
        }
        if (payload['subscription'] != null) {
          formData.fields.add(MapEntry('subscription', jsonEncode(payload['subscription'])));
        }
        if (payload['adminUser'] != null) {
          formData.fields.add(MapEntry('adminUser', jsonEncode(payload['adminUser'])));
        }
        formData.files.add(MapEntry(
          'logo',
          MultipartFile.fromBytes(logoBytes, filename: logoFileName ?? 'logo.jpg'),
        ));
        postData = formData;
      } else {
        postData = payload;
      }

      final response = await _dio.post(
        PlatformEndpoints.onboard,
        data: postData,
      );

      return (response.data['data'] as Map<String, dynamic>?) ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Update organization details with optional logo upload
  Future<PlatformOrgModel> updateOrganization(
    String id,
    Map<String, dynamic> data, {
    List<int>? logoBytes,
    String? logoFileName,
  }) async {
    try {
      dynamic patchData;
      if (logoBytes != null && logoBytes.isNotEmpty) {
        final formData = FormData();
        for (final entry in data.entries) {
          if (entry.value != null) {
            if (entry.value is Map || entry.value is List) {
              formData.fields.add(MapEntry(entry.key, jsonEncode(entry.value)));
            } else {
              formData.fields.add(MapEntry(entry.key, entry.value.toString()));
            }
          }
        }
        formData.files.add(MapEntry(
          'logo',
          MultipartFile.fromBytes(logoBytes, filename: logoFileName ?? 'logo.jpg'),
        ));
        patchData = formData;
      } else {
        patchData = data;
      }

      final response = await _dio.patch(
        PlatformEndpoints.organizationById(id),
        data: patchData,
      );

      final resData = response.data['data'] as Map<String, dynamic>;
      return PlatformOrgModel.fromJson(resData);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Update organization status (ACTIVE, SUSPENDED, etc.)
  Future<PlatformOrgModel> updateStatus(String id, String status) async {
    try {
      final response = await _dio.patch(
        PlatformEndpoints.organizationStatus(id),
        data: {'status': status},
      );

      final resData = response.data['data'] as Map<String, dynamic>;
      return PlatformOrgModel.fromJson(resData);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Assign / change subscription plan
  Future<ActiveSubscriptionModel> assignSubscription(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        PlatformEndpoints.organizationSubscription(id),
        data: data,
      );

      final resData = response.data['data'] as Map<String, dynamic>;
      return ActiveSubscriptionModel.fromJson(resData);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}

import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints/platform_endpoints.dart';
import '../models/platform_plan_model.dart';

class PlatformSubscriptionRepository {
  final Dio _dio;

  PlatformSubscriptionRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  /// Get all subscription plans (unpaginated)
  Future<List<PlatformPlanModel>> getAllPlans({bool includeInactive = true}) async {
    try {
      final response = await _dio.get(
        PlatformEndpoints.plans,
        queryParameters: {
          'includeInactive': includeInactive,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>?;
      final plans = (data?['plans'] as List?) ?? [];
      return plans
          .map((item) => PlatformPlanModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Create a new subscription plan with features
  Future<PlatformPlanModel> createPlan(Map<String, dynamic> planData) async {
    try {
      final response = await _dio.post(
        PlatformEndpoints.plans,
        data: planData,
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return PlatformPlanModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Update an existing subscription plan
  Future<PlatformPlanModel> updatePlan(String id, Map<String, dynamic> planData) async {
    try {
      final response = await _dio.patch(
        PlatformEndpoints.planById(id),
        data: planData,
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return PlatformPlanModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Toggle plan active status
  Future<PlatformPlanModel> togglePlanStatus(String id) async {
    try {
      final response = await _dio.patch(PlatformEndpoints.togglePlanStatus(id));
      final data = response.data['data'] as Map<String, dynamic>;
      return PlatformPlanModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Delete a plan
  Future<void> deletePlan(String id) async {
    try {
      await _dio.delete(PlatformEndpoints.planById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}

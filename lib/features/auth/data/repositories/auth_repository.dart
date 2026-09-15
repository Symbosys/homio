import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints/user.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  /// Authenticate user credentials against backend
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        UserEndpoints.login,
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
        },
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Fetch currently authenticated user profile
  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get(UserEndpoints.me);
      final data = response.data['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Invalidate user session
  Future<void> logout({String? refreshToken}) async {
    try {
      await _dio.post(
        UserEndpoints.logout,
        data: {
          'refreshToken': ?refreshToken,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}

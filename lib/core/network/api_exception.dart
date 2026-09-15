import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({
    required this.message,
    this.statusCode,
  });

  factory ApiException.fromDio(DioException error) {
    if (error.response != null && error.response?.data != null) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return ApiException(
            message: message,
            statusCode: error.response?.statusCode,
          );
        }
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Connection timed out. Please check your network.',
          statusCode: 408,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Cannot connect to server. Please verify the backend is running.',
          statusCode: 503,
        );
      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled.',
        );
      default:
        return ApiException(
          message: error.message ?? 'An unexpected network error occurred.',
          statusCode: error.response?.statusCode,
        );
    }
  }

  @override
  String toString() => message;
}

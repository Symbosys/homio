import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final String? message;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Backend returns { success: true, message: "...", data: { accessToken, refreshToken, user } }
    final message = json['message'] as String?;
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;

    return AuthResponseModel(
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? {}),
      message: message,
    );
  }
}

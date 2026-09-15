import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage instance = LocalStorage._internal();
  LocalStorage._internal();

  static const String _keyAccessToken = 'homio_access_token';
  static const String _keyRefreshToken = 'homio_refresh_token';
  static const String _keyUserData = 'homio_user_data';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _getPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveAuthSession({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> userJson,
  }) async {
    final prefs = await _getPrefs;
    await Future.wait([
      prefs.setString(_keyAccessToken, accessToken),
      prefs.setString(_keyRefreshToken, refreshToken),
      prefs.setString(_keyUserData, jsonEncode(userJson)),
    ]);
  }

  Future<String?> getAccessToken() async {
    final prefs = await _getPrefs;
    return prefs.getString(_keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await _getPrefs;
    return prefs.getString(_keyRefreshToken);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _getPrefs;
    final jsonStr = prefs.getString(_keyUserData);
    if (jsonStr == null) return null;
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    final prefs = await _getPrefs;
    await Future.wait([
      prefs.remove(_keyAccessToken),
      prefs.remove(_keyRefreshToken),
      prefs.remove(_keyUserData),
    ]);
  }

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

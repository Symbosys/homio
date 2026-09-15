import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../storage/local_storage.dart';
import '../utils/toast_service.dart';

class AuthStateNotifier extends ChangeNotifier {
  static final AuthStateNotifier instance = AuthStateNotifier._internal();
  AuthStateNotifier._internal();

  bool _isAuthenticated = false;
  UserModel? _currentUser;
  bool _isInitialized = false;

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;
  bool get isInitialized => _isInitialized;

  /// Load persisted session from LocalStorage on app startup
  Future<void> initialize() async {
    final hasToken = await LocalStorage.instance.hasValidSession();
    if (hasToken) {
      final userJson = await LocalStorage.instance.getUserData();
      if (userJson != null) {
        _currentUser = UserModel.fromJson(userJson);
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
        _currentUser = null;
      }
    } else {
      _isAuthenticated = false;
      _currentUser = null;
    }
    _isInitialized = true;
    notifyListeners();
  }

  /// Update auth state upon successful login
  void setAuthenticated(UserModel user) {
    _isAuthenticated = true;
    _currentUser = user;
    notifyListeners();
  }

  /// Complete logout flow: revoke token on backend, clear local storage, reset query cache, and trigger route redirect
  Future<void> logout() async {
    try {
      final refreshToken = await LocalStorage.instance.getRefreshToken();
      await AuthRepository().logout(refreshToken: refreshToken);
    } catch (_) {
      // Ignore network errors to guarantee clean local logout
    } finally {
      await setUnauthenticated();
      CachedQuery.instance.deleteCache(key: 'current_user');
      ToastService.showSuccess('You have been logged out successfully.');
    }
  }

  /// Clear auth state upon logout or session invalidation
  Future<void> setUnauthenticated() async {
    _isAuthenticated = false;
    _currentUser = null;
    await LocalStorage.instance.clearSession();
    notifyListeners();
  }
}

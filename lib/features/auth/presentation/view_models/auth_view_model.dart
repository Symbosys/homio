import 'package:flutter/material.dart';
import '../../../../core/auth/auth_state_notifier.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/toast_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, success, failure }
enum AuthPortalMode { teamCrm, clientPortal, platformAdmin }

/// ViewModel managing state, validation, and API authentication.
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthStatus _status = AuthStatus.initial;
  AuthPortalMode _portalMode = AuthPortalMode.teamCrm;
  String? _errorMessage;
  bool _rememberMe = true;
  bool _isPasswordVisible = false;
  UserModel? _authenticatedUser;

  AuthViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository() {
    // Fill initial demo credentials
    emailController.text = AppConstants.demoEmail;
    passwordController.text = AppConstants.demoPassword;
  }

  AuthStatus get status => _status;
  AuthPortalMode get portalMode => _portalMode;
  bool get isClientPortal => _portalMode == AuthPortalMode.clientPortal;
  bool get isPlatformPortal => _portalMode == AuthPortalMode.platformAdmin;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isSuccess => _status == AuthStatus.success;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;
  bool get isPasswordVisible => _isPasswordVisible;
  UserModel? get authenticatedUser => _authenticatedUser;

  void setPortalMode(AuthPortalMode mode) {
    if (_portalMode != mode) {
      _portalMode = mode;
      _errorMessage = null;
      if (mode == AuthPortalMode.platformAdmin) {
        emailController.text = AppConstants.demoPlatformEmail;
        passwordController.text = AppConstants.demoPlatformPassword;
      } else if (mode == AuthPortalMode.clientPortal) {
        emailController.text = 'sarah.homeowner@gmail.com';
        passwordController.text = 'Client@2026';
      } else {
        emailController.text = AppConstants.demoEmail;
        passwordController.text = AppConstants.demoPassword;
      }
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void fillDemoCredentials() {
    if (_portalMode == AuthPortalMode.platformAdmin) {
      emailController.text = AppConstants.demoPlatformEmail;
      passwordController.text = AppConstants.demoPlatformPassword;
    } else if (_portalMode == AuthPortalMode.clientPortal) {
      emailController.text = 'sarah.homeowner@gmail.com';
      passwordController.text = 'Client@2026';
    } else {
      emailController.text = AppConstants.demoEmail;
      passwordController.text = AppConstants.demoPassword;
    }
    _errorMessage = null;
    notifyListeners();
  }

  String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return 'Email address is required.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required.';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  /// Perform real authentication against the backend with portal verification
  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final emailErr = validateEmail(email);
    final passErr = validatePassword(password);

    if (emailErr != null) {
      _errorMessage = emailErr;
      _status = AuthStatus.failure;
      notifyListeners();
      return false;
    }

    if (passErr != null) {
      _errorMessage = passErr;
      _status = AuthStatus.failure;
      notifyListeners();
      return false;
    }

    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _authRepository.login(
        email: email,
        password: password,
      );

      // Verify portal compatibility
      if (_portalMode == AuthPortalMode.platformAdmin && res.user.userType != 'PLATFORM_ADMIN') {
        _errorMessage =
            'Access denied: This account is not a Platform Admin.';
        _status = AuthStatus.failure;
        notifyListeners();
        ToastService.showError(_errorMessage!);
        return false;
      }

      if (_portalMode == AuthPortalMode.teamCrm && res.user.userType == 'USER') {
        _errorMessage =
            'Access denied: This account belongs to the Client Portal. Please switch to the Client Portal tab.';
        _status = AuthStatus.failure;
        notifyListeners();
        ToastService.showError(_errorMessage!);
        return false;
      }

      if (_portalMode == AuthPortalMode.clientPortal && res.user.userType != 'USER') {
        _errorMessage =
            'Access denied: This account belongs to the Team Workspace. Please switch to the Team Portal tab.';
        _status = AuthStatus.failure;
        notifyListeners();
        ToastService.showError(_errorMessage!);
        return false;
      }

      // Persist session
      await LocalStorage.instance.saveAuthSession(
        accessToken: res.accessToken,
        refreshToken: res.refreshToken,
        userJson: res.user.toJson(),
      );

      _authenticatedUser = res.user;
      AuthStateNotifier.instance.setAuthenticated(res.user);
      _status = AuthStatus.success;
      notifyListeners();
      ToastService.showSuccess(res.message ?? 'Login successful! Welcome back.');
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.failure;
      notifyListeners();
      ToastService.showError(e);
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = AuthStatus.failure;
      notifyListeners();
      ToastService.showError(e);
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

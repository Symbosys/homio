import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

enum AuthStatus { initial, loading, success, failure }
enum AuthPortalMode { teamCrm, clientPortal }

/// ViewModel managing state and validation for the SaaS login experience.
class AuthViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthStatus _status = AuthStatus.initial;
  AuthPortalMode _portalMode = AuthPortalMode.teamCrm;
  String? _errorMessage;
  bool _rememberMe = true;
  bool _isPasswordVisible = false;

  AuthStatus get status => _status;
  AuthPortalMode get portalMode => _portalMode;
  bool get isClientPortal => _portalMode == AuthPortalMode.clientPortal;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isSuccess => _status == AuthStatus.success;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;
  bool get isPasswordVisible => _isPasswordVisible;

  void setPortalMode(AuthPortalMode mode) {
    if (_portalMode != mode) {
      _portalMode = mode;
      _errorMessage = null;
      if (mode == AuthPortalMode.clientPortal) {
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
    if (_portalMode == AuthPortalMode.clientPortal) {
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

    // Simulate authenticating against production API endpoint
    await Future.delayed(const Duration(milliseconds: 1200));

    _status = AuthStatus.success;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

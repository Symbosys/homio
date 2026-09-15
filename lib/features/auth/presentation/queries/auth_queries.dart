import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../../core/auth/auth_state_notifier.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/toast_service.dart';
import '../../data/models/auth_response.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

abstract class AuthQueryKeys {
  static const String currentUser = 'current_user';
}

class AuthQueries {
  final AuthRepository _repository;

  AuthQueries({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  /// Query for currently authenticated user profile
  Query<UserModel> getCurrentUserQuery() {
    return Query<UserModel>(
      key: AuthQueryKeys.currentUser,
      config: QueryConfig(
        staleDuration: const Duration(minutes: 5),
        cacheDuration: const Duration(hours: 1),
      ),
      queryFn: () => _repository.getMe(),
    );
  }

  /// Mutation for user login
  Mutation<AuthResponseModel, ({String email, String password})> getLoginMutation() {
    return Mutation<AuthResponseModel, ({String email, String password})>(
      mutationFn: (args) => _repository.login(
        email: args.email,
        password: args.password,
      ),
      onSuccess: (res, args) async {
        await LocalStorage.instance.saveAuthSession(
          accessToken: res.accessToken,
          refreshToken: res.refreshToken,
          userJson: res.user.toJson(),
        );
        AuthStateNotifier.instance.setAuthenticated(res.user);
        CachedQuery.instance.invalidateCache(key: AuthQueryKeys.currentUser);
        ToastService.showSuccess(res.message ?? 'Login successful! Welcome back.');
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation for user logout
  Mutation<void, void> getLogoutMutation() {
    return Mutation<void, void>(
      mutationFn: (_) async {
        final refreshToken = await LocalStorage.instance.getRefreshToken();
        await _repository.logout(refreshToken: refreshToken);
      },
      onSuccess: (_, _) async {
        await AuthStateNotifier.instance.setUnauthenticated();
        CachedQuery.instance.deleteCache(key: AuthQueryKeys.currentUser);
        ToastService.showSuccess('You have been logged out successfully.');
      },
      onError: (arg, error, fallback) async {
        // Guarantee clean local logout even if network request fails
        await AuthStateNotifier.instance.setUnauthenticated();
        CachedQuery.instance.deleteCache(key: AuthQueryKeys.currentUser);
        ToastService.showError(error);
      },
    );
  }
}

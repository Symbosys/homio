import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../../core/storage/local_storage.dart';
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
        CachedQuery.instance.invalidateCache(key: AuthQueryKeys.currentUser);
      },
    );
  }
}

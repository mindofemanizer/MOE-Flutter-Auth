import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_auth/src/config/auth_config.dart';
import 'package:moe_flutter_auth/src/events/auth_events.dart';
import 'package:moe_flutter_auth/src/models/auth_dto.dart';
import 'package:moe_flutter_auth/src/providers/auth_session.dart';
import 'package:moe_flutter_auth/src/services/auth_repository.dart';

/// State for auth operations (login/register).
sealed class AuthOperationState {
  const AuthOperationState();
}

final class AuthIdle extends AuthOperationState {
  const AuthIdle();
}

final class AuthLoading extends AuthOperationState {
  const AuthLoading();
}

final class AuthSuccess extends AuthOperationState {
  final UserModel user;
  const AuthSuccess(this.user);
}

final class AuthError extends AuthOperationState {
  final AppFailure failure;
  const AuthError(this.failure);
}

/// Notifier for login.
///
/// Call `login(email, password)` → state changes.
/// On success, updates [AuthSessionNotifier] so router redirects.
class LoginNotifier extends StateNotifier<AuthOperationState> {
  final AuthRepository _repository;
  final Ref _ref;

  LoginNotifier(this._repository, this._ref) : super(const AuthIdle());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _repository.login(
      LoginRequest(email: email, password: password),
    );

    switch (result) {
      case Ok(:final data):
        _ref
            .read(authSessionProvider.notifier)
            .setAuthenticated(user: data.user);
        _ref.read(moeEventBusProvider.notifier).emit(AuthLoginEvent(data.user));
        state = AuthSuccess(data.user);
      case Err(:final failure):
        state = AuthError(failure);
    }
  }

  void reset() {
    state = const AuthIdle();
  }
}

/// Notifier for register.
class RegisterNotifier extends StateNotifier<AuthOperationState> {
  final AuthRepository _repository;
  final Ref _ref;

  RegisterNotifier(this._repository, this._ref) : super(const AuthIdle());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _repository.register(
      RegisterRequest(name: name, email: email, password: password),
    );

    switch (result) {
      case Ok(:final data):
        _ref
            .read(authSessionProvider.notifier)
            .setAuthenticated(user: data.user);
        _ref
            .read(moeEventBusProvider.notifier)
            .emit(AuthRegisterEvent(data.user));
        state = AuthSuccess(data.user);
      case Err(:final failure):
        state = AuthError(failure);
    }
  }

  void reset() {
    state = const AuthIdle();
  }
}

/// Provider for AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageServiceProvider);
  final config = ref.watch(authConfigOverrideProvider);
  return AuthRepository(dio, storage, config.tokenKey);
});

/// Provider for LoginNotifier.
final loginProvider =
    StateNotifierProvider<LoginNotifier, AuthOperationState>((ref) {
  return LoginNotifier(ref.watch(authRepositoryProvider), ref);
});

/// Provider for RegisterNotifier.
final registerProvider =
    StateNotifierProvider<RegisterNotifier, AuthOperationState>((ref) {
  return RegisterNotifier(ref.watch(authRepositoryProvider), ref);
});

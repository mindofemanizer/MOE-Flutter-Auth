import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_auth/src/config/auth_config.dart';
import 'package:moe_flutter_auth/src/events/auth_events.dart';
import 'package:moe_flutter_auth/src/models/user_model.dart';

/// Auth session state.
sealed class AuthState {
  const AuthState();
}

/// Unknown status (startup) — checking token.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// User not logged in.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// User logged in.
final class AuthAuthenticated extends AuthState {
  final UserModel? user;
  const AuthAuthenticated({this.user});
}

/// Notifier that manages user login status.
///
/// Reads token from SecureStorage at startup,
/// listens to MoeEventBus for 401 events (auto-logout).
class AuthSessionNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    ref.listen<MoeEvent?>(moeEventBusProvider, (_, event) {
      if (event is AuthExpiredEvent) {
        state = const AuthUnauthenticated();
      } else if (event is AuthLogoutEvent) {
        state = const AuthUnauthenticated();
      }
    });

    _checkInitialToken();
    return const AuthInitial();
  }

  Future<void> _checkInitialToken() async {
    final config = ref.read(authConfigOverrideProvider);
    final storage = ref.read(secureStorageServiceProvider);
    final token = await storage.read(config.tokenKey);
    state = token != null
        ? const AuthAuthenticated()
        : const AuthUnauthenticated();
  }

  /// Call after login/register success (token already saved).
  void setAuthenticated({UserModel? user}) {
    state = AuthAuthenticated(user: user);
  }

  /// Logout manual — clear token + broadcast event.
  Future<void> logout() async {
    final config = ref.read(authConfigOverrideProvider);
    final storage = ref.read(secureStorageServiceProvider);
    await storage.delete(config.tokenKey);
    ref.read(moeEventBusProvider.notifier).emit(const AuthLogoutEvent());
    state = const AuthUnauthenticated();
  }
}

/// Global provider for auth session.
final authSessionProvider =
    NotifierProvider<AuthSessionNotifier, AuthState>(AuthSessionNotifier.new);

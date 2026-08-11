import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_auth/src/config/auth_config.dart';
import 'package:moe_flutter_auth/src/services/auth_repository.dart';
import 'package:moe_flutter_auth/src/services/token_interceptor.dart';

/// Auth interceptor — injects Bearer token + handles 401.
///
/// Extends [TokenInterceptor] from core, adds 401 event emission.
class AuthInterceptor extends TokenInterceptor {
  final Ref _ref;

  AuthInterceptor(super.storage, this._ref, super.tokenKey);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Clear token
      _storage.delete(_ref.read(authConfigProvider).tokenKey);
      // Broadcast event — router redirect to login
      _ref.read(moeEventBusProvider.notifier).emit(const AuthExpiredEvent());
    }
    super.onError(err, handler);
  }
}

// Re-export AuthExpiredEvent for the interceptor
export 'package:moe_flutter_auth/src/events/auth_events.dart';

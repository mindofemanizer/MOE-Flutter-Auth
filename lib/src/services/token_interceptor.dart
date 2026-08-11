import 'package:dio/dio.dart';
import 'package:moe_flutter_core/moe_flutter_core.dart';

/// Auth-specific token interceptor.
///
/// Injects Bearer token from SecureStorage into every request.
/// 401 handling is done by [AuthInterceptor] in auth package.
class TokenInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final String _tokenKey;

  TokenInterceptor(this._storage, this._tokenKey);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';

    final token = await _storage.read(_tokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}

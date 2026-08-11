import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_auth/src/models/auth_dto.dart';
import 'package:moe_flutter_auth/src/models/user_model.dart';

/// Repository for auth operations (login, register, me, logout).
///
/// All methods return [AppResult] — never throws to UI.
/// UI must handle `Ok` and `Err` explicitly.
class AuthRepository {
  final Dio _dio;
  final SecureStorageService _storage;
  final String _tokenKey;

  AuthRepository(this._dio, this._storage, this._tokenKey);

  /// Login with email + password.
  ///
  /// Backend: `POST /login` → `{token, user}` or 401.
  Future<AppResult<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/login', data: request.toJson());
      final authResponse = AuthResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      await _storage.write(_tokenKey, authResponse.token);
      return Ok(authResponse);
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(
        type: FailureType.unknown,
        message: e.toString(),
      ));
    }
  }

  /// Register new account.
  ///
  /// Backend: `POST /register` → `{token, user}` (201).
  Future<AppResult<AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post('/register', data: request.toJson());
      final authResponse = AuthResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      await _storage.write(_tokenKey, authResponse.token);
      return Ok(authResponse);
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(
        type: FailureType.unknown,
        message: e.toString(),
      ));
    }
  }

  /// Get current user data.
  ///
  /// Backend: `GET /me` → `{user}` (auth: sanctum).
  Future<AppResult<UserModel>> me() async {
    try {
      final response = await _dio.get('/me');
      final user = UserModel.fromJson(
        (response.data as Map<String, dynamic>)['user']
            as Map<String, dynamic>,
      );
      return Ok(user);
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(
        type: FailureType.unknown,
        message: e.toString(),
      ));
    }
  }

  /// Logout — clear local token.
  Future<void> logout() async {
    await _storage.delete(_tokenKey);
  }

  /// Get stored token.
  Future<String?> getToken() async {
    return await _storage.read(_tokenKey);
  }
}

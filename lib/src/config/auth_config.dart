import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';

/// Configuration for MOE Auth package.
class MoeAuthConfig {
  final String loginEndpoint;
  final String registerEndpoint;
  final String meEndpoint;
  final String tokenKey;
  final String? googleClientId;
  final bool enableOtp;
  final Duration sessionTimeout;

  const MoeAuthConfig({
    this.loginEndpoint = '/login',
    this.registerEndpoint = '/register',
    this.meEndpoint = '/me',
    this.tokenKey = 'auth_token',
    this.googleClientId,
    this.enableOtp = false,
    this.sessionTimeout = const Duration(hours: 24),
  });
}

/// Provider for auth config.
final authConfigProvider = Provider<MoeAuthConfig>((ref) {
  throw UnimplementedError('MoeAuth.setup() must be called before use.');
});

/// Setup function — call in main() before runApp().
///
/// ```dart
/// void main() {
///   MoeCore.setup(envConfig: EnvConfig.fromEnvironment());
///   MoeAuth.setup(
///     config: MoeAuthConfig(
///       googleClientId: 'xxx.apps.googleusercontent.com',
///       enableOtp: true,
///     ),
///   );
///   runApp(const ProviderScope(child: MyApp()));
/// }
/// ```
class MoeAuth {
  static late MoeAuthConfig _config;

  static void setup({required MoeAuthConfig config}) {
    _config = config;
  }

  static MoeAuthConfig get config => _config;
}

/// Override provider for auth config — used internally by setup.
final authConfigOverrideProvider = Provider<MoeAuthConfig>((ref) {
  return MoeAuth.config;
});

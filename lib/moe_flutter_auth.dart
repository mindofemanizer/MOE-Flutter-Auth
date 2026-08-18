/// Barrel file — public API for moe_flutter_auth.
///
/// Consumer only imports:
/// ```dart
/// import 'package:moe_flutter_auth/moe_flutter_auth.dart';
/// ```
library;

// Config
export 'src/config/auth_config.dart';

// Models
export 'src/models/user_model.dart';
export 'src/models/auth_dto.dart';

// Events
export 'src/events/auth_events.dart';

// Services
export 'src/services/auth_repository.dart';
export 'src/services/auth_interceptor.dart';
export 'src/services/token_interceptor.dart';

// Providers
export 'src/providers/auth_session.dart';
export 'src/providers/auth_provider.dart';

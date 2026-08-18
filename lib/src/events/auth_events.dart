import 'package:moe_flutter_core/moe_flutter_core.dart';

import 'package:moe_flutter_auth/src/models/user_model.dart';

export 'package:moe_flutter_auth/src/models/user_model.dart';

/// Auth events for cross-module communication via MoeEventBus.
///
/// See STRATEGI_PACKAGE.md Pasal 4.3 — Event Pattern.

/// Token expired / session invalid — router should redirect to login.
class AuthExpiredEvent extends MoeEvent {
  const AuthExpiredEvent();
}

/// User logged out manually.
class AuthLogoutEvent extends MoeEvent {
  const AuthLogoutEvent();
}

/// User logged in successfully.
class AuthLoginEvent extends MoeEvent {
  final UserModel user;
  const AuthLoginEvent(this.user);
}

/// User registered successfully.
class AuthRegisterEvent extends MoeEvent {
  final UserModel user;
  const AuthRegisterEvent(this.user);
}

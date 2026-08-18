# MOE-Flutter-Auth

Auth package for MOE Flutter ecosystem â€” login, register, OTP, Google OAuth, session, token management.

## Installation

```yaml
dependencies:
  moe_flutter_auth:
    git:
      url: https://github.com/mindofemanizer/MOE-Flutter-Auth.git
      ref: v1.0.0
```

## Usage

### Setup

```dart
import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_auth/moe_flutter_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  MoeCore.setup(
    envConfig: EnvConfig.fromEnvironment(),
    environment: Environment.production,
  );

  MoeAuth.setup(
    config: MoeAuthConfig(
      loginEndpoint: '/login',
      registerEndpoint: '/register',
      googleClientId: 'xxx.apps.googleusercontent.com',
      enableOtp: true,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}
```

### Login

```dart
final loginState = ref.watch(loginProvider);

switch (loginState) {
  case AuthIdle():
    // show login form
  case AuthLoading():
    // show loading indicator
  case AuthSuccess(:final user):
    // navigate to home
  case AuthError(:final failure):
    // show error message
}

// trigger login
ref.read(loginProvider.notifier).login(
  email: 'user@test.com',
  password: 'password123',
);
```

### Register

```dart
final registerState = ref.watch(registerProvider);

// trigger register
ref.read(registerProvider.notifier).register(
  name: 'Test User',
  email: 'user@test.com',
  password: 'password123',
);
```

### Auth Session (for routing)

```dart
final authState = ref.watch(authSessionProvider);

switch (authState) {
  case AuthInitial():
    // show splash / loading
  case AuthUnauthenticated():
    // redirect to login
  case AuthAuthenticated(:final user):
    // redirect to home
}

// logout
ref.read(authSessionProvider.notifier).logout();
```

### Event Bus (cross-module)

```dart
// listen to auth events from other packages
ref.listen(moeEventBusProvider, (prev, event) {
  if (event is AuthExpiredEvent) {
    // token expired â€” cleanup
  } else if (event is AuthLoginEvent) {
    // user logged in â€” load profile
  }
});
```

## What's Included

| Module | Description |
|--------|-------------|
| `UserModel` | User data model |
| `LoginRequest`, `RegisterRequest`, `AuthResponse` | DTOs |
| `AuthRepository` | API calls with AppResult |
| `AuthInterceptor` | Token injection + 401 handling |
| `AuthSessionNotifier` | Session state management |
| `LoginNotifier`, `RegisterNotifier` | Operation state |
| `MoeAuthConfig` | Configurable endpoints + features |
| Auth Events | Cross-module communication |

# Changelog

## 1.0.0 — 2026-08-10

### Added
- Initial release
- `UserModel` — user data model with fromJson/toJson/copyWith
- `LoginRequest`, `RegisterRequest`, `AuthResponse` — DTOs
- `AuthRepository` — login, register, me, logout with AppResult
- `AuthInterceptor` — token injection + 401 event emission
- `TokenInterceptor` — base token interceptor
- `AuthSessionNotifier` — session state (initial/unauthenticated/authenticated)
- `LoginNotifier`, `RegisterNotifier` — operation state (idle/loading/success/error)
- `MoeAuthConfig` — configurable endpoints, token key, OTP, Google OAuth
- `MoeAuth.setup()` — entry point
- Auth events: `AuthExpiredEvent`, `AuthLogoutEvent`, `AuthLoginEvent`, `AuthRegisterEvent`
- Riverpod providers: `authSessionProvider`, `loginProvider`, `registerProvider`, `authRepositoryProvider`

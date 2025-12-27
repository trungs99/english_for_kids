# Design

## Architecture
The splash feature will remain in `features/splash`. It will strictly follow the MVVM pattern with Clean Architecture separation:
- **Presentation**: `SplashPage` (UI), `SplashController` (Logic), `SplashBinding` (DI).
- **Domain/Data**: Currently minimal, but `SplashController` will be structured to easily dependency-inject a `CheckAuthUseCase` or `LoadConfigUseCase` in the future.

## Key Decisions
- **TranslationKeys**: Strictly used for all text.
- **Assets**: `flutter_gen` used for all assets.
- **Navigation**: Controlled by `SplashController` using `Get.offNamed`.

## Constraints
- Must not block startup for more than 3 seconds unless initializing critical data.
- Must handle fast resume (not applicable for simple splash but good to note).

# Implementation Tasks: setup-project

## 1. Android Configuration
- [x] 1.1 Update `android/app/build.gradle.kts`:
  - Set `minSdk = 28` ✅
  - Set `compileSdk = 36` ✅ (updated from 35 due to androidx.core dependency requirement)
  - Set `targetSdk = 36` ✅ (updated from 35 due to androidx.core dependency requirement)
  - Add `multiDexEnabled = true` ✅
- [x] 1.2 Update `android/app/src/main/AndroidManifest.xml`:
  - Add `<uses-permission android:name="android.permission.CAMERA"/>` ✅
  - Add `<uses-feature android:name="android.hardware.camera" android:required="true"/>` ✅
  - Add `<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>` ✅
  - Consolidate existing `<queries>` blocks ✅
  - Update `android:label` to "Kids English" ✅

## 2. Project Dependencies
- [x] 2.1 `flutter_gen` and `build_runner` already added ✅
- [x] 2.2 Skip `flip_card` for now (will select alternative during flashcard feature) ✅
- [x] 2.3 Run `flutter pub get` to ensure dependencies are installed ✅

## 3. Create Clean Architecture Folder Structure
- [x] 3.1 Create core directories:
  - `lib/core/bindings/` ✅
  - `lib/core/constants/` ✅
  - `lib/core/routes/` ✅
  - `lib/core/theme/` ✅
  - `lib/core/translations/` ✅
  - `lib/core/widgets/` ✅
- [x] 3.2 Create splash feature structure:
  - `lib/features/splash/presentation/bindings/` ✅
  - `lib/features/splash/presentation/controllers/` ✅
  - `lib/features/splash/presentation/pages/` ✅
- [x] 3.3 Create home feature structure:
  - `lib/features/home/presentation/bindings/` ✅
  - `lib/features/home/presentation/controllers/` ✅
  - `lib/features/home/presentation/pages/` ✅
  - `lib/features/home/presentation/widgets/` ✅
- [x] 3.4 Create learning feature domain layer:
  - `lib/features/learning/domain/entities/` ✅
  - `lib/features/learning/domain/repositories/` ✅
  - `lib/features/learning/domain/usecases/` ✅
- [x] 3.5 Create learning feature data layer:
  - `lib/features/learning/data/datasources/` ✅
  - `lib/features/learning/data/mappers/` ✅
  - `lib/features/learning/data/models/` ✅
  - `lib/features/learning/data/repositories/` ✅
- [x] 3.6 Create learning feature presentation layer:
  - `lib/features/learning/presentation/bindings/` ✅
  - `lib/features/learning/presentation/controllers/` ✅
  - `lib/features/learning/presentation/pages/` ✅
  - `lib/features/learning/presentation/widgets/` ✅

## 4. Assets Setup
- [x] 4.1 Create `assets/images/learning/lession_1/` directory ✅ (already existed)
- [x] 4.2 Validate images for lessons (already added by user):
  - `assets/images/learning/lession_1/img_apple.png` ✅
  - `assets/images/learning/lession_1/img_bottle.png` ✅
  - `assets/images/learning/lession_1/img_cup.png` ✅
  - `assets/images/learning/lession_1/img_desk.png` ✅
  - `assets/images/learning/lession_1/img_ear.png` ✅
- [x] 4.3 Update `pubspec.yaml` to declare assets:
  ```yaml
  flutter:
    uses-material-design: true
    assets:
      - assets/images/learning/lession_1/
  ``` ✅
- [x] 4.4 Run `dart run build_runner build --delete-conflicting-outputs` to generate assets ✅

## 5. Translation Infrastructure
- [x] 5.1 Create `lib/core/translations/translation_keys.dart` ✅
- [x] 5.2 Create `lib/core/translations/en.dart` (English translations) ✅
- [x] 5.3 Create `lib/core/translations/vi.dart` (Vietnamese translations) ✅
- [x] 5.4 Create `lib/core/translations/app_translations.dart`:
  - Configure GetX translations ✅
  - **Set `Locale('vi', 'VN')` as default locale** ✅
  - Set fallback locale to English ✅

## 6. Routing Setup
- [x] 6.1 Create `lib/core/routes/app_routes.dart` (Route constants):
  - Define routes for: splash, home, learning ✅
- [x] 6.2 Create `lib/core/routes/app_pages.dart` (Route configuration) ✅

## 7. Theme Setup
- [x] 7.1 Create `lib/core/theme/app_colors.dart` ✅
- [x] 7.2 Create `lib/core/theme/app_theme.dart` ✅

## 8. Update Main Entry Point
- [x] 8.1 Update `lib/main.dart` to use:
  - `GetMaterialApp` with translations ✅
  - **Vietnamese (`vi_VN`) as default locale** ✅
  - App routing configuration ✅
  - Theme configuration ✅
  - Initial route: splash ✅

## 9. Verification
- [x] 9.1 Run `flutter analyze` - no errors ✅
- [x] 9.2 Run `flutter build apk --debug` - in progress (build running)
- [x] 9.3 Test on real Android device - app launches (requires user to test)
- [x] 9.4 Verify folder structure matches technical spec ✅

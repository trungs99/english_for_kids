# project-setup Specification

## Purpose
TBD - created by archiving change setup-project. Update Purpose after archive.
## Requirements
### Requirement: Android Platform Configuration
The system SHALL be configured for Android platform only with ML Kit compatibility.

#### Scenario: Minimum SDK version
- **WHEN** building the Android application
- **THEN** the `minSdk` SHALL be set to 28 (Android 9 Pie)
- **AND** the `compileSdk` SHALL be set to 35
- **AND** the `targetSdk` SHALL be set to 35

#### Scenario: MultiDex enabled for ML Kit
- **WHEN** the application includes ML Kit dependencies
- **THEN** `multiDexEnabled` SHALL be set to true in `build.gradle.kts`

#### Scenario: Camera permission granted
- **WHEN** the user launches the AR game feature
- **THEN** the app SHALL have `CAMERA` permission declared in `AndroidManifest.xml`
- **AND** the app SHALL declare camera hardware features

#### Scenario: TTS service query
- **WHEN** the application uses Text-to-Speech
- **THEN** the app SHALL declare TTS service query in `AndroidManifest.xml`

---

### Requirement: Clean Architecture Folder Structure
The system SHALL follow Clean Architecture principles with a feature-first folder organization.

#### Scenario: Core module structure
- **WHEN** shared infrastructure is needed
- **THEN** the code SHALL be placed under `lib/core/` directory
- **AND** subdirectories SHALL include: `bindings/`, `constants/`, `routes/`, `theme/`, `translations/`, `widgets/`

#### Scenario: Feature module structure
- **WHEN** implementing features
- **THEN** the splash screen code SHALL be organized under `lib/features/splash/presentation/`
- **AND** the home screen code SHALL be organized under `lib/features/home/presentation/`
- **AND** the learning feature code SHALL be organized under `lib/features/learning/`
- **AND** learning feature SHALL contain `domain/`, `data/`, and `presentation/` subdirectories

#### Scenario: Domain layer isolation
- **WHEN** code is placed in the domain layer
- **THEN** it SHALL NOT import Flutter or GetX packages
- **AND** it SHALL contain only: `entities/`, `repositories/`, `usecases/`

#### Scenario: Data layer dependencies
- **WHEN** code is placed in the data layer
- **THEN** it SHALL only depend on the domain layer
- **AND** it SHALL contain: `datasources/`, `mappers/`, `models/`, `repositories/`

#### Scenario: Presentation layer access
- **WHEN** code is placed in the presentation layer
- **THEN** it MAY depend on both domain and data layers
- **AND** it SHALL contain: `bindings/`, `controllers/`, `pages/`, `widgets/`

---

### Requirement: Asset Management with flutter_gen
The system SHALL use `flutter_gen` for type-safe asset access.

#### Scenario: Asset configuration
- **WHEN** configuring asset generation
- **THEN** `flutter_gen` SHALL output to `lib/gen/` directory
- **AND** image assets SHALL be declared in `pubspec.yaml`

#### Scenario: Asset usage
- **WHEN** displaying an image asset in the application
- **THEN** the code SHALL use `Assets.images.<name>.image()` syntax
- **AND** hardcoded asset path strings (e.g., `'assets/images/learning/lession_1/img_apple.png'`) SHALL NOT be used

#### Scenario: Asset generation
- **WHEN** new assets are added to the project
- **THEN** `dart run build_runner build --delete-conflicting-outputs` SHALL be executed
- **AND** generated code SHALL be placed in `lib/gen/assets.gen.dart`

---

### Requirement: Translation Infrastructure
The system SHALL use centralized translation keys for all UI strings.

#### Scenario: Translation key definition
- **WHEN** defining translatable text
- **THEN** a constant SHALL be added to `TranslationKeys` class
- **AND** the constant SHALL use snake_case naming convention

#### Scenario: Translation map configuration
- **WHEN** adding translations
- **THEN** translations SHALL be defined in `lib/core/translations/en.dart` for English
- **AND** translations SHALL be defined in `lib/core/translations/vi.dart` for Vietnamese

#### Scenario: Translation usage in UI
- **WHEN** displaying text in the UI
- **THEN** the code SHALL use `TranslationKeys.<key>.tr` syntax
- **AND** hardcoded UI strings (e.g., `'Start Learning'`) SHALL NOT be used

#### Scenario: Parameterized translations
- **WHEN** a translation requires dynamic values
- **THEN** the translation SHALL use `@param` syntax in the translation map
- **AND** the code SHALL use `TranslationKeys.<key>.trParams({'param': value})` syntax

#### Scenario: Default locale configuration
- **WHEN** the application starts
- **THEN** the default locale SHALL be Vietnamese (`vi_VN`)
- **AND** the fallback locale SHALL be English (`en_US`)
- **AND** the target audience is Vietnamese children learning English

---

### Requirement: App Routing Configuration
The system SHALL use GetX routing with centralized route definitions.

#### Scenario: Route constants
- **WHEN** defining a navigable screen
- **THEN** a route constant SHALL be added to `AppRoutes` class in `lib/core/routes/app_routes.dart`

#### Scenario: Route pages registration
- **WHEN** configuring navigation
- **THEN** routes SHALL be registered in `AppPages` class in `lib/core/routes/app_pages.dart`
- **AND** each route SHALL specify its binding for dependency injection

---

### Requirement: Project Dependencies
The system SHALL include all required dependencies for the MVP features.

#### Scenario: Core dependencies
- **WHEN** the application is built
- **THEN** `pubspec.yaml` SHALL include:
  - `exo_shared` from git repository
  - `get` for state management and navigation
  - `flutter_tts` for Text-to-Speech
  - `google_mlkit_image_labeling` for object detection
  - `camera` for camera access
  - `permission_handler` for runtime permissions

#### Scenario: Dev dependencies
- **WHEN** developing or generating code
- **THEN** `pubspec.yaml` dev_dependencies SHALL include:
  - `build_runner` for code generation
  - `flutter_gen_runner` for asset generation


# Change: Setup Project Foundation for Kids English Learning App

## Why
The Kids English Learning App project requires initial setup following **Clean Architecture** principles as specified in `doc/technical_spec.md`. This includes configuring Android settings, creating the folder structure, setting up dependencies, and establishing the core infrastructure for asset and translation management.

## What Changes

### Android Configuration
- Update `minSdk` to 28 (required for ML Kit)
- Update `compileSdk` and `targetSdk` to 35
- Add `multiDexEnabled` for ML Kit
- Add `CAMERA` permission to `AndroidManifest.xml`
- Add camera hardware features
- Consolidate TTS service queries

### Project Structure
- Create Clean Architecture folder structure:
  - `lib/core/` - Shared utilities, translations, routes, theme
  - `lib/features/splash/` - Splash screen feature (domain, data, presentation)
  - `lib/features/home/` - Home screen feature (domain, data, presentation)
  - `lib/features/learning/domain/` - Entities, UseCases, Repository Interfaces
  - `lib/features/learning/data/` - Models, DataSources, Mappers, Repositories
  - `lib/features/learning/presentation/` - Controllers, Pages, Widgets, Bindings

### Dependencies
- ~~Skip `flip_card` for now~~ (will select alternative package during flashcard feature implementation)
- `flutter_gen` and `build_runner` already configured ✅

### Core Infrastructure
- Create `TranslationKeys` class for localization
- Add English (`en.dart`) and Vietnamese (`vi.dart`) translations
- **Set Vietnamese (VI) as default locale** (target audience: Vietnamese kids learning English)
- Create placeholder asset images for 5 lessons (Apple, Bottle, Cup, Desk, Ear) at `assets/images/learning/lession_1/`
- Configure app routing structure

## Impact
- Affected specs: `project-setup` (new capability)
- Affected code:
  - `android/app/build.gradle.kts`
  - `android/app/src/main/AndroidManifest.xml`
  - `pubspec.yaml`
  - `lib/` folder structure (new directories)

# Change: Implement Speech-to-Text Feature

## Why
Enhance the learning experience by adding pronunciation practice. Users speak vocabulary words aloud, reinforcing English learning through active speech.

## What Changes
- Add SpeechGamePage with speech recognition UI
- Add SpeechGameController with speech_to_text integration (English locale `en_US`)
- Add SpeechGameBinding for dependency injection
- Add ProcessSpeechUseCase for matching spoken text against vocabulary
- Add microphone permission handling
- Add translations for speech game UI
- Add debug button on home page for testing
- Add `speech_to_text` package dependency to pubspec.yaml

## Impact
- Affected specs: learning-data
- Affected code:
  - `lib/features/learning/domain/usecases/process_speech_usecase.dart` (new)
  - `lib/features/learning/presentation/controllers/speech_game_controller.dart` (new)
  - `lib/features/learning/presentation/pages/speech_game_page.dart` (new)
  - `lib/features/learning/presentation/bindings/speech_game_binding.dart` (new)
  - `lib/core/translations/translation_keys.dart` (modified)
  - `lib/core/translations/en.dart` (modified)
  - `lib/core/translations/vi.dart` (modified)
  - `lib/core/routes/app_routes.dart` (modified)
  - `lib/features/home/presentation/controllers/home_controller.dart` (modified)
  - `android/app/src/main/AndroidManifest.xml` (verify RECORD_AUDIO permission)
  - `pubspec.yaml` (add speech_to_text dependency)


## 0. Dependencies
- [x] 0.1 Add `speech_to_text: ^6.6.0` to `pubspec.yaml`
- [x] 0.2 Run `flutter pub get` to install the package

## 1. Domain Layer
- [x] 1.1 Create ProcessSpeechUseCase in `lib/features/learning/domain/usecases/process_speech_usecase.dart`
  - Accept vocabulary word and spoken text
  - Normalize both strings (lowercase, trim whitespace)
  - Check if spoken text contains the vocabulary word (case-insensitive substring match)
  - Return boolean match result

## 2. Presentation Layer - Controller
- [x] 2.1 Create SpeechGameController in `lib/features/learning/presentation/controllers/speech_game_controller.dart`
  - Extend BaseController from exo_shared
  - Initialize speech_to_text with English locale (`en_US`)
  - Request microphone permission on initialization
  - Handle speech recognition callbacks
  - Manage game state (listening, success, error)
  - Integrate ProcessSpeechUseCase for matching

## 3. Presentation Layer - Page and Widgets
- [x] 3.1 Create SpeechGamePage in `lib/features/learning/presentation/pages/speech_game_page.dart`
  - Extend BaseView from exo_shared
  - Display target vocabulary word
  - Show listening indicator when active
  - Display success dialog on match
  - Handle skip functionality
- [x] 3.2 Create SpeechGameBinding in `lib/features/learning/presentation/bindings/speech_game_binding.dart`
  - Register SpeechGameController with dependencies

## 4. Translations
- [x] 4.1 Add translation keys to `lib/core/translations/translation_keys.dart`
  - speechGameTitle
  - sayTheWord
  - listening
  - speechSuccess
  - speechTryAgain
  - errorMicrophonePermission
  - errorMicrophoneNotAvailable
- [x] 4.2 Add English translations to `lib/core/translations/en.dart`
- [x] 4.3 Add Vietnamese translations to `lib/core/translations/vi.dart`

## 5. Debug Access
- [x] 5.1 Add debug button to home page in `lib/features/home/presentation/controllers/home_controller.dart`
  - Show "Test Speech Game" button in debug mode only
  - Navigate to SpeechGamePage with mock vocabulary

## 6. Route Configuration
- [x] 6.1 Add route definition in `lib/core/routes/app_routes.dart` (or wherever routes are defined)
  - Register SpeechGamePage route

## 7. Android Permissions
- [x] 7.1 Verify microphone permission in `android/app/src/main/AndroidManifest.xml`
  - Ensure RECORD_AUDIO permission is declared

## 8. Validation
- [ ] 8.1 Test on physical Android device
- [ ] 8.2 Verify English locale recognition accuracy
- [ ] 8.3 Verify permission flow (grant/deny)
- [ ] 8.4 Verify success dialog display
- [x] 8.5 Run `flutter analyze` to ensure no static analysis errors


# Tasks: Implement AR Game Lesson Step

## Required Dependencies Check
- [x] Verify `google_ml_kit_image_labeling: ^0.14.1` in `pubspec.yaml`
- [x] Verify `camera: ^0.11.3` in `pubspec.yaml`
- [x] Verify `permission_handler: ^12.0.1` in `pubspec.yaml`

---

## Phase 1: Domain Layer Updates

### 1.1 Extend VocabularyEntity
- [x] Add `allowedLabels: List<String>` field to `VocabularyEntity` (default empty list)
- [x] Update `copyWith`, `==`, `hashCode`, `toString` methods

### 1.2 Extend VocabularyModel
- [x] Add `allowedLabels: List<String>` field to `VocabularyModel` (Isar)
- [x] Run `dart run build_runner build --delete-conflicting-outputs`

### 1.3 Update LearningMapper
- [x] Map `allowedLabels` between entity and model in `lib/features/learning/data/mappers/learning_mapper.dart`

### 1.4 Update Data Seeding
- [x] Update `LearningLocalDataSource.seedInitialData` in `lib/features/learning/data/datasources/learning_local_datasource.dart` to include `allowedLabels` for each vocabulary:
  - `vocab_a` (Apple): `['Apple', 'Fruit', 'Food', 'Red', 'Natural foods']`
  - `vocab_b` (Bottle): `['Bottle', 'Water bottle', 'Drinkware', 'Plastic', 'Container']`
  - `vocab_c` (Cup): `['Cup', 'Mug', 'Coffee cup', 'Tableware', 'Drinkware']`
  - `vocab_d` (Desk): `['Desk', 'Table', 'Furniture', 'Office', 'Wood']`
  - `vocab_e` (Egg): `['Egg', 'Food', 'Oval', 'White', 'Ingredient', 'Breakfast']`

### 1.5 Create ProcessImageLabelUseCase
- [x] Create `lib/features/learning/domain/usecases/process_image_label_usecase.dart`
- [x] Implement fuzzy matching: check if detected label is in `vocabulary.allowedLabels` with confidence >= 0.7
- [x] Use case-insensitive comparison

---

## Phase 2: Presentation Layer - Controller & Binding

### 2.1 Create ARGameController
- [x] Create `lib/features/learning/presentation/controllers/ar_game_controller.dart`
- [x] Extend `BaseController` from `exo_shared`
- [x] Implement `_requestCameraPermission()` using `PermissionUtil` from `exo_shared`
- [x] Implement camera initialization (back camera only, `ResolutionPreset.medium`)
- [x] Implement ML Kit ImageLabeler initialization with error handling
- [x] Implement `_processCameraImage` with throttling (500ms)
- [x] Implement `_convertToInputImage` for ML Kit format
- [x] Implement game state management (`detectedLabels`, `isProcessing`, `objectFound`, `showDebugOverlay`)
- [x] Implement `onObjectFound` success flow
- [x] Implement `skipGame` for skip/cheat button
- [x] Implement `toggleDebugOverlay` for debug visibility
- [x] Implement resource cleanup in `onClose()` (dispose camera, close labeler)
- [x] Handle initialization errors with skip-only fallback mode

### 2.2 Create ARGameBinding
- [x] Create `lib/features/learning/presentation/bindings/ar_game_binding.dart`
- [x] Register `ProcessImageLabelUseCase`
- [x] Register `ARGameController` with vocabulary and lessonId from arguments

---

## Phase 3: Presentation Layer - Page & Widgets

### 3.1 Create ARGamePage
- [x] Create `lib/features/learning/presentation/pages/ar_game_page.dart`
- [x] Extend `BaseView<ARGameController>`
- [x] Implement `getPageRoute` with `ARGameBinding`
- [x] Layout: Header (TargetDisplayWidget), Camera Preview, Debug Overlay, Skip Button

### 3.2 Create CameraPreviewWidget
- [x] Create `lib/features/learning/presentation/widgets/camera_preview_widget.dart`
- [x] Display camera feed from controller using `CameraPreview`
- [x] Handle camera not initialized state with loading indicator

### 3.3 Create TargetDisplayWidget
- [x] Create `lib/features/learning/presentation/widgets/target_display_widget.dart`
- [x] Display "Find a [WORD]!" header with target word
- [x] Use `TranslationKeys.findObject.trParams({'word': vocabulary.word})`

### 3.4 Create DebugOverlayWidget
- [x] Create `lib/features/learning/presentation/widgets/debug_overlay_widget.dart`
- [x] Display top 5 detected labels with confidence percentages
- [x] Position in top-left corner with semi-transparent background
- [x] Implement `GestureDetector` for tap-to-toggle visibility
- [x] Use `Obx` to react to `showDebugOverlay` state

### 3.5 Create SuccessDialogWidget
- [x] Create `lib/features/learning/presentation/widgets/success_dialog_widget.dart`
- [x] Show celebration message using `TranslationKeys.correctMessage`
- [x] "Next" button to proceed using `TranslationKeys.nextButton`

---

## Phase 4: Integration

### 4.1 Add AR Game Route
- [x] Add `static const arGame = '/ar-game';` to `AppRoutes`
- [x] Register `ARGamePage.getPageRoute` in `app_pages.dart`

### 4.2 Add Translation Keys
- [x] Add to `translation_keys.dart`:
  - `arGameTitle`
  - `findObject`
  - `skipButton`
  - `correctMessage`
  - `cameraPermissionDenied`
  - `cameraInitError`
- [x] Add English translations to `en.dart`
- [x] Add Vietnamese translations to `vi.dart`

### 4.3 Connect to Learning Flow
- [ ] Update learning page/controller to navigate to AR Game when step is `arGame` (Skipped: Learning Controller/Page not fully implemented yet)
- [ ] Pass `vocabulary` and `lessonId` as arguments:
  ```dart
  Get.toNamed(AppRoutes.arGame, arguments: {
    'vocabulary': currentVocabulary,
    'lessonId': lesson.id,
  });
  ```
- [x] Handle AR Game success callback to call `UpdateLessonProgressUseCase`

### 4.4 Add Home Page Test Button (Debug)
- [x] Add debug test button in `HomePage.body()` to navigate to AR Game
- [x] Create mock `VocabularyEntity` with `allowedLabels` for testing
- [x] Add translation key `testArGame` for button text
- [x] Button should only be visible in debug mode (wrap with `kDebugMode`)

---

## Phase 5: Verification

### 5.1 Static Analysis
- [x] Run `flutter analyze` - must pass with no errors

### 5.2 Build Verification
- [x] Run `flutter build apk --debug` - must succeed

### 5.3 Manual Testing (Physical Device Required)
- [ ] **Camera Permission**: Grant camera permission when prompted
- [ ] **Permission Denied**: Deny permission, verify skip option is available
- [ ] **Camera Preview**: Verify back camera shows correctly
- [ ] **Label Detection**: Point at an object, verify debug overlay shows labels
- [ ] **Debug Toggle**: Tap debug overlay, verify it toggles visibility
- [ ] **Match Detection**: Point at target object (e.g., apple), verify success triggers
- [ ] **Skip Button**: Tap skip, verify game completes without detection
- [ ] **Progress Update**: Verify lesson progresses to next step/lesson
- [ ] **Home Test Button**: Tap test button on home, verify AR Game opens with mock vocabulary
- [ ] **Error Handling**: Force ML Kit failure (if possible), verify skip-only mode

---

## Notes
- **Physical Android device required** - Emulators are too slow for ML Kit
- **Back camera only** - Front camera is not supported
- **Offline mode** - ML Kit runs locally, no internet needed
- **Debug overlay** - Essential for testing label detection accuracy

# AR Game Lesson Step - Specification

## Purpose
Defines the AR Object Hunt game step where children use the device camera to find real-world objects matching vocabulary words using ML Kit image labeling.

---

## ADDED Requirements

### Requirement: Vocabulary Allowed Labels
The system SHALL store allowed ML Kit labels for each vocabulary word to enable fuzzy matching during AR detection.

#### Scenario: Vocabulary with allowed labels
- **GIVEN** a vocabulary word "Apple"
- **WHEN** the vocabulary is fetched from the repository
- **THEN** the `VocabularyEntity` SHALL contain `allowedLabels` including "Apple", "Fruit", "Food", "Red"

#### Scenario: Allowed labels storage
- **GIVEN** a `VocabularyModel` is persisted to Isar
- **WHEN** `allowedLabels` list is `["Cup", "Mug", "Drinkware"]`
- **THEN** the list SHALL be stored as `List<String>` in the database

#### Scenario: Empty allowed labels default
- **GIVEN** a vocabulary item without AR support
- **WHEN** `allowedLabels` is not specified
- **THEN** it SHALL default to an empty list `[]`

---

### Requirement: Image Label Processing
The system SHALL process camera images using ML Kit and match detected labels against vocabulary allowed labels.

#### Scenario: Successful match with high confidence
- **GIVEN** a vocabulary targets the word "Apple" with `allowedLabels` `["Apple", "Fruit", "Food"]`
- **AND** ML Kit detects label "Fruit" with confidence 0.85
- **WHEN** `ProcessImageLabelUseCase` evaluates the detection
- **THEN** it SHALL return `true` (match found)

#### Scenario: Rejected match with low confidence
- **GIVEN** a vocabulary targets the word "Apple" with `allowedLabels` `["Apple", "Fruit", "Food"]`
- **AND** ML Kit detects label "Apple" with confidence 0.55
- **WHEN** `ProcessImageLabelUseCase` evaluates the detection
- **THEN** it SHALL return `false` (confidence below 0.7 threshold)

#### Scenario: No match for unrelated label
- **GIVEN** a vocabulary targets the word "Apple" with `allowedLabels` `["Apple", "Fruit", "Food"]`
- **AND** ML Kit detects label "Furniture" with confidence 0.95
- **WHEN** `ProcessImageLabelUseCase` evaluates the detection
- **THEN** it SHALL return `false` (label not in allowed list)

#### Scenario: Case-insensitive matching
- **GIVEN** `allowedLabels` contains "Coffee cup"
- **AND** ML Kit detects label "coffee cup" with confidence 0.80
- **WHEN** `ProcessImageLabelUseCase` evaluates the detection
- **THEN** it SHALL return `true` (case-insensitive match)

---

### Requirement: Camera Integration
The AR Game SHALL use the device back camera for object detection with proper permission handling via `PermissionUtil` from `exo_shared`.

#### Scenario: Request camera permission before initialization
- **WHEN** `ARGameController` starts
- **THEN** it SHALL use `PermissionUtil.requestCameraPermission()` from `exo_shared`
- **AND** wait for permission result before initializing camera

#### Scenario: Back camera initialization
- **GIVEN** camera permission is granted
- **WHEN** `ARGameController` initializes camera
- **THEN** it SHALL select the back-facing camera only
- **AND** use `ResolutionPreset.medium` for performance

#### Scenario: Camera permission denied
- **GIVEN** camera permission is denied by the user via `PermissionUtil`
- **WHEN** `ARGameController` receives denied result
- **THEN** it SHALL show a permission rationale message
- **AND** allow the user to skip the game

#### Scenario: Image stream processing throttle
- **WHEN** camera image stream is being processed
- **THEN** the controller SHALL process at most 1 frame every 500ms
- **AND** skip frames while a previous frame is still being processed

---

### Requirement: Error Handling
The AR Game SHALL handle initialization and runtime errors gracefully.

#### Scenario: Camera initialization failure
- **GIVEN** camera fails to initialize (e.g., hardware error)
- **WHEN** `ARGameController` catches the initialization exception
- **THEN** it SHALL display an error message to the user
- **AND** enable skip-only mode (skip button only, no camera preview)

#### Scenario: ML Kit initialization failure
- **GIVEN** ML Kit `ImageLabeler` fails to initialize
- **WHEN** `ARGameController` catches the initialization exception
- **THEN** it SHALL display an error message to the user
- **AND** enable skip-only mode

#### Scenario: Image processing exception
- **GIVEN** an exception occurs during image label processing
- **WHEN** `_processCameraImage` catches the exception
- **THEN** it SHALL log the error
- **AND** continue processing subsequent frames (not crash)

---

### Requirement: Game Flow
The AR Game SHALL guide the user through finding a target object and handle success/skip actions.

#### Scenario: Display target word
- **WHEN** AR Game page is displayed
- **THEN** it SHALL show "Find a [WORD]!" where `[WORD]` is the current vocabulary item

#### Scenario: Object found success
- **GIVEN** ML Kit detects a matching label with sufficient confidence
- **WHEN** `ProcessImageLabelUseCase` returns `true`
- **THEN** the game SHALL stop camera processing
- **AND** show a success celebration dialog
- **AND** provide a "Next" button to proceed

#### Scenario: Skip button action
- **GIVEN** the user taps the skip button
- **WHEN** the skip action is triggered
- **THEN** the game SHALL complete without detection
- **AND** proceed to the next lesson step

#### Scenario: Resource cleanup
- **WHEN** AR Game page is closed
- **THEN** `ARGameController` SHALL dispose camera controller
- **AND** close ML Kit `ImageLabeler`

---

### Requirement: Debug Overlay
The AR Game SHALL display a debug overlay showing real-time ML Kit detection results.

#### Scenario: Display detected labels
- **WHEN** ML Kit processes a camera frame
- **THEN** the debug overlay SHALL display up to 5 detected labels
- **AND** show confidence percentage for each label
- **AND** position in top-left corner with semi-transparent background

#### Scenario: Debug overlay visibility
- **GIVEN** `showDebugOverlay` is `true`
- **THEN** the debug overlay SHALL be visible during camera preview

#### Scenario: Toggle debug overlay
- **GIVEN** the debug overlay is visible
- **WHEN** user taps the overlay
- **THEN** it SHALL toggle visibility (hide if visible, show if hidden)

---

### Requirement: AR Game Translations
The AR Game SHALL support localized UI text.

#### Scenario: English translations
- **WHEN** app locale is English
- **THEN** "Find a @word" SHALL display as "Find a Apple"
- **AND** skip button SHALL display "Skip"
- **AND** success message SHALL display "Correct! Well done!"

#### Scenario: Vietnamese translations
- **WHEN** app locale is Vietnamese
- **THEN** "Find a @word" SHALL display as "Tìm Apple"
- **AND** skip button SHALL display "Bỏ Qua"
- **AND** success message SHALL display "Chính xác! Giỏi lắm!"

---

### Requirement: Home Page Debug Button
For testing purposes, the home page SHALL include a debug button to launch AR Game.

#### Scenario: Debug button visibility
- **GIVEN** the app is running in debug mode (`kDebugMode == true`)
- **WHEN** the home page is displayed
- **THEN** a "Test AR Game" button SHALL be visible

#### Scenario: Debug button navigation
- **GIVEN** the debug button is tapped
- **WHEN** navigation is triggered
- **THEN** it SHALL navigate to AR Game with mock vocabulary data
- **AND** the mock vocabulary SHALL have predefined `allowedLabels` for testing

#### Scenario: Debug button hidden in release
- **GIVEN** the app is running in release mode (`kDebugMode == false`)
- **WHEN** the home page is displayed
- **THEN** the "Test AR Game" button SHALL NOT be visible

# learning-data Specification

## Purpose
TBD - created by archiving change prepare-learning-feature. Update Purpose after archive.
## Requirements
### Requirement: Domain Entities
The system SHALL provide pure Dart domain entities for learning content including TopicEntity, LessonEntity, and VocabularyEntity.

#### Scenario: TopicEntity with nested lessons
- **WHEN** a topic is fetched from the repository
- **THEN** the TopicEntity SHALL contain all associated LessonEntity objects
- **AND** each LessonEntity SHALL contain all associated VocabularyEntity objects

#### Scenario: LessonStep enum serialization
- **GIVEN** a LessonEntity has a currentStep of arGame
- **WHEN** the entity is converted to a model for storage
- **THEN** the step SHALL be stored as the string lesson_step_ar_game

#### Scenario: LessonStep enum deserialization
- **GIVEN** a LessonModel has currentStep value lesson_step_flashcard
- **WHEN** the model is converted to an entity
- **THEN** the LessonEntity SHALL have currentStep LessonStep.flashcard

---

### Requirement: Isar Database Models
The system SHALL persist learning data using Isar collections with proper IsarLinks relationships.

#### Scenario: TopicModel with IsarLinks
- **GIVEN** a new topic is created
- **WHEN** lessons are added to the topic
- **THEN** the TopicModel.lessons IsarLinks SHALL contain all LessonModel references

#### Scenario: LessonModel with IsarLinks
- **GIVEN** a new lesson is created
- **WHEN** vocabulary items are added to the lesson
- **THEN** the LessonModel.vocabularies IsarLinks SHALL contain all VocabularyModel references

#### Scenario: Indexed fields for efficient queries
- **WHEN** a topic is queried by modelId
- **THEN** the query SHALL use the index for efficient lookup

---

### Requirement: Data Seeding
The system SHALL seed initial learning content on first launch using predefined constants for topics, lessons, and vocabularies.

#### Scenario: Seed topics from constants
- **GIVEN** the database is empty
- **WHEN** SeedInitialDataUseCase is executed
- **THEN** the database SHALL contain 3 Topics from topic constants: "Khởi động", "Chào hỏi", "Gia đình"
- **AND** each Topic SHALL have the correct metadata (id, name, description, thumbnailPath, orderIndex)

#### Scenario: Seed lessons from constants
- **GIVEN** the database is empty
- **WHEN** SeedInitialDataUseCase is executed
- **THEN** the database SHALL contain 5 Lessons from lesson constants (A-E)
- **AND** each Lesson SHALL have the correct metadata (id, title, orderIndex)
- **AND** the same 5 Lessons SHALL be linked to all 3 Topics (lessons are shared across topics)

#### Scenario: Seed vocabularies from constants
- **GIVEN** the database is empty
- **WHEN** SeedInitialDataUseCase is executed
- **THEN** the database SHALL contain 5 Vocabularies from vocabulary constants
- **AND** each Vocabulary SHALL have the correct metadata (id, word, meaning, imagePath, allowedLabels)
- **AND** Vocabularies SHALL be linked to their respective Lessons

#### Scenario: Skip seeding if data exists
- **GIVEN** the database already contains topics
- **WHEN** SeedInitialDataUseCase is executed
- **THEN** no new data SHALL be added

#### Scenario: Initial unlock state
- **GIVEN** the database is freshly seeded
- **THEN** Topic with orderIndex 0 ("Khởi động") SHALL have isLocked equals false
- **AND** Topics with orderIndex 1 and 2 ("Chào hỏi", "Gia đình") SHALL have isLocked equals true
- **AND** Lesson with orderIndex 0 (Letter A) SHALL have isLocked equals false in all Topics
- **AND** all other Lessons (B-E) SHALL have isLocked equals true in all Topics
- **AND** all Lessons SHALL have currentStep equals story

### Requirement: Lesson Progress Tracking
The system SHALL track and update lesson progress through the step sequence story, flashcard, arGame, done.

#### Scenario: Complete story step
- **GIVEN** a Lesson has currentStep story
- **WHEN** UpdateLessonProgressUseCase is called with completedStep story
- **THEN** the Lesson currentStep SHALL become flashcard

#### Scenario: Complete flashcard step
- **GIVEN** a Lesson has currentStep flashcard
- **WHEN** UpdateLessonProgressUseCase is called with completedStep flashcard
- **THEN** the Lesson currentStep SHALL become arGame

#### Scenario: Complete arGame step unlocks next lesson
- **GIVEN** Lesson A has currentStep arGame
- **AND** Lesson B has isLocked equals true
- **WHEN** UpdateLessonProgressUseCase is called with completedStep arGame
- **THEN** Lesson A SHALL have isCompleted equals true and currentStep equals done
- **AND** Lesson B SHALL have isLocked equals false

#### Scenario: Complete last lesson in topic
- **GIVEN** Lesson E has currentStep arGame
- **WHEN** UpdateLessonProgressUseCase is called with completedStep arGame
- **THEN** Lesson E SHALL have isCompleted equals true
- **AND** Topic Alphabet SHALL have isCompleted equals true

#### Scenario: Ignore duplicate step completion
- **GIVEN** a Lesson has currentStep flashcard
- **WHEN** UpdateLessonProgressUseCase is called with completedStep story
- **THEN** the Lesson currentStep SHALL remain flashcard

#### Scenario: Prevent out-of-order step completion
- **GIVEN** a Lesson has currentStep story
- **WHEN** UpdateLessonProgressUseCase is called with completedStep arGame
- **THEN** the Lesson currentStep SHALL remain story

---

### Requirement: Repository Operations
The repository MUST handle data access errors gracefully and provide methods for fetching specific entities.

#### Scenario: Storage error on database failure
- **GIVEN** an Isar write transaction fails
- **WHEN** the repository catches the error
- **THEN** a StorageError MUST be thrown with the original error attached

#### Scenario: NotFoundError for missing entity
- **GIVEN** a lesson ID does not exist in the database
- **WHEN** getLessonById is called with that ID
- **THEN** a NotFoundError MUST be thrown

#### Scenario: Fetch specific topic by ID
- **GIVEN** a topic with ID topic_alphabet exists
- **WHEN** getTopicById is called with topic_alphabet
- **THEN** it SHALL return the corresponding TopicEntity

#### Scenario: Fetch specific lesson by ID
- **GIVEN** a lesson with ID lesson_a exists
- **WHEN** getLessonById is called with lesson_a
- **THEN** it SHALL return the corresponding LessonEntity

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

### Requirement: Learning Data Constants
The system SHALL provide constant definitions for initial learning content in the data layer.

#### Scenario: Topic constants structure
- **GIVEN** topic constants are defined
- **WHEN** a constant is accessed
- **THEN** it SHALL provide all required fields: id, name, description, thumbnailPath, orderIndex
- **AND** the structure SHALL support associating lessons with topics (via lesson ID references)
- **AND** constants SHALL include 3 topics: "Khởi động" (orderIndex 0), "Chào hỏi" (orderIndex 1), "Gia đình" (orderIndex 2)
- **AND** each topic SHALL reference the same 5 shared lessons (A-E)

#### Scenario: Lesson constants structure
- **GIVEN** lesson constants are defined
- **WHEN** a constant is accessed
- **THEN** it SHALL provide all required fields: id, title, orderIndex
- **AND** the structure SHALL support associating vocabularies with lessons
- **AND** constants SHALL include 5 lessons (A-E) that are shared across all 3 topics
- **AND** each lesson SHALL be associated with exactly one vocabulary item

#### Scenario: Vocabulary constants structure
- **GIVEN** vocabulary constants are defined
- **WHEN** a constant is accessed
- **THEN** it SHALL provide all required fields: id, word, meaning, imagePath, allowedLabels
- **AND** allowedLabels SHALL be a non-empty list for AR-enabled vocabularies
- **AND** constants SHALL include 5 vocabularies (one per lesson A-E)

#### Scenario: Constants location
- **GIVEN** constants are created
- **WHEN** the file structure is examined
- **THEN** constants SHALL be located in `lib/features/learning/data/constants/`
- **AND** topic constants SHALL be in `topic_constants.dart`
- **AND** lesson constants SHALL be in `lesson_constants.dart`
- **AND** vocabulary constants SHALL be in `vocabulary_constants.dart`
- **AND** a barrel file `constants.dart` MAY be provided to export all constants for convenient imports

#### Scenario: Data source uses constants
- **GIVEN** constants are defined
- **WHEN** `LearningLocalDataSource.seedInitialData()` is called
- **THEN** it SHALL use the constants instead of hardcoded data structures
- **AND** it SHALL create 3 topics (replacing the previous "Alphabet" topic)
- **AND** it SHALL associate the same 5 shared lessons with all 3 topics
- **AND** the seeding logic SHALL remain functionally equivalent for relationships and unlock states


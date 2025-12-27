# learning-data Specification

## MODIFIED Requirements

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

## ADDED Requirements

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

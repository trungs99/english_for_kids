# learning-data Specification

## Purpose

This capability defines the data persistence layer for the Learning Feature, including entities, database models, and repository operations for Topics, Lessons, and Vocabulary.

---

## ADDED Requirements

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
The system SHALL seed initial learning content on first launch with the Alphabet topic.

#### Scenario: Seed Alphabet topic
- **GIVEN** the database is empty
- **WHEN** SeedInitialDataUseCase is executed
- **THEN** the database SHALL contain 1 Topic named Alphabet
- **AND** the Topic SHALL contain 5 Lessons for letters A through E
- **AND** each Lesson SHALL contain 1 Vocabulary item

#### Scenario: Skip seeding if data exists
- **GIVEN** the database already contains topics
- **WHEN** SeedInitialDataUseCase is executed
- **THEN** no new data SHALL be added

#### Scenario: Initial unlock state
- **GIVEN** the database is freshly seeded
- **THEN** Topic Alphabet SHALL have isLocked equals false
- **AND** Lesson Letter A SHALL have isLocked equals false
- **AND** Lessons B C D E SHALL have isLocked equals true
- **AND** all Lessons SHALL have currentStep equals story

---

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

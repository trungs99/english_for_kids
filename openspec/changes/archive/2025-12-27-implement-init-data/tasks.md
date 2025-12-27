# Tasks: Implement Init Data Constants

## Overview

Ordered list of work items to extract hardcoded learning data into reusable constants.

---

## Task List

### Phase 0: Analysis

- [x] **0.1** Review current `seedInitialData()` implementation
  - Document current "Alphabet" topic structure
  - Identify all hardcoded data that needs extraction
  - Note lesson-vocabulary relationships
  - **Verify**: Understanding of current implementation

- [x] **0.2** Document lesson-topic association requirements
  - Clarify how 5 lessons (A-E) will be shared across 3 topics
  - Determine lesson orderIndex handling when shared
  - Document topic-lesson association structure
  - **Verify**: Clear understanding of data relationships

- [x] **0.3** Determine migration strategy for existing "Alphabet" topic data
  - Confirm that `isDatabaseSeeded()` prevents re-seeding
  - Document that existing users will keep "Alphabet" topic until future migration
  - Note that new installations will get 3 new topics
  - **Verify**: Migration approach is documented

### Phase 1: Create Constants Files

- [x] **1.1** Create `lib/features/learning/data/constants/vocabulary_constants.dart`
  - Define 5 vocabulary constants (one for each lesson A-E)
  - Use typed data classes with const constructors for type safety
  - Each constant should include: `id`, `word`, `meaning`, `imagePath`, `allowedLabels`
  - Add documentation comments explaining each constant's purpose
  - Use the existing data from `seedInitialData()` as reference
  - **Verify**: Dart analyzer passes
  - **Verify**: Constants match VocabularyEntity structure

- [x] **1.2** Create `lib/features/learning/data/constants/lesson_constants.dart`
  - Define 5 lesson constants (A-E)
  - Use typed data classes with const constructors for type safety
  - Each constant should include: `id`, `title`, `orderIndex`
  - Reference vocabulary constants where appropriate (associate vocab ID with lesson)
  - Add documentation comments explaining each constant's purpose
  - **Verify**: Dart analyzer passes
  - **Verify**: Constants match LessonEntity structure

- [x] **1.3** Create `lib/features/learning/data/constants/topic_constants.dart`
  - Define 3 topic constants: "Khởi động" (orderIndex 0), "Chào hỏi" (orderIndex 1), "Gia đình" (orderIndex 2)
  - Use typed data classes with const constructors for type safety
  - Each constant should include: `id`, `name`, `description`, `thumbnailPath`, `orderIndex`
  - Structure to support associating lessons with topics (include list of lesson IDs that belong to this topic)
  - Add documentation comments explaining each constant's purpose
  - **Verify**: Dart analyzer passes
  - **Verify**: Constants match TopicEntity structure

- [x] **1.4** Create `lib/features/learning/data/constants/constants.dart` (barrel file)
  - Export all constant files for convenient imports
  - **Verify**: Dart analyzer passes

### Phase 2: Refactor Data Source

- [x] **2.1** Update `LearningLocalDataSource.seedInitialData()`
  - Import the new constants files (use barrel file if created)
  - Replace hardcoded "Alphabet" topic with 3 new topics from constants
  - Replace hardcoded lessons with lesson constants
  - Replace hardcoded vocabularies with vocabulary constants
  - Associate shared lessons (A-E) with all 3 topics
  - Maintain the same seeding logic and relationships
  - **Verify**: Dart analyzer passes
  - **Verify**: Database seeding still works correctly
  - **Verify**: All 3 topics are created with correct metadata
  - **Verify**: Lessons are properly linked to all topics

### Phase 2.5: Migration Considerations

- [x] **2.5.1** Verify existing user data handling
  - Confirm `isDatabaseSeeded()` check prevents re-seeding
  - Document that existing "Alphabet" topic will remain for current users
  - Note that new installations will receive 3 new topics
  - **Verify**: Migration approach is clear and documented

- [x] **2.5.2** Test migration path (if applicable)
  - Test that existing database with "Alphabet" topic is not affected
  - Test that empty database receives 3 new topics
  - **Verify**: No data loss for existing users

### Phase 3: Validation

- [x] **3.1** Validate constant structure
  - Verify all constants match their respective entity structures
  - Check that required fields are present in all constants
  - Verify type safety (no runtime errors from missing fields)
  - **Verify**: Constants are properly structured and type-safe

- [x] **3.2** Test data seeding
  - Clear database and run seed operation
  - Verify all 3 topics are created with correct metadata
  - Verify all 5 lessons are created and linked correctly to all topics
  - Verify all 5 vocabularies are created and linked correctly to lessons
  - Verify initial unlock state (first topic and first lesson unlocked)
  - **Verify**: All relationships are preserved
  - **Verify**: Seeding behavior matches spec requirements

- [x] **3.3** Run static analysis
  - Execute `flutter analyze` and resolve any issues
  - **Verify**: No analyzer warnings or errors


# Change: Implement Init Data Constants

## Why

Currently, the initial learning data (topics, lessons, and vocabularies) is hardcoded directly in the `seedInitialData()` method of `LearningLocalDataSource`. The current implementation seeds a single "Alphabet" topic with 5 lessons (A-E). This makes it difficult to:
- Maintain and update learning content
- Reuse data definitions across different parts of the application
- Add new topics, lessons, or vocabularies without modifying the data source implementation
- Test data seeding logic independently

This change expands the initial data from 1 topic to 3 topics ("Khởi động", "Chào hỏi", "Gia đình") suitable for Vietnamese children learning English. The 5 lessons (A-E) will be shared across all 3 topics. Extracting this data into well-structured constants will improve maintainability, testability, and follow Clean Architecture principles by separating data definitions from implementation.

## What Changes

- **ADDED**: Create constant files for topics, lessons, and vocabularies in the data layer
  - `lib/features/learning/data/constants/topic_constants.dart` - 3 topic definitions: "Khởi động", "Chào hỏi", "Gia đình"
  - `lib/features/learning/data/constants/lesson_constants.dart` - 5 lesson definitions (A-E) that are shared across topics
  - `lib/features/learning/data/constants/vocabulary_constants.dart` - 5 vocabulary definitions (one per lesson)
  - `lib/features/learning/data/constants/constants.dart` - Barrel file to export all constants
- **MODIFIED**: Update `LearningLocalDataSource.seedInitialData()` to use the new constants instead of hardcoded data
  - Replace current "Alphabet" topic seeding with 3 new topics
  - Associate shared lessons (A-E) with all 3 topics
- **MODIFIED**: Update the data seeding requirement in `learning-data` spec to reference the constants and clarify lesson sharing
- **REMOVED**: Current "Alphabet" topic seeding logic (replaced by 3 new topics)

## Impact

- **Affected specs**: `learning-data` (data seeding requirement)
- **Affected code**: 
  - `lib/features/learning/data/datasources/learning_local_datasource.dart`
  - New constants directory: `lib/features/learning/data/constants/`
- **Breaking changes**: 
  - The "Alphabet" topic will be replaced with 3 new topics. Existing users with the "Alphabet" topic will need database migration or will receive the new topics on next app launch (seeding only occurs when database is empty).
- **Migration**: 
  - For new installations: Seeding will create 3 topics with shared lessons
  - For existing users: The `isDatabaseSeeded()` check prevents re-seeding. Existing "Alphabet" topic data will remain until a future migration is implemented if needed.


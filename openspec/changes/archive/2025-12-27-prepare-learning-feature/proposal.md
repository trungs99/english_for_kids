# Prepare Learning Feature - Domain & Data Layers

## Summary

This change implements the **Domain Layer** and **Data Layer** for the Learning Feature using Isar Database, following Clean Architecture principles. The goal is to establish persistent data models for Topics, Lessons, and Vocabulary that replace hardcoded lists and enable progress tracking.

## Why

The Kids English Learning App currently lacks a data persistence layer. Without persistent storage:
- Learning progress is lost when the app closes
- Lessons unlock state cannot be tracked
- Content must be hardcoded rather than structured
- Future content expansion becomes difficult

This change establishes the foundational data layer that all presentation layer features (Topic selection, Lesson flow, Progress tracking) will depend on.

## Context

The Kids English Learning App needs a structured data layer to:
- Store and retrieve learning content (Topics, Lessons, Vocabulary)
- Track lesson progress with step-based unlocking (Story → Flashcard → AR Game)
- Seed initial content for the "Alphabet" topic with 5 lessons (Letters A-E)

## Scope

- **In Scope:**
  - Domain entities (`TopicEntity`, `LessonEntity`, `VocabularyEntity`)
  - Isar models with proper relationships (`IsarLinks`, `@Backlink`)
  - `LessonStep` enum with strict `toIdString()`/`fromIdString()` pattern (snake_case IDs)
  - Repository interface and implementation
  - Data source with seeding logic
  - Business Logic UseCases (Fetch topics, updates progress, etc.)
  - `IsarService` schema integration

- **Out of Scope:**
  - Presentation layer (pages, controllers, widgets)
  - UI for learning flow (Story, Flashcard, AR Game screens)
  - Navigation and routing

## User Review Required

> [!IMPORTANT]
> This proposal introduces new Isar collections. After implementation, running `build_runner` is required to generate Isar schemas.

> [!NOTE]
> The seed data uses `Assets.images.*.path` from `flutter_gen`. Ensure images (apple.png, bottle.png, cup.png, desk.png, egg.png) exist in `assets/images/` before seeding.

## Proposed Changes

### Domain Layer

#### [NEW] [lesson_step_type.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/entities/lesson_step_type.dart)
- `LessonStep` enum with values: `story`, `flashcard`, `arGame`, `done`
- Implements `toIdString()` returning snake_case strings: `lesson_step_story`, `lesson_step_flashcard`, `lesson_step_ar_game`, `lesson_step_done`
- Implements `static fromIdString()` for deserialization

#### [NEW] [topic_entity.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/entities/topic_entity.dart)
- Pure Dart class with fields: `id`, `name`, `description`, `thumbnailPath`, `orderIndex`, `isLocked`, `isCompleted`
- Contains list of `LessonEntity`

#### [NEW] [lesson_entity.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/entities/lesson_entity.dart)
- Pure Dart class with fields: `id`, `title`, `orderIndex`, `isLocked`, `isCompleted`, `currentStep`
- Contains list of `VocabularyEntity`

#### [NEW] [vocabulary_entity.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/entities/vocabulary_entity.dart)
- Pure Dart class with fields: `id`, `word`, `meaning`, `imagePath`, `audioPath`

#### [NEW] [learning_repository_interface.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/repositories/learning_repository_interface.dart)
- Methods: `getAllTopics()`, `getTopicById()`, `getLessonById()`, `updateLessonProgress()`, `seedInitialData()`, `isDatabaseSeeded()`

---

### Data Layer

#### [NEW] [topic_model.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/data/models/topic_model.dart)
- Isar `@collection` with indexed fields
- `IsarLinks<LessonModel>` for relationship

#### [NEW] [lesson_model.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/data/models/lesson_model.dart)
- Isar `@collection` with indexed fields
- `IsarLinks<VocabularyModel>` for relationship
- Stores `currentStep` as String
- `@Backlink(to: 'lessons')` to `TopicModel`

#### [NEW] [vocabulary_model.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/data/models/vocabulary_model.dart)
- Isar `@collection` with indexed fields
- `@Backlink(to: 'vocabularies')` to `LessonModel`

#### [NEW] [learning_mapper.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/data/mappers/learning_mapper.dart)
- Extensions: `TopicModel.toEntity()`, `TopicEntity.toModel()`
- Extensions: `LessonModel.toEntity()`, `LessonEntity.toModel()`
- Extensions: `VocabularyModel.toEntity()`, `VocabularyEntity.toModel()`

#### [NEW] [learning_local_datasource.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/data/datasources/learning_local_datasource.dart)
- Constructor takes `Isar` instance
- Implements all data operations
- Contains `seedInitialData()` with exact content from spec

#### [NEW] [learning_repository.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/data/repositories/learning_repository.dart)
- Implements `LearningRepositoryInterface`
- Wraps all Isar calls in try-catch
- Throws `StorageError` or `NotFoundError` on failure

---

### UseCases

#### [NEW] [get_topics_usecase.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/usecases/get_topics_usecase.dart)
- Fetches all topics with nested lessons and vocabulary

#### [NEW] [get_topic_by_id_usecase.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/usecases/get_topic_by_id_usecase.dart)
- Fetches a specific topic by ID

#### [NEW] [get_lesson_by_id_usecase.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/usecases/get_lesson_by_id_usecase.dart)
- Fetches a specific lesson by ID

#### [NEW] [update_lesson_progress_usecase.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/usecases/update_lesson_progress_usecase.dart)
- Input: `lessonId`, `completedStep`
- Logic: Updates current step, unlocks next step or lesson based on progression rules

#### [NEW] [seed_initial_data_usecase.dart](file:///Users/trungshin/product/english_for_kids/lib/features/learning/domain/usecases/seed_initial_data_usecase.dart)
- Checks if DB is empty
- Seeds the "Alphabet" topic with 5 lessons

---

### Service Integration

#### [MODIFY] [isar_service.dart](file:///Users/trungshin/product/english_for_kids/lib/core/storage/isar_service.dart)
- Add import for learning models
- Update `Isar.open()` to include: `[TopicModelSchema, LessonModelSchema, VocabularyModelSchema]`

## Verification Plan

### Automated Tests

After implementation, run:

```bash
# Generate Isar schemas
dart run build_runner build --delete-conflicting-outputs

# Static analysis
flutter analyze

# Build verification (Android debug APK)
flutter build apk --debug
```

### Manual Verification

1. Run the app on a real Android device
2. Verify the splash screen loads without Isar errors
3. (Future) Once presentation layer is added, verify topics and lessons display correctly

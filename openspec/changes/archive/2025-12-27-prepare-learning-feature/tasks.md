# Tasks: Prepare Learning Feature

## Overview

Ordered list of work items to implement the Learning Feature's Domain and Data layers.

---

## Task List

### Phase 1: Domain Layer Setup

- [x] **1.1** Create `LessonStep` enum in `lib/features/learning/domain/entities/lesson_step_type.dart`
  - Values: `story`, `flashcard`, `arGame`, `done`
  - Implement `toIdString()` → `lesson_step_story`, etc. (snake_case)
  - Implement `static fromIdString(String?)` for parsing
  - **Verify:** Dart analyzer passes ✓
- [x] **1.2** Create `VocabularyEntity` in `lib/features/learning/domain/entities/vocabulary_entity.dart`
  - Fields: `id`, `word`, `meaning`, `imagePath`, `audioPath` (optional)
  - Include `copyWith()`, `==`, `hashCode`, `toString()`
  - **Verify:** Dart analyzer passes ✓
- [x] **1.3** Create `LessonEntity` in `lib/features/learning/domain/entities/lesson_entity.dart`
  - Fields: `id`, `title`, `orderIndex`, `isLocked`, `isCompleted`, `currentStep` (LessonStep)
  - Contains `List<VocabularyEntity> vocabularies`
  - Include `copyWith()`, `==`, `hashCode`, `toString()`
  - **Verify:** Dart analyzer passes ✓
- [x] **1.4** Create `TopicEntity` in `lib/features/learning/domain/entities/topic_entity.dart`
  - Fields: `id`, `name`, `description`, `thumbnailPath`, `orderIndex`, `isLocked`, `isCompleted`
  - Contains `List<LessonEntity> lessons`
  - Include `copyWith()`, `==`, `hashCode`, `toString()`
  - **Verify:** Dart analyzer passes ✓
- [x] **1.5** Create `LearningRepositoryInterface` in `lib/features/learning/domain/repositories/learning_repository_interface.dart`
  - Methods: `getAllTopics()`, `getTopicById()`, `getLessonById()`, `updateLessonProgress()`, `seedInitialData()`, `isDatabaseSeeded()`
  - **Verify:** Dart analyzer passes ✓

---

### Phase 2: Data Layer - Models

- [x] **2.1** Create `VocabularyModel` in `lib/features/learning/data/models/vocabulary_model.dart`
  - Isar `@collection` annotation
  - Fields: `id`, `modelId` (indexed), `word`, `meaning`, `imagePath`, `audioPath`
  - `@Backlink(to: 'vocabularies')` to `LessonModel`
  - **Verify:** File created, no syntax errors ✓
- [x] **2.2** Create `LessonModel` in `lib/features/learning/data/models/lesson_model.dart`
  - Isar `@collection` annotation
  - Fields: `id`, `modelId` (indexed), `title`, `orderIndex`, `isLocked`, `isCompleted`, `currentStep` (String)
  - `IsarLinks<VocabularyModel> vocabularies`
  - `@Backlink(to: 'lessons')` to `TopicModel`
  - **Verify:** File created, no syntax errors ✓
- [x] **2.3** Create `TopicModel` in `lib/features/learning/data/models/topic_model.dart`
  - Isar `@collection` annotation
  - Fields: `id`, `modelId` (indexed), `name`, `description`, `thumbnailPath`, `orderIndex`, `isLocked`, `isCompleted`
  - `IsarLinks<LessonModel> lessons`
  - **Verify:** File created, no syntax errors ✓
- [x] **2.4** Run `build_runner` to generate Isar schemas
  - Command: `dart run build_runner build --delete-conflicting-outputs`
  - **Verify:** `.g.dart` files generated for all models ✓

---

### Phase 3: Data Layer - Mappers & DataSource

- [x] **3.1** Create mappers in `lib/features/learning/data/mappers/learning_mapper.dart`
  - `VocabularyModel.toEntity()` and `VocabularyEntity.toModel()`
  - `LessonModel.toEntity()` and `LessonEntity.toModel()`
  - `TopicModel.toEntity()` and `TopicEntity.toModel()`
  - Handle `LessonStep` enum conversion via `toIdString()`/`fromIdString()`
  - **Verify:** Dart analyzer passes ✓
- [x] **3.2** Create `LearningLocalDataSource` in `lib/features/learning/data/datasources/learning_local_datasource.dart`
  - Constructor: `LearningLocalDataSource(this._isar)`
  - Implement CRUD operations for topics, lessons, vocabulary
  - Implement `seedInitialData()` with exact "Alphabet" topic data:
    - Lesson A: Apple (Quả táo)
    - Lesson B: Bottle (Cái chai)
    - Lesson C: Cup (Cái cốc)
    - Lesson D: Desk (Cái bàn)
    - Lesson E: Egg (Quả trứng)
  - **Verify:** Dart analyzer passes ✓

---

### Phase 4: Repository & UseCases

- [x] **4.1** Create `LearningRepository` in `lib/features/learning/data/repositories/learning_repository.dart`
  - Implements `LearningRepositoryInterface`
  - Wrap all Isar operations in try-catch
  - Throw `StorageError` on failure, `NotFoundError` when entity not found
  - **Verify:** Dart analyzer passes ✓
- [x] **4.2** Create `GetTopicsUseCase` in `lib/features/learning/domain/usecases/get_topics_usecase.dart`
  - Fetches all topics with hierarchy
  - **Verify:** Dart analyzer passes ✓
- [x] **4.3** Create `GetTopicByIdUseCase` in `lib/features/learning/domain/usecases/get_topic_by_id_usecase.dart`
  - Fetches a specific topic by ID
  - **Verify:** Dart analyzer passes ✓
- [x] **4.4** Create `GetLessonByIdUseCase` in `lib/features/learning/domain/usecases/get_lesson_by_id_usecase.dart`
  - Fetches a specific lesson by ID
  - **Verify:** Dart analyzer passes ✓
- [x] **4.5** Create `UpdateLessonProgressUseCase` in `lib/features/learning/domain/usecases/update_lesson_progress_usecase.dart`
  - Input: `lessonId`, `completedStep`
  - Implements step progression logic (story -> flashcard -> arGame -> done)
  - Handles unlocking logic for next lessons
  - **Verify:** Dart analyzer passes ✓
- [x] **4.6** Create `SeedInitialDataUseCase` in `lib/features/learning/domain/usecases/seed_initial_data_usecase.dart`
  - Check if DB is empty
  - Call `seedInitialData()` if needed
  - **Verify:** Dart analyzer passes ✓

---

### Phase 5: Service Integration

- [x] **5.1** Update `IsarService.init()` in `lib/core/storage/isar_service.dart`
  - Add imports for `TopicModel`, `LessonModel`, `VocabularyModel`
  - Update `Isar.open()` schemas: `[TopicModelSchema, LessonModelSchema, VocabularyModelSchema]`
  - **Verify:** Dart analyzer passes ✓
- [x] **5.2** Run final verification
  - Command: `flutter analyze`
  - Command: `flutter build apk --debug`
  - **Verify:** No errors, APK builds successfully ✓

---

## Dependencies

- **Phase 1 (1.1-1.5)**: Foundation. Can be done in parallel.
- **Phase 2 (2.1-2.3)**: Depends on Phase 1 Entities.
- **Phase 2 (2.4)**: Depends on 2.1-2.3 completion.
- **Phase 3 (3.1)**: Depends on 2.4 (Generated schemas).
- **Phase 3 (3.2)**: Depends on 3.1 (Mappers).
- **Phase 4 (4.1)**: Depends on 3.2 (DataSource).
- **Phase 4 (4.2-4.6)**: Depends on 4.1 (RepositoryImpl).
- **Phase 5 (5.1)**: Depends on 2.4 (Generated schemas).
- **Phase 5 (5.2)**: Final integration check.

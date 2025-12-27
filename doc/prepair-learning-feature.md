# Role
You are a Senior Flutter Developer expert in Clean Architecture, GetX, and Isar Database.
You strictly follow the guidelines in `new-feature-implementation-instruction.md`.

# Context
I am building the "Learning Feature" for a Kids English Learning App.
- **Architecture:** Clean Architecture (Domain, Data, Presentation layers).
- **Core Library:** `exo_shared` (Base classes).
- **Database:** `isar_community` (Local storage).
- **DI:** GetX Bindings.
- **Service:** `IsarService` (located in `lib/core/storage/isar_service.dart`) is already implemented.

# Task
Implement the **Domain Layer** and **Data Layer** for the Learning Feature using Isar Database.
The goal is to replace hardcoded lists with a persistent local database that tracks progress.

# 1. Data Structure & Hierarchy

## A. Entities & Relationships
1.  **Topic** (e.g., "Alphabet")
    -   Fields: `id` (String), `name` (String), `description` (String), `thumbnailPath` (String), `orderIndex` (int), `isLocked` (bool), `isCompleted` (bool).
    -   Relation: Contains multiple `Lessons`.
2.  **Lesson** (e.g., "Letter A")
    -   Fields: `id` (String), `title` (String), `orderIndex` (int), `isLocked` (bool), `isCompleted` (bool).
    -   State: `currentStep` (Enum: `story`, `flashcard`, `ar_game`, `done`).
    -   Relation: Contains multiple `Vocabularies`.
3.  **Vocabulary**
    -   Fields: `id` (String), `word` (String), `meaning` (String - Vietnamese), `imagePath` (String), `audioPath` (String - optional).

## B. Enum Requirements (STRICT)
-   Create `LessonStep` enum (story, flashcard, ar_game, done).
-   **MUST** implement `toIdString()` and `static fromIdString()` pattern as defined in the "New Feature Implementation Guide".
-   Isar Models must store this enum as a `String`.

# 2. Business Logic (UseCases)

## A. Unlocking Logic (Sequential)
1.  **Topic Locking:** Topic `orderIndex: n` is locked until Topic `n-1` is completed. (Topic 0 is always unlocked).
2.  **Lesson Locking:** Lesson `n` is locked until Lesson `n-1` is completed within the same Topic.
3.  **Step Progression:**
    -   User finishes `story` -> unlocks `flashcard`.
    -   User finishes `flashcard` -> unlocks `ar_game`.
    -   User finishes `ar_game` -> set `isCompleted = true`, `currentStep = done`, and **unlocks next Lesson**.

## B. Required UseCases
1.  `GetTopicsUseCase`: Fetch all topics with their hierarchy (including nested lessons status).
2.  `UpdateLessonProgressUseCase`:
    -   Input: `lessonId`, `completedStep`.
    -   Logic: Update current step. If strictly required step flow is finished, unlock the next logical step or next lesson.
3.  `SeedInitialDataUseCase`:
    -   Check if DB is empty.
    -   If empty, insert the **Specific Data** provided below.

# 3. Implementation Requirements

## Domain Layer (`lib/features/learning/domain/`)
* **Entities:** Pure Dart classes (`TopicEntity`, `LessonEntity`, `VocabularyEntity`). **NO** Isar dependencies.
* **Repository Interface:** `LearningRepositoryInterface`.

## Data Layer (`lib/features/learning/data/`)
* **Isar Models:** Classes annotated with `@collection`.
    * Use `IsarLinks` for relationships.
    * **Fields:** Ensure IDs are indexed.
* **Mappers:** create extensions `toEntity()` and `toModel()` in `mappers/` folder.
* **DataSource:** `LearningLocalDataSource`.
    * Constructor: `LearningLocalDataSource(this._isar)`.
* **Repository Impl:** `LearningRepository` implementing the interface.
    * **Error Handling:** Must wrap Isar calls in try-catch and throw `StorageError` or `NotFoundError` (from `core/errors/app_errors.dart`).

## Service Integration
* Update `IsarService.init()` in `lib/core/storage/isar_service.dart` to include schemas: `[TopicModelSchema, LessonModelSchema, VocabularyModelSchema]`.

# 4. Seed Data Content (Use this for Seeding)
Do not use "Lorem Ipsum". Use this exact structure for the "Alphabet" Topic:

**Topic:** "Alphabet" (id: "topic_alphabet", order: 0)

**Lessons:**
1.  **Letter A** (id: "lesson_a", order: 0)
    -   Vocab: Word: "Apple", Meaning: "Quả táo", Image: `Assets.images.apple.path`
2.  **Letter B** (id: "lesson_b", order: 1)
    -   Vocab: Word: "Bottle", Meaning: "Cái chai", Image: `Assets.images.bottle.path`
3.  **Letter C** (id: "lesson_c", order: 2)
    -   Vocab: Word: "Cup", Meaning: "Cái cốc", Image: `Assets.images.cup.path`
4.  **Letter D** (id: "lesson_d", order: 3)
    -   Vocab: Word: "Desk", Meaning: "Cái bàn", Image: `Assets.images.desk.path`
5.  **Letter E** (id: "lesson_e", order: 4)
    -   Vocab: Word: "Egg", Meaning: "Quả trứng", Image: `Assets.images.egg.path`

# Output Deliverables
Provide code for:
1.  `lib/features/learning/domain/entities/lesson_step_type.dart` (Enum with strict pattern).
2.  Isar Models (`TopicModel`, `LessonModel`, `VocabularyModel`).
3.  Domain Entities (`Topic`, `Lesson`, `Vocabulary`).
4.  `LearningLocalDataSource` (Include the Seeding logic with the data above).
5.  `LearningRepository` (Impl).
6.  `UpdateLessonProgressUseCase`.
7.  Instruction on how to update `IsarService`.
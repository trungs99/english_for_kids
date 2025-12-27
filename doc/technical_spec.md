# 📱 Technical Specification: Kids English Learning App (Clean Architecture MVP)

> **Context:** This is an 8-hour hackathon project. The goal is to build a functional MVP using Flutter with **Clean Architecture**.  
> **Core Feature:** Interactive learning flow: Story → Flashcard → AR Object Hunt.  
> **Architecture:** Clean Architecture (Domain, Data, Presentation) using `exo_shared` library for standardized Base classes and UI components.

---

## ⚠️ Platform & Device Requirements

| Requirement | Specification |
|-------------|---------------|
| **Platform** | **Android ONLY** (iOS is out of scope for this MVP) |
| **Test Device** | **Real Android Device Required** |
| **Reason** | Emulators are too slow for ML Kit real-time image processing. A physical device is mandatory for testing the AR Object Hunt feature. |

---

# 🇬🇧 PART 1: ENGLISH SPECIFICATION (For AI Agent)

## 1. Project Overview

| Item | Value |
|------|-------|
| **App Name** | Kids English MVP |
| **Framework** | Flutter (Latest Stable) |
| **Architecture** | **Clean Architecture** (Domain, Data, Presentation layers) |
| **State Management** | GetX (`GetMaterialApp`, `Get.to`) |
| **Target Platform** | Android Only (Real Device Required) |
| **Camera** | **Back Camera ONLY** |

---

## 2. Architecture Overview

The app follows **Clean Architecture** with clear separation of concerns across three main layers:

```
lib/
├── core/                          # Shared core utilities
│   ├── bindings/                  # Global bindings
│   ├── constants/                 # App constants
│   ├── data/                      # Shared data layer
│   │   ├── mappers/               # Entity <-> Model mappers
│   │   └── models/                # Shared models (if any)
│   ├── domain/                    # Shared domain layer
│   │   └── entities/              # Domain entities
│   ├── routes/                    # App routing
│   ├── theme/                     # App theme/colors
│   ├── translations/              # i18n translations
│   └── widgets/                   # Shared widgets
│
├── features/                      # Feature modules
│   └── learning/                  # Main learning feature
│       ├── data/                  # DATA LAYER
│       │   ├── datasources/       # Local data sources
│       │   ├── mappers/           # Model <-> Entity mappers
│       │   ├── models/            # DTOs / Data Models
│       │   └── repositories/      # Repository Implementations
│       ├── domain/                # DOMAIN LAYER
│       │   ├── entities/          # Feature entities
│       │   ├── repositories/      # Repository interfaces
│       │   └── usecases/          # Business logic
│       └── presentation/          # PRESENTATION LAYER
│           ├── bindings/          # GetX bindings
│           ├── controllers/       # GetX controllers
│           ├── pages/             # Pages/screens
│           └── widgets/           # Feature widgets
```

### Layer Responsibilities

| Layer | Responsibility | Dependencies |
|-------|----------------|--------------|
| **Domain** | Business logic, entities, repository interfaces | None (Pure Dart) |
| **Data** | Data persistence, repository implementations, mappers | Domain layer only |
| **Presentation** | UI, controllers, user interactions | Domain + Data layers |

---

## 3. Tech Stack & Dependencies

Add these packages to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Internal Standard Library
  exo_shared:
    git:
      url: git@github.com:trungs99/exo_shared.git
      ref: v1.0.7
  
  # State Management & Navigation
  get: ^4.7.3
  
  # Feature-specific packages
  flutter_tts: ^4.2.3                   # Text-to-Speech for reading stories
  flip_card: ^0.7.0                     # For the Review/Flashcard step
  google_ml_kit_image_labeling: ^0.14.1 # For Object Detection (Offline)
  camera: ^0.11.3                       # Camera stream for ML Kit
  permission_handler: ^12.0.1           # To handle Camera permissions
  
  # Code Generation
  flutter_gen: ^5.3.1                   # Asset code generation

dev_dependencies:
  build_runner: ^2.4.6
  flutter_gen_runner: ^5.3.1
```

> **Note:** Ensure `get` version is compatible with `exo_shared`. If conflicts arise, use the version specified in `exo_shared`'s `pubspec.yaml`.

---

## 4. Android Configuration (CRITICAL)

### 4.1. SDK Versions (`android/app/build.gradle`)

```gradle
android {
    compileSdkVersion 34  // Can be 34, 35, or 36

    defaultConfig {
        minSdkVersion 28        // Android 9 (Pie) - Required for ML Kit
        targetSdkVersion 34     // Match compileSdkVersion
        
        // Required for ML Kit due to large number of methods
        multiDexEnabled true
    }
}
```

### 4.2. AndroidManifest.xml Configuration

Update `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- ========== PERMISSIONS ========== -->
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <!-- ========== HARDWARE FEATURES ========== -->
    <uses-feature android:name="android.hardware.camera" android:required="true"/>
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
    
    <!-- ========== QUERIES (Required for Android 11+) ========== -->
    <!-- This allows the app to query for TTS engine availability -->
    <queries>
        <intent>
            <action android:name="android.intent.action.TTS_SERVICE"/>
        </intent>
    </queries>

    <application
        android:label="Kids English MVP"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- ... existing activity configurations ... -->
        
    </application>
</manifest>
```

### 4.3. Setup Checklist

- [ ] Update `minSdkVersion` to 28 in `build.gradle`
- [ ] Update `targetSdkVersion` to 34 in `build.gradle`
- [ ] Add `multiDexEnabled true` in `build.gradle`
- [ ] Add `CAMERA` permission in `AndroidManifest.xml`
- [ ] Add camera hardware features in `AndroidManifest.xml`
- [ ] Add `<queries>` for TTS service in `AndroidManifest.xml`
- [ ] Test on a **Real Android Device**

---

## 5. Domain Layer Design

### 5.1. Entities

#### Lesson Entity
```dart
// lib/features/learning/domain/entities/lesson_entity.dart

/// Domain entity representing a single lesson
/// Pure Dart class without any framework dependencies
class LessonEntity {
  final String id;
  final String letter;
  final String word;
  final String vietnameseMeaning;
  final String imagePath;
  final String storySentence;
  final List<String> allowedLabels;

  const LessonEntity({
    required this.id,
    required this.letter,
    required this.word,
    required this.vietnameseMeaning,
    required this.imagePath,
    required this.storySentence,
    required this.allowedLabels,
  });

  LessonEntity copyWith({
    String? id,
    String? letter,
    String? word,
    String? vietnameseMeaning,
    String? imagePath,
    String? storySentence,
    List<String>? allowedLabels,
  }) {
    return LessonEntity(
      id: id ?? this.id,
      letter: letter ?? this.letter,
      word: word ?? this.word,
      vietnameseMeaning: vietnameseMeaning ?? this.vietnameseMeaning,
      imagePath: imagePath ?? this.imagePath,
      storySentence: storySentence ?? this.storySentence,
      allowedLabels: allowedLabels ?? this.allowedLabels,
    );
  }
}
```

#### Learning Progress Entity
```dart
// lib/features/learning/domain/entities/learning_progress_entity.dart

/// Domain entity tracking user's learning progress
class LearningProgressEntity {
  final String userId;
  final int currentLessonIndex;
  final int currentStep; // 0: Story, 1: Flashcard, 2: AR Game
  final List<String> completedLessonIds;

  const LearningProgressEntity({
    required this.userId,
    required this.currentLessonIndex,
    required this.currentStep,
    required this.completedLessonIds,
  });

  LearningProgressEntity copyWith({
    String? userId,
    int? currentLessonIndex,
    int? currentStep,
    List<String>? completedLessonIds,
  }) {
    return LearningProgressEntity(
      userId: userId ?? this.userId,
      currentLessonIndex: currentLessonIndex ?? this.currentLessonIndex,
      currentStep: currentStep ?? this.currentStep,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
    );
  }
}
```

### 5.2. Repository Interfaces

```dart
// lib/features/learning/domain/repositories/lesson_repository_interface.dart

import '../entities/lesson_entity.dart';

abstract class LessonRepositoryInterface {
  /// Get all available lessons
  Future<List<LessonEntity>> getAllLessons();
  
  /// Get a specific lesson by ID
  Future<LessonEntity?> getLessonById(String id);
  
  /// Get lesson by index (0-4 for MVP)
  Future<LessonEntity?> getLessonByIndex(int index);
}
```

```dart
// lib/features/learning/domain/repositories/progress_repository_interface.dart

import '../entities/learning_progress_entity.dart';

abstract class ProgressRepositoryInterface {
  /// Get current progress for a user
  Future<LearningProgressEntity?> getProgress(String userId);
  
  /// Save progress
  Future<void> saveProgress(LearningProgressEntity progress);
  
  /// Reset progress
  Future<void> resetProgress(String userId);
}
```

### 5.3. Use Cases

```dart
// lib/features/learning/domain/usecases/get_lesson_usecase.dart

import '../entities/lesson_entity.dart';
import '../repositories/lesson_repository_interface.dart';

class GetLessonUseCase {
  final LessonRepositoryInterface _repository;

  GetLessonUseCase(this._repository);

  Future<LessonEntity?> call(int lessonIndex) async {
    return await _repository.getLessonByIndex(lessonIndex);
  }
}
```

```dart
// lib/features/learning/domain/usecases/process_image_label_usecase.dart

import '../entities/lesson_entity.dart';

class ProcessImageLabelUseCase {
  ProcessImageLabelUseCase();

  /// Check if detected label matches the target lesson
  /// Returns true if confidence > 0.7 and label is in allowed list
  bool call({
    required LessonEntity lesson,
    required String detectedLabel,
    required double confidence,
  }) {
    if (confidence < 0.7) return false;
    
    return lesson.allowedLabels.any(
      (allowed) => allowed.toLowerCase() == detectedLabel.toLowerCase(),
    );
  }
}
```

```dart
// lib/features/learning/domain/usecases/update_progress_usecase.dart

import '../entities/learning_progress_entity.dart';
import '../repositories/progress_repository_interface.dart';

class UpdateProgressUseCase {
  final ProgressRepositoryInterface _repository;

  UpdateProgressUseCase(this._repository);

  Future<void> call({
    required String userId,
    int? nextLessonIndex,
    int? nextStep,
    String? completedLessonId,
  }) async {
    final current = await _repository.getProgress(userId);
    
    if (current == null) {
      // Create new progress
      final newProgress = LearningProgressEntity(
        userId: userId,
        currentLessonIndex: nextLessonIndex ?? 0,
        currentStep: nextStep ?? 0,
        completedLessonIds: completedLessonId != null ? [completedLessonId] : [],
      );
      await _repository.saveProgress(newProgress);
    } else {
      // Update existing progress
      final updatedCompletedIds = completedLessonId != null
          ? [...current.completedLessonIds, completedLessonId]
          : current.completedLessonIds;
      
      final updated = current.copyWith(
        currentLessonIndex: nextLessonIndex,
        currentStep: nextStep,
        completedLessonIds: updatedCompletedIds,
      );
      await _repository.saveProgress(updated);
    }
  }
}
```

---

## 6. Data Layer Strategy

### 6.1. Data Source (Local - Hardcoded for MVP)

```dart
// lib/features/learning/data/datasources/lesson_local_datasource.dart

import '../models/lesson_model.dart';

abstract class LessonLocalDataSource {
  Future<List<LessonModel>> getAllLessons();
  Future<LessonModel?> getLessonById(String id);
  Future<LessonModel?> getLessonByIndex(int index);
}

class LessonLocalDataSourceImpl implements LessonLocalDataSource {
  // Hardcoded data for MVP (no backend required)
  static final List<LessonModel> _lessons = [
    LessonModel(
      id: 'lesson_a',
      letter: 'A',
      word: 'Apple',
      vietnameseMeaning: 'Quả táo',
      imagePath: 'assets/images/apple.png',
      storySentence: 'A is for Apple. The apple is red.',
      allowedLabels: ['Apple', 'Fruit', 'Food', 'Red'],
    ),
    LessonModel(
      id: 'lesson_b',
      letter: 'B',
      word: 'Bottle',
      vietnameseMeaning: 'Cái chai',
      imagePath: 'assets/images/bottle.png',
      storySentence: 'B is for Bottle. The bottle holds water.',
      allowedLabels: ['Bottle', 'Water bottle', 'Drinkware', 'Plastic', 'Container'],
    ),
    LessonModel(
      id: 'lesson_c',
      letter: 'C',
      word: 'Cup',
      vietnameseMeaning: 'Cái cốc',
      imagePath: 'assets/images/cup.png',
      storySentence: 'C is for Cup. The cup is on the table.',
      allowedLabels: ['Cup', 'Mug', 'Coffee cup', 'Tableware', 'Drinkware'],
    ),
    LessonModel(
      id: 'lesson_d',
      letter: 'D',
      word: 'Desk',
      vietnameseMeaning: 'Cái bàn',
      imagePath: 'assets/images/desk.png',
      storySentence: 'D is for Desk. The desk is brown.',
      allowedLabels: ['Desk', 'Table', 'Furniture', 'Office', 'Wood'],
    ),
    LessonModel(
      id: 'lesson_e',
      letter: 'E',
      word: 'Egg',
      vietnameseMeaning: 'Quả trứng',
      imagePath: 'assets/images/egg.png',
      storySentence: 'E is for Egg. The egg is white.',
      allowedLabels: ['Egg', 'Food', 'Oval', 'White', 'Ingredient', 'Breakfast'],
    ),
  ];

  @override
  Future<List<LessonModel>> getAllLessons() async {
    // Simulate async operation
    await Future.delayed(Duration(milliseconds: 100));
    return _lessons;
  }

  @override
  Future<LessonModel?> getLessonById(String id) async {
    await Future.delayed(Duration(milliseconds: 50));
    try {
      return _lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<LessonModel?> getLessonByIndex(int index) async {
    await Future.delayed(Duration(milliseconds: 50));
    if (index >= 0 && index < _lessons.length) {
      return _lessons[index];
    }
    return null;
  }
}
```

### 6.2. Models (Data Transfer Objects)

```dart
// lib/features/learning/data/models/lesson_model.dart

/// Data model for Lesson (used in Data Layer)
class LessonModel {
  final String id;
  final String letter;
  final String word;
  final String vietnameseMeaning;
  final String imagePath;
  final String storySentence;
  final List<String> allowedLabels;

  LessonModel({
    required this.id,
    required this.letter,
    required this.word,
    required this.vietnameseMeaning,
    required this.imagePath,
    required this.storySentence,
    required this.allowedLabels,
  });

  // For future JSON serialization if needed
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      letter: json['letter'] as String,
      word: json['word'] as String,
      vietnameseMeaning: json['vietnameseMeaning'] as String,
      imagePath: json['imagePath'] as String,
      storySentence: json['storySentence'] as String,
      allowedLabels: List<String>.from(json['allowedLabels'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'letter': letter,
      'word': word,
      'vietnameseMeaning': vietnameseMeaning,
      'imagePath': imagePath,
      'storySentence': storySentence,
      'allowedLabels': allowedLabels,
    };
  }
}
```

### 6.3. Mappers

```dart
// lib/features/learning/data/mappers/lesson_mapper.dart

import '../../domain/entities/lesson_entity.dart';
import '../models/lesson_model.dart';

/// Extension to convert LessonModel to LessonEntity
extension LessonModelMapper on LessonModel {
  LessonEntity toEntity() {
    return LessonEntity(
      id: id,
      letter: letter,
      word: word,
      vietnameseMeaning: vietnameseMeaning,
      imagePath: imagePath,
      storySentence: storySentence,
      allowedLabels: allowedLabels,
    );
  }
}

/// Extension to convert LessonEntity to LessonModel
extension LessonEntityMapper on LessonEntity {
  LessonModel toModel() {
    return LessonModel(
      id: id,
      letter: letter,
      word: word,
      vietnameseMeaning: vietnameseMeaning,
      imagePath: imagePath,
      storySentence: storySentence,
      allowedLabels: allowedLabels,
    );
  }
}
```

### 6.4. Repository Implementations

```dart
// lib/features/learning/data/repositories/lesson_repository.dart

import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/lesson_repository_interface.dart';
import '../datasources/lesson_local_datasource.dart';
import '../mappers/lesson_mapper.dart';

class LessonRepository implements LessonRepositoryInterface {
  final LessonLocalDataSource _localDataSource;

  LessonRepository(this._localDataSource);

  @override
  Future<List<LessonEntity>> getAllLessons() async {
    final models = await _localDataSource.getAllLessons();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<LessonEntity?> getLessonById(String id) async {
    final model = await _localDataSource.getLessonById(id);
    return model?.toEntity();
  }

  @override
  Future<LessonEntity?> getLessonByIndex(int index) async {
    final model = await _localDataSource.getLessonByIndex(index);
    return model?.toEntity();
  }
}
```

```dart
// lib/features/learning/data/repositories/progress_repository.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/learning_progress_entity.dart';
import '../../domain/repositories/progress_repository_interface.dart';

class ProgressRepository implements ProgressRepositoryInterface {
  static const String _progressKey = 'learning_progress';

  @override
  Future<LearningProgressEntity?> getProgress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('${_progressKey}_$userId');
    
    if (jsonString == null) return null;
    
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return LearningProgressEntity(
      userId: json['userId'] as String,
      currentLessonIndex: json['currentLessonIndex'] as int,
      currentStep: json['currentStep'] as int,
      completedLessonIds: List<String>.from(json['completedLessonIds'] as List),
    );
  }

  @override
  Future<void> saveProgress(LearningProgressEntity progress) async {
    final prefs = await SharedPreferences.getInstance();
    final json = {
      'userId': progress.userId,
      'currentLessonIndex': progress.currentLessonIndex,
      'currentStep': progress.currentStep,
      'completedLessonIds': progress.completedLessonIds,
    };
    await prefs.setString('${_progressKey}_${progress.userId}', jsonEncode(json));
  }

  @override
  Future<void> resetProgress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_progressKey}_$userId');
  }
}
```

---

## 7. Asset & String Management (STRICT)

### 7.1. Asset Management with flutter_gen

**FORBIDDEN:** Hardcoded image path strings like `"assets/images/apple.png"`

**REQUIRED:** Usage of `flutter_gen`

#### Configuration (`pubspec.yaml`)
```yaml
flutter_gen:
  output: lib/gen/
  line_length: 80
  
  integrations:
    flutter_svg: true
```

#### Usage in Code
```dart
// ❌ WRONG
Image.asset('assets/images/apple.png')

// ✅ CORRECT
import '../../../gen/assets.gen.dart';

Assets.images.apple.image(width: 100, height: 100)
```

#### Generate Assets
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7.2. String Management with Translations

**FORBIDDEN:** Hardcoded UI text like `"Start Learning"`

**REQUIRED:** Usage of `TranslationKeys` and localization

```dart
// lib/core/translations/translation_keys.dart

class TranslationKeys {
  // Home Screen
  static const String appTitle = 'app_title';
  static const String startLearning = 'start_learning';
  
  // Story Screen
  static const String storyTitle = 'story_title';
  static const String nextButton = 'next_button';
  
  // Flashcard Screen
  static const String flashcardTitle = 'flashcard_title';
  static const String playGame = 'play_game';
  
  // AR Game Screen
  static const String arGameTitle = 'ar_game_title';
  static const String findObject = 'find_object';
  static const String skipButton = 'skip_button';
  static const String correctMessage = 'correct_message';
  
  // Common
  static const String loading = 'loading';
  static const String error = 'error';
}
```

```dart
// lib/core/translations/en.dart

import 'translation_keys.dart';

const Map<String, String> en = {
  TranslationKeys.appTitle: 'Kids English Learning',
  TranslationKeys.startLearning: 'Start Learning',
  TranslationKeys.storyTitle: 'Story Time',
  TranslationKeys.nextButton: 'Next',
  TranslationKeys.flashcardTitle: 'Review',
  TranslationKeys.playGame: 'Play Game',
  TranslationKeys.arGameTitle: 'Find the Object!',
  TranslationKeys.findObject: 'Find a @word',
  TranslationKeys.skipButton: 'Skip',
  TranslationKeys.correctMessage: 'Correct! Well done!',
  TranslationKeys.loading: 'Loading...',
  TranslationKeys.error: 'Something went wrong',
};
```

```dart
// lib/core/translations/vi.dart

import 'translation_keys.dart';

const Map<String, String> vi = {
  TranslationKeys.appTitle: 'Học Tiếng Anh Cho Trẻ',
  TranslationKeys.startLearning: 'Bắt Đầu Học',
  TranslationKeys.storyTitle: 'Giờ Kể Chuyện',
  TranslationKeys.nextButton: 'Tiếp Theo',
  TranslationKeys.flashcardTitle: 'Ôn Tập',
  TranslationKeys.playGame: 'Chơi Game',
  TranslationKeys.arGameTitle: 'Tìm Đồ Vật!',
  TranslationKeys.findObject: 'Tìm @word',
  TranslationKeys.skipButton: 'Bỏ Qua',
  TranslationKeys.correctMessage: 'Chính xác! Giỏi lắm!',
  TranslationKeys.loading: 'Đang tải...',
  TranslationKeys.error: 'Có lỗi xảy ra',
};
```

#### Usage in UI
```dart
// ❌ WRONG
Text('Start Learning')

// ✅ CORRECT
import 'package:get/get.dart';
import '../../core/translations/translation_keys.dart';

Text(TranslationKeys.startLearning.tr)

// With parameters
Text(TranslationKeys.findObject.trParams({'word': lesson.word}))
```

---

## 8. Presentation Layer Implementation

### 8.1. Controllers (Extending BaseController)

```dart
// lib/features/learning/presentation/controllers/home_controller.dart

import 'package:exo_shared/exo_shared.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  @override
  Future<void> initData() async {
    await withLoadingSafe(() async {
      // Initialize any required data
      await Future.delayed(Duration(milliseconds: 500));
    });
  }

  Future<void> startLearning() async {
    await withLoadingSafe(() async {
      // Navigate to learning screen
      await Get.toNamed('/learning');
    });
  }
}
```

```dart
// lib/features/learning/presentation/controllers/lesson_controller.dart

import 'package:exo_shared/exo_shared.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import '../../domain/usecases/update_progress_usecase.dart';

class LessonController extends BaseController {
  final GetLessonUseCase _getLessonUseCase;
  final UpdateProgressUseCase _updateProgressUseCase;
  final FlutterTts _flutterTts = FlutterTts();

  LessonController(this._getLessonUseCase, this._updateProgressUseCase);

  // Observable state
  final Rx<LessonEntity?> currentLesson = Rx<LessonEntity?>(null);
  final RxInt currentLessonIndex = 0.obs;
  final RxInt currentStep = 0.obs; // 0: Story, 1: Flashcard, 2: AR Game

  @override
  Future<void> initData() async {
    await withLoadingSafe(() async {
      await _loadLesson(0);
      await _initializeTts();
    });
  }

  Future<void> _loadLesson(int index) async {
    final lesson = await _getLessonUseCase(index);
    if (lesson != null) {
      currentLesson.value = lesson;
      currentLessonIndex.value = index;
    }
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speakSentence() async {
    await withLoadingSafe(() async {
      if (currentLesson.value != null) {
        await _flutterTts.speak(currentLesson.value!.storySentence);
      }
    });
  }

  Future<void> nextStep() async {
    await withLoadingSafe(() async {
      if (currentStep.value < 2) {
        currentStep.value++;
        update();
      }
    });
  }

  Future<void> nextLesson() async {
    await withLoadingSafe(() async {
      if (currentLessonIndex.value < 4) {
        // Mark current lesson as completed
        await _updateProgressUseCase(
          userId: 'default_user', // For MVP, use default user
          nextLessonIndex: currentLessonIndex.value + 1,
          nextStep: 0,
          completedLessonId: currentLesson.value?.id,
        );

        // Load next lesson
        await _loadLesson(currentLessonIndex.value + 1);
        currentStep.value = 0;
      } else {
        // All lessons completed
        Get.toNamed('/completion');
      }
    });
  }

  Future<void> skipLevel() async {
    await nextLesson();
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}
```

```dart
// lib/features/learning/presentation/controllers/ar_game_controller.dart

import 'package:exo_shared/exo_shared.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/usecases/process_image_label_usecase.dart';

class ARGameController extends BaseController {
  final ProcessImageLabelUseCase _processImageLabelUseCase;
  final LessonEntity lesson;

  ARGameController(this._processImageLabelUseCase, this.lesson);

  CameraController? cameraController;
  ImageLabeler? imageLabeler;
  
  final RxList<ImageLabel> detectedLabels = <ImageLabel>[].obs;
  final RxBool isProcessing = false.obs;
  final RxBool objectFound = false.obs;

  @override
  Future<void> initData() async {
    await withLoadingSafe(() async {
      await _initializeCamera();
      await _initializeMLKit();
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    // Use back camera only
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController!.initialize();
    
    // Start image stream processing
    cameraController!.startImageStream(_processCameraImage);
  }

  Future<void> _initializeMLKit() async {
    final options = ImageLabelerOptions(confidenceThreshold: 0.7);
    imageLabeler = ImageLabeler(options: options);
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (isProcessing.value || objectFound.value) return;
    
    isProcessing.value = true;

    try {
      // Convert CameraImage to InputImage for ML Kit
      final inputImage = _convertToInputImage(image);
      
      // Process with ML Kit
      final labels = await imageLabeler!.processImage(inputImage);
      detectedLabels.value = labels;

      // Check if any label matches the target
      for (final label in labels) {
        final isMatch = _processImageLabelUseCase(
          lesson: lesson,
          detectedLabel: label.label,
          confidence: label.confidence,
        );

        if (isMatch) {
          objectFound.value = true;
          await _onObjectFound();
          break;
        }
      }
    } catch (e) {
      // Error handled by safeAsync
    } finally {
      isProcessing.value = false;
      // Debounce: wait 500ms before next processing
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  InputImage _convertToInputImage(CameraImage image) {
    // Implementation for converting CameraImage to InputImage
    // This is a simplified version - actual implementation depends on platform
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final InputImageRotation imageRotation = InputImageRotation.rotation0deg;
    final InputImageFormat inputImageFormat = InputImageFormat.nv21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  }

  Future<void> _onObjectFound() async {
    // Stop camera stream
    await cameraController?.stopImageStream();
    
    // Show success dialog/animation
    Get.dialog(
      AlertDialog(
        title: Text(TranslationKeys.correctMessage.tr),
        content: Text('You found the ${lesson.word}!'),
        actions: [
          MButton.elevated(
            text: TranslationKeys.nextButton.tr,
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(result: true); // Return to lesson controller
            },
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    cameraController?.dispose();
    imageLabeler?.close();
    super.onClose();
  }
}
```

### 8.2. Bindings

```dart
// lib/features/learning/presentation/bindings/home_binding.dart

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
```

```dart
// lib/features/learning/presentation/bindings/lesson_binding.dart

import 'package:get/get.dart';
import '../../data/datasources/lesson_local_datasource.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../data/repositories/progress_repository.dart';
import '../../domain/repositories/lesson_repository_interface.dart';
import '../../domain/repositories/progress_repository_interface.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import '../../domain/usecases/update_progress_usecase.dart';
import '../controllers/lesson_controller.dart';

class LessonBinding extends Bindings {
  @override
  void dependencies() {
    // Register Data Sources
    Get.lazyPut<LessonLocalDataSource>(() => LessonLocalDataSourceImpl());

    // Register Repositories
    if (!Get.isRegistered<LessonRepositoryInterface>()) {
      Get.put<LessonRepositoryInterface>(
        LessonRepository(Get.find<LessonLocalDataSource>()),
      );
    }
    
    if (!Get.isRegistered<ProgressRepositoryInterface>()) {
      Get.put<ProgressRepositoryInterface>(ProgressRepository());
    }

    // Register Use Cases
    Get.lazyPut(() => GetLessonUseCase(Get.find<LessonRepositoryInterface>()));
    Get.lazyPut(() => UpdateProgressUseCase(Get.find<ProgressRepositoryInterface>()));

    // Register Controller
    Get.put(LessonController(
      Get.find<GetLessonUseCase>(),
      Get.find<UpdateProgressUseCase>(),
    ));
  }
}
```

### 8.3. Pages (Extending BaseView)

```dart
// lib/features/learning/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/translation_keys.dart';
import '../bindings/home_binding.dart';
import '../controllers/home_controller.dart';

class HomePage extends BaseView<HomeController> {
  const HomePage({super.key});

  static GetPageRoute getPageRoute(RouteSettings settings) {
    return GetPageRoute(
      routeName: '/',
      page: () => const HomePage(),
      binding: HomeBinding(),
      settings: settings,
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return MAppBar(
      title: Text(
        TranslationKeys.appTitle.tr,
        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
    );
  }

  @override
  bool get showLoading => true;

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Topic Banner
          Text(
            'Learn the Alphabet',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40),
          
          // Start Button
          MButton.elevated(
            text: TranslationKeys.startLearning.tr,
            isLoading: controller.isLoading,
            onPressed: controller.startLearning,
          ),
        ],
      ),
    );
  }
}
```

```dart
// lib/features/learning/presentation/pages/learning_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exo_shared/exo_shared.dart';
import '../controllers/lesson_controller.dart';
import '../widgets/story_view_widget.dart';
import '../widgets/flashcard_view_widget.dart';
import '../widgets/ar_game_view_widget.dart';

class LearningPage extends BaseView<LessonController> {
  const LearningPage({super.key});

  @override
  bool get showLoading => true;

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      final lesson = controller.currentLesson.value;
      if (lesson == null) {
        return Center(child: Text('Loading lesson...'));
      }

      // Switch between steps
      switch (controller.currentStep.value) {
        case 0:
          return StoryViewWidget(lesson: lesson);
        case 1:
          return FlashcardViewWidget(lesson: lesson);
        case 2:
          return ARGameViewWidget(lesson: lesson);
        default:
          return Container();
      }
    });
  }
}
```

### 8.4. Widgets

```dart
// lib/features/learning/presentation/widgets/story_view_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../core/translations/translation_keys.dart';
import '../../domain/entities/lesson_entity.dart';
import '../controllers/lesson_controller.dart';

class StoryViewWidget extends GetView<LessonController> {
  final LessonEntity lesson;

  const StoryViewWidget({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title
        Text(
          TranslationKeys.storyTitle.tr,
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        
        // Image (using flutter_gen)
        _buildLessonImage(),
        SizedBox(height: 20),
        
        // Story Sentence
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            lesson.storySentence,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 18),
          ),
        ),
        SizedBox(height: 40),
        
        // Speaker Button
        MButton.icon(
          icon: Icons.volume_up,
          onPressed: controller.speakSentence,
          isLoading: controller.isLoading,
        ),
        SizedBox(height: 20),
        
        // Next Button
        MButton.elevated(
          text: TranslationKeys.nextButton.tr,
          isLoading: controller.isLoading,
          onPressed: controller.nextStep,
        ),
      ],
    );
  }

  Widget _buildLessonImage() {
    // Map lesson ID to generated asset
    switch (lesson.id) {
      case 'lesson_a':
        return Assets.images.apple.image(width: 200, height: 200);
      case 'lesson_b':
        return Assets.images.bottle.image(width: 200, height: 200);
      case 'lesson_c':
        return Assets.images.cup.image(width: 200, height: 200);
      case 'lesson_d':
        return Assets.images.desk.image(width: 200, height: 200);
      case 'lesson_e':
        return Assets.images.egg.image(width: 200, height: 200);
      default:
        return Container(width: 200, height: 200, color: Colors.grey);
    }
  }
}
```

---

## 9. Implementation Plan (Updated for Clean Architecture)

### Phase 1: Setup & Foundation (1.5 hours)

1. **Android Configuration (30 min)**
   - Configure `android/app/build.gradle` (minSdk 28, targetSdk 34, multiDex)
   - Configure `AndroidManifest.xml` (permissions, features, queries)
   - Test camera permission on real device

2. **Project Structure Setup (30 min)**
   - Create folder structure: `features/learning/{domain,data,presentation}`
   - Add all dependencies to `pubspec.yaml`
   - Configure `flutter_gen` for assets
   - Add images to `assets/images/` folder

3. **Core Setup (30 min)**
   - Create `TranslationKeys` class
   - Add English and Vietnamese translations
   - Configure routes in `app_routes.dart` and `app_pages.dart`
   - Run `build_runner` for assets

### Phase 2: Domain Layer (1 hour)

1. **Entities (20 min)**
   - Create `LessonEntity`
   - Create `LearningProgressEntity`

2. **Repository Interfaces (15 min)**
   - Create `LessonRepositoryInterface`
   - Create `ProgressRepositoryInterface`

3. **Use Cases (25 min)**
   - Create `GetLessonUseCase`
   - Create `ProcessImageLabelUseCase`
   - Create `UpdateProgressUseCase`

### Phase 3: Data Layer (1 hour)

1. **Models (15 min)**
   - Create `LessonModel` with hardcoded data

2. **Data Sources (20 min)**
   - Create `LessonLocalDataSource` with 5 lessons

3. **Mappers (10 min)**
   - Create `LessonMapper` (Entity <-> Model)

4. **Repository Implementations (15 min)**
   - Implement `LessonRepository`
   - Implement `ProgressRepository` (using SharedPreferences)

### Phase 4: Presentation Layer - UI (2 hours)

1. **Controllers (40 min)**
   - Create `HomeController`
   - Create `LessonController` with TTS integration
   - Create `ARGameController` (basic structure)

2. **Bindings (15 min)**
   - Create `HomeBinding`
   - Create `LessonBinding` with dependency injection

3. **Pages & Widgets (65 min)**
   - Create `HomePage`
   - Create `LearningPage`
   - Create `StoryViewWidget`
   - Create `FlashcardViewWidget` (with flip_card)
   - Create `ARGameViewWidget` (placeholder)

### Phase 5: AR Module (2 hours)

1. **Camera Integration (45 min)**
   - Implement camera initialization (back camera only)
   - Create camera preview widget
   - Handle camera permissions

2. **ML Kit Integration (45 min)**
   - Initialize `ImageLabeler`
   - Implement image stream processing
   - Implement fuzzy matching logic

3. **Debug Features (30 min)**
   - Add debug overlay (show detected labels)
   - Add skip/cheat button
   - Test with all 5 objects

### Phase 6: Integration & Polish (1.5 hours)

1. **Flow Integration (45 min)**
   - Connect AR success to `nextLesson()`
   - Implement progress tracking
   - Add completion screen

2. **UI Polish (30 min)**
   - Add success animations
   - Improve transitions between steps
   - Add loading states

3. **Final Testing (15 min)**
   - Test complete flow on real device
   - Verify all 5 lessons work
   - Test skip button
   - Verify debug overlay

---

## 10. Business Rules: AR Fuzzy Matching

The AR object detection uses **fuzzy matching** to handle ML Kit's varied label outputs:

### Matching Configuration

```dart
// Already embedded in LessonLocalDataSource
final Map<String, List<String>> allowedLabelsMap = {
  'Apple': ['Apple', 'Fruit', 'Food', 'Red'],
  'Bottle': ['Bottle', 'Water bottle', 'Drinkware', 'Plastic', 'Container'],
  'Cup': ['Cup', 'Mug', 'Coffee cup', 'Tableware', 'Drinkware'],
  'Desk': ['Desk', 'Table', 'Furniture', 'Office', 'Wood'],
  'Egg': ['Egg', 'Food', 'Oval', 'White', 'Ingredient', 'Breakfast'],
};
```

### Matching Algorithm

```
IF (detectedLabel.confidence > 0.7 AND lesson.allowedLabels.contains(detectedLabel.text))
THEN Success
```

This logic is encapsulated in `ProcessImageLabelUseCase`.

---

## 11. Debug & Demo Features (MANDATORY)

### 11.1. Debug Overlay

Display real-time ML Kit results on camera preview:

```dart
Widget buildDebugOverlay(List<ImageLabel> labels) {
  return Positioned(
    top: 10,
    left: 10,
    child: Container(
      padding: EdgeInsets.all(8),
      color: Colors.black54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: labels.take(5).map((label) => 
          Text(
            '${label.label}: ${(label.confidence * 100).toStringAsFixed(1)}%',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ).toList(),
      ),
    ),
  );
}
```

**Purpose:** Proves to judges that AI is working in real-time.

### 11.2. Skip/Cheat Button

Force-pass a level if object detection fails:

```dart
MButton.icon(
  icon: Icons.skip_next,
  onPressed: controller.skipLevel,
  backgroundColor: Colors.orange,
)
```

**Purpose:** Ensures demo continues smoothly even with poor lighting.

---

## 12. Improvement Notes (Clean Architecture Benefits)

### 12.1. Testability

With Clean Architecture, you can now:
- Unit test Use Cases independently
- Mock repositories for controller testing
- Test business logic without UI dependencies

### 12.2. Scalability

Future enhancements are easier:
- Add remote API → Create `RemoteDataSource`, update repository
- Add more lessons → Update `LessonLocalDataSource`
- Add user authentication → Create `AuthRepository` in core

### 12.3. Maintainability

- Clear separation of concerns
- Easy to locate bugs (Domain vs Data vs UI)
- Consistent patterns across features

---

# 🇻🇳 PHẦN 2: ĐẶC TẢ KỸ THUẬT (Dành cho Team Dev)

## 1. Tổng quan Kiến trúc

| Mục | Giá trị |
|-----|---------|
| **Tên App** | Kids English MVP |
| **Kiến trúc** | **Clean Architecture** (3 tầng: Domain, Data, Presentation) |
| **Công nghệ** | Flutter + GetX + exo_shared |
| **Nền tảng** | Android Only (cần điện thoại thật) |

## 2. Cấu trúc thư mục

```
lib/
├── core/                    # Shared utilities
├── features/
│   └── learning/
│       ├── domain/          # Entities, UseCases, Repository Interfaces
│       ├── data/            # Models, DataSources, Repository Implementations
│       └── presentation/    # Controllers, Pages, Widgets
└── gen/                     # Generated code (assets, translations)
```

## 3. Luồng dữ liệu

```
UI (Presentation) 
  ↓ gọi
Controller 
  ↓ gọi
UseCase (Domain)
  ↓ gọi
Repository Interface (Domain)
  ↓ implement bởi
Repository Implementation (Data)
  ↓ gọi
DataSource (Data)
  ↓ trả về
Model (Data)
  ↓ map sang
Entity (Domain)
  ↓ trả về
Controller
  ↓ cập nhật
UI
```

## 4. Quy tắc bắt buộc

### 4.1. Quản lý Assets

❌ **KHÔNG ĐƯỢC:** `Image.asset('assets/images/apple.png')`

✅ **BẮT BUỘC:** `Assets.images.apple.image()`

### 4.2. Quản lý Text

❌ **KHÔNG ĐƯỢC:** `Text('Start Learning')`

✅ **BẮT BUỘC:** `Text(TranslationKeys.startLearning.tr)`

### 4.3. Kiến trúc

- **Domain Layer:** KHÔNG ĐƯỢC import Flutter/GetX
- **Data Layer:** CHỈ import Domain, KHÔNG import Presentation
- **Presentation Layer:** CÓ THỂ import cả Domain và Data

## 5. Kế hoạch triển khai (8 Giờ)

| Phase | Thời gian | Công việc |
|-------|-----------|-----------|
| **1. Setup** | 1.5 giờ | Android config, folder structure, dependencies |
| **2. Domain** | 1 giờ | Entities, Repository Interfaces, UseCases |
| **3. Data** | 1 giờ | Models, DataSources, Repositories, Mappers |
| **4. UI** | 2 giờ | Controllers, Pages, Widgets (Story, Flashcard) |
| **5. AR** | 2 giờ | Camera, ML Kit, Debug Overlay, Skip button |
| **6. Polish** | 0.5 giờ | Integration, animations, testing |

## 6. Checklist trước khi Demo

- [ ] App chạy trên điện thoại Android thật
- [ ] Camera sau hoạt động
- [ ] Debug Overlay hiển thị labels
- [ ] Nút Skip hoạt động
- [ ] TTS đọc được câu tiếng Anh
- [ ] Có đủ 5 đồ vật để demo
- [ ] Ánh sáng đủ tốt cho object detection
- [ ] Tất cả assets dùng `Assets.images.xxx`
- [ ] Tất cả text dùng `TranslationKeys.xxx.tr`

---

## 📋 Summary of Changes from Original Spec

### Architecture Changes
- ✅ Upgraded from simple MVVM to **Clean Architecture**
- ✅ Introduced **Domain Layer** (Entities, UseCases, Repository Interfaces)
- ✅ Introduced **Data Layer** (Models, DataSources, Mappers, Repository Implementations)
- ✅ Separated **Presentation Layer** (Controllers, Pages, Widgets)

### Data Management Changes
- ✅ Replaced "Hardcoded Data" with **LocalDataSource** pattern
- ✅ Introduced **Entities** (Domain) vs **Models** (Data)
- ✅ Added **Mappers** for Entity <-> Model conversion
- ✅ Added **Repository Pattern** with interfaces and implementations

### Asset & String Management
- ✅ **Forbidden:** Hardcoded asset paths
- ✅ **Required:** `flutter_gen` usage (`Assets.images.xxx`)
- ✅ **Forbidden:** Hardcoded UI strings
- ✅ **Required:** `TranslationKeys` and `.tr` usage

### Preserved Elements
- ✅ All AR/ML Kit logic (fuzzy matching, confidence threshold)
- ✅ All Android configuration (minSdk 28, permissions, queries)
- ✅ All UI flows (Story → Flashcard → AR Game)
- ✅ Debug Overlay and Skip Button
- ✅ TTS integration
- ✅ `exo_shared` usage (BaseView, BaseController, MButton)
- ✅ 5 lessons dataset (A-E, with Egg instead of Ear)

---

**End of Technical Specification**
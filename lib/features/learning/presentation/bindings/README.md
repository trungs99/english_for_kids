# Learning Feature Binding Usage

## Overview

The `LearningBinding` properly registers all learning feature dependencies using GetX dependency injection pattern.

## Dependencies Registered

### 1. DataSource Layer
- `LearningLocalDataSource` - Handles Isar database operations

### 2. Repository Layer
- `LearningRepositoryInterface` - Abstract interface
- `LearningRepository` - Concrete implementation

### 3. UseCases
- `GetTopicsUseCase` - Fetch all topics with hierarchy
- `GetTopicByIdUseCase` - Fetch specific topic
- `GetLessonByIdUseCase` - Fetch specific lesson
- `UpdateLessonProgressUseCase` - Update lesson progress
- `SeedInitialDataUseCase` - Seed initial data

## Usage Examples

### In a Page/Route

```dart
import 'package:get/get.dart';
import 'package:english_for_kids/features/learning/presentation/bindings/learning_binding.dart';

class MyLearningPage extends StatelessWidget {
  static GetPageRoute getPageRoute(RouteSettings settings) {
    return GetPageRoute(
      routeName: '/learning',
      page: () => const MyLearningPage(),
      binding: LearningBinding(), // Register dependencies
      settings: settings,
    );
  }
  
  // ... rest of page
}
```

### In a Controller

```dart
import 'package:get/get.dart';
import 'package:english_for_kids/features/learning/domain/usecases/get_topics_usecase.dart';

class MyController extends GetxController {
  // Dependencies are automatically injected
  final GetTopicsUseCase _getTopicsUseCase = Get.find();
  
  Future<void> loadTopics() async {
    final topics = await _getTopicsUseCase();
    // Use topics...
  }
}
```

### Manual Initialization (e.g., in main.dart or InitialBinding)

```dart
import 'package:english_for_kids/features/learning/presentation/bindings/learning_binding.dart';

void initializeLearning() {
  LearningBinding().dependencies();
}

// Then use anywhere:
final seedUseCase = Get.find<SeedInitialDataUseCase>();
await seedUseCase();
```

## Benefits

✅ **No direct Get.find calls** in repository  
✅ **Proper dependency injection** - Easy to test and maintain  
✅ **Lazy loading** - Dependencies created only when needed  
✅ **Single source of truth** - All dependencies registered in one place  
✅ **Type-safe** - Interface-based dependency registration

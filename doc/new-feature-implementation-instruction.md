---
description: Comprehensive guide for AI Agents to implement new features using Clean Architecture, exo_shared, and strict coding standards.
---

# New Feature Implementation Guide

This document provides comprehensive instructions for AI agents to implement new features in the Period Tracker app following the established **Clean Architecture** patterns, coding conventions, and best practices.

---

## 1. Architecture Overview

The app follows **Clean Architecture** with clear separation of concerns across three main layers:

```
lib/
├── core/                          # Shared core utilities
│   ├── bindings/                  # Global bindings
│   ├── constants/                 # App constants
│   ├── controllers/               # Shared controllers
│   ├── data/                      # Shared data layer
│   │   ├── mappers/               # Entity <-> Model mappers
│   │   └── models/                # Isar database models
│   ├── domain/                    # Shared domain layer
│   │   └── entities/              # Domain entities
│   ├── errors/                    # Error definitions
│   ├── routes/                    # App routing
│   ├── storage/                   # Storage services (Isar)
│   ├── theme/                     # App theme/colors
│   ├── translations/              # i18n translations
│   └── widgets/                   # Shared widgets
│
├── features/                      # Feature modules
│   └── [feature_name]/
│       ├── data/                  # DATA LAYER
│       │   ├── datasources/       # Remote (API) & Local (DB) data sources
│       │   ├── mappers/           # Model <-> Entity mappers
│       │   ├── models/            # DTOs (Data Transfer Objects) / DB Models
│       │   └── repositories/      # Repository Implementations
│       ├── domain/                # Domain layer
│       │   ├── entities/          # Feature entities
│       │   ├── repositories/      # Repository interfaces
│       │   └── usecases/          # Business logic
│       └── presentation/          # Presentation layer
│           ├── bindings/          # GetX bindings
│           ├── controllers/       # GetX controllers
│           ├── dialogs/           # Dialogs
│           ├── pages/             # Pages/screens
│           └── widgets/           # Feature widgets
```

---

## 2. Quick Start - Implementation Order

> [!TIP]
> Follow this order for consistent, error-free implementation.

```
┌─────────────────────────────────────────────────────────────────┐
│  1. DOMAIN LAYER (Business Logic)                               │
│     Entity → Repository Interface → Use Cases                   │
├─────────────────────────────────────────────────────────────────┤
│  2. DATA LAYER (Persistence)                                    │
│     Isar Model → build_runner → Mapper → Repository Impl        │
├─────────────────────────────────────────────────────────────────┤
│  3. PRESENTATION LAYER (UI)                                     │
│     Controller → Binding → Page → Widgets                       │
├─────────────────────────────────────────────────────────────────┤
│  4. CROSS-CUTTING CONCERNS                                      │
│     Translations (ALL 9 languages) → Routes → Assets            │
├─────────────────────────────────────────────────────────────────┤
│  5. VERIFICATION                                                │
│     build_runner → flutter analyze → Test → Manual Check        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Prerequisites (Check Before Starting)

Before implementing a new feature, verify:

- [ ] Identify if this feature uses an **existing entity** or requires a **new one**
- [ ] Determine if the feature requires **new assets** (images/icons)
- [ ] Check if similar patterns exist in the codebase to follow
- [ ] Verify `exo_shared` package is available in `pubspec.yaml`
- [ ] Understand the feature requirements clearly

### When to Use `core/` vs `features/`

| Location | Use When |
|----------|----------|
| `core/domain/entities/` | Entity is **shared across multiple features** (e.g., `DailyLog`, `UserProfile`) |
| `core/data/models/` | Model is **shared** or used by core services |
| `core/data/mappers/` | Mapper for shared entities |
| `features/[name]/domain/entities/` | Entity is **feature-specific** only |
| `features/[name]/data/models/` | Model is **feature-specific** only |

### File Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Entity | `[name]_entity.dart` | `daily_log_entity.dart` |
| Enum Type | `[name]_type.dart` | `symptom_type.dart` |
| Isar Model | `[name]_model.dart` | `daily_log_model.dart` |
| Mapper | `[name]_mapper.dart` | `daily_log_mapper.dart` |
| Repository Interface | `[name]_repository_interface.dart` | `log_repository_interface.dart` |
| Repository Impl | `[name]_repository.dart` | `log_repository.dart` |
| Controller | `[name]_controller.dart` | `log_controller.dart` |
| Binding | `[name]_binding.dart` | `log_binding.dart` |
| Page | `[name]_page.dart` | `log_page.dart` |
| Widget | `[name]_widget.dart` | `log_card_widget.dart` |
| Use Case | `[action]_[entity]_usecase.dart` | `save_log_usecase.dart` |

---

## 4. Layer-by-Layer Implementation

### 4.1 Domain Layer (Business Logic)

#### Entities
Pure Dart classes representing business objects. No database dependencies.

```dart
// lib/core/domain/entities/[entity_name]_entity.dart

/// Domain entity for [description]
/// Pure Dart class without database dependencies
class MyEntity {
  final String id;
  final DateTime date;
  final String userId;
  // ... other fields

  const MyEntity({
    required this.id,
    required this.date,
    required this.userId,
  });

  /// Create a copy with some fields replaced
  MyEntity copyWith({
    String? id,
    DateTime? date,
    String? userId,
  }) {
    return MyEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyEntity &&
        other.id == id &&
        other.date == date &&
        other.userId == userId;
  }

  @override
  int get hashCode => Object.hash(id, date, userId);

  @override
  String toString() => 'MyEntity(id: $id, date: $date, userId: $userId)';
}
```

#### Enum Types
Enums with translation keys and icon paths.

```dart
// lib/core/domain/entities/[type_name]_type.dart

import '../../translations/translation_keys.dart';

enum MyType {
  option1,
  option2,
  option3;

  /// Get the icon path for this type
  String get iconPath {
    final index = MyType.values.indexOf(this) + 1;
    return 'assets/images/my_type/type_$index.png';
  }

  /// Get the translation key for this type's label
  String get label {
    switch (this) {
      case MyType.option1:
        return TranslationKeys.myTypeOption1;
      case MyType.option2:
        return TranslationKeys.myTypeOption2;
      case MyType.option3:
        return TranslationKeys.myTypeOption3;
    }
  }

  /// Convert to string ID for database storage
  String toIdString() {
    final index = MyType.values.indexOf(this) + 1;
    return 'my_type_$index';
  }

  /// Create from string ID
  static MyType? fromIdString(String? id) {
    if (id == null) return null;
    final match = RegExp(r'my_type_(\d+)').firstMatch(id);
    if (match != null) {
      final index = int.tryParse(match.group(1) ?? '');
      if (index != null && index >= 1 && index <= MyType.values.length) {
        return MyType.values[index - 1];
      }
    }
    return null;
  }
}
```

#### Repository Interfaces
Abstract interfaces defining data operations.

```dart
// lib/features/[feature]/domain/repositories/[name]_repository_interface.dart

import '../../../../core/domain/entities/my_entity.dart';

abstract class MyRepositoryInterface {
  Future<MyEntity> create(MyEntity entity);
  Future<MyEntity?> getById(String id, String userId);
  Future<List<MyEntity>> getByUser(String userId);
  Future<MyEntity> update(MyEntity entity);
  Future<void> delete(String id, String userId);
}
```

#### Use Cases
Single-responsibility business logic operations.

```dart
// lib/features/[feature]/domain/usecases/[action]_[entity]_usecase.dart

import '../../../../core/domain/entities/my_entity.dart';
import '../repositories/my_repository_interface.dart';

class SaveMyEntityUseCase {
  final MyRepositoryInterface _repository;

  SaveMyEntityUseCase(this._repository);

  Future<MyEntity> call(MyEntity entity) async {
    // Check if entity exists
    final existing = await _repository.getById(entity.id, entity.userId);
    
    if (existing != null) {
      return _repository.update(entity.copyWith(id: existing.id));
    } else {
      return _repository.create(entity);
    }
  }
}
```

---

### 4.2 Data Layer (Persistence)

#### Isar Models
Database models with `@collection` annotation.

```dart
// lib/core/data/models/my_model.dart

import 'package:isar_community/isar.dart';

part 'my_model.g.dart';

@collection
class MyModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String modelId;

  @Index()
  late DateTime date;

  @Index()
  late String userId;

  // Store enums as strings
  String? myType;
  late List<String> items;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  MyModel();

  MyModel.create({
    required this.modelId,
    required this.userId,
    required this.date,
    this.myType,
    List<String>? items,
  }) {
    this.items = items ?? [];
    final now = DateTime.now();
    createdAt = now;
    updatedAt = now;
  }

  void update({
    DateTime? date,
    String? myType,
    List<String>? items,
  }) {
    if (date != null) this.date = date;
    if (myType != null) this.myType = myType;
    if (items != null) this.items = items;
    updatedAt = DateTime.now();
  }
}
```

> [!IMPORTANT]
> After creating/modifying Isar models, run:
> ```bash
> dart run build_runner build --delete-conflicting-outputs
> ```

#### Mappers
Extensions to convert between Entity and Model.

```dart
// lib/core/data/mappers/my_mapper.dart

import '../../domain/entities/my_entity.dart';
import '../../domain/entities/my_type.dart';
import '../models/my_model.dart';

/// Extension to convert MyModel to MyEntity
extension MyModelMapper on MyModel {
  MyEntity toEntity() {
    return MyEntity(
      id: modelId,
      date: date,
      userId: userId,
      myType: MyType.fromIdString(myType),
      items: items
          .map((s) => ItemType.fromIdString(s))
          .whereType<ItemType>()
          .toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Extension to convert MyEntity to MyModel
extension MyEntityMapper on MyEntity {
  MyModel toModel() {
    final model = MyModel();
    model.modelId = id;
    model.date = date;
    model.userId = userId;
    model.myType = myType?.toIdString();
    model.items = items.map((s) => s.toIdString()).toList();
    model.createdAt = createdAt;
    model.updatedAt = updatedAt;
    return model;
  }
}
```

#### Repository Implementations
Concrete implementations using Isar.

```dart
// lib/features/[feature]/data/repositories/my_repository.dart

import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import '../../../../core/data/models/my_model.dart';
import '../../../../core/data/mappers/my_mapper.dart';
import '../../../../core/domain/entities/my_entity.dart';
import '../../../../core/storage/isar_service.dart';
import '../../../../core/errors/app_errors.dart';
import '../../domain/repositories/my_repository_interface.dart';

class MyRepository implements MyRepositoryInterface {
  final Isar _isar;

  MyRepository() : _isar = Get.find<IsarService>().isar;

  @override
  Future<MyEntity> create(MyEntity entity) async {
    try {
      final model = entity.toModel();
      await _isar.writeTxn(() async {
        await _isar.myModels.put(model);
      });
      return model.toEntity();
    } catch (e) {
      throw StorageError(
        'Failed to create entity',
        code: 'CREATE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<MyEntity?> getById(String id, String userId) async {
    try {
      final model = await _isar.myModels
          .filter()
          .modelIdEqualTo(id)
          .userIdEqualTo(userId)
          .findFirst();
      return model?.toEntity();
    } catch (e) {
      throw StorageError(
        'Failed to get entity',
        code: 'GET_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<List<MyEntity>> getByUser(String userId) async {
    try {
      final models = await _isar.myModels
          .filter()
          .userIdEqualTo(userId)
          .sortByDateDesc()
          .findAll();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw StorageError(
        'Failed to get entities',
        code: 'GET_LIST_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<MyEntity> update(MyEntity entity) async {
    try {
      final existing = await _isar.myModels
          .filter()
          .modelIdEqualTo(entity.id)
          .userIdEqualTo(entity.userId)
          .findFirst();

      if (existing == null) {
        throw NotFoundError('Entity not found: ${entity.id}');
      }

      final model = entity.toModel();
      model.id = existing.id;

      await _isar.writeTxn(() async {
        await _isar.myModels.put(model);
      });
      return model.toEntity();
    } catch (e) {
      if (e is NotFoundError) rethrow;
      throw StorageError(
        'Failed to update entity',
        code: 'UPDATE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> delete(String id, String userId) async {
    try {
      final model = await _isar.myModels
          .filter()
          .modelIdEqualTo(id)
          .userIdEqualTo(userId)
          .findFirst();
      if (model == null) {
        throw NotFoundError('Entity not found: $id');
      }
      await _isar.writeTxn(() async {
        await _isar.myModels.delete(model.id);
      });
    } catch (e) {
      if (e is NotFoundError) rethrow;
      throw StorageError(
        'Failed to delete entity',
        code: 'DELETE_FAILED',
        originalError: e,
      );
    }
  }
}
```

---

### 4.3 Extending an Existing Entity

When adding new fields to an existing entity (common scenario):

> [!WARNING]
> Never remove or rename existing fields without a migration strategy.

**Steps:**
1. **Update Entity** - Add new fields with nullable types or defaults
2. **Update Isar Model** - Add new fields (nullable for migration)
3. **Update Mapper** - Handle new fields in both directions
4. **Run build_runner** - Regenerate Isar code
5. **Test** - Verify existing data loads correctly

**Example: Adding `pregnancySymptoms` to `DailyLog`**

```dart
// 1. Entity - add with empty default
class DailyLog {
  // ... existing fields
  final List<PregnancySymptomType> pregnancySymptoms;
  
  DailyLog({
    // ... existing params
    this.pregnancySymptoms = const [],  // Default for existing data
  });
}

// 2. Isar Model - add as nullable list
@collection
class DailyLogModel {
  // ... existing fields
  late List<String> pregnancySymptoms;  // Will be empty for old records
}

// 3. Mapper - handle null/empty gracefully
extension DailyLogModelMapper on DailyLogModel {
  DailyLog toEntity() {
    return DailyLog(
      // ... existing mappings
      pregnancySymptoms: pregnancySymptoms
          .map((s) => PregnancySymptomType.fromIdString(s))
          .whereType<PregnancySymptomType>()
          .toList(),
    );
  }
}
```

---

### 4.4 Presentation Layer (UI)

#### Controllers
Use `BaseController` from `exo_shared` with `withLoadingSafe`.

```dart
// lib/features/[feature]/presentation/controllers/my_controller.dart

import 'package:exo_shared/exo_shared.dart';
import 'package:get/get.dart';
import '../../data/repositories/my_repository.dart';
import '../../../../core/domain/entities/my_entity.dart';

class MyController extends BaseController {
  final MyRepository _repository = MyRepository();

  // Observable state
  final RxList<MyEntity> items = <MyEntity>[].obs;
  final Rx<MyEntity?> selectedItem = Rx<MyEntity?>(null);

  // Computed properties
  int get totalCount => items.length;

  String? _userId;

  @override
  Future<void> initData() async {
    await withLoadingSafe(() async {
      _userId = await _getUserId();
      if (_userId == null) return;

      await fetchItems();
    });
  }

  Future<void> fetchItems() async {
    if (_userId == null) return;
    final data = await _repository.getByUser(_userId!);
    items.value = data;
  }

  @override
  Future<void> refresh() async {
    await withLoadingSafe(() async {
      await fetchItems();
    });
    super.refresh();
  }

  Future<void> saveItem(MyEntity entity) async {
    await withLoadingSafe(() async {
      await _repository.create(entity);
      await fetchItems();
    });
  }

  Future<void> deleteItem(String id) async {
    if (_userId == null) return;
    await withLoadingSafe(() async {
      await _repository.delete(id, _userId!);
      await fetchItems();
    });
  }

  Future<String?> _getUserId() async {
    // Get user ID from Isar UserProfile
    try {
      final isar = Get.find<IsarService>().isar;
      final profiles = await isar.userProfiles.where().findAll();
      return profiles.isNotEmpty ? profiles.first.userId : null;
    } catch (e) {
      return null;
    }
  }
}
```

#### Bindings
Register controllers and dependencies.

```dart
// lib/features/[feature]/presentation/bindings/my_binding.dart

import 'package:get/get.dart';
import '../../data/repositories/my_repository.dart';
import '../../domain/repositories/my_repository_interface.dart';
import '../../domain/usecases/save_my_entity_usecase.dart';
import '../controllers/my_controller.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    // Register repository as singleton if not already registered
    if (!Get.isRegistered<MyRepositoryInterface>()) {
      Get.put<MyRepositoryInterface>(MyRepository());
    }
    final repository = Get.find<MyRepositoryInterface>();

    // Register usecases
    Get.lazyPut(() => SaveMyEntityUseCase(repository));

    // Register controller
    Get.put(MyController());
  }
}
```

#### Pages
Use `BaseView<T>` from `exo_shared`.

```dart
// lib/features/[feature]/presentation/pages/my_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/translation_keys.dart';
import '../bindings/my_binding.dart';
import '../controllers/my_controller.dart';

class MyPage extends BaseView<MyController> {
  const MyPage({super.key});

  /// Static method for navigation routing
  static GetPageRoute getPageRoute(RouteSettings settings) {
    return GetPageRoute(
      routeName: '/my-page',
      page: () => const MyPage(),
      binding: MyBinding(),
      settings: settings,
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return MAppBar(
      title: Text(
        TranslationKeys.myPageTitle.tr,
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
  bool get isEnablePullToRefresh => true;

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      final items = controller.items;
      
      if (items.isEmpty) {
        return Center(
          child: Text(TranslationKeys.noData.tr),
        );
      }

      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.id),
            subtitle: Text(item.date.toString()),
          );
        },
      );
    });
  }
}
```

#### Widgets
Use `GetView<T>` for widgets that need controller access.

```dart
// lib/features/[feature]/presentation/widgets/my_card_widget.dart

import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/translation_keys.dart';
import '../controllers/my_controller.dart';

class MyCardWidget extends GetView<MyController> {
  final String title;
  final String value;

  const MyCardWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return MButton.elevated(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16),
      onPressed: () => controller.onCardTapped(),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 5. Translations

### 5.1 Add Translation Keys

```dart
// lib/core/translations/translation_keys.dart

class TranslationKeys {
  // ... existing keys

  // My Feature
  static const String myFeatureTitle = 'my_feature_title';
  static const String myFeatureDescription = 'my_feature_description';
  static const String myFeatureOption1 = 'my_feature_option_1';
}
```

### 5.2 Add Translations to All Language Files

```dart
// lib/core/translations/en.dart

const Map<String, String> en = {
  // ... existing translations

  // My Feature
  TranslationKeys.myFeatureTitle: 'My Feature',
  TranslationKeys.myFeatureDescription: 'Feature description',
  TranslationKeys.myFeatureOption1: 'Option 1',
};
```

> [!IMPORTANT]
> Add translations to **ALL 9 language files**:
> - `en.dart` (English)
> - `vi.dart` (Vietnamese)
> - `es.dart` (Spanish)
> - `hi.dart` (Hindi)
> - `de.dart` (German)
> - `fr.dart` (French)
> - `ar.dart` (Arabic)
> - `id.dart` (Indonesian)
> - `pt.dart` (Portuguese)

### 5.3 Using Translations in UI

```dart
// Simple translation
Text(TranslationKeys.myFeatureTitle.tr)

// Translation with parameters
TranslationKeys.nDays.trParams({'n': count.toString()})
```

---

## 6. Routing

### 6.1 Add Route Constants

```dart
// lib/core/routes/app_routes.dart

abstract class AppRoutes {
  // ... existing routes
  
  static const String myPage = '/my-page';
}
```

### 6.2 Register Route in App Pages

```dart
// lib/core/routes/app_pages.dart

static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    // ... existing cases
    
    case AppRoutes.myPage:
      return MyPage.getPageRoute(settings);
    
    // ...
  }
}
```

---

## 7. Asset Management (flutter_gen)

**Tool**: `flutter_gen`  
**Rule**: NEVER hardcode asset strings. Always use the generated `Assets` class.

### ❌ Wrong:

```dart
Image.asset('assets/images/logo.png');
```

### ✅ Correct:

```dart
import '../../../../gen/assets.gen.dart';

// For Images
Assets.images.logo.image(width: 50, height: 50);

// For SVGs
Assets.images.icons.homeIcon.svg(color: Colors.blue);

// For Path only
String path = Assets.images.logo.path;
```

> [!NOTE]
> After adding new assets, run:
> ```bash
> flutter pub run build_runner build
> ```

---

## 8. Coding Conventions

### 8.1 Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case | `daily_log_controller.dart` |
| Classes | PascalCase | `DailyLogController` |
| Variables/Functions | camelCase | `fetchLogs()` |
| Constants | camelCase | `static const String appName` |
| Private | prefix with `_` | `_userId`, `_repository` |

### 8.2 File Organization

```
feature/
├── data/
│   ├── models/           # Isar models
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Domain entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Use cases
└── presentation/
    ├── bindings/         # GetX bindings
    ├── controllers/      # GetX controllers
    ├── dialogs/          # Dialog widgets
    ├── pages/            # Page widgets
    └── widgets/          # Reusable widgets
```

### 8.3 Import Order

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter/GetX packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exo_shared/exo_shared.dart';

// 3. Third-party packages
import 'package:google_fonts/google_fonts.dart';
import 'package:isar_community/isar.dart';

// 4. Core modules (absolute imports)
import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/translation_keys.dart';

// 5. Feature modules (relative imports within feature)
import '../controllers/my_controller.dart';
import '../widgets/my_widget.dart';
```

---

## 9. Key Patterns & Best Practices

### 9.1 State Management

```dart
// Reactive state with GetX
final RxList<MyEntity> items = <MyEntity>[].obs;
final Rx<MyEntity?> selected = Rx<MyEntity?>(null);
final RxBool isProcessing = false.obs;

// In UI, wrap with Obx
Obx(() => Text('Count: ${controller.items.length}'))
```

### 9.2 Loading States

Always use `withLoadingSafe` for async operations:

```dart
@override
Future<void> initData() async {
  await withLoadingSafe(() async {
    // Your async logic here
    await fetchData();
  });
}
```

### 9.3 Error Handling

```dart
// Use typed errors from core/errors/app_errors.dart
throw StorageError(
  'Failed to save',
  code: 'SAVE_FAILED',
  originalError: e,
);

throw NotFoundError('Entity not found: $id');
```

### 9.4 Dependency Registration

```dart
// Check before registering singletons
if (!Get.isRegistered<MyRepositoryInterface>()) {
  Get.put<MyRepositoryInterface>(MyRepository());
}

// Use lazyPut for usecases
Get.lazyPut(() => MyUseCase(Get.find()));
```

---

## 10. Decision Tree for Complex Scenarios

### Should I create a new Entity?
```
Is the data structure unique to this feature?
├── YES → Create new entity in feature/domain/entities/
└── NO → Use/extend existing entity in core/domain/entities/
```

### Should I create a new Repository?
```
Does the feature have unique data operations?
├── YES → Create new repository
└── NO → Use existing repository, potentially add methods
```

### Should I create a Use Case?
```
Is there reusable business logic beyond simple CRUD?
├── YES → Create use case
└── NO → Direct repository access is acceptable
```

### Controller vs Service?
```
Does it manage UI state?
├── YES → Controller (extends BaseController)
└── NO → Service (singleton with Get.put, no extends)
```

---

## 11. Checklist for New Features

### Domain Layer
- [ ] Create entity in `domain/entities/`
- [ ] Create enum types with `label`, `iconPath`, `toIdString()`, `fromIdString()`
- [ ] Create repository interface in `domain/repositories/`
- [ ] Create use cases in `domain/usecases/`

### Data Layer
- [ ] Create Isar model in `data/models/`
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Create mapper in `core/data/mappers/`
- [ ] Create repository implementation in `data/repositories/`

### Presentation Layer
- [ ] Create controller extending `BaseController`
- [ ] Create binding extending `Bindings`
- [ ] Create page extending `BaseView<T>`
- [ ] Create widgets using `GetView<T>` or stateless

### Translations
- [ ] Add keys to `translation_keys.dart`
- [ ] Add translations to ALL 9 language files

### Routing
- [ ] Add route to `app_routes.dart`
- [ ] Register in `app_pages.dart`

### Assets (if needed)
- [ ] Add images/icons to `assets/`
- [ ] Run `flutter pub run build_runner build` to update `assets.gen.dart`
- [ ] Use `Assets.images.xxx.image()` or `Assets.images.icons.xxx.svg()` - NEVER hardcode asset strings

### Testing
- [ ] Create unit tests for use cases in `test/features/[feature]/domain/usecases/`
- [ ] Create unit tests for repositories in `test/features/[feature]/data/repositories/`
- [ ] Use `mockito` or `mocktail` for mocking dependencies

---

## 12. Common Mistakes to Avoid

| ❌ Mistake | ✅ Correct Approach |
|------------|---------------------|
| Mix layers (Entity imports Model) | Entities should NEVER import Models |
| Forget `build_runner` after Isar changes | Always run after modifying Isar models |
| Hardcode user-facing strings | Use `TranslationKeys` for all text |
| Forget loading states | Always use `withLoadingSafe` |
| Only add English translations | Add to ALL 9 language files |
| Use raw strings for enum storage | Use `toIdString()` and `fromIdString()` |
| Create controllers without bindings | Always pair Controller + Binding |
| Hardcode asset paths | Use `Assets.images.xxx` from flutter_gen |
| Forget to register routes | Add to both `app_routes.dart` and `app_pages.dart` |

---

## 13. Data Sources (Optional - for API Integration)

When features require both remote (API) and local (cache/DB) data, split into separate data sources:

### Remote Data Source

```dart
// features/my_feature/data/datasources/product_remote_data_source.dart
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient _apiClient;
  ProductRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final response = await _apiClient.get('/products');
    return (response.data as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }
}
```

### Local Data Source

```dart
// features/my_feature/data/datasources/product_local_data_source.dart
abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> models);
  Future<List<ProductModel>> getLastProducts();
}
```

### Repository with Data Strategy

```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;

  ProductRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      // 1. Try Network
      final models = await remote.fetchProducts();
      // 2. Cache Data
      await local.cacheProducts(models);
      // 3. Return Mapped Data
      return models.map((e) => e.toEntity()).toList();
    } catch (e) {
      // 4. Fallback to Local on error
      final localModels = await local.getLastProducts();
      if (localModels.isEmpty) throw e;
      return localModels.map((e) => e.toEntity()).toList();
    }
  }
}
```

---

## 14. Testing

AI Agents must generate basic Unit Tests for the Domain and Data layers using `mockito` or `mocktail`.

### Use Case Test Example

```dart
// test/features/my_feature/domain/usecases/get_products_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;

  final tProductList = [
    ProductEntity(id: '1', name: 'Product 1', price: 10.0),
    ProductEntity(id: '2', name: 'Product 2', price: 20.0),
  ];

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  test('should get product list from repository', () async {
    // Arrange
    when(() => mockRepository.getProducts()).thenAnswer((_) async => tProductList);
    
    // Act
    final result = await useCase();
    
    // Assert
    expect(result, tProductList);
    verify(() => mockRepository.getProducts()).called(1);
  });
}
```

### Repository Test Example

```dart
// test/features/my_feature/data/repositories/product_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRemoteDataSource extends Mock implements ProductRemoteDataSource {}
class MockProductLocalDataSource extends Mock implements ProductLocalDataSource {}

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemote;
  late MockProductLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockProductRemoteDataSource();
    mockLocal = MockProductLocalDataSource();
    repository = ProductRepositoryImpl(remote: mockRemote, local: mockLocal);
  });

  group('getProducts', () {
    test('should return remote data when call is successful', () async {
      // Arrange
      final tModels = [ProductModel(id: '1', name: 'Test', price: 10.0)];
      when(() => mockRemote.fetchProducts()).thenAnswer((_) async => tModels);
      when(() => mockLocal.cacheProducts(any())).thenAnswer((_) async {});
      
      // Act
      final result = await repository.getProducts();
      
      // Assert
      expect(result.length, 1);
      verify(() => mockRemote.fetchProducts()).called(1);
      verify(() => mockLocal.cacheProducts(tModels)).called(1);
    });

    test('should return cached data when remote call fails', () async {
      // Arrange
      final tModels = [ProductModel(id: '1', name: 'Cached', price: 10.0)];
      when(() => mockRemote.fetchProducts()).thenThrow(Exception('Network error'));
      when(() => mockLocal.getLastProducts()).thenAnswer((_) async => tModels);
      
      // Act
      final result = await repository.getProducts();
      
      // Assert
      expect(result.length, 1);
      verify(() => mockLocal.getLastProducts()).called(1);
    });
  });
}
```

---

## 15. Verification Steps

After implementation, verify your work:

### Build Verification

```bash
# 1. Generate Isar code (if Isar models were modified)
dart run build_runner build --delete-conflicting-outputs

# 2. Verify no compile errors
flutter analyze

# 3. Run tests
flutter test

# 4. Build app (optional)
flutter build apk --debug
```

### Manual Verification Checklist

- [ ] Route navigation works correctly
- [ ] Data persists after app restart
- [ ] All translations display correctly (check multiple languages)
- [ ] Loading states show properly during async operations
- [ ] Error states are handled gracefully
- [ ] Pull-to-refresh works (if enabled)
- [ ] New assets display correctly

---

## 16. Debugging Tips

### Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| `_model.g.dart` not found | `build_runner` not run | Run `dart run build_runner build --delete-conflicting-outputs` |
| Translation shows key text | Key not in language file | Add to ALL 9 language files |
| Controller not found | Binding not registered | Check route has correct binding in `app_pages.dart` |
| Data not persisting | Wrong model ID | Verify `modelId` matches entity `id` |
| Widget not rebuilding | Missing `Obx` wrapper | Wrap reactive widgets with `Obx(() => ...)` |
| Assets not found | flutter_gen not run | Run `flutter pub run build_runner build` |
| Route not found | Route not registered | Add to both `app_routes.dart` and `app_pages.dart` |

### Debug Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs

# Check for analysis issues
flutter analyze

# Verbose build for debugging
flutter build apk --debug --verbose
```

---

## 17. AI Agent Implementation Protocol

> [!CAUTION]
> Follow this protocol strictly to ensure consistent, high-quality implementations.

### Before Writing Code

1. **Search for existing patterns** - Use grep/find to locate similar implementations
2. **Read existing entities/models** - If extending, understand current structure
3. **Confirm scope** - Ask user for clarification if requirements are unclear
4. **Plan the implementation order** - Follow Section 2 (Quick Start)

### While Writing Code

1. **Follow exact file structure** - Use patterns from this guide
2. **Copy patterns from similar features** - Consistency is key
3. **Add ALL translation keys** - Before testing the UI
4. **Use type-safe patterns** - `toIdString()`, `fromIdString()` for enums
5. **Never skip layers** - Domain → Data → Presentation order

### After Writing Code

1. **Run build_runner** - If any Isar models or assets were modified
2. **Run flutter analyze** - Check for issues
3. **Verify translations** - Spot-check in multiple languages
4. **Document changes** - Create walkthrough summarizing work done

### Code Quality Checklist

- [ ] No hardcoded strings (use `TranslationKeys`)
- [ ] No hardcoded asset paths (use `Assets.images.xxx`)
- [ ] All async operations wrapped in `withLoadingSafe`
- [ ] Repository interface + implementation properly paired
- [ ] Controller + Binding properly paired
- [ ] All 9 language files updated
- [ ] Route registered in both route files

# 📱 Technical Specification: Kids English Learning App (MVP)

> **Context:** This is an 8-hour hackathon project. The goal is to build a functional MVP using Flutter.  
> **Core Feature:** Interactive learning flow: Story -> Flashcard -> AR Object Hunt.  
> **Architecture:** MVVM pattern using `exo_shared` library for standardized Base classes and UI components.

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
| **Architecture** | **MVVM** (using `BaseView` & `BaseController` from `exo_shared`) |
| **State Management** | GetX (`GetMaterialApp`, `Get.to`) |
| **Target Platform** | Android Only (Real Device Required) |
| **Camera** | **Back Camera ONLY** |

---

## 2. Tech Stack & Dependencies

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
```

> **Note:** Ensure `get` version is compatible with `exo_shared`. If conflicts arise, use the version specified in `exo_shared`'s `pubspec.yaml`.

---

## 3. Android Configuration (CRITICAL)

### 3.1. SDK Versions (`android/app/build.gradle`)

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

### 3.2. AndroidManifest.xml Configuration

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

### 3.3. Setup Checklist

- [ ] Update `minSdkVersion` to 28 in `build.gradle`
- [ ] Update `targetSdkVersion` to 34 in `build.gradle`
- [ ] Add `multiDexEnabled true` in `build.gradle`
- [ ] Add `CAMERA` permission in `AndroidManifest.xml`
- [ ] Add camera hardware features in `AndroidManifest.xml`
- [ ] Add `<queries>` for TTS service in `AndroidManifest.xml`
- [ ] Test on a **Real Android Device**

---

## 4. Data Structure (Hardcoded)

**No backend required.** Use a static `List<Map>` or a Model Class.

### Data Schema:

| Field | Type | Example |
|-------|------|---------|
| `letter` | String | `"A"` |
| `word` | String | `"Apple"` |
| `vietnameseMeaning` | String | `"Quả táo"` |
| `imageAsset` | String | `assets/images/apple.png` |
| `storySentence` | String | `"A is for Apple. The apple is red."` |

### Initial Dataset (5 Levels):

| Level | Letter | Word | Vietnamese | Image | Story |
|-------|--------|------|------------|-------|-------|
| 1 | A | Apple | Quả táo | `assets/images/apple.png` | "A is for Apple." |
| 2 | B | Bottle | Cái chai | `assets/images/bottle.png` | "B is for Bottle." |
| 3 | C | Cup | Cái cốc | `assets/images/cup.png` | "C is for Cup." |
| 4 | D | Desk | Cái bàn | `assets/images/desk.png` | "D is for Desk." |
| 5 | E | **Egg** | Quả trứng | `assets/images/egg.png` | "E is for Egg." |

> **⚠️ Note:** Level E was changed from "Ear" to "Egg" because scanning an ear with the back camera is physically awkward during a demo. An egg is easier to place on a table and scan.

---

## 5. Application Flow & UI Logic

### Architecture Pattern: MVVM

All screens **MUST** follow the MVVM pattern using `exo_shared`:

| Component | Requirement | Description |
|-----------|-------------|-------------|
| **View** | Extend `BaseView<T>` | T is the corresponding Controller type |
| **Controller** | Extend `BaseController` | Manages business logic and state |
| **Loading State** | Use `isLoading` (built-in) | Automatically available in `BaseController` |
| **Error Handling** | Use `safeAsync` or `withLoadingSafe` | Prevents app crashes, auto-assigns to `errorMsg` |

### A. Home Screen

#### UI Components:
| Element | Component | Specification |
|---------|-----------|---------------|
| **Layout** | `PageView` | Horizontal scrolling for topics |
| **Primary Action** | `MButton.elevated` | "Start Learning" button |

#### Controller: `HomeController extends BaseController`
```dart
class HomeController extends BaseController {
  Future<void> startLesson() async {
    await withLoadingSafe(() async {
      // Initialize lesson data
      await Get.to(() => LearningScreen());
    });
  }
}
```

#### View: `HomeScreen extends BaseView<HomeController>`
```dart
class HomeScreen extends BaseView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Topic PageView
          MButton.elevated(
            text: "Start Learning",
            isLoading: controller.isLoading,  // Bind to controller's loading state
            onPressed: controller.startLesson,
          ),
        ],
      ),
    );
  }
}
```

### B. Learning Screen (The Main Flow)

#### Controller: `LessonController extends BaseController`

**State Management:**
- `currentLevelIndex` (0-4)
- `currentStep` (Story -> Flashcard -> Game)
- `isLoading` (inherited from `BaseController`)

**Key Methods:**
```dart
class LessonController extends BaseController {
  int currentLevelIndex = 0;
  int currentStep = 0; // 0: Story, 1: Flashcard, 2: Game
  
  Future<void> nextStep() async {
    await withLoadingSafe(() async {
      if (currentStep < 2) {
        currentStep++;
        update();
      }
    });
  }
  
  Future<void> nextLevel() async {
    await withLoadingSafe(() async {
      if (currentLevelIndex < 4) {
        currentLevelIndex++;
        currentStep = 0;
        update();
      }
    });
  }
}
```

#### Step 1: Story View (Learning)

| Aspect | Specification |
|--------|---------------|
| **UI** | Display image (large) and `storySentence` |
| **Speaker Button** | `MButton.icon` with speaker icon |
| **TTS Feature** | Use `flutter_tts` to read sentence aloud |
| **Next Button** | `MButton.elevated` with text "Next" |
| **Loading State** | Bind `MButton.isLoading` to `controller.isLoading` |

**Example:**
```dart
MButton.icon(
  icon: Icons.volume_up,
  onPressed: controller.speakSentence,
  isLoading: controller.isLoading,
)

MButton.elevated(
  text: "Next",
  onPressed: controller.nextStep,
  isLoading: controller.isLoading,
)
```

#### Step 2: Flashcard View (Review)

| Aspect | Specification |
|--------|---------------|
| **UI** | Use `FlipCard` widget |
| **Front** | Image + English Word |
| **Back** | Vietnamese Meaning |
| **Action Button** | `MButton.elevated` with text "Play Game" |

**Example:**
```dart
MButton.elevated(
  text: "Play Game",
  onPressed: controller.nextStep,
  isLoading: controller.isLoading,
)
```

#### Step 3: AR Object Hunt (Practice - CRITICAL)

| Aspect | Specification |
|--------|---------------|
| **UI** | Full-screen Camera Preview (Back Camera Only) |
| **Overlay** | Center guide box for object placement |
| **Camera** | **MUST use Back Camera** |
| **Skip Button** | `MButton.icon` with skip icon (for demo/debug) |

**Controller Logic:**
```dart
class ARGameController extends BaseController {
  Future<void> initializeCamera() async {
    await withLoadingSafe(() async {
      // Initialize camera and ML Kit
      // Use isLoading to show loading spinner
    });
  }
  
  Future<void> processImage() async {
    await safeAsync(() async {
      // Process camera stream
      // Match labels with target word
      // If errors occur, they're auto-assigned to errorMsg
    });
  }
}
```

**Logic:**
1. Initialize Camera (Back Camera) and `ImageLabeler` - **Use `isLoading` during initialization**
2. Process the camera stream
3. **Matching Logic:** Compare detected labels with target word using Fuzzy Logic (see Section 6)
4. **Debounce:** Only process labels every 500ms to avoid lag
5. **Success State:** Match found -> Show "Correct!" dialog/animation -> Call `controller.nextLevel()` -> Navigate to next letter (Story View)

---

## 6. Business Rules: AR Fuzzy Matching

Since ML Kit might return synonyms or broader categories, **do not use exact string matching**. Use the following Mapping Configuration:

```dart
// Map<TargetWord, List<AllowedLabels>>
final Map<String, List<String>> vocabConfig = {
  'Apple': ['Apple', 'Fruit', 'Food', 'Red'],
  'Bottle': ['Bottle', 'Water bottle', 'Drinkware', 'Plastic', 'Container'],
  'Cup': ['Cup', 'Mug', 'Coffee cup', 'Tableware', 'Drinkware'],
  'Desk': ['Desk', 'Table', 'Furniture', 'Office', 'Wood'],
  'Egg': ['Egg', 'Food', 'Oval', 'White', 'Ingredient', 'Breakfast'],  // Updated from Ear
};
```

### Algorithm:
```dart
IF (detectedLabel.confidence > 0.7 AND vocabConfig[targetWord].contains(detectedLabel.text)) 
THEN Success
```

---

## 7. Debug & Demo Features (CRUCIAL)

These features are **mandatory** for hackathon demos and debugging:

### 7.1. Debug Overlay

Display detected labels and confidence scores in real-time on the camera preview.

```dart
// Display in top-left corner of camera preview
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

**Purpose:** Proves to judges/audience that the AI is working in real-time.

### 7.2. Cheat/Skip Button

A button to force-pass a level if lighting conditions fail the object detection.

```dart
// Can be hidden (long-press) or visible (for demo)
Widget buildCheatButton(VoidCallback onSkip) {
  return Positioned(
    bottom: 20,
    right: 20,
    child: GestureDetector(
      onLongPress: onSkip,  // Long-press to skip (hidden)
      child: FloatingActionButton(
        onPressed: onSkip,   // Or direct tap if visible for demo
        backgroundColor: Colors.orange,
        child: Icon(Icons.skip_next),
      ),
    ),
  );
}
```

**Purpose:** Ensures the demo can continue smoothly even if object detection fails due to poor lighting or object unavailability.

---

## 8. Implementation Plan (8 Hours)

### Phase 1: Setup & Android Configuration (1 hour)
1. Create Flutter project
2. **Configure `android/app/build.gradle`:**
   - Set `minSdkVersion 28`
   - Set `targetSdkVersion 34`
   - Add `multiDexEnabled true`
3. **Configure `AndroidManifest.xml`:**
   - Add `CAMERA` permission
   - Add camera hardware features
   - Add `<queries>` for TTS service
4. Add all packages to `pubspec.yaml`
5. Copy images to `assets/` folder
6. **Test on Real Android Device** - Verify camera permission works

### Phase 2: Core UI (2 hours)
1. Code Home Screen with topic banner
2. Code Story View with TTS integration
3. Code Flashcard View with flip animation
4. No navigation logic yet - focus on UI

### Phase 3: AR Module (3 hours)
1. Create Camera widget (Back Camera only)
2. Integrate ML Kit Image Labeling
3. Implement fuzzy matching logic
4. **Add Debug Overlay** (show labels + confidence)
5. **Add Cheat/Skip Button**
6. Test object detection with all 5 items

### Phase 4: Integration (1.5 hours)
1. Connect AR module to lesson flow
2. Implement level progression (Next Level)
3. Add success animations/dialogs
4. End-of-course celebration screen

### Phase 5: Polish (0.5 hours)
1. Add sound effects (if time permits)
2. UI refinements
3. Final testing on Real Device

---

## 9. Improvement Proposals & Implementation Notes (Expert Advice)

This section contains critical technical guidance derived from analyzing the `exo_shared` library. Following these patterns will significantly improve code quality, prevent common bugs, and accelerate development.

### 9.1. Loading State Management & UX

**Problem:** Users double-tapping buttons can cause navigation bugs or duplicate async operations.

**Solution:** Bind `controller.isLoading` to `MButton.isLoading`

```dart
// ❌ BAD: Button can be pressed multiple times
MButton.elevated(
  text: "Start Lesson",
  onPressed: () async {
    await controller.startLesson();
  },
)

// ✅ GOOD: Button automatically disables and shows spinner during async operation
MButton.elevated(
  text: "Start Lesson",
  isLoading: controller.isLoading,  // Binds to BaseController's isLoading
  onPressed: controller.startLesson,
)
```

**How it works:**
- `BaseController` automatically sets `isLoading = true` when using `withLoadingSafe()`
- `MButton` displays a spinner and disables interaction when `isLoading = true`
- After the async operation completes, `isLoading` automatically resets to `false`

**Best Practice:**
- **Always** use `withLoadingSafe()` for navigation or data-loading operations
- **Always** bind `isLoading` to primary action buttons (`MButton.elevated`)
- For secondary actions (like Speaker button), binding is optional but recommended

### 9.2. View Binding with BaseView

**Problem:** Manually calling `Get.find<Controller>()` is verbose and error-prone.

**Solution:** `BaseView<T>` automatically injects the controller.

```dart
// ❌ BAD: Manual controller lookup
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();  // Verbose, can fail
    return Scaffold(
      body: MButton.elevated(
        text: "Start",
        onPressed: controller.startLesson,
      ),
    );
  }
}

// ✅ GOOD: Automatic controller injection
class HomeScreen extends BaseView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // 'controller' is already available - no need for Get.find()
    return Scaffold(
      body: MButton.elevated(
        text: "Start",
        isLoading: controller.isLoading,
        onPressed: controller.startLesson,
      ),
    );
  }
}
```

**Benefits:**
- Cleaner code
- Type-safe controller access
- Automatic dependency injection
- No risk of `Get.find()` failing

### 9.3. Theming with MThemeExtension

**Problem:** Hardcoding colors leads to inconsistent UI and difficult maintenance.

**Solution:** Configure `MThemeExtension` in `main.dart` for app-wide theming.

```dart
// main.dart
void main() {
  runApp(
    GetMaterialApp(
      title: 'Kids English MVP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        extensions: [
          MThemeExtension(
            primaryColor: Color(0xFF2196F3),      // Main brand color
            secondaryColor: Color(0xFFFF9800),    // Accent color
            successColor: Color(0xFF4CAF50),      // For success states
            errorColor: Color(0xFFF44336),        // For error states
          ),
        ],
      ),
      home: HomeScreen(),
    ),
  );
}
```

**Result:**
- All `MButton.elevated` widgets automatically use `primaryColor`
- All `MButton.outlined` widgets use `primaryColor` for borders
- Consistent color scheme across the entire app
- Easy to change brand colors in one place

**Accessing theme colors in widgets:**
```dart
final theme = Theme.of(context).extension<MThemeExtension>()!;
Container(
  color: theme.primaryColor,
  child: Text('Themed content'),
)
```

### 9.4. Error Handling Best Practices

**Problem:** Excessive `try-catch` blocks make code hard to read and maintain.

**Solution:** Use `safeAsync` in `BaseController` for automatic error handling.

```dart
// ❌ BAD: Manual error handling everywhere
class LessonController extends BaseController {
  Future<void> loadLesson() async {
    try {
      isLoading = true;
      update();
      
      final data = await lessonRepository.fetchLesson();
      // Process data...
      
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      errorMsg = e.toString();
      update();
      // Show error dialog...
    }
  }
}

// ✅ GOOD: Automatic error handling with safeAsync
class LessonController extends BaseController {
  Future<void> loadLesson() async {
    await safeAsync(() async {
      final data = await lessonRepository.fetchLesson();
      // Process data...
      // Errors are automatically caught and assigned to errorMsg
    });
  }
}
```

**What `safeAsync` does:**
- Automatically catches all exceptions
- Assigns error messages to `errorMsg` variable
- Logs errors for debugging
- Prevents app crashes from unhandled exceptions

**Displaying errors in UI:**
```dart
class LessonScreen extends BaseView<LessonController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Show error message if present
          if (controller.errorMsg.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.red.shade100,
              child: Text(
                controller.errorMsg,
                style: TextStyle(color: Colors.red),
              ),
            ),
          // Rest of UI...
        ],
      ),
    );
  }
}
```

### 9.5. MButton Component Usage Patterns

**Component Selection Guide:**

| Use Case | Component | Example |
|----------|-----------|---------|
| Primary action (CTA) | `MButton.elevated` | "Start Learning", "Next", "Play Game" |
| Secondary action | `MButton.outlined` | "Cancel", "Back" |
| Icon-only action | `MButton.icon` | Speaker button, Skip button |
| Text-only action | `MButton.text` | "Learn more", "Skip intro" |

**MButton.elevated (Primary Actions):**
```dart
MButton.elevated(
  text: "Start Learning",
  isLoading: controller.isLoading,
  onPressed: controller.startLesson,
  // Optional customization:
  // backgroundColor: Colors.green,
  // textColor: Colors.white,
)
```

**MButton.icon (Functional Buttons):**
```dart
MButton.icon(
  icon: Icons.volume_up,
  onPressed: controller.speakSentence,
  isLoading: controller.isLoading,
  // Optional:
  // backgroundColor: Colors.blue.shade100,
  // iconColor: Colors.blue,
)
```

**MButton with Loading State:**
```dart
// The button automatically shows a spinner when isLoading = true
MButton.elevated(
  text: "Processing...",
  isLoading: controller.isLoading,  // Shows CircularProgressIndicator
  onPressed: controller.processData,
)
```

### 9.6. Implementation Checklist for exo_shared Integration

Before starting development, ensure:

- [ ] All Controllers extend `BaseController`
- [ ] All Views extend `BaseView<T>` where T is the controller type
- [ ] All async operations use `withLoadingSafe()` or `safeAsync()`
- [ ] All primary action buttons use `MButton.elevated` with `isLoading` binding
- [ ] All icon buttons use `MButton.icon`
- [ ] `MThemeExtension` is configured in `main.dart`
- [ ] Error messages are displayed using `controller.errorMsg`
- [ ] No manual `Get.find<Controller>()` calls in Views (use `controller` directly)

### 9.7. Common Pitfalls to Avoid

| ❌ Don't Do This | ✅ Do This Instead |
|------------------|-------------------|
| `class MyController extends GetxController` | `class MyController extends BaseController` |
| `Get.find<MyController>()` in Views | Use `controller` from `BaseView<T>` |
| Manual `isLoading` state management | Use `withLoadingSafe()` |
| Nested `try-catch` blocks | Use `safeAsync()` |
| Standard Flutter buttons | Use `MButton` components |
| Hardcoded colors | Use `MThemeExtension` |
| `onPressed: () async { await method(); }` | `onPressed: method` with `isLoading` binding |

---

# 🇻🇳 PHẦN 2: ĐẶC TẢ KỸ THUẬT (Dành cho Team Dev)

## ⚠️ Yêu cầu Nền tảng & Thiết bị

| Yêu cầu | Chi tiết |
|---------|----------|
| **Nền tảng** | **Chỉ Android** (iOS không nằm trong phạm vi MVP này) |
| **Thiết bị test** | **Bắt buộc dùng Điện thoại Android thật** |
| **Lý do** | Emulator quá chậm cho xử lý ML Kit real-time. Thiết bị vật lý là bắt buộc để test tính năng AR. |
| **Camera** | **Chỉ dùng Camera Sau** |

---

## 1. Tổng quan dự án

| Mục | Giá trị |
|-----|---------|
| **Tên App** | Kids English MVP |
| **Mục tiêu** | Demo ứng dụng học tiếng Anh trong 8 giờ |
| **Kiến trúc** | **MVVM** (dùng `BaseView` & `BaseController` từ `exo_shared`) |
| **Công nghệ** | Flutter + GetX |
| **Nền tảng** | Android Only (cần điện thoại thật) |

---

## 2. Thư viện sử dụng (Packages)

| Package | Mô tả |
|---------|-------|
| `exo_shared` | Thư viện nội bộ cung cấp Base classes (BaseView, BaseController) và UI Components (MButton) |
| `get` | Quản lý trạng thái và điều hướng màn hình |
| `flutter_tts` | Chuyển văn bản thành giọng nói (Text-to-Speech) |
| `flip_card` | Tạo hiệu ứng lật thẻ flashcard |
| `google_ml_kit_image_labeling` | AI nhận diện đồ vật offline |
| `camera` | Truy cập camera thiết bị |
| `permission_handler` | Xử lý quyền Camera |

---

## 3. Cấu hình Android (QUAN TRỌNG)

### 3.1. Cập nhật `android/app/build.gradle`

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 28        // Android 9 trở lên
        targetSdkVersion 34
        multiDexEnabled true    // Bắt buộc cho ML Kit
    }
}
```

### 3.2. Cập nhật `AndroidManifest.xml`

```xml
<!-- Quyền Camera -->
<uses-permission android:name="android.permission.CAMERA"/>

<!-- Yêu cầu phần cứng Camera -->
<uses-feature android:name="android.hardware.camera" android:required="true"/>
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>

<!-- Query TTS (bắt buộc cho Android 11+) -->
<queries>
    <intent>
        <action android:name="android.intent.action.TTS_SERVICE"/>
    </intent>
</queries>
```

---

## 4. Dữ liệu (Hardcoded)

**Không cần Server.** Dữ liệu được code cứng trong App.

### Danh sách bài học (5 Levels):

| Level | Chữ | Từ | Nghĩa | Ảnh |
|-------|-----|-----|-------|-----|
| 1 | A | Apple | Quả táo | `apple.png` |
| 2 | B | Bottle | Cái chai | `bottle.png` |
| 3 | C | Cup | Cái cốc | `cup.png` |
| 4 | D | Desk | Cái bàn | `desk.png` |
| 5 | E | **Egg** | Quả trứng | `egg.png` |

> **Lưu ý:** Level E đổi từ "Ear" sang "Egg" vì soi camera sau vào tai rất khó khăn khi demo. Trứng dễ đặt lên bàn và quét hơn.

---

## 5. Luồng màn hình (User Flow)

### Kiến trúc MVVM (Bắt buộc)

Tất cả màn hình **PHẢI** tuân theo pattern MVVM sử dụng `exo_shared`:

| Thành phần | Yêu cầu | Mô tả |
|------------|---------|-------|
| **View** | Kế thừa `BaseView<T>` | T là kiểu Controller tương ứng |
| **Controller** | Kế thừa `BaseController` | Quản lý logic và state |
| **Loading State** | Dùng `isLoading` (có sẵn) | Tự động có trong `BaseController` |
| **Xử lý lỗi** | Dùng `safeAsync` hoặc `withLoadingSafe` | Tránh crash, tự động gán vào `errorMsg` |

### Màn hình chính (Home)
- Hiển thị Banner chủ đề (Ví dụ: "Làm quen bảng chữ cái")
- Nút "Bắt đầu học" (dùng `MButton.elevated`) -> Chuyển vào bài đầu tiên (Letter A)
- **Quan trọng:** Bind `isLoading` của Controller vào `MButton` để tránh double-tap

### Luồng bài học (Lesson Flow)

Dùng `LessonController extends BaseController` để quản lý việc chuyển đổi giữa 3 bước:

#### Bước 1: Truyện (Story)
- Hiển thị ảnh và câu tiếng Anh
- Bấm nút Loa (`MButton.icon`) -> App đọc câu tiếng Anh (dùng TTS)
- Bấm "Tiếp tục" (`MButton.elevated`) -> Chuyển sang Bước 2
- **Lưu ý:** Bind `controller.isLoading` vào tất cả các nút

#### Bước 2: Ôn tập (Flashcard)
- Hiển thị thẻ từ vựng
- Chạm vào thẻ -> Thẻ lật lại để hiện nghĩa tiếng Việt
- Bấm "Chơi game" (`MButton.elevated`) -> Chuyển sang Bước 3

#### Bước 3: Thực hành AR (Săn đồ vật) - **QUAN TRỌNG**
- Mở Camera toàn màn hình (**Camera Sau**)
- Yêu cầu bé tìm đồ vật tương ứng (Ví dụ: "Find an Apple")
- **Debug Overlay:** Hiển thị labels + confidence ở góc trên trái
- **Nút Skip:** (`MButton.icon`) Cho phép bỏ qua nếu ánh sáng kém
- **Khởi tạo Camera:** Dùng `withLoadingSafe()` để quản lý `isLoading`

**Cơ chế nhận diện:**
1. Camera quét liên tục (500ms/lần)
2. So sánh kết quả với từ khóa (Fuzzy Matching)
3. Nếu đúng -> Hiện thông báo chúc mừng -> Chuyển sang bài tiếp theo

---

## 6. Quy tắc nghiệp vụ: AR Logic

Do AI của Google đôi khi trả về kết quả không chính xác 100%, ta cần dùng cơ chế **"Khớp linh hoạt" (Fuzzy Matching)**:

| Từ mục tiêu | Labels được chấp nhận |
|-------------|----------------------|
| Apple | 'Apple', 'Fruit', 'Food', 'Red' |
| Bottle | 'Bottle', 'Water bottle', 'Drinkware', 'Plastic', 'Container' |
| Cup | 'Cup', 'Mug', 'Coffee cup', 'Tableware', 'Drinkware' |
| Desk | 'Desk', 'Table', 'Furniture', 'Office', 'Wood' |
| **Egg** | 'Egg', 'Food', 'Oval', 'White', 'Ingredient', 'Breakfast' |

---

## 7. Tính năng Debug/Demo (BẮT BUỘC)

### 7.1. Debug Overlay
- Hiển thị labels và confidence score real-time
- Vị trí: góc trên bên trái màn hình camera
- Mục đích: Chứng minh AI đang hoạt động cho giám khảo

### 7.2. Nút Skip/Cheat
- Cho phép bỏ qua level nếu ánh sáng kém
- Có thể ẩn (long-press) hoặc hiện (cho demo)
- Mục đích: Đảm bảo demo chạy mượt mà

---

## 8. Kế hoạch triển khai (8 Giờ)

| Phase | Thời gian | Công việc |
|-------|-----------|-----------|
| **1. Setup Android** | 1 giờ | Cấu hình `build.gradle`, `AndroidManifest.xml`, thêm packages, test quyền camera trên điện thoại thật |
| **2. Core UI** | 2 giờ | Code màn hình Home, Story, Flashcard |
| **3. AR Module** | 3 giờ | Camera (sau only), ML Kit, Debug Overlay, Nút Skip |
| **4. Integration** | 1.5 giờ | Ghép AR vào luồng bài học, chuyển level |
| **5. Polish** | 0.5 giờ | Hiệu ứng, chỉnh UI, test final |

---

## 📋 Checklist trước khi Demo

- [ ] App chạy trên điện thoại Android thật (không phải emulator)
- [ ] Camera sau hoạt động
- [ ] Debug Overlay hiển thị labels
- [ ] Nút Skip hoạt động
- [ ] TTS đọc được câu tiếng Anh
- [ ] Có đủ 5 đồ vật để demo (Apple, Bottle, Cup, Desk/Table, Egg)
- [ ] Ánh sáng đủ tốt cho object detection
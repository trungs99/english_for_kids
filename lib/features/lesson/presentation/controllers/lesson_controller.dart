import 'package:english_for_kids/app/routes/m_routes.dart';
import 'package:english_for_kids/core/constants/lesson_data.dart';
import 'package:english_for_kids/core/models/lesson_model.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class LessonController extends BaseController {
  final FlutterTts flutterTts = FlutterTts();
  
  int currentLevelIndex = 0;
  int currentStep = 0; // 0: Story, 1: Flashcard, 2: AR Game
  final Rx<LessonModel?> currentLesson = Rx<LessonModel?>(null);
  
  @override
  Future<void> initData() async {
    // Get level index from route arguments first (synchronous)
    final args = Get.arguments;
    if (args is int) {
      currentLevelIndex = args;
    } else {
      // Try to get from route parameters
      final routeParams = Get.parameters;
      if (routeParams.containsKey('levelIndex')) {
        currentLevelIndex = int.tryParse(routeParams['levelIndex'] ?? '0') ?? 0;
      }
    }
    
    // Load lesson data immediately (synchronous)
    currentLesson.value = getLessonByIndex(currentLevelIndex);
    if (currentLesson.value == null) {
      currentLesson.value = getLessonByIndex(0); // Fallback to first lesson
      currentLevelIndex = 0;
    }
    
    // Initialize TTS asynchronously without blocking UI
    await safeAsync(() async {
      await _initializeTTS();
    });
  }
  
  Future<void> _initializeTTS() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5); // Slower rate for kids
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }
  
  Future<void> speakSentence() async {
    if (currentLesson.value == null) return;
    
    await safeAsync(() async {
      await flutterTts.speak(currentLesson.value!.word.storySentence);
    });
  }
  
  Future<void> speakWord() async {
    if (currentLesson.value == null) return;
    
    await safeAsync(() async {
      await flutterTts.speak(currentLesson.value!.word.word);
    });
  }
  
  Future<void> nextStep() async {
    if (currentStep == 0) {
      // Story -> Flashcard
      currentStep = 1;
      await Get.toNamed('${MRoutes.flashcard}/$currentLevelIndex', arguments: currentLevelIndex);
    } else if (currentStep == 1) {
      // Flashcard -> Camera
      currentStep = 2;
      await Get.toNamed('${MRoutes.camera}/$currentLevelIndex', arguments: currentLesson.value);
    }
    update();
  }
  
  Future<void> nextLevel() async {
    if (currentLevelIndex < 4) {
      currentLevelIndex++;
      currentStep = 0;
      currentLesson.value = getLessonByIndex(currentLevelIndex);
      // Navigate to next lesson's story page
      await Get.offNamed('${MRoutes.lesson}/$currentLevelIndex', arguments: currentLevelIndex);
    } else {
      // All lessons completed - go back to home
      Get.offAllNamed(MRoutes.home);
    }
    update();
  }
  
  void goToStory() {
    currentStep = 0;
    update();
  }
  
  void goToFlashcard() {
    currentStep = 1;
    update();
  }
  
  void goToCamera() {
    currentStep = 2;
    update();
  }
  
  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}


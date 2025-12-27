import 'package:exo_shared/exo_shared.dart';

import 'package:english_for_kids/core/routes/app_routes.dart';
import 'package:english_for_kids/features/learning/domain/entities/vocabulary_entity.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class HomeController extends BaseController {
  @override
  Future<void> initData() async {
    // No data initialization needed for home
  }

  void navigateToLearning() {
    // Will be implemented in learning feature
  }

  void navigateToARGameTest() {
    if (!kDebugMode) return;

    final mockVocab = const VocabularyEntity(
      id: 'test_cup',
      word: 'Cup',
      meaning: 'Cái cốc',
      imagePath: 'assets/images/learning/lession_1/img_cup.png',
      allowedLabels: ['Cup', 'Mug', 'Coffee cup'],
    );

    Get.toNamed(
      AppRoutes.arGame,
      arguments: {'vocabulary': mockVocab, 'lessonId': 'lesson_c'},
    );
  }

  void navigateToSpeechGameTest() {
    if (!kDebugMode) return;

    final mockVocab = const VocabularyEntity(
      id: 'test_apple',
      word: 'Apple',
      meaning: 'Quả táo',
      imagePath: 'assets/images/learning/lession_1/img_apple.png',
      allowedLabels: ['Apple', 'Fruit'],
    );

    Get.toNamed(
      AppRoutes.speechGame,
      arguments: {'vocabulary': mockVocab, 'lessonId': 'lesson_a'},
    );
  }
}

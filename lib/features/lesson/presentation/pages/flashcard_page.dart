import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:english_for_kids/features/lesson/presentation/controllers/lesson_controller.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/flashcard_widget.dart';

class FlashcardPage extends BaseView<LessonController> {
  const FlashcardPage({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return MAppBar(
      title: Text(
        'Ôn tập',
        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  @override
  bool get showLoading => false; // Don't show loading overlay, handle manually

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      final lesson = controller.currentLesson.value;

      if (lesson == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        color: AppColors.background,
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Instruction
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Chạm vào thẻ để xem nghĩa',
                style: GoogleFonts.inter(fontSize: 18, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // Flashcard
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FlashcardWidget(word: lesson.word, onSpeak: controller.speakWord),
                ),
              ),
            ),

            // Play game button
            Padding(
              padding: const EdgeInsets.all(16),
              child: MButton.elevated(
                child: const Text('Chơi game'),
                onPressed: controller.nextStep,
                isLoading: controller.isLoading.value,
              ),
            ),
          ],
        ),
      );
    });
  }
}

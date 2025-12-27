import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:english_for_kids/features/lesson/presentation/bindings/lesson_binding.dart';
import 'package:english_for_kids/features/lesson/presentation/controllers/lesson_controller.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryPage extends BaseView<LessonController> {
  const StoryPage({super.key});

  static GetPageRoute getPageRoute(RouteSettings settings) {
    return GetPageRoute(
      routeName: '/lesson/:levelIndex',
      page: () => const StoryPage(),
      binding: LessonBinding(),
      settings: settings,
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return MAppBar(
      title: Text(
        'Câu chuyện',
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
            // Image section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'Ảnh: ${lesson.word.word}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Story sentence section
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lesson.word.storySentence,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Speaker button
                    IconButton(
                      onPressed: controller.isLoading.value ? null : controller.speakSentence,
                      icon: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.volume_up),
                      color: AppColors.primary,
                      iconSize: 32,
                    ),
                  ],
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.all(16),
              child: MButton.elevated(
                child: const Text('Tiếp tục'),
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

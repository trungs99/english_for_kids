import 'package:english_for_kids/core/models/lesson_model.dart';
import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:english_for_kids/features/home/bindings/home_binding.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';

class HomePage extends BaseView<HomeController> {
  const HomePage({super.key});

  static Route<dynamic> getPageRoute(RouteSettings settings) => GetPageRoute(
    page: () => const HomePage(),
    settings: settings,
    routeName: '/home',
    binding: HomeBinding(),
  );

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return MAppBar(
      title: Text(
        'Làm quen bảng chữ cái',
        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  bool get showLoading => true;

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      final lessons = controller.lessons;

      if (lessons.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        color: AppColors.background,
        child: Column(
          children: [
            // Banner section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Chào mừng đến với',
                    style: GoogleFonts.inter(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kids English Learning',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Lessons grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    final isUnlocked = !lesson.isLocked || index == 0;

                    return _LessonCard(
                      lesson: lesson,
                      isUnlocked: isUnlocked,
                      onTap: isUnlocked ? () => controller.startLesson(index) : null,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const _LessonCard({required this.lesson, required this.isUnlocked, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Stack(
          children: [
            // Lock overlay
            if (!isUnlocked)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.locked.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: Icon(Icons.lock, size: 48, color: AppColors.disabled)),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Letter
                  Text(
                    lesson.letter,
                    style: GoogleFonts.inter(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? AppColors.primary : AppColors.disabled,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Word
                  Text(
                    lesson.word.word,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isUnlocked ? AppColors.textPrimary : AppColors.disabled,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Image placeholder
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        'Ảnh:\n${lesson.word.word}',
                        style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

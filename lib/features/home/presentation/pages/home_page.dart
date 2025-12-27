import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:english_for_kids/core/translations/translation_keys.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../widgets/hero_header_widget.dart';
import '../widgets/lesson_card_widget.dart';
import '../widgets/page_indicator_widget.dart';

class HomePage extends BaseView<HomeController> {
  const HomePage({super.key});

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      if (controller.topics.isEmpty) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/img_bg_home.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      final completedCount = controller.topics
          .where((t) => t.isCompleted)
          .length;

      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img_bg_home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Hero Header with greeting and stats
              HeroHeaderWidget(
                title: TranslationKeys.appName.tr,
                completedLessons: completedCount,
                totalLessons: controller.topics.length,
                currentStreak: 0,
              ),

              // PageView for lesson cards
              Expanded(
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: controller.pageController,
                  itemCount: controller.topics.length,
                  itemBuilder: (context, index) {
                    final topic = controller.topics[index];
                    return LessonCardWidget(
                      topic: topic,
                      index: index,
                      onTap: () {
                        if (!topic.isLocked) {
                          controller.navigateToLearning();
                        }
                      },
                    );
                  },
                ),
              ),

              // Page Indicators
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: PageIndicatorWidget(
                    itemCount: controller.topics.length,
                    currentIndex: controller.currentPageIndex.value,
                  ),
                ),
              ),

              // Start Learning Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                child: Obx(() {
                  final currentTopic =
                      controller.topics[controller.currentPageIndex.value];
                  final isLocked = currentTopic.isLocked;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isLocked
                          ? []
                          : [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                    ),
                    child: SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: !isLocked
                            ? () {
                                controller.navigateToLearning();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLocked
                              ? AppColors.greyLight
                              : AppColors.primary,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: AppColors.greyLight,
                          disabledForegroundColor: AppColors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: isLocked ? 0 : 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isLocked
                                  ? Icons.lock_rounded
                                  : Icons.play_arrow_rounded,
                              color: isLocked
                                  ? AppColors.grey
                                  : AppColors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isLocked
                                  ? TranslationKeys.completePreviousLesson.tr
                                  : TranslationKeys.startLearning.tr,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: isLocked
                                        ? AppColors.grey
                                        : AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}

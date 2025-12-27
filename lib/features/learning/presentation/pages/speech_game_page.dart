import 'package:english_for_kids/core/translations/translation_keys.dart';
import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../controllers/speech_game_controller.dart';
import '../bindings/speech_game_binding.dart';

/// Speech Game page - Pronounce vocabulary words aloud
class SpeechGamePage extends BaseView<SpeechGameController> {
  const SpeechGamePage({super.key});

  static GetPage getPageRoute({required String name}) {
    return GetPage(
      name: name,
      page: () => const SpeechGamePage(),
      binding: SpeechGameBinding(),
    );
  }

  @override
  Widget? backgroundImage(BuildContext context) {
    return Assets.images.bgSpeechGame.image(
      height: context.height,
      width: context.width,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      // Skip-only mode (error fallback)
      if (controller.skipOnlyMode.value) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryLight.withValues(alpha: 0.1),
                AppColors.secondaryLight.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic_off_outlined,
                      size: 64,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    TranslationKeys.errorMicrophoneNotAvailable.tr,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    TranslationKeys.skipStepMessage.tr,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: controller.skipGame,
                    icon: const Icon(Icons.skip_next),
                    label: Text(TranslationKeys.skipButton.tr),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Main speech game UI
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryLight.withValues(alpha: 0.1),
              AppColors.secondaryLight.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            // Target vocabulary display (top)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        TranslationKeys.sayTheWord.tr,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          controller.targetVocabulary.word,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Listening indicator
                      if (controller.isListening.value) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mic,
                            size: 64,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          TranslationKeys.listening.tr,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (controller.recognizedText.value.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            controller.recognizedText.value,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ] else ...[
                        MButton.icon(
                          onPressed: controller.startListening,
                          child: Assets.icons.icMicrophone.image(
                            width: 150,
                            height: 150,
                          ),
                        ),
                        Text(
                          TranslationKeys.speechTryAgain.tr,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

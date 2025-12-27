import 'package:english_for_kids/core/translations/translation_keys.dart';
import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ar_game_controller.dart';
import '../bindings/ar_game_binding.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/target_display_widget.dart';
import '../widgets/scanner_overlay_widget.dart';

/// AR Game page - Find real-world objects matching vocabulary
class ARGamePage extends BaseView<ARGameController> {
  const ARGamePage({super.key});

  static GetPage getPageRoute({required String name}) {
    return GetPage(
      name: name,
      page: () => const ARGamePage(),
      binding: ARGameBinding(),
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
                      Icons.camera_alt_outlined,
                      size: 64,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Camera not available',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You can skip this step and continue learning',
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

      // Loading state
      if (!controller.cameraReady.value) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(height: 24),
                Text(
                  TranslationKeys.loading.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        );
      }

      // AR Game UI
      return Stack(
        children: [
          // Camera preview (full screen)
          const Positioned.fill(child: CameraPreviewWidget()),

          // Scanner overlay (centered viewfinder)
          const Positioned.fill(child: ScannerOverlayWidget()),

          // Target display card (top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TargetDisplayWidget(vocabulary: controller.targetVocabulary),
          ),

          // Skip button (bottom center, glassmorphism style)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.skipGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  
                  child: Text(TranslationKeys.skipButton.tr),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/ar_game_binding.dart';
import '../controllers/ar_game_controller.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/debug_overlay_widget.dart';
import '../widgets/success_celebration_widget.dart';

/// AR Game page - Camera object detection game
class ARGamePage extends BaseView<ARGameController> {
  const ARGamePage({super.key});

  /// Static method for navigation routing
  static GetPageRoute getPageRoute(RouteSettings settings) {
    return GetPageRoute(
      routeName: '/ar-game',
      page: () => const ARGamePage(),
      binding: ARGameBinding(),
      settings: settings,
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Find the Object'),
      centerTitle: true,
      backgroundColor: Colors.black,
    );
  }

  @override
  bool get showLoading => true;

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      // Show success celebration if match found
      if (controller.isMatchFound.value && controller.targetWord != null) {
        return Stack(
          children: [
            // Camera preview in background
            _buildCameraView(),
            // Success overlay
            SuccessCelebrationWidget(
              word: controller.targetWord!,
              onDismiss: controller.handleSuccess,
            ),
          ],
        );
      }

      return _buildCameraView();
    });
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        // Camera preview (full screen)
        CameraPreviewWidget(controller: controller.cameraController),

        // Center guide box
        _buildGuideBox(),

        // Debug overlay (top-left)
        Obx(() => DebugOverlayWidget(labels: controller.detectedLabels.toList())),

        // Instruction text (top-center)
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(
                () => Text(
                  controller.targetWord != null
                      ? 'Find: ${controller.targetWord!}'
                      : 'Find the object',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Skip button (bottom-right)
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: controller.isLoading.value ? null : controller.skipLevel,
            backgroundColor: Colors.orange.withValues(alpha: 0.8),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.skip_next, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideBox() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.yellow, width: 4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow.withValues(alpha: 0.5), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

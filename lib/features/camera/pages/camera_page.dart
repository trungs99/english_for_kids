import 'package:camera/camera.dart' as camera_package;
import 'package:english_for_kids/core/theme/app_colors.dart';
import 'package:english_for_kids/features/camera/bindings/camera_binding.dart';
import 'package:english_for_kids/features/camera/controllers/camera_controller.dart';
import 'package:english_for_kids/features/camera/widgets/debug_overlay_widget.dart';
import 'package:english_for_kids/features/camera/widgets/guide_box_widget.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraPage extends BaseView<CameraController> {
  const CameraPage({super.key});

  static GetPageRoute getPageRoute(RouteSettings settings) {
    return GetPageRoute(
      routeName: '/camera/:levelIndex',
      page: () => const CameraPage(),
      binding: CameraBinding(),
      settings: settings,
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return MAppBar(
      title: Text(
        'Tìm đồ vật',
        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  @override
  bool get showLoading => true;

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      // Check camera initialization (reactive)
      if (!controller.isCameraReady.value ||
          controller.cameraController == null ||
          !controller.cameraController!.value.isInitialized) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Get lesson (reactive)
      final lesson = controller.currentLesson.value;
      if (lesson == null) {
        return const Center(
          child: Text('No lesson data'),
        );
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview (reactive to camera ready state)
          camera_package.CameraPreview(controller.cameraController!),
          
          // Debug overlay (reactive to detectedLabels)
          Obx(() => DebugOverlayWidget(
            labels: controller.detectedLabels.toList(),
          )),
          
          // Guide box (static)
          GuideBoxWidget(
            word: lesson.word.vietnameseMeaning,
          ),
          
          // Skip button (reactive to isLoading)
          Positioned(
            bottom: 20,
            right: 20,
            child: Obx(() => FloatingActionButton(
              onPressed: controller.isLoading.value ? null : controller.skipLevel,
              backgroundColor: AppColors.secondary,
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.skip_next, color: Colors.white),
            )),
          ),
          
          // Success overlay (reactive to isDetected)
          Obx(() {
            if (!controller.isDetected.value) {
              return const SizedBox.shrink();
            }
            
            return Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tuyệt vời!',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bạn đã tìm thấy ${lesson.word.word}!',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}


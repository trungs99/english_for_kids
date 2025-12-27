import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ar_game_controller.dart';

/// Widget to display camera preview
class CameraPreviewWidget extends GetView<ARGameController> {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if camera is initialized
    if (controller.cameraController == null ||
        !controller.cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Get screen size and camera aspect ratio
    final size = MediaQuery.of(context).size;
    final cameraRatio = controller.cameraController!.value.aspectRatio;

    // Display camera preview with proper scaling
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRect(
        child: SizedBox(
          width: size.width,
          height: size.width / cameraRatio,
          child: CameraPreview(controller.cameraController!),
        ),
      ),
    );
  }
}

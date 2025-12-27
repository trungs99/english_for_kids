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

    // Display camera preview
    return CameraPreview(controller.cameraController!);
  }
}

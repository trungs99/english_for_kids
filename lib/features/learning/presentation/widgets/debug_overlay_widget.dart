import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ar_game_controller.dart';

/// Debug overlay widget to show detected labels
/// Tap to toggle visibility
class DebugOverlayWidget extends GetView<ARGameController> {
  const DebugOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Don't show if disabled
      if (!controller.showDebugOverlay.value) {
        // Show small tap area to re-enable
        return GestureDetector(
          onTap: controller.toggleDebugOverlay,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.visibility_off,
              color: Colors.white,
              size: 20,
            ),
          ),
        );
      }

      // Show debug info
      return GestureDetector(
        onTap: controller.toggleDebugOverlay,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bug_report, color: Colors.yellow, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Debug (tap to hide)',
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (controller.detectedLabels.isEmpty)
                const Text(
                  'Scanning...',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              else
                ...controller.detectedLabels.take(5).map((label) {
                  final percentage = (label.confidence * 100).toStringAsFixed(
                    0,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${label.label}: $percentage%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

/// Debug overlay widget showing detected labels and confidence scores
class DebugOverlayWidget extends StatelessWidget {
  final List<ImageLabel> labels;

  const DebugOverlayWidget({
    super.key,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha:0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'AI Detection:',
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (labels.isEmpty)
              const Text(
                'No labels detected',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              )
            else
              ...labels.take(5).map((label) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${label.label}: ${(label.confidence * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}


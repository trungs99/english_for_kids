import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/ar_game_controller.dart';

/// Scanner overlay widget with animated scanning line
/// Provides visual feedback for AR object detection
class ScannerOverlayWidget extends GetView<ARGameController> {
  const ScannerOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isFound = controller.objectFound.value;
      final isProcessing = controller.isProcessing.value;

      return _AnimatedScannerOverlay(
        isFound: isFound,
        isProcessing: isProcessing,
      );
    });
  }
}

/// Stateful widget to handle animation
class _AnimatedScannerOverlay extends StatefulWidget {
  final bool isFound;
  final bool isProcessing;

  const _AnimatedScannerOverlay({
    required this.isFound,
    required this.isProcessing,
  });

  @override
  State<_AnimatedScannerOverlay> createState() => _AnimatedScannerOverlayState();
}

class _AnimatedScannerOverlayState extends State<_AnimatedScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: ScannerOverlayPainter(
            isFound: widget.isFound,
            isProcessing: widget.isProcessing,
            animationValue: widget.isProcessing && !widget.isFound
                ? _animation.value
                : null,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

/// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  final bool isFound;
  final bool isProcessing;
  final double? animationValue;

  ScannerOverlayPainter({
    required this.isFound,
    required this.isProcessing,
    this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Calculate scanner frame dimensions (80% of screen width, centered)
    final frameWidth = size.width * 0.8;
    final frameHeight = frameWidth * 0.75; // 4:3 aspect ratio
    final frameLeft = (size.width - frameWidth) / 2;
    final frameTop = (size.height - frameHeight) / 2;
    final frameRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(frameLeft, frameTop, frameWidth, frameHeight),
      const Radius.circular(20),
    );

    // Determine colors based on state
    final cornerColor = isFound ? AppColors.success : Colors.white;
    final borderColor = isFound
        ? AppColors.success.withValues(alpha: 0.5)
        : Colors.white.withValues(alpha: 0.3);

    // Draw semi-transparent overlay outside the frame
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      overlayPaint,
    );
    canvas.drawRRect(frameRect, Paint()..color = Colors.transparent);

    // Draw frame border
    paint.color = borderColor;
    canvas.drawRRect(frameRect, paint);

    // Draw corner indicators
    final cornerLength = 30.0;
    final cornerWidth = 4.0;
    final cornerPaint = Paint()
      ..color = cornerColor
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    canvas.drawLine(
      Offset(frameLeft, frameTop + cornerLength),
      Offset(frameLeft, frameTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft, frameTop),
      Offset(frameLeft + cornerLength, frameTop),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(frameLeft + frameWidth - cornerLength, frameTop),
      Offset(frameLeft + frameWidth, frameTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft + frameWidth, frameTop),
      Offset(frameLeft + frameWidth, frameTop + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(frameLeft, frameTop + frameHeight - cornerLength),
      Offset(frameLeft, frameTop + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft, frameTop + frameHeight),
      Offset(frameLeft + cornerLength, frameTop + frameHeight),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(frameLeft + frameWidth - cornerLength, frameTop + frameHeight),
      Offset(frameLeft + frameWidth, frameTop + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameLeft + frameWidth, frameTop + frameHeight - cornerLength),
      Offset(frameLeft + frameWidth, frameTop + frameHeight),
      cornerPaint,
    );

    // Draw scanning line animation (only when processing)
    if (isProcessing && !isFound && animationValue != null) {
      final scanY = frameTop + (frameHeight * animationValue!);
      final scanPaint = Paint()
        ..color = AppColors.primary.withValues(alpha: 0.6)
        ..strokeWidth = 2.0;

      // Draw scanning line
      canvas.drawLine(
        Offset(frameLeft + 10, scanY),
        Offset(frameLeft + frameWidth - 10, scanY),
        scanPaint,
      );

      // Draw gradient effect for scanning line
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.0),
            AppColors.primary.withValues(alpha: 0.8),
            AppColors.primary.withValues(alpha: 0.0),
          ],
        ).createShader(
          Rect.fromLTWH(
            frameLeft,
            scanY - 20,
            frameWidth,
            40,
          ),
        )
        ..strokeWidth = 3.0;
      canvas.drawLine(
        Offset(frameLeft + 10, scanY),
        Offset(frameLeft + frameWidth - 10, scanY),
        gradientPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) {
    return oldDelegate.isFound != isFound ||
        oldDelegate.isProcessing != isProcessing ||
        oldDelegate.animationValue != animationValue;
  }
}


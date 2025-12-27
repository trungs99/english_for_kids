import 'dart:async';

import 'package:camera/camera.dart';
import 'package:english_for_kids/core/constants/vocab_config.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

import '../../../../core/utils/permission_service.dart';
import '../../../lesson/presentation/controllers/lesson_controller.dart';

/// Controller for AR Camera Game feature
class ARGameController extends BaseController {
  // Camera
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  // ML Kit
  ImageLabeler? _imageLabeler;

  // Current target word
  String? targetWord;

  // Detection state
  final RxBool isDetecting = false.obs;
  final RxList<ImageLabel> detectedLabels = <ImageLabel>[].obs;
  final RxBool isMatchFound = false.obs;

  // Debounce timer
  Timer? _debounceTimer;
  DateTime? _lastProcessTime;

  @override
  Future<void> initData() async {
    await withLoadingSafe(() async {
      await initializeCamera();
      await initializeMLKit();
      // Get target word from lesson controller or arguments
      final args = Get.arguments;
      if (args != null && args['word'] != null) {
        targetWord = args['word'] as String;
      }
    });
  }

  /// Initialize camera (back camera only)
  Future<void> initializeCamera() async {
    await withLoadingSafe(() async {
      // Check permission
      final hasPermission = await PermissionService.isCameraPermissionGranted();
      if (!hasPermission) {
        final granted = await PermissionService.requestCameraPermission();
        if (!granted) {
          throw Exception('Camera permission denied');
        }
      }

      // Get available cameras
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      // Use back camera (first camera is usually back)
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // Initialize camera controller
      _cameraController = CameraController(backCamera, ResolutionPreset.high);

      await _cameraController!.initialize();

      // Start image stream processing
      _cameraController!.startImageStream(_processCameraImage);
    });
  }

  /// Initialize ML Kit Image Labeler
  Future<void> initializeMLKit() async {
    await withLoadingSafe(() async {
      final options = ImageLabelerOptions(confidenceThreshold: 0.5);
      _imageLabeler = ImageLabeler(options: options);
    });
  }

  /// Process camera image stream
  void _processCameraImage(CameraImage image) {
    // Debounce: only process every 500ms
    final now = DateTime.now();
    if (_lastProcessTime != null) {
      final diff = now.difference(_lastProcessTime!);
      if (diff.inMilliseconds < 500) {
        return;
      }
    }
    _lastProcessTime = now;

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _processImage(image);
    });
  }

  /// Process image with ML Kit
  Future<void> _processImage(CameraImage image) async {
    if (_imageLabeler == null || isDetecting.value) return;

    await safeAsync(() async {
      isDetecting.value = true;

      // Convert CameraImage to InputImage
      final inputImage = _inputImageFromCameraImage(image);

      // Process with ML Kit
      final labels = await _imageLabeler!.processImage(inputImage);

      detectedLabels.value = labels;

      // Check for match
      if (targetWord != null) {
        final match = _checkMatch(labels);
        if (match) {
          isMatchFound.value = true;
          _debounceTimer?.cancel();
        }
      }

      isDetecting.value = false;
    });
  }

  /// Convert CameraImage to InputImage for ML Kit
  InputImage _inputImageFromCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final imageRotation = InputImageRotation.rotation0deg;
    final format = InputImageFormat.nv21;

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: imageRotation,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  /// Check if detected labels match target word (fuzzy matching)
  bool _checkMatch(List<ImageLabel> labels) {
    if (targetWord == null) return false;

    final allowedLabels = vocabConfig[targetWord!];
    if (allowedLabels == null) return false;

    for (final label in labels) {
      // Check confidence threshold (0.7 = 70%)
      if (label.confidence > 0.7) {
        // Check if label text matches any allowed label (case-insensitive)
        final labelText = label.label.toLowerCase();
        for (final allowed in allowedLabels) {
          if (labelText.contains(allowed.toLowerCase()) ||
              allowed.toLowerCase().contains(labelText)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  /// Skip current level (for demo/debug)
  Future<void> skipLevel() async {
    await withLoadingSafe(() async {
      // Navigate back or to next level
      Get.back();
    });
  }

  /// Handle success - proceed to next level
  Future<void> handleSuccess() async {
    await withLoadingSafe(() async {
      // Wait a bit for celebration animation
      await Future.delayed(const Duration(seconds: 2));
      // Navigate back to home or next level
      Get.back();
      // If there's a lesson controller, move to next level
      if (Get.isRegistered<LessonController>()) {
        final lessonController = Get.find<LessonController>();
        // Check if there's a next level (0-4, so max is 4)
        if (lessonController.currentLevelIndex < 4) {
          await lessonController.nextLevel();
        } else {
          // All levels completed - go back to home
          Get.offAllNamed('/home');
        }
      }
    });
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _imageLabeler?.close();
    super.onClose();
  }
}

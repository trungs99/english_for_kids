import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:english_for_kids/core/translations/translation_keys.dart';
import '../../domain/entities/vocabulary_entity.dart';
import '../../domain/usecases/process_image_label_usecase.dart';
import '../../domain/usecases/update_lesson_progress_usecase.dart';

/// Controller for AR Game page
/// Manages camera, ML Kit image labeling, and game state
class ARGameController extends BaseController {
  final ProcessImageLabelUseCase _processImageLabelUseCase;
  final UpdateLessonProgressUseCase _updateLessonProgressUseCase;

  ARGameController({
    required ProcessImageLabelUseCase processImageLabelUseCase,
    required UpdateLessonProgressUseCase updateLessonProgressUseCase,
  }) : _processImageLabelUseCase = processImageLabelUseCase,
       _updateLessonProgressUseCase = updateLessonProgressUseCase;

  // Camera
  CameraController? cameraController;
  CameraDescription? _cameraDescription;
  ImageLabeler? imageLabeler;

  // Orientation map for Android rotation compensation
  final Map<DeviceOrientation, int> _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  // Game state
  final RxList<ImageLabel> detectedLabels = <ImageLabel>[].obs;
  final RxBool isProcessing = false.obs;
  final RxBool objectFound = false.obs;
  final RxBool showDebugOverlay = true.obs;
  final RxBool skipOnlyMode = false.obs; // Error fallback mode
  final RxBool cameraReady = false.obs;

  // Target vocabulary (from arguments)
  late final VocabularyEntity targetVocabulary;
  late final String lessonId;

  // Frame throttling
  DateTime? _lastProcessedTime;
  static const _processingInterval = Duration(milliseconds: 500);

  @override
  Future<void> initData() async {
    // No async data to load initially, but we need to implement this
  }

  @override
  void onInit() {
    super.onInit();

    // Get arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      _showError('Missing arguments');
      Get.back();
      return;
    }

    targetVocabulary = args['vocabulary'] as VocabularyEntity;
    lessonId = args['lessonId'] as String;

    _initializeARGame();
  }

  /// Initialize camera and ML Kit
  Future<void> _initializeARGame() async {
    try {
      // Request camera permission
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        skipOnlyMode.value = true;
        return;
      }

      // Initialize camera
      await _initializeCamera();

      // Initialize ML Kit
      await _initializeMLKit();

      cameraReady.value = true;

      // Start processing image stream
      _startImageStream();
    } catch (e) {
      _showError('${TranslationKeys.cameraInitError.tr}: $e');
      skipOnlyMode.value = true;
    }
  }

  /// Request camera permission
  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      _showError(TranslationKeys.errorCameraPermission.tr);
      return false;
    }
    return true;
  }

  /// Initialize camera (back camera only)
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraDescription = backCamera;

      cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await cameraController!.initialize();
    } catch (e) {
      throw Exception('Camera initialization failed: $e');
    }
  }

  /// Initialize ML Kit ImageLabeler
  Future<void> _initializeMLKit() async {
    try {
      final options = ImageLabelerOptions(
        confidenceThreshold:
            0.5, // Lower threshold, we filter at 0.7 in use case
      );
      imageLabeler = ImageLabeler(options: options);
    } catch (e) {
      throw Exception('ML Kit initialization failed: $e');
    }
  }

  /// Start camera image stream for processing
  void _startImageStream() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    cameraController!.startImageStream((CameraImage image) {
      _processCameraImage(image);
    });
  }

  /// Process camera image with throttling
  Future<void> _processCameraImage(CameraImage image) async {
    // Skip if already processing
    if (isProcessing.value) return;

    // Skip if object already found
    if (objectFound.value) return;

    // Throttle processing to 500ms
    final now = DateTime.now();
    if (_lastProcessedTime != null &&
        now.difference(_lastProcessedTime!) < _processingInterval) {
      return;
    }

    _lastProcessedTime = now;
    isProcessing.value = true;

    try {
      // Convert CameraImage to InputImage
      final inputImage = _convertToInputImage(image);
      if (inputImage == null) {
        isProcessing.value = false;
        return;
      }

      // Process image with ML Kit
      final labels = await imageLabeler!.processImage(inputImage);

      // Update detected labels for debug overlay
      detectedLabels.value = labels.take(5).toList();

      // Check for matches
      for (final label in labels) {
        final isMatch = _processImageLabelUseCase(
          vocabulary: targetVocabulary,
          detectedLabel: label.label,
          confidence: label.confidence,
        );

        if (isMatch) {
          _onObjectFound();
          break;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Image processing error: $e');
      }
    } finally {
      isProcessing.value = false;
    }
  }

  /// Convert CameraImage to InputImage for ML Kit
  InputImage? _convertToInputImage(CameraImage image) {
    if (cameraController == null || _cameraDescription == null) return null;

    // Get image rotation
    // It is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // In both platforms `rotation` and `camera.lensDirection` can be used to
    // compensate `x` and `y` coordinates on a canvas
    final sensorOrientation = _cameraDescription!.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;

      if (_cameraDescription!.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    // Get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    // Validate format depending on platform
    // Only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    // Since format is constrained to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // Compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  /// Handle successful object detection
  void _onObjectFound() async {
    objectFound.value = true;

    // Stop camera stream (pause the pipeline)
    await cameraController?.stopImageStream();
    await cameraController?.pausePreview();

    // Show success alert using AlertUtil from exo_shared
    Get.dialog(AlertDialog(
      title: Text(TranslationKeys.correctMessage.trParams({'word': targetVocabulary.word})),
      actions: [
        TextButton(onPressed: () {
          Get.back();
          Get.back();
        }, child: Text(TranslationKeys.nextLesson.tr)),
      ],
    ));

    // Update lesson progress
    // try {
    //   await _updateLessonProgressUseCase(
    //     lessonId: lessonId,
    //     completedStep: LessonStep.arGame,
    //   );
    // } catch (e) {
    //   _showError('Failed to update progress: $e');
    // }

    // Return to learning flow
    // Get.back();
  }

  /// Skip the game (for debugging or errors)
  void skipGame() async {
    // Update lesson progress (mark as completed even though skipped)
    // try {
    //   await _updateLessonProgressUseCase(
    //     lessonId: lessonId,
    //     completedStep: LessonStep.arGame,
    //   );
    // } catch (e) {
    //   _showError('Failed to update progress: $e');
    // }

    Get.back();
  }

  /// Toggle debug overlay visibility
  void toggleDebugOverlay() {
    showDebugOverlay.value = !showDebugOverlay.value;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    // Cleanup resources
    cameraController?.dispose();
    imageLabeler?.close();
    super.onClose();
  }
}

import 'dart:async';
import 'package:camera/camera.dart' as camera_package;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:english_for_kids/app/routes/m_routes.dart';
import 'package:english_for_kids/core/constants/vocab_config.dart';
import 'package:english_for_kids/core/models/lesson_model.dart';
import 'package:english_for_kids/features/lesson/presentation/controllers/lesson_controller.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraController extends BaseController {
  camera_package.CameraController? cameraController;
  ImageLabeler? imageLabeler;
  FlutterTts flutterTts = FlutterTts();
  
  final Rx<LessonModel?> currentLesson = Rx<LessonModel?>(null);
  final RxBool isCameraReady = false.obs;
  String targetWord = '';
  List<String> allowedLabels = [];
  final RxBool isDetected = false.obs;
  final RxList<ImageLabel> detectedLabels = <ImageLabel>[].obs;
  
  Timer? _detectionTimer;
  DateTime? _lastProcessTime;
  
  @override
  Future<void> initData() async {
    await withLoadingSafe(() async {
      // Get lesson from arguments
      final args = Get.arguments;
      if (args is LessonModel) {
        currentLesson.value = args;
      } else if (args is int) {
        // Get lesson by index
        if (Get.isRegistered<LessonController>()) {
          currentLesson.value = Get.find<LessonController>().currentLesson.value;
        }
      }
      
      if (currentLesson.value == null) {
        // Use safeAsync to set error
        await safeAsync(() async {
          throw Exception('No lesson data available');
        });
        return;
      }
      
      targetWord = currentLesson.value!.word.word;
      allowedLabels = vocabConfig[targetWord] ?? [targetWord];
      
      // Initialize TTS
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.5);
      
      // Request camera permission
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        await safeAsync(() async {
          throw Exception('Camera permission denied');
        });
        return;
      }
      
      // Initialize camera and ML Kit
      await _initializeCamera();
      await _initializeMLKit();
      
      // Start detection
      _startDetection();
    });
  }
  
  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }
  
  Future<void> _initializeCamera() async {
    final cameras = await camera_package.availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No cameras available');
    }
    
    // Use back camera (last camera in the list is usually back camera)
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == camera_package.CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    
    cameraController = camera_package.CameraController(
      backCamera,
      camera_package.ResolutionPreset.medium,
    );
    
    await cameraController!.initialize();
    isCameraReady.value = true;
    update();
  }
  
  Future<void> _initializeMLKit() async {
    final options = ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);
  }
  
  void _startDetection() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    
    cameraController!.startImageStream((camera_package.CameraImage image) {
      if (isDetected.value) return;
      
      // Debounce: only process every 500ms
      if (_lastProcessTime != null) {
        final now = DateTime.now();
        if (now.difference(_lastProcessTime!).inMilliseconds < 500) {
          return;
        }
      }
      _lastProcessTime = DateTime.now();
      
      _processFrame(image);
    });
  }
  
  Future<void> _processFrame(camera_package.CameraImage image) async {
    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;
      
      final labels = await imageLabeler!.processImage(inputImage);
      
      detectedLabels.value = labels;
      
      // Check for match
      for (final label in labels) {
        if (checkLabelMatch(targetWord, label.label, label.confidence)) {
          await onMatchFound();
          break;
        }
      }
    } catch (e) {
      // Silently handle errors during detection
    }
  }
  
  InputImage? _inputImageFromCameraImage(camera_package.CameraImage image) {
    try {
      // Convert CameraImage to InputImage
      final WriteBuffer allBytes = WriteBuffer();
      for (final camera_package.Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();
      
      final imageRotation = InputImageRotation.rotation0deg;
      
      final inputImageData = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: imageRotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      );
      
      return InputImage.fromBytes(
        bytes: bytes,
        metadata: inputImageData,
      );
    } catch (e) {
      return null;
    }
  }
  
  Future<void> onMatchFound() async {
    if (isDetected.value) return;
    
    isDetected.value = true;
    _detectionTimer?.cancel();
    
    // Speak success message
    await flutterTts.speak('Excellent! This is a $targetWord');
    
    // Show success dialog
    Get.dialog(
      AlertDialog(
        title: const Text('Tuyệt vời!'),
        content: Text('Bạn đã tìm thấy $targetWord!'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _goToNextLevel();
            },
            child: const Text('Tiếp tục'),
          ),
        ],
      ),
    );
    
    update();
  }
  
  Future<void> _goToNextLevel() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (Get.isRegistered<LessonController>()) {
      final lessonController = Get.find<LessonController>();
      await lessonController.nextLevel();
    } else {
      // Fallback: navigate to home
      Get.offAllNamed(MRoutes.home);
    }
  }
  
  Future<void> skipLevel() async {
    await withLoadingSafe(() async {
      await _goToNextLevel();
    });
  }
  
  @override
  void onClose() {
    _detectionTimer?.cancel();
    isCameraReady.value = false;
    cameraController?.stopImageStream();
    cameraController?.dispose();
    imageLabeler?.close();
    flutterTts.stop();
    super.onClose();
  }
}


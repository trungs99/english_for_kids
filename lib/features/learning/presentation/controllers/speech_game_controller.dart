import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:english_for_kids/core/translations/translation_keys.dart';
import '../../domain/entities/vocabulary_entity.dart';
import '../../domain/usecases/process_speech_usecase.dart';

/// Controller for Speech Game page
/// Manages speech recognition and game state
class SpeechGameController extends BaseController {
  final ProcessSpeechUseCase _processSpeechUseCase;

  SpeechGameController({
    required ProcessSpeechUseCase processSpeechUseCase,
  }) : _processSpeechUseCase = processSpeechUseCase;

  // Speech recognition
  final stt.SpeechToText _speech = stt.SpeechToText();
  final RxBool isListening = false.obs;
  final RxBool speechAvailable = false.obs;
  final RxBool skipOnlyMode = false.obs;
  final RxBool speechSuccess = false.obs;
  final RxString recognizedText = ''.obs;

  // Target vocabulary (from arguments)
  late final VocabularyEntity targetVocabulary;
  late final String lessonId;

  @override
  Future<void> initData() async {
    // No async data to load initially
  }

  @override
  void onInit() {
    super.onInit();

    // Get arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      _showError(TranslationKeys.errorMissingArgs.tr);
      Get.back();
      return;
    }

    targetVocabulary = args['vocabulary'] as VocabularyEntity;
    lessonId = args['lessonId'] as String;

    _initializeSpeechRecognition();
  }

  /// Initialize speech recognition with English locale
  Future<void> _initializeSpeechRecognition() async {
    try {
      // Request microphone permission
      final hasPermission = await _requestMicrophonePermission();
      if (!hasPermission) {
        skipOnlyMode.value = true;
        return;
      }

      // Check if speech recognition is available
      final available = await _speech.initialize(
        onError: (error) {
          if (kDebugMode) {
            print('Speech recognition error: $error');
          }
          _showError(TranslationKeys.errorMicrophoneNotAvailable.tr);
          skipOnlyMode.value = true;
        },
        onStatus: (status) {
          if (kDebugMode) {
            print('Speech recognition status: $status');
          }
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
      );

      if (!available) {
        _showError(TranslationKeys.errorMicrophoneNotAvailable.tr);
        skipOnlyMode.value = true;
        return;
      }

      speechAvailable.value = true;
    } catch (e) {
      _showError('${TranslationKeys.errorMicrophoneNotAvailable.tr}: $e');
      skipOnlyMode.value = true;
    }
  }

  /// Request microphone permission
  Future<bool> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      _showError(TranslationKeys.errorMicrophonePermission.tr);
      return false;
    }
    return true;
  }

  /// Start listening for speech
  Future<void> startListening() async {
    if (!speechAvailable.value || isListening.value) return;

    try {
      recognizedText.value = '';
      isListening.value = true;
      speechSuccess.value = false;

      await _speech.listen(
        onResult: (result) {
          recognizedText.value = result.recognizedWords;

          if (result.finalResult) {
            _processSpeechResult(result.recognizedWords);
          }
        },
        localeId: 'en_US', // Fixed English locale
        pauseFor: const Duration(seconds: 10),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error starting speech recognition: $e');
      }
      _showError('${TranslationKeys.errorMicrophoneNotAvailable.tr}: $e');
      isListening.value = false;
    }
  }

  /// Stop listening for speech
  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  /// Process speech recognition result
  void _processSpeechResult(String spokenText) {
    stopListening();

    // Check if spoken text matches the target vocabulary
    final isMatch = _processSpeechUseCase(
      vocabulary: targetVocabulary,
      spokenText: spokenText,
    );

    if (isMatch) {
      _onSpeechSuccess();
    } else {
      // Allow user to try again
      recognizedText.value = '';
    }
  }

  /// Handle successful speech recognition
  void _onSpeechSuccess() {
    speechSuccess.value = true;

    // Show success dialog
    Get.dialog(
      AlertDialog(
        title: Text(
          TranslationKeys.greatJob.tr,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        content: Text(
          TranslationKeys.speechSuccess.trParams({'word': targetVocabulary.word}),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: Text(TranslationKeys.nextLesson.tr),
          ),
        ],
      ),
    );
  }

  /// Skip the game
  void skipGame() {
    Get.back();
  }

  void _showError(String message) {
    Get.snackbar(
      TranslationKeys.errorTitle.tr,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    _speech.cancel();
    super.onClose();
  }
}


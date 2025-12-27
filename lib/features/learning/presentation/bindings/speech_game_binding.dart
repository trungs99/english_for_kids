import 'package:get/get.dart';

import '../../domain/usecases/process_speech_usecase.dart';
import '../controllers/speech_game_controller.dart';

/// Binding for Speech Game page
class SpeechGameBinding extends Bindings {
  @override
  void dependencies() {
    // Register use case
    Get.lazyPut<ProcessSpeechUseCase>(() => ProcessSpeechUseCase());

    // Register controller
    Get.lazyPut<SpeechGameController>(
      () => SpeechGameController(
        processSpeechUseCase: Get.find<ProcessSpeechUseCase>(),
      ),
    );
  }
}


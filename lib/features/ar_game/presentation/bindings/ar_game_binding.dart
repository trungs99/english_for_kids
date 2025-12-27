import 'package:get/get.dart';
import '../controllers/ar_game_controller.dart';

/// Binding for AR Game feature
class ARGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ARGameController>(
      () => ARGameController(),
    );
  }
}


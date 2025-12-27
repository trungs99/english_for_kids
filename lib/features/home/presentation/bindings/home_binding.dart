import 'package:get/get.dart';

import '../../../learning/presentation/bindings/learning_binding.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure learning dependencies are available
    LearningBinding().dependencies();

    Get.lazyPut<HomeController>(() => HomeController());
  }
}

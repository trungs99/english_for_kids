import 'package:exo_shared/exo_shared.dart';
import 'package:get/get.dart';
import 'package:english_for_kids/core/routes/app_routes.dart';

class SplashController extends BaseController {
  @override
  Future<void> initData() async {
    await _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offNamed(AppRoutes.home);
  }
}

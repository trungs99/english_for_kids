import 'package:get/get.dart';
import 'package:english_for_kids/features/splash/presentation/pages/splash_page.dart';
import 'package:english_for_kids/features/splash/presentation/bindings/splash_binding.dart';
import 'package:english_for_kids/features/home/presentation/pages/home_page.dart';
import 'package:english_for_kids/features/home/presentation/bindings/home_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    // Learning route will be added in subsequent feature implementation
  ];
}

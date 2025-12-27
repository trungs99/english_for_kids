import 'package:english_for_kids/app/routes/m_routes.dart';
import 'package:english_for_kids/core/theme/app_theme.dart';
import 'package:english_for_kids/features/camera/bindings/camera_binding.dart';
import 'package:english_for_kids/features/camera/pages/camera_page.dart';
import 'package:english_for_kids/features/home/bindings/home_binding.dart';
import 'package:english_for_kids/features/home/pages/home_page.dart';
import 'package:english_for_kids/features/lesson/presentation/bindings/lesson_binding.dart';
import 'package:english_for_kids/features/lesson/presentation/pages/flashcard_page.dart';
import 'package:english_for_kids/features/lesson/presentation/pages/story_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kids English MVP',
      debugShowCheckedModeBanner: false,
      initialRoute: MRoutes.home,
      getPages: [
        GetPage(name: MRoutes.home, page: () => const HomePage(), binding: HomeBinding()),
        GetPage(
          name: '${MRoutes.lesson}/:levelIndex',
          page: () => const StoryPage(),
          binding: LessonBinding(),
        ),
        GetPage(
          name: '${MRoutes.flashcard}/:levelIndex',
          page: () => const FlashcardPage(),
          binding: LessonBinding(),
        ),
        GetPage(
          name: '${MRoutes.camera}/:levelIndex',
          page: () => const CameraPage(),
          binding: CameraBinding(),
        ),
      ],
      theme: AppTheme.lightTheme,
    );
  }
}

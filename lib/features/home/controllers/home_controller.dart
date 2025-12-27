import 'package:english_for_kids/app/routes/m_routes.dart';
import 'package:english_for_kids/core/constants/lesson_data.dart';
import 'package:english_for_kids/core/models/lesson_model.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  final RxList<LessonModel> lessons = <LessonModel>[].obs;
  
  @override
  Future<void> initData() async {
    await withLoadingSafe(() async {
      lessons.value = generateLessons();
    });
  }
  
  Future<void> startLesson(int levelIndex) async {
    await withLoadingSafe(() async {
      // Navigate to story page for the lesson
      await Get.toNamed('${MRoutes.lesson}/$levelIndex', arguments: levelIndex);
    });
  }
  
  bool isLessonUnlocked(int levelIndex) {
    if (levelIndex == 0) return true; // First lesson always unlocked
    
    // Check if previous lesson is completed
    if (levelIndex - 1 < lessons.length) {
      return lessons[levelIndex - 1].isCompleted;
    }
    return false;
  }
}

import 'package:get/get.dart';

import '../../../../core/storage/isar_service.dart';
import '../../data/datasources/learning_local_datasource.dart';
import '../../data/repositories/learning_repository.dart';
import '../../domain/repositories/learning_repository_interface.dart';
import '../../domain/usecases/process_image_label_usecase.dart';
import '../../domain/usecases/update_lesson_progress_usecase.dart';
import '../controllers/ar_game_controller.dart';

/// Binding for AR Game page
class ARGameBinding extends Bindings {
  @override
  void dependencies() {
    // Register use cases
    Get.lazyPut<ProcessImageLabelUseCase>(() => ProcessImageLabelUseCase());

    // UpdateLessonProgressUseCase should already be registered from LearningBinding
    // But we ensure the dependency chain is available for standalone navigation (e.g. debugging from Home)
    if (!Get.isRegistered<UpdateLessonProgressUseCase>()) {
      if (!Get.isRegistered<LearningLocalDataSource>()) {
        Get.lazyPut<LearningLocalDataSource>(
          () => LearningLocalDataSource(Get.find<IsarService>().isar),
        );
      }

      if (!Get.isRegistered<LearningRepositoryInterface>()) {
        Get.lazyPut<LearningRepositoryInterface>(
          () => LearningRepository(Get.find<LearningLocalDataSource>()),
        );
      }

      Get.lazyPut<UpdateLessonProgressUseCase>(
        () => UpdateLessonProgressUseCase(
          Get.find<LearningRepositoryInterface>(),
        ),
      );
    }

    // Register controller
    Get.lazyPut<ARGameController>(
      () => ARGameController(
        processImageLabelUseCase: Get.find<ProcessImageLabelUseCase>(),
        updateLessonProgressUseCase: Get.find<UpdateLessonProgressUseCase>(),
      ),
    );
  }
}

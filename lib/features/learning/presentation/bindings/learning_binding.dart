import 'package:get/get.dart';
import '../../../../core/storage/isar_service.dart';
import '../../data/datasources/learning_local_datasource.dart';
import '../../data/repositories/learning_repository.dart';
import '../../domain/repositories/learning_repository_interface.dart';
import '../../domain/usecases/get_topics_usecase.dart';
import '../../domain/usecases/get_topic_by_id_usecase.dart';
import '../../domain/usecases/get_lesson_by_id_usecase.dart';
import '../../domain/usecases/update_lesson_progress_usecase.dart';
import '../../domain/usecases/seed_initial_data_usecase.dart';

/// Binding for learning feature
/// Registers all dependencies: DataSource, Repository, and UseCases
class LearningBinding extends Bindings {
  @override
  void dependencies() {
    // Register DataSource
    Get.lazyPut<LearningLocalDataSource>(
      () => LearningLocalDataSource(Get.find<IsarService>().isar),
    );

    // Register Repository
    Get.lazyPut<LearningRepositoryInterface>(
      () => LearningRepository(Get.find<LearningLocalDataSource>()),
    );

    // Register UseCases
    final repository = Get.find<LearningRepositoryInterface>();

    Get.lazyPut(() => GetTopicsUseCase(repository));
    Get.lazyPut(() => GetTopicByIdUseCase(repository));
    Get.lazyPut(() => GetLessonByIdUseCase(repository));
    Get.lazyPut(() => UpdateLessonProgressUseCase(repository));
    Get.lazyPut(() => SeedInitialDataUseCase(repository));
  }
}

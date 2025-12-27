import 'package:get/get.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:english_for_kids/core/storage/isar_service.dart';

class InitialBinding {
  /// Initializes core services required for the application.
  /// This must be called before the app starts to ensure all dependencies are ready.
  Future<void> initializeServices() async {
    try {
      LoggerUtil.info('Starting service initialization...');

      // 1. Initialize SharedPrefService first and register it using Get.put
      final sharedPrefService = SharedPrefService();
      Get.put(sharedPrefService, permanent: true);
      LoggerUtil.info('SharedPrefService registered');

      // 2. Then, initialize IsarService using Get.putAsync(() => IsarService().init())
      await Get.putAsync(() => IsarService().init(), permanent: true);
      LoggerUtil.info('IsarService initialized and registered');

      LoggerUtil.info('All services initialized successfully');
    } catch (e) {
      LoggerUtil.error('Error during initial service initialization', e);
      // Rethrow the error so it can be caught by main.dart or the caller
      rethrow;
    }
  }
}

import '../../domain/repositories/learning_repository_interface.dart';

/// UseCase to seed initial learning data
/// Seeds 3 topics ("Khởi động", "Chào hỏi", "Gia đình") with 5 shared lessons (A-E) if database is empty
class SeedInitialDataUseCase {
  final LearningRepositoryInterface _repository;

  SeedInitialDataUseCase(this._repository);

  /// Seeds initial data if database is empty
  /// Returns true if seeding was performed, false if data already exists
  Future<bool> call() async {
    final isSeeded = await _repository.isDatabaseSeeded();

    if (!isSeeded) {
      await _repository.seedInitialData();
      return true;
    }

    return false;
  }
}

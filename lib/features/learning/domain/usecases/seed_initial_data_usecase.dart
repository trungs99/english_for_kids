import '../../domain/repositories/learning_repository_interface.dart';

/// UseCase to seed initial learning data
/// Seeds the "Alphabet" topic with 5 lessons (A-E) if database is empty
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

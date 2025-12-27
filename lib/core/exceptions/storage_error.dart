class StorageError implements Exception {
  final String message;
  final dynamic originalError;

  StorageError(this.message, [this.originalError]);

  @override
  String toString() =>
      'StorageError: $message${originalError != null ? ' ($originalError)' : ''}';
}

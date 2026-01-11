class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

class TaskException implements Exception {
  final String message;
  final String? code;

  TaskException(this.message, {this.code});

  @override
  String toString() => message;
}

class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => message;
}

class WeatherException implements Exception {
  final String message;
  final String? code;

  WeatherException(this.message, {this.code});

  @override
  String toString() => message;
}

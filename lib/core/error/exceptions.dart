/// Data-layer exceptions — thrown inside DataSources,
/// caught in Repository impls and converted to Failures.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

final class ServerException extends AppException {
  const ServerException(super.message);
}

final class AuthException extends AppException {
  const AuthException(super.message);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found']);
}

final class StorageException extends AppException {
  const StorageException(super.message);
}
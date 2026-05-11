import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handle.dart';
import '../entities/user_entity.dart';

/// Abstract contract — Domain owns this interface.
/// Data layer provides the concrete implementation.
abstract interface class AuthRepository {
  /// Returns the logged-in UserEntity or a Failure.
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required UserRole role,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, Unit>> resetPassword(String email);

  /// Stream emits whenever auth state changes (login/logout/token refresh)
  Stream<UserEntity?> get authStateChanges;
}
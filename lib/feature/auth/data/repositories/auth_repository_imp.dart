import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handle.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/user_model.dart';


/// Bridges DataSource ↔ Domain.
/// Catches AppExceptions, returns Failures via Either.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    return _safeCall(
          () => _dataSource.login(email: email, password: password),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required UserRole role,
  }) async {
    return _safeCall(
          () => _dataSource.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _dataSource.logout();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    return _safeCall(() => _dataSource.getCurrentUser());
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email) async {
    try {
      await _dataSource.resetPassword(email);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _dataSource.authStateChanges.map(
          (model) => model?.toEntity(),
    );
  }

  // ─── Private helper ─────────────────────────────────────────────────────

  Future<Either<Failure, UserEntity>> _safeCall(
      Future<UserModel> Function() call,
      ) async {
    try {
      final model = await call();
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
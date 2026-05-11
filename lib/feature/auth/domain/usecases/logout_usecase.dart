import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handle.dart';
import '../repositories/user_repository.dart';


class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.logout();
}
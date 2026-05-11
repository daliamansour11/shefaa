import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handle.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';


class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}
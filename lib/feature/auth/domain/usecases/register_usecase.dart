import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handle.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      phone: params.phone,
      role: params.role,
    );
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final UserRole role;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.role,
  });
}
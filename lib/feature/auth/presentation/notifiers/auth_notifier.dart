import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/di/injection_container.dart';
import '../../../../core/error/error_handle.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';


sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required Ref ref,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthInitial()) {
    // Listen to Supabase session changes
    ref.read(authRepositoryProvider).authStateChanges.listen((user) {
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
          (failure) => state = AuthError(_mapFailure(failure)),
          (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required UserRole role,
  }) async {
    state = const AuthLoading();

    final result = await _registerUseCase(
      RegisterParams(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
      ),
    );

    result.fold(
          (failure) => state = AuthError(_mapFailure(failure)),
          (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await _logoutUseCase();
    state = const AuthUnauthenticated();
  }

  String _mapFailure(Failure failure) => switch (failure) {
    AuthFailure(:final message) => message,
    NetworkFailure(:final message) => message,
    ServerFailure(:final message) => message,
    _ => 'حدث خطأ غير متوقع',
  };
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    registerUseCase: ref.read(registerUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
    ref: ref,
  );
});
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../feature/auth/domain/entities/user_entity.dart';
import '../../feature/auth/presentation/notifiers/auth_notifier.dart';
import '../../feature/auth/presentation/pages/login_screen.dart';
import '../../feature/auth/presentation/pages/register_screen.dart';

/// Route name constants — avoids magic strings throughout the app.
abstract class Routes {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const patientHome = '/patient';
  static const doctorHome = '/doctor';
  static const adminHome = '/admin';
}

@riverpod
/// Manual provider — no code generation needed for the router.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: Routes.login,
    debugLogDiagnostics: true,
    redirect: (context, state) => _redirect(authState, state),
    routes: [
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgotPassword',
        builder: (_, __) => const _PlaceholderScreen('Forgot Password'),
      ),
      GoRoute(
        path: Routes.patientHome,
        name: 'patientHome',
        builder: (_, __) => const _PlaceholderScreen('Patient Home'),
      ),
      GoRoute(
        path: Routes.doctorHome,
        name: 'doctorHome',
        builder: (_, __) => const _PlaceholderScreen('Doctor Home'),
      ),
      GoRoute(
        path: Routes.adminHome,
        name: 'adminHome',
        builder: (_, __) => const _PlaceholderScreen('Admin Home'),
      ),
    ],
  );
});

String? _redirect(AuthState authState, GoRouterState state) {
  final isOnAuthPage = state.matchedLocation == Routes.login ||
      state.matchedLocation == Routes.register ||
      state.matchedLocation == Routes.forgotPassword;

  if (authState is AuthLoading || authState is AuthInitial) return null;

  if (authState is AuthUnauthenticated || authState is AuthError) {
    return isOnAuthPage ? null : Routes.login;
  }

  if (authState is AuthAuthenticated) {
    // If on an auth page, redirect to role-based home
    if (isOnAuthPage) {
      return _roleHome(authState.user.role);
    }
    // Enforce role-based access
    return _enforceRole(authState.user.role, state.matchedLocation);
  }

  return null;
}

String _roleHome(UserRole role) => switch (role) {
  UserRole.patient => Routes.patientHome,
  UserRole.doctor => Routes.doctorHome,
  UserRole.admin => Routes.adminHome,
};

String? _enforceRole(UserRole role, String location) {
  // Doctor/Admin cannot access patient-only routes and vice versa
  if (role == UserRole.patient && location.startsWith('/doctor')) {
    return Routes.patientHome;
  }
  if (role == UserRole.doctor && location.startsWith('/patient')) {
    return Routes.doctorHome;
  }
  if (role != UserRole.admin && location.startsWith('/admin')) {
    return _roleHome(role);
  }
  return null;
}

/// Temporary placeholder — replaced module by module in later phases
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
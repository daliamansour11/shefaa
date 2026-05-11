import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required UserRole role,
  });
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> resetPassword(String email);
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        throw const AuthException('بيانات الدخول غير صحيحة');
      }

      return _fetchUserProfile(response.user!.id);
    } on AuthException {
      rethrow;
    } on AuthApiException catch (e) {
      throw AuthException(_mapAuthError(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required UserRole role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'full_name': fullName.trim(),
          'phone': phone.trim(),
          'role': role.name,
        },
      );

      if (response.user == null) {
        throw const AuthException('فشل إنشاء الحساب');
      }

      // Insert into public.users table (trigger can also do this server-side)
      await _client.from('users').upsert({
        'id': response.user!.id,
        'email': email.trim(),
        'full_name': fullName.trim(),
        'phone': phone.trim(),
        'role': role.name,
        'is_verified': false,
        'is_active': true,
      });

      return _fetchUserProfile(response.user!.id);
    } on AuthException {
      rethrow;
    } on AuthApiException catch (e) {
      throw AuthException(_mapAuthError(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) throw const AuthException('لم يتم تسجيل الدخول');
    return _fetchUserProfile(user.id);
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email.trim());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      if (event.session?.user == null) return null;
      try {
        return await _fetchUserProfile(event.session!.user.id);
      } catch (_) {
        return null;
      }
    });
  }

  // ─── Private helpers ────────────────────────────────────────────────────

  Future<UserModel> _fetchUserProfile(String userId) async {
    final data = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    return UserModel.fromJson(data);
  }

  String _mapAuthError(String raw) => switch (raw) {
    'Invalid login credentials' => 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
    'Email not confirmed' => 'يرجى تأكيد بريدك الإلكتروني أولاً',
    'User already registered' => 'هذا البريد الإلكتروني مسجل مسبقاً',
    'Password should be at least 6 characters' =>
    'كلمة المرور قصيرة جداً',
    _ => raw,
  };
}
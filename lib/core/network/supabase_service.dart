import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton accessor for the Supabase client.
/// All DataSources depend on this — never import Supabase directly.
class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => client.auth;

  static SupabaseStorageClient get storage => client.storage;

  /// Helper: current authenticated user id (throws if not authed)
  static String get currentUserId {
    final uid = auth.currentUser?.id;
    if (uid == null) throw Exception('User not authenticated');
    return uid;
  }

  /// Current user or null
  static User? get currentUser => auth.currentUser;

  /// True if a session is active
  static bool get isAuthenticated => auth.currentSession != null;
}
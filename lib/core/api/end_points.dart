/// Supabase table names & RPC function names.
/// Centralised so a rename never breaks multiple files.
abstract class SupabaseTables {
  static const users = 'users';
  static const doctors = 'doctors';
  static const patients = 'patients';
  static const appointments = 'appointments';
  static const consultations = 'consultations';
  static const messages = 'messages';
  static const medicalRecords = 'medical_records';
  static const prescriptions = 'prescriptions';
  static const payments = 'payments';
  static const ratings = 'ratings';
  static const notifications = 'notifications';
}

abstract class SupabaseRPC {
  static const verifyDoctor = 'verify_doctor';
  static const getDoctorStats = 'get_doctor_stats';
}

abstract class StorageBuckets {
  static const prescriptions = 'prescriptions';
  static const medicalRecords = 'medical_records';
  static const avatars = 'avatars';
  static const doctorLicenses = 'doctor_licenses';
}
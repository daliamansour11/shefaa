import 'package:equatable/equatable.dart';

/// Roles supported by Shefaa
enum UserRole { patient, doctor, admin }

/// Pure domain entity — no JSON, no Supabase types here.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final UserRole role;
  final String? avatarUrl;
  final bool isVerified;      // doctors need manual admin verification
  final bool isActive;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    this.avatarUrl,
    this.isVerified = false,
    this.isActive = true,
    required this.createdAt,
  });

  bool get isDoctor => role == UserRole.doctor;
  bool get isPatient => role == UserRole.patient;
  bool get isAdmin => role == UserRole.admin;

  UserEntity copyWith({
    String? fullName,
    String? phone,
    String? avatarUrl,
    bool? isVerified,
    bool? isActive,
  }) {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, email, fullName, phone, role, isVerified];
}
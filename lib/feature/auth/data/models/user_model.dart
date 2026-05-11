import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model: handles JSON serialization and maps to/from Domain Entity.
/// freezed gives us immutability + copyWith + equality for free.
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    String? phone,
    required String role,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    fullName: fullName,
    phone: phone,
    role: _roleFromString(role),
    avatarUrl: avatarUrl,
    isVerified: isVerified,
    isActive: isActive,
    createdAt: DateTime.parse(createdAt),
  );

  static UserRole _roleFromString(String role) => switch (role) {
    'doctor' => UserRole.doctor,
    'admin' => UserRole.admin,
    _ => UserRole.patient,
  };
}
import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary brand — medical teal
  static const primary = Color(0xFF0D7377);
  static const primaryLight = Color(0xFF14A085);
  static const primaryDark = Color(0xFF0A5A5D);

  // Accent
  static const accent = Color(0xFF32E0C4);

  // Roles
  static const patientColor = Color(0xFF2D9CDB);
  static const doctorColor = Color(0xFF27AE60);
  static const adminColor = Color(0xFFEB5757);

  // Neutrals
  static const background = Color(0xFFF8FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1A1D1E);
  static const backgroundDark = Color(0xFF121416);

  // Text
  static const textPrimary = Color(0xFF1A1D1E);
  static const textSecondary = Color(0xFF6B7280);
  static const textPrimaryDark = Color(0xFFF3F4F6);
  static const textSecondaryDark = Color(0xFF9CA3AF);

  // Status
  static const success = Color(0xFF27AE60);
  static const warning = Color(0xFFF2994A);
  static const error = Color(0xFFEB5757);
  static const info = Color(0xFF2D9CDB);

  // Border
  static const border = Color(0xFFE5E7EB);
  static const borderDark = Color(0xFF374151);
}
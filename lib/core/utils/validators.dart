/// Pure validation functions — no Flutter imports needed.
abstract class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'البريد الإلكتروني مطلوب';
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return 'بريد إلكتروني غير صالح';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    if (value.length < 8) return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'يجب أن تحتوي على حرف كبير';
    if (!value.contains(RegExp(r'[0-9]'))) return 'يجب أن تحتوي على رقم';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'تأكيد كلمة المرور مطلوب';
    if (value != original) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  static String? required(String? value, {String fieldName = 'هذا الحقل'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName مطلوب';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'رقم الهاتف مطلوب';
    final regex = RegExp(r'^(\+20|0)?1[0125]\d{8}$');
    if (!regex.hasMatch(value.replaceAll(' ', ''))) {
      return 'رقم هاتف مصري غير صالح';
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'الاسم مطلوب';
    if (value.trim().split(' ').length < 2) return 'أدخل الاسم الأول والأخير';
    return null;
  }
}
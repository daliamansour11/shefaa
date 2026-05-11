/// All user-facing strings in one place.
/// Later: replace values with ARB localization keys.
abstract class AppStrings {
  static const appName = 'Shefaa';

  // Auth
  static const login = 'تسجيل الدخول';
  static const register = 'إنشاء حساب';
  static const email = 'البريد الإلكتروني';
  static const password = 'كلمة المرور';
  static const confirmPassword = 'تأكيد كلمة المرور';
  static const fullName = 'الاسم الكامل';
  static const phone = 'رقم الهاتف';
  static const forgotPassword = 'نسيت كلمة المرور؟';
  static const noAccount = 'ليس لديك حساب؟';
  static const haveAccount = 'لديك حساب بالفعل؟';
  static const loginAsPatient = 'دخول كمريض';
  static const loginAsDoctor = 'دخول كطبيب';

  // Errors
  static const genericError = 'حدث خطأ، يرجى المحاولة مجدداً';
  static const networkError = 'تحقق من اتصالك بالإنترنت';
  static const invalidEmail = 'بريد إلكتروني غير صالح';
  static const weakPassword = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
  static const passwordMismatch = 'كلمتا المرور غير متطابقتين';
  static const requiredField = 'هذا الحقل مطلوب';
}
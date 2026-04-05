// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get registerTitle => 'إنشاء حساب جديد';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'رقم الجوال';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get passwordNotMatch => 'كلمة المرور غير متطابقة';

  @override
  String get accountCreated => 'تم إنشاء الحساب بنجاح';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get registerNow => 'سجل الآن';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get emailSentSuccess => 'تم إرسال رابط إعادة تعيين كلمة المرور بنجاح';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get passwordResetSuccess => 'تم إعادة تعيين كلمة المرور بنجاح';

  @override
  String get selectRegion => 'اختر المنطقة';

  @override
  String get regionRequired => 'يرجى اختيار المنطقة';

  @override
  String get forgotPasswordDescription => 'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get confirmPasswordHint => 'تأكيد كلمة المرور';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get passwordRule1 => 'على الأقل 8 أحرف';

  @override
  String get passwordRule2 => 'يحتوي على حرف كبير واحد على الأقل';

  @override
  String get passwordRule3 => 'يحتوي على رقم واحد على الأقل';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get passwordWeak => 'كلمة المرور ضعيفة';

  @override
  String get passwordResetEmailDescription => 'لقد أرسلنا رابط إعادة التعيين إلى بريدك الإلكتروني، يرجى التحقق من صندوق الوارد.';

  @override
  String get resetSuccessDescription => 'يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.';

  @override
  String get regionRiyadh => 'الرياض';

  @override
  String get regionMakkah => 'مكة المكرمة';

  @override
  String get regionMadinah => 'المدينة المنورة';

  @override
  String get regionQassim => 'القصيم';

  @override
  String get regionEastern => 'المنطقة الشرقية';

  @override
  String get regionAsir => 'عسير';

  @override
  String get regionTabuk => 'تبوك';

  @override
  String get regionHail => 'حائل';

  @override
  String get regionNorthern => 'الحدود الشمالية';

  @override
  String get regionJazan => 'جازان';

  @override
  String get regionNajran => 'نجران';

  @override
  String get regionBaha => 'الباحة';

  @override
  String get regionJouf => 'الجوف';

  @override
  String get home => 'الرئيسية';

  @override
  String get categories => 'الأقسام';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get interactiveMap => 'الخريطة التفاعلية';

  @override
  String get tapToExplore => 'اضغط على الخريطة لاستكشاف المناطق المميزة';

  @override
  String get regions => 'المناطق';

  @override
  String get hello => 'مرحباً';

  @override
  String helloUser(Object name) {
    return 'مرحباً $name';
  }

  @override
  String get detectPlant => 'التعرف على النبات';

  @override
  String get uploadPlantImage => 'ارفع صورة النبات';

  @override
  String get chooseImage => 'اختر صورة';

  @override
  String get detectInstruction => 'التقط أو ارفع صورة النبات للتعرف عليه';

  @override
  String get detectSubTitle => 'التقط صورة النبات ليتم التعرف عليه';

  @override
  String get mapSubTitle => 'اضغط على أي محافظة لعرض النباتات المميزة';

  @override
  String get plants => 'نباتات';

  @override
  String get searchPlant => 'ابحث عن نبات...';

  @override
  String get all => 'الكل';

  @override
  String get trees => 'أشجار';

  @override
  String get medicalPlants => 'نباتات طبية';

  @override
  String get aromaticPlants => 'نباتات عطرية';

  @override
  String get memberSince => 'عضو منذ';

  @override
  String get location => 'المنطقة';

  @override
  String get joinDate => 'تاريخ الانضمام';

  @override
  String get manageApp => 'إدارة تفضيلات التطبيق';

  @override
  String get general => 'عام';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get language => 'اللغة';

  @override
  String get privacySecurity => 'الخصوصية والأمان';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get support => 'الدعم';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get account => 'الحساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get reportBug => 'الإبلاغ عن خطأ';

  @override
  String get contactSupport => 'التواصل مع الدعم';

  @override
  String get suggestFeature => 'اقتراح ميزة';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get faqDescription => 'أكثر الأسئلة شيوعًا عن التطبيق';
}

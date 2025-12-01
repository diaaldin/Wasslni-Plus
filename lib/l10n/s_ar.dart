// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SAr extends S {
  SAr([String locale = 'ar']) : super(locale);

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get privacy_intro =>
      'نحن ملتزمون بحماية خصوصية بياناتك وأمانها. توضح سياسة البيانات هذه كيفية تعاملنا مع بياناتك الشخصية.';

  @override
  String get data_collection => 'جمع البيانات';

  @override
  String get data_collection_desc =>
      'نقوم بجمع البيانات لتوفير خدماتنا وتحسينها، وتخصيص تجربتك، وإبقاءك على اطلاع بالتحديثات.';

  @override
  String get data_usage => 'استخدام البيانات';

  @override
  String get data_usage_desc =>
      'يتم استخدام البيانات التي نجمعها فقط لتحسين وظائف التطبيق لدينا، وضمان الأمان، والامتثال للالتزامات القانونية.';

  @override
  String get data_sharing => 'مشاركة البيانات';

  @override
  String get data_sharing_desc =>
      'لن يتم مشاركة بياناتك مع أي طرف ثالث إلا إذا كان ذلك ضرورياً لأغراض قانونية.';

  @override
  String get data_retention => 'الاحتفاظ بالبيانات';

  @override
  String get data_retention_desc =>
      'نحتفظ ببياناتك طالما تستخدم خدماتنا أو حسبما يقتضيه القانون. يمكنك طلب حذف البيانات عن طريق الاتصال بنا.';

  @override
  String get phone_number => 'رقم الهاتف';

  @override
  String get user_rights => 'حقوق المستخدم';

  @override
  String get user_rights_desc =>
      'لديك الحق في الوصول إلى بياناتك وتعديلها وحذفها. يرجى التواصل معنا إذا كانت لديك أي مخاوف أو طلبات.';

  @override
  String get thank_you =>
      'نشكرك على ثقتك بنا فيما يتعلق بمعلوماتك. نحن نسعى جاهدين للحفاظ على بياناتك آمنة وشفافة.';

  @override
  String get contact_support =>
      'لمزيد من التفاصيل، لا تتردد في الاتصال بفريق الدعم لدينا.';

  @override
  String get merchant_dashboard => 'لوحة التاجر';

  @override
  String get dark_mode => 'وضع الليل';

  @override
  String get sunny_mode => 'وضع النهار';

  @override
  String get language => 'اللغة';

  @override
  String get main => 'الرئيسية';

  @override
  String get parcels => 'الطرود';

  @override
  String get settings => 'الاعدادات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get general_serach_hint => 'بحث...';

  @override
  String get clear_selection => 'مسح الاختيار';

  @override
  String get add_parcel => 'إضافة طرد';

  @override
  String get recipient_name => 'اسم المستلم';

  @override
  String get recipient_phone => 'رقم المستلم';

  @override
  String get alt_phone => 'رقم بديل (اختياري)';

  @override
  String get region => 'المنطقة';

  @override
  String get address => 'العنوان, مدينة - شارع';

  @override
  String get parcel_price => 'سعر الطرد (بدون التوصيل)';

  @override
  String get parcel_description => 'وصف الطرد';

  @override
  String get attach_barcode => 'أرفق باركود';

  @override
  String barcode_label(Object code) {
    return 'الباركود: $code';
  }

  @override
  String get total_price_label => 'السعر الإجمالي (مع التوصيل)';

  @override
  String get save_parcel => 'حفظ الطرد';

  @override
  String get choose_region_warning => 'يرجى اختيار المنطقة';

  @override
  String get invalid_price => 'السعر يجب أن يكون رقمًا أكبر من أو يساوي 0';

  @override
  String get enter_price => 'الرجاء إدخال السعر';

  @override
  String get enter_recipient_name => 'الرجاء إدخال اسم المستلم';

  @override
  String get enter_phone => 'الرجاء إدخال رقم المستلم';

  @override
  String get invalid_phone => 'رقم غير صالح';

  @override
  String get enter_address => 'أدخل العنوان (مدينة - شارع)';

  @override
  String get password => 'الرقم السري';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get joinUs => 'انضم إلينا';

  @override
  String get joinUsDescription =>
      'هذه الصفحة مخصصة لأصحاب الأعمال الذين يرغبون في الانضمام إلينا.';

  @override
  String get acceptPolicyStart => 'أوافق على ';

  @override
  String get dataPolicy => 'سياسة الخصوصية';

  @override
  String get name => 'الاسم';

  @override
  String get message => 'الرسالة';

  @override
  String get submit => 'إرسال';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String get validation_phone_required => 'يرجى إدخال رقم الهاتف';

  @override
  String get no_internet_connection => '⚠ No internet connection';

  @override
  String get validation_phone_invalid =>
      'يجب أن يتكون الرقم من 10 أرقام إنجليزية';

  @override
  String get app_name => 'وصلني بلس';

  @override
  String get app_tagline => 'توصيل سريع وموثوق';

  @override
  String get welcome_to_app => 'مرحباً بك في وصلني بلس';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enter_email => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get invalid_email => 'بريد إلكتروني غير صالح';

  @override
  String get enter_password => 'الرجاء إدخال كلمة المرور';

  @override
  String get register => 'تسجيل جديد';

  @override
  String get role => 'الدور';

  @override
  String get merchant => 'تاجر';

  @override
  String get courier => 'مندوب توصيل';

  @override
  String get customer => 'زبون';

  @override
  String get login_failed => 'فشل تسجيل الدخول';

  @override
  String get registration_failed => 'فشل التسجيل';

  @override
  String get success => 'نجاح';

  @override
  String get already_have_account => 'لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get dont_have_account => 'ليس لديك حساب؟ تسجيل جديد';
}

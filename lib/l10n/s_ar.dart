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
  String get no_internet_connection => '⚠ لا يوجد اتصال بالإنترنت';

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

  @override
  String get logout_confirmation => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get logout_error => 'خطأ في تسجيل الخروج. يرجى المحاولة مرة أخرى.';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get in_transit => 'قيد التوصيل';

  @override
  String get delivered => 'تم التوصيل';

  @override
  String get cancelled => 'ملغى';

  @override
  String get monthly_revenue => 'الإيرادات الشهرية';

  @override
  String get recent_parcels => 'الطرود الأخيرة';

  @override
  String get view_all => 'عرض الكل';

  @override
  String get no_parcels_yet => 'لا توجد طرود بعد';

  @override
  String get recipient => 'المستلم';

  @override
  String get delivery_region => 'منطقة التوصيل';

  @override
  String get mark_all_read => 'تحديد الكل كمقروء';

  @override
  String get no_notifications => 'لا توجد إشعارات';

  @override
  String get all => 'الكل';

  @override
  String get unread => 'غير مقروء';

  @override
  String get delete => 'حذف';

  @override
  String get edit_parcel => 'تعديل الطرد';

  @override
  String get update_parcel => 'تحديث الطرد';

  @override
  String get cancel_parcel => 'إلغاء الطرد';

  @override
  String get confirm_cancel_parcel => 'هل أنت متأكد من إلغاء هذا الطرد؟';

  @override
  String get cancellation_reason => 'سبب الإلغاء';

  @override
  String get yes_cancel => 'نعم، إلغاء';

  @override
  String get no => 'لا';

  @override
  String get parcel_updated_success => 'تم تحديث الطرد بنجاح';

  @override
  String get parcel_created_success => 'تم إنشاء الطرد بنجاح';

  @override
  String get parcel_cancelled_success => 'تم إلغاء الطرد بنجاح';

  @override
  String error_occurred(Object error) {
    return 'حدث خطأ: $error';
  }

  @override
  String get parcel_details => 'تفاصيل الطرد';

  @override
  String status_label(Object status) {
    return 'الحالة: $status';
  }

  @override
  String get delivery_fee => 'رسوم التوصيل';

  @override
  String get history => 'السجل';

  @override
  String note_label(Object note) {
    return 'ملاحظة: $note';
  }

  @override
  String get weight => 'الوزن (كجم)';

  @override
  String get dimensions => 'الأبعاد (سم)';

  @override
  String get length => 'الطول';

  @override
  String get width => 'العرض';

  @override
  String get height => 'الارتفاع';

  @override
  String get delivery_instructions => 'تعليمات التوصيل (اختياري)';

  @override
  String get optional => 'اختياري';

  @override
  String get images => 'الصور';

  @override
  String get add_image => 'إضافة صورة';

  @override
  String get delivery_time_slot => 'وقت التوصيل المفضل';

  @override
  String get morning => 'صباحاً (9ص - 12م)';

  @override
  String get afternoon => 'ظهراً (12م - 5م)';

  @override
  String get evening => 'مساءً (5م - 9م)';

  @override
  String get anytime => 'أي وقت';

  @override
  String get requires_signature => 'يتطلب توقيع المستلم';

  @override
  String get signature_description => 'يجب على المندوب جمع التوقيع عند التسليم';

  @override
  String get print_label => 'طباعة الملصق';

  @override
  String get print_receipt => 'طباعة الإيصال';

  @override
  String get shipping_label => 'ملصق الشحن';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get parcel_info => 'معلومات الطرد';

  @override
  String get scan_to_track => 'امسح للتتبع';

  @override
  String get export => 'تصدير';

  @override
  String get export_pdf => 'تصدير إلى PDF';

  @override
  String get export_excel => 'تصدير إلى Excel';

  @override
  String get export_success => 'تم التصدير بنجاح';

  @override
  String get export_error => 'فشل التصدير';

  @override
  String get parcels_report => 'تقرير الطرود';

  @override
  String get total_parcels => 'إجمالي الطرود';

  @override
  String get date_range => 'نطاق التاريخ';

  @override
  String get bulk_upload => 'رفع جماعي';

  @override
  String get upload_csv => 'رفع ملف CSV';

  @override
  String get download_template => 'تنزيل النموذج';

  @override
  String get select_file => 'اختر ملف';

  @override
  String get upload_success => 'تم الرفع بنجاح';

  @override
  String get upload_error => 'فشل الرفع';

  @override
  String get processing_file => 'جاري معالجة الملف...';

  @override
  String get parcels_imported => 'تم استيراد الطرود';

  @override
  String get reports => 'التقارير';

  @override
  String get analytics => 'التحليلات';

  @override
  String get monthly_report => 'التقرير الشهري';

  @override
  String get delivery_statistics => 'إحصائيات التوصيل';

  @override
  String get revenue_overview => 'نظرة عامة على الإيرادات';

  @override
  String get performance_metrics => 'مقاييس الأداء';

  @override
  String get select_month => 'اختر الشهر';

  @override
  String get total_deliveries => 'إجمالي التوصيلات';

  @override
  String get successful_deliveries => 'التوصيلات الناجحة';

  @override
  String get failed_deliveries => 'التوصيلات الفاشلة';

  @override
  String get pending_deliveries => 'التوصيلات المعلقة';

  @override
  String get success_rate => 'معدل النجاح';

  @override
  String get average_delivery_time => 'متوسط وقت التوصيل';

  @override
  String get total_revenue => 'إجمالي الإيرادات';

  @override
  String get delivery_fees_collected => 'رسوم التوصيل المحصلة';

  @override
  String get success_rate_trend => 'اتجاه معدل النجاح';

  @override
  String get weekly_success_rate => 'معدل النجاح الأسبوعي';

  @override
  String get no_data_available => 'لا توجد بيانات متاحة';

  @override
  String get top_customers => 'أفضل العملاء';

  @override
  String get parcels_delivered => 'الطرود التي تم توصيلها';

  @override
  String get notification_settings => 'إعدادات الإشعارات';

  @override
  String get parcel_updates => 'تحديثات الطرود';

  @override
  String get parcel_updates_desc => 'احصل على إشعار عند تغيير حالة الطرد';

  @override
  String get promotional_offers => 'العروض الترويجية';

  @override
  String get promotional_offers_desc =>
      'تلقي تحديثات حول الميزات والعروض الجديدة';

  @override
  String get system_announcements => 'إعلانات النظام';

  @override
  String get system_announcements_desc => 'تحديثات مهمة حول المنصة';

  @override
  String get courier_dashboard => 'لوحة السائق';

  @override
  String get daily_assignments => 'المهام اليومية';

  @override
  String get todays_deliveries => 'توصيلات اليوم';

  @override
  String get earnings_today => 'الأرباح اليوم';

  @override
  String get completed => 'مكتمل';

  @override
  String get pending_pickup => 'في انتظار الاستلام';

  @override
  String get my_route => 'مسار التوصيل';

  @override
  String get start_delivery => 'بدء التوصيل';

  @override
  String get no_assignments => 'لا توجد مهام لهذا اليوم';

  @override
  String get route_map => 'خريطة المسار';

  @override
  String get delivery_points => 'نقاط التوصيل';

  @override
  String get navigate => 'التنقل';

  @override
  String get map_view => 'عرض الخريطة';

  @override
  String get list_view => 'عرض القائمة';

  @override
  String get delivery_location => 'موقع التوصيل';

  @override
  String get current_location => 'الموقع الحالي';

  @override
  String get show_route => 'إظهار المسار';

  @override
  String get hide_route => 'إخفاء المسار';

  @override
  String get optimized_route => 'المسار الأمثل';

  @override
  String get distance => 'المسافة';

  @override
  String get estimated_time => 'الوقت المتوقع';

  @override
  String get weekly_earnings => 'الأرباح الأسبوعية';

  @override
  String get monthly_earnings => 'الأرباح الشهرية';

  @override
  String get total_earnings => 'إجمالي الأرباح';

  @override
  String get earnings_breakdown => 'تفصيل الأرباح';

  @override
  String get todays_performance => 'أداء اليوم';

  @override
  String get delivery_success_rate => 'معدل نجاح التوصيل';

  @override
  String get failed => 'فشل';

  @override
  String get minutes => 'دقائق';

  @override
  String get hours => 'ساعات';

  @override
  String get days => 'أيام';

  @override
  String get view_details => 'عرض التفاصيل';

  @override
  String get performance => 'الأداء';

  @override
  String get this_week => 'هذا الأسبوع';

  @override
  String get this_month => 'هذا الشهر';

  @override
  String get earnings_trend => 'اتجاه الأرباح';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get delivery_queue => 'قائمة التوصيل';

  @override
  String get no_active_deliveries => 'لا توجد توصيلات نشطة';

  @override
  String get all_caught_up => 'أنت على اطلاع بكل شيء!';

  @override
  String get call => 'اتصال';

  @override
  String get delivery_checklist => 'قائمة التحقق من التوصيل';

  @override
  String get complete_steps_to_proceed => 'أكمل الخطوات التالية للمتابعة';

  @override
  String get verify_recipient => 'التحقق من المستلم';

  @override
  String get confirm_location => 'تأكيد الموقع';

  @override
  String get check_package_condition => 'فحص حالة الطرد';

  @override
  String get ensure_no_damage => 'تأكد من عدم وجود تلف ظاهر';

  @override
  String get collect_payment => 'تحصيل الدفع';

  @override
  String get proceed_to_proof => 'المتابعة إلى إثبات التوصيل';

  @override
  String get proof_of_delivery => 'إثبات التوصيل';

  @override
  String get take_photo_proof => 'التقط صورة للطرد الذي تم توصيله';

  @override
  String get take_photo => 'التقاط صورة';

  @override
  String get retake => 'إعادة التقاط';

  @override
  String get confirm_delivery => 'تأكيد التوصيل';

  @override
  String get uploading => 'جاري الرفع...';

  @override
  String get delivery_completed_successfully => 'تم التوصيل بنجاح!';
}

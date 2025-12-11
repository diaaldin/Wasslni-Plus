import 'package:wasslni_plus/models/faq_model.dart';

/// Service to manage FAQs
class FAQService {
  static final FAQService _instance = FAQService._internal();
  factory FAQService() => _instance;
  FAQService._internal();

  /// Get all FAQs
  List<FAQ> getAllFAQs() {
    return _defaultFAQs;
  }

  /// Get FAQs by category
  List<FAQ> getFAQsByCategory(String category) {
    return _defaultFAQs.where((faq) => faq.category == category).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// Search FAQs
  List<FAQ> searchFAQs(String query, String languageCode) {
    if (query.isEmpty) return getAllFAQs();

    final lowerQuery = query.toLowerCase();
    return _defaultFAQs.where((faq) {
      final question = faq.getQuestion(languageCode).toLowerCase();
      final answer = faq.getAnswer(languageCode).toLowerCase();
      return question.contains(lowerQuery) || answer.contains(lowerQuery);
    }).toList();
  }

  /// Default FAQs
  static final List<FAQ> _defaultFAQs = [
    // General FAQs
    FAQ(
      id: '1',
      category: 'general',
      order: 1,
      questionEn: 'What is Wasslni Plus?',
      questionAr: 'ما هو وصلني بلس؟',
      answerEn:
          'Wasslni Plus is a comprehensive delivery management platform that connects customers, merchants, and couriers. We provide fast, reliable, and trackable delivery services across Palestine.',
      answerAr:
          'وصلني بلس هي منصة شاملة لإدارة التوصيل تربط العملاء والتجار والسعاة. نحن نقدم خدمات توصيل سريعة وموثوقة وقابلة للتتبع في جميع أنحاء فلسطين.',
    ),
    FAQ(
      id: '2',
      category: 'general',
      order: 2,
      questionEn: 'How do I track my delivery?',
      questionAr: 'كيف أتتبع طلبي؟',
      answerEn:
          'You can track your delivery in real-time through the app. Go to "Order History" and select your order to see the current status, location on map, and estimated delivery time.',
      answerAr:
          'يمكنك تتبع طلبك في الوقت الفعلي من خلال التطبيق. انتقل إلى "سجل الطلبات" واختر طلبك لرؤية الحالة الحالية والموقع على الخريطة ووقت التسليم المتوقع.',
    ),
    FAQ(
      id: '3',
      category: 'general',
      order: 3,
      questionEn: 'What areas do you cover?',
      questionAr: 'ما هي المناطق التي تغطونها؟',
      answerEn:
          'We currently cover Jerusalem, West Bank, and Israel. We are continuously expanding our coverage to serve more areas.',
      answerAr:
          'نحن نغطي حالياً القدس والضفة الغربية وإسرائيل. نحن نتوسع باستمرار لتغطية المزيد من المناطق.',
    ),

    // Orders & Parcels FAQs
    FAQ(
      id: '4',
      category: 'orders',
      order: 1,
      questionEn: 'How do I create a new parcel?',
      questionAr: 'كيف أنشئ طرد جديد؟',
      answerEn:
          'To create a new parcel, go to the "Parcels" section and tap "Add Parcel". Fill in the recipient details, select the delivery region, enter the parcel price and description, then submit.',
      answerAr:
          'لإنشاء طرد جديد، انتقل إلى قسم "الطرود" واضغط على "إضافة طرد". املأ تفاصيل المستلم، اختر منطقة التوصيل، أدخل سعر الطرد والوصف، ثم أرسل.',
    ),
    FAQ(
      id: '5',
      category: 'orders',
      order: 2,
      questionEn: 'Can I cancel or edit my order?',
      questionAr: 'هل يمكنني إلغاء أو تعديل طلبي؟',
      answerEn:
          'Yes, you can cancel or edit your order before it has been picked up by the courier. Go to the parcel details page and select "Edit" or "Cancel". Once the courier has picked it up, contact support for assistance.',
      answerAr:
          'نعم، يمكنك إلغاء أو تعديل طلبك قبل أن يتم استلامه من قبل السائق. انتقل إلى صفحة تفاصيل الطرد واختر "تعديل" أو "إلغاء". بمجرد استلام السائق له، اتصل بالدعم للمساعدة.',
    ),
    FAQ(
      id: '6',
      category: 'orders',
      order: 3,
      questionEn: 'What are the parcel status types?',
      questionAr: 'ما هي أنواع حالات الطرود؟',
      answerEn:
          'Parcel statuses include: Awaiting Label, Ready to Ship, En Route to Distributor, At Distributor\'s Warehouse, Out for Delivery, Delivered, Returned, and Cancelled. Each status shows the current stage of your delivery.',
      answerAr:
          'حالات الطرود تشمل: بانتظار الملصق، جاهز للإرسال، في الطريق للموزع، في مخزن الموزع، في الطريق للزبون، تم التوصيل، طرد راجع، وملغي. كل حالة تظهر المرحلة الحالية من توصيلك.',
    ),

    // Delivery FAQs
    FAQ(
      id: '7',
      category: 'delivery',
      order: 1,
      questionEn: 'How long does delivery take?',
      questionAr: 'كم تستغرق مدة التوصيل؟',
      answerEn:
          'Delivery times vary depending on the region and distance. Typically, deliveries within the same city take 1-2 days, while inter-city deliveries take 2-4 days. You can see the estimated delivery time on your order page.',
      answerAr:
          'أوقات التوصيل تختلف حسب المنطقة والمسافة. عادةً، التوصيل داخل نفس المدينة يستغرق 1-2 يوم، بينما التوصيل بين المدن يستغرق 2-4 أيام. يمكنك رؤية وقت التسليم المتوقع في صفحة طلبك.',
    ),
    FAQ(
      id: '8',
      category: 'delivery',
      order: 2,
      questionEn: 'What if I\'m not available for delivery?',
      questionAr: 'ماذا لو لم أكن متاحاً للاستلام؟',
      answerEn:
          'If you\'re not available, the courier will attempt to contact you. You can also call the courier directly using the contact button in the app. If delivery fails, the parcel will be returned to the merchant.',
      answerAr:
          'إذا لم تكن متاحاً، سيحاول السائق الاتصال بك. يمكنك أيضاً الاتصال بالسائق مباشرة باستخدام زر الاتصال في التطبيق. إذا فشل التسليم، سيتم إرجاع الطرد إلى التاجر.',
    ),
    FAQ(
      id: '9',
      category: 'delivery',
      order: 3,
      questionEn: 'Can I change the delivery address?',
      questionAr: 'هل يمكنني تغيير عنوان التوصيل؟',
      answerEn:
          'You can change the delivery address before the courier picks up the parcel. After pickup, contact our support team and they will coordinate with the courier to update the address if possible.',
      answerAr:
          'يمكنك تغيير عنوان التوصيل قبل أن يستلم السائق الطرد. بعد الاستلام، اتصل بفريق الدعم لدينا وسيقومون بالتنسيق مع السائق لتحديث العنوان إن أمكن.',
    ),

    // Payment FAQs
    FAQ(
      id: '10',
      category: 'payment',
      order: 1,
      questionEn: 'What payment methods do you accept?',
      questionAr: 'ما هي طرق الدفع المقبولة؟',
      answerEn:
          'We currently accept cash on delivery (COD). We are working on adding more payment options including credit cards and digital wallets.',
      answerAr:
          'نحن نقبل حالياً الدفع عند الاستلام. نحن نعمل على إضافة المزيد من خيارات الدفع بما في ذلك بطاقات الائتمان والمحافظ الرقمية.',
    ),
    FAQ(
      id: '11',
      category: 'payment',
      order: 2,
      questionEn: 'How are delivery fees calculated?',
      questionAr: 'كيف يتم حساب رسوم التوصيل؟',
      answerEn:
          'Delivery fees are based on the delivery region and parcel weight. You can see the delivery fee when creating a new parcel. The total price includes both the parcel price and delivery fee.',
      answerAr:
          'رسوم التوصيل تعتمد على منطقة التوصيل ووزن الطرد. يمكنك رؤية رسوم التوصيل عند إنشاء طرد جديد. السعر الإجمالي يشمل سعر الطرد ورسوم التوصيل.',
    ),

    // Account FAQs
    FAQ(
      id: '12',
      category: 'account',
      order: 1,
      questionEn: 'How do I create an account?',
      questionAr: 'كيف أنشئ حساب؟',
      answerEn:
          'To create an account, open the app and tap "Register". Fill in your name, email, phone number, and choose a password. Select your role (Customer, Merchant, or Courier) and submit.',
      answerAr:
          'لإنشاء حساب، افتح التطبيق واضغط على "تسجيل". املأ اسمك، البريد الإلكتروني، رقم الهاتف، واختر كلمة مرور. اختر دورك (عميل، تاجر، أو سائق) وأرسل.',
    ),
    FAQ(
      id: '13',
      category: 'account',
      order: 2,
      questionEn: 'How do I reset my password?',
      questionAr: 'كيف أعيد تعيين كلمة المرور؟',
      answerEn:
          'On the login page, tap "Forgot Password". Enter your email address and we\'ll send you instructions to reset your password. You can also change your password from the Settings page if you\'re logged in.',
      answerAr:
          'في صفحة تسجيل الدخول، اضغط على "نسيت كلمة المرور". أدخل عنوان بريدك الإلكتروني وسنرسل لك تعليمات لإعادة تعيين كلمة المرور. يمكنك أيضاً تغيير كلمة المرور من صفحة الإعدادات إذا كنت مسجلاً للدخول.',
    ),
    FAQ(
      id: '14',
      category: 'account',
      order: 3,
      questionEn: 'Can I have multiple accounts?',
      questionAr: 'هل يمكنني امتلاك حسابات متعددة؟',
      answerEn:
          'Each phone number and email can only be associated with one account. However, you can switch between different roles (Customer, Merchant, Courier) by contacting support.',
      answerAr:
          'كل رقم هاتف وبريد إلكتروني يمكن ربطه بحساب واحد فقط. ومع ذلك، يمكنك التبديل بين الأدوار المختلفة (عميل، تاجر، سائق) بالاتصال بالدعم.',
    ),
  ];
}

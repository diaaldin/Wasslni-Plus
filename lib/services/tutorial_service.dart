import 'package:flutter/material.dart';

/// Tutorial Step Model
class TutorialStep {
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final IconData icon;
  final String? imagePath;

  TutorialStep({
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.icon,
    this.imagePath,
  });

  String getTitle(String languageCode) {
    return languageCode == 'ar' ? titleAr : title;
  }

  String getDescription(String languageCode) {
    return languageCode == 'ar' ? descriptionAr : description;
  }
}

/// Tutorial Service to manage tutorial content for different user roles
class TutorialService {
  static final TutorialService _instance = TutorialService._internal();
  factory TutorialService() => _instance;
  TutorialService._internal();

  /// Get tutorial steps for customer role
  List<TutorialStep> getCustomerTutorial() {
    return [
      TutorialStep(
        title: 'Welcome to Wasslni Plus',
        titleAr: 'مرحباً بك في وصلني بلس',
        description:
            'Track your deliveries in real-time, view order history, and manage your delivery addresses all in one place.',
        descriptionAr:
            'تتبع طلباتك في الوقت الفعلي، اعرض سجل الطلبات، وأدر عناوين التوصيل الخاصة بك في مكان واحد.',
        icon: Icons.home,
      ),
      TutorialStep(
        title: 'Track Your Orders',
        titleAr: 'تتبع طلباتك',
        description:
            'See your courier\'s live location on the map, get estimated arrival time, and receive real-time status updates.',
        descriptionAr:
            'شاهد موقع السائق المباشر على الخريطة، احصل على وقت الوصول المتوقع، واستقبل تحديثات الحالة في الوقت الفعلي.',
        icon: Icons.location_on,
      ),
      TutorialStep(
        title: 'Manage Addresses',
        titleAr: 'إدارة العناوين',
        description:
            'Save multiple delivery addresses like Home, Work, etc. Set a default address for quick ordering.',
        descriptionAr:
            'احفظ عدة عناوين للتوصيل مثل المنزل، العمل، إلخ. عيّن عنواناً افتراضياً للطلب السريع.',
        icon: Icons.place,
      ),
      TutorialStep(
        title: 'Rate & Review',
        titleAr: 'التقييم والمراجعة',
        description:
            'After delivery, rate your experience and leave feedback. Your reviews help us maintain quality service.',
        descriptionAr:
            'بعد التوصيل، قيّم تجربتك واترك تعليقك. تساعدنا مراجعاتك في الحفاظ على جودة الخدمة.',
        icon: Icons.star,
      ),
      TutorialStep(
        title: 'Report Issues',
        titleAr: 'الإبلاغ عن المشاكل',
        description:
            'Encountered a problem? Report issues directly from the order details, and our support team will help.',
        descriptionAr:
            'واجهت مشكلة؟ أبلغ عن المشاكل مباشرة من تفاصيل الطلب، وسيساعدك فريق الدعم لدينا.',
        icon: Icons.report_problem,
      ),
    ];
  }

  /// Get tutorial steps for merchant role
  List<TutorialStep> getMerchantTutorial() {
    return [
      TutorialStep(
        title: 'Welcome Merchant!',
        titleAr: 'مرحباً بك أيها التاجر!',
        description:
            'Manage your deliveries efficiently with our comprehensive merchant dashboard. Create, track, and export your parcels.',
        descriptionAr:
            'أدر توصيلاتك بكفاءة مع لوحة تحكم التاجر الشاملة. أنشئ، تتبع، وصدّر طرودك.',
        icon: Icons.store,
      ),
      TutorialStep(
        title: 'Create Parcels',
        titleAr: 'إنشاء الطرود',
        description:
            'Add single parcels or bulk upload via CSV. Include recipient details, delivery region, and parcel information.',
        descriptionAr:
            'أضف طرود فردية أو قم بالتحميل الجماعي عبر CSV. ضمّن تفاصيل المستلم، منطقة التوصيل، ومعلومات الطرد.',
        icon: Icons.add_box,
      ),
      TutorialStep(
        title: 'Print Labels & Receipts',
        titleAr: 'طباعة الملصقات والإيصالات',
        description:
            'Generate shipping labels with barcodes and print receipts for your records. Everything you need for professional delivery.',
        descriptionAr:
            'أنشئ ملصقات الشحن مع الباركود واطبع الإيصالات لسجلاتك. كل ما تحتاجه للتوصيل الاحترافي.',
        icon: Icons.print,
      ),
      TutorialStep(
        title: 'Track Status',
        titleAr: 'تتبع الحالة',
        description:
            'Monitor all your parcels from creation to delivery. See which courier is assigned and get real-time updates.',
        descriptionAr:
            'راقب جميع طرودك من الإنشاء إلى التسليم. اعرف أي سائق معيّن واحصل على التحديثات في الوقت الفعلي.',
        icon: Icons.track_changes,
      ),
      TutorialStep(
        title: 'Analytics & Reports',
        titleAr: 'التحليلات والتقارير',
        description:
            'View monthly revenue, delivery statistics, and success rates. Export detailed reports in PDF or Excel.',
        descriptionAr:
            'اعرض الإيرادات الشهرية، إحصائيات التوصيل، ومعدلات النجاح. صدّر تقارير مفصلة بصيغة PDF أو Excel.',
        icon: Icons.analytics,
      ),
    ];
  }

  /// Get tutorial steps for courier role
  List<TutorialStep> getCourierTutorial() {
    return [
      TutorialStep(
        title: 'Welcome Courier!',
        titleAr: 'مرحباً بك أيها السائق!',
        description:
            'Manage your daily deliveries, optimize your route, and track your earnings all from your mobile device.',
        descriptionAr:
            'أدر توصيلاتك اليومية، حسّن مسارك، وتتبع أرباحك كلها من جهازك المحمول.',
        icon: Icons.local_shipping,
      ),
      TutorialStep(
        title: 'Daily Assignments',
        titleAr: 'المهام اليومية',
        description:
            'View all your assigned deliveries for the day. See pickup and delivery locations on the map.',
        descriptionAr:
            'اعرض جميع مهام التوصيل المعينة لك لليوم. شاهد مواقع الاستلام والتسليم على الخريطة.',
        icon: Icons.assignment,
      ),
      TutorialStep(
        title: 'Optimize Your Route',
        titleAr: 'حسّن مسارك',
        description:
            'Get the most efficient delivery route automatically. Save time and fuel by following the optimized path.',
        descriptionAr:
            'احصل على مسار التوصيل الأكثر كفاءة تلقائياً. وفر الوقت والوقود باتباع المسار المُحسّن.',
        icon: Icons.route,
      ),
      TutorialStep(
        title: 'Update Status',
        titleAr: 'تحديث الحالة',
        description:
            'Update parcel status at each stage: Picked Up, At Warehouse, Out for Delivery, and Delivered.',
        descriptionAr:
            'حدّث حالة الطرد في كل مرحلة: تم الاستلام، في المخزن، في الطريق للتوصيل، وتم التسليم.',
        icon: Icons.update,
      ),
      TutorialStep(
        title: 'Proof of Delivery',
        titleAr: 'إثبات التسليم',
        description:
            'Take a photo and collect signatures for delivered parcels. This protects both you and the customer.',
        descriptionAr:
            'التقط صورة واجمع التوقيعات للطرود المُسلّمة. هذا يحمي كلاً منك والعميل.',
        icon: Icons.camera_alt,
      ),
      TutorialStep(
        title: 'Track Your Earnings',
        titleAr: 'تتبع أرباحك',
        description:
            'See your daily, weekly, and monthly earnings. View delivery fees, tips, and bonuses all in one place.',
        descriptionAr:
            'شاهد أرباحك اليومية، الأسبوعية، والشهرية. اعرض رسوم التوصيل، الإكراميات، والمكافآت في مكان واحد.',
        icon: Icons.account_balance_wallet,
      ),
    ];
  }

  /// Get tutorial steps for manager role
  List<TutorialStep> getManagerTutorial() {
    return [
      TutorialStep(
        title: 'Welcome Manager!',
        titleAr: 'مرحباً بك أيها المدير!',
        description:
            'Oversee all operations, manage couriers, and monitor system-wide performance from your dashboard.',
        descriptionAr:
            'راقب جميع العمليات، أدر السعاة، وراقب الأداء على مستوى النظام من لوحة التحكم الخاصة بك.',
        icon: Icons.dashboard,
      ),
      TutorialStep(
        title: 'Assign Couriers',
        titleAr: 'تعيين السعاة',
        description:
            'Assign parcels to available couriers based on their location, workload, and working regions.',
        descriptionAr:
            'عيّن الطرود للسعاة المتاحين بناءً على موقعهم، عبء العمل، ومناطق عملهم.',
        icon: Icons.person_add,
      ),
      TutorialStep(
        title: 'Monitor Performance',
        titleAr: 'مراقبة الأداء',
        description:
            'Track courier performance metrics including success rate, delivery time, and customer ratings.',
        descriptionAr:
            'تتبع مقاييس أداء السعاة بما في ذلك معدل النجاح، وقت التوصيل، وتقييمات العملاء.',
        icon: Icons.trending_up,
      ),
      TutorialStep(
        title: 'Handle Escalations',
        titleAr: 'معالجة التصعيدات',
        description:
            'Review and resolve customer complaints and delivery issues. Take action to maintain service quality.',
        descriptionAr:
            'راجع وحل شكاوى العملاء ومشاكل التوصيل. اتخذ إجراءات للحفاظ على جودة الخدمة.',
        icon: Icons.support_agent,
      ),
      TutorialStep(
        title: 'Generate Reports',
        titleAr: 'إنشاء التقارير',
        description:
            'Create comprehensive reports on deliveries, revenue, and performance. Export for analysis.',
        descriptionAr:
            'أنشئ تقارير شاملة عن التوصيلات، الإيرادات، والأداء. صدّرها للتحليل.',
        icon: Icons.assessment,
      ),
    ];
  }

  /// Get tutorial steps for admin role
  List<TutorialStep> getAdminTutorial() {
    return [
      TutorialStep(
        title: 'Welcome Admin!',
        titleAr: 'مرحباً بك أيها المسؤول!',
        description:
            'Full system control at your fingertips. Manage users, configure settings, and monitor system health.',
        descriptionAr:
            'التحكم الكامل في النظام في متناول يدك. أدر المستخدمين، اضبط الإعدادات، وراقب صحة النظام.',
        icon: Icons.admin_panel_settings,
      ),
      TutorialStep(
        title: 'User Management',
        titleAr: 'إدارة المستخدمين',
        description:
            'Create, edit, and delete user accounts. Change user roles and manage account status.',
        descriptionAr:
            'أنشئ، عدّل، واحذف حسابات المستخدمين. غيّر أدوار المستخدمين وأدر حالة الحسابات.',
        icon: Icons.people,
      ),
      TutorialStep(
        title: 'System Configuration',
        titleAr: 'تكوين النظام',
        description:
            'Configure delivery regions, set fees, manage privacy policies, and customize system settings.',
        descriptionAr:
            'اضبط مناطق التوصيل، حدد الرسوم، أدر سياسات الخصوصية، وخصص إعدادات النظام.',
        icon: Icons.settings,
      ),
      TutorialStep(
        title: 'System Analytics',
        titleAr: 'تحليلات النظام',
        description:
            'View complete system analytics including user growth, delivery trends, and revenue metrics.',
        descriptionAr:
            'اعرض تحليلات النظام الكاملة بما في ذلك نمو المستخدمين، اتجاهات التوصيل، ومقاييس الإيرادات.',
        icon: Icons.bar_chart,
      ),
      TutorialStep(
        title: 'Monitor System Health',
        titleAr: 'مراقبة صحة النظام',
        description:
            'Check system status, view error logs, and ensure all services are running smoothly.',
        descriptionAr:
            'تحقق من حالة النظام، اعرض سجلات الأخطاء، وتأكد من أن جميع الخدمات تعمل بسلاسة.',
        icon: Icons.health_and_safety,
      ),
    ];
  }

  /// Get tutorial for a specific role
  List<TutorialStep> getTutorialForRole(String role) {
    switch (role.toLowerCase()) {
      case 'customer':
        return getCustomerTutorial();
      case 'merchant':
        return getMerchantTutorial();
      case 'courier':
        return getCourierTutorial();
      case 'manager':
        return getManagerTutorial();
      case 'admin':
        return getAdminTutorial();
      default:
        return getCustomerTutorial(); // Default to customer
    }
  }
}

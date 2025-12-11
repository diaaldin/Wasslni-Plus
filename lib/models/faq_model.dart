/// FAQ (Frequently Asked Questions) Model
class FAQ {
  final String id;
  final String questionEn;
  final String questionAr;
  final String answerEn;
  final String answerAr;
  final String category;
  final int order;

  FAQ({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.answerEn,
    required this.answerAr,
    required this.category,
    this.order = 0,
  });

  String getQuestion(String languageCode) {
    return languageCode == 'ar' ? questionAr : questionEn;
  }

  String getAnswer(String languageCode) {
    return languageCode == 'ar' ? answerAr : answerEn;
  }
}

/// FAQ Categories
enum FAQCategory {
  general,
  orders,
  delivery,
  payment,
  account,
}

extension FAQCategoryExtension on FAQCategory {
  String get nameEn {
    switch (this) {
      case FAQCategory.general:
        return 'General';
      case FAQCategory.orders:
        return 'Orders & Parcels';
      case FAQCategory.delivery:
        return 'Delivery';
      case FAQCategory.payment:
        return 'Payment';
      case FAQCategory.account:
        return 'Account';
    }
  }

  String get nameAr {
    switch (this) {
      case FAQCategory.general:
        return 'عام';
      case FAQCategory.orders:
        return 'الطلبات والطرود';
      case FAQCategory.delivery:
        return 'التوصيل';
      case FAQCategory.payment:
        return 'الدفع';
      case FAQCategory.account:
        return 'الحساب';
    }
  }

  String getName(String languageCode) {
    return languageCode == 'ar' ? nameAr : nameEn;
  }
}

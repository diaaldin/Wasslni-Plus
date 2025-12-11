import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:wasslni_plus/models/privacy_policy_model.dart';

/// Service to manage privacy policy versions and user acceptances
class PrivacyPolicyService {
  static final PrivacyPolicyService _instance =
      PrivacyPolicyService._internal();
  factory PrivacyPolicyService() => _instance;
  PrivacyPolicyService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _policiesCollection =>
      _firestore.collection('privacyPolicies');
  CollectionReference get _acceptancesCollection =>
      _firestore.collection('privacyPolicyAcceptances');

  /// Get the active privacy policy
  Future<PrivacyPolicyModel?> getActivePrivacyPolicy() async {
    try {
      final snapshot = await _policiesCollection
          .where('isActive', isEqualTo: true)
          .orderBy('effectiveDate', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        // Return default policy if none exists
        return _getDefaultPrivacyPolicy();
      }

      return PrivacyPolicyModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      debugPrint('Error getting active privacy policy: $e');
      return _getDefaultPrivacyPolicy();
    }
  }

  /// Get privacy policy by version
  Future<PrivacyPolicyModel?> getPrivacyPolicyByVersion(String version) async {
    try {
      final snapshot = await _policiesCollection
          .where('version', isEqualTo: version)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return PrivacyPolicyModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      debugPrint('Error getting privacy policy by version: $e');
      return null;
    }
  }

  /// Check if user has accepted the current privacy policy
  Future<bool> hasUserAcceptedCurrentPolicy(String userId) async {
    try {
      final currentPolicy = await getActivePrivacyPolicy();
      if (currentPolicy == null) return true; // No policy exists

      final snapshot = await _acceptancesCollection
          .where('userId', isEqualTo: userId)
          .where('policyVersion', isEqualTo: currentPolicy.version)
          .where('accepted', isEqualTo: true)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking user acceptance: $e');
      return false;
    }
  }

  /// Record user acceptance of privacy policy
  Future<void> recordUserAcceptance({
    required String userId,
    required String policyVersion,
    String ipAddress = '',
  }) async {
    try {
      final acceptance = PrivacyPolicyAcceptance(
        userId: userId,
        policyVersion: policyVersion,
        acceptedAt: DateTime.now(),
        ipAddress: ipAddress,
        accepted: true,
      );

      await _acceptancesCollection.add(acceptance.toMap());
      debugPrint(
          'Privacy policy acceptance recorded for user $userId, version $policyVersion');
    } catch (e) {
      debugPrint('Error recording privacy policy acceptance: $e');
      rethrow;
    }
  }

  /// Record user decline of privacy policy
  Future<void> recordUserDecline({
    required String userId,
    required String policyVersion,
    String ipAddress = '',
  }) async {
    try {
      final acceptance = PrivacyPolicyAcceptance(
        userId: userId,
        policyVersion: policyVersion,
        acceptedAt: DateTime.now(),
        ipAddress: ipAddress,
        accepted: false,
      );

      await _acceptancesCollection.add(acceptance.toMap());
      debugPrint(
          'Privacy policy decline recorded for user $userId, version $policyVersion');
    } catch (e) {
      debugPrint('Error recording privacy policy decline: $e');
      rethrow;
    }
  }

  /// Get user's privacy policy acceptance history
  Future<List<PrivacyPolicyAcceptance>> getUserAcceptanceHistory(
      String userId) async {
    try {
      final snapshot = await _acceptancesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('acceptedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PrivacyPolicyAcceptance.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Error getting user acceptance history: $e');
      return [];
    }
  }

  /// Create or update privacy policy (admin only)
  Future<void> createOrUpdatePrivacyPolicy(PrivacyPolicyModel policy) async {
    try {
      if (policy.id != null) {
        // Update existing
        await _policiesCollection.doc(policy.id).update(policy.toMap());
      } else {
        // Create new
        await _policiesCollection.add(policy.toMap());
      }
      debugPrint('Privacy policy ${policy.version} saved successfully');
    } catch (e) {
      debugPrint('Error saving privacy policy: $e');
      rethrow;
    }
  }

  /// Get default privacy policy (fallback)
  PrivacyPolicyModel _getDefaultPrivacyPolicy() {
    return PrivacyPolicyModel(
      version: '1.0',
      effectiveDate: DateTime(2024, 1, 1),
      contentAr: _getDefaultContentAr(),
      contentEn: _getDefaultContentEn(),
      isActive: true,
      createdAt: DateTime.now(),
    );
  }

  String _getDefaultContentAr() {
    return '''
# سياسة الخصوصية - وصلني بلس

آخر تحديث: ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}

## 1. جمع البيانات
نقوم بجمع المعلومات التالية:
- الاسم ورقم الهاتف
- عنوان التوصيل
- تفاصيل الطرود
- معلومات الدفع

## 2. استخدام البيانات
نستخدم بياناتك من أجل:
- تقديم خدمات التوصيل
- التواصل بشأن طرودك
- تحسين خدماتنا
- المعالجة المالية

## 3. مشاركة البيانات
نشارك بياناتك فقط مع:
- السعاة المعينين للتوصيل
- معالجي الدفع
- السلطات القانونية عند الضرورة

## 4. الاحتفاظ بالبيانات
نحتفظ ببياناتك طالما كان حسابك نشطًا وفقًا للمتطلبات القانونية.

## 5. حقوقك
لديك الحق في:
- الوصول إلى بياناتك
- تصحيح بياناتك
- حذف بياناتك
- سحب الموافقة

## اتصل بنا
للأسئلة حول هذه السياسة، اتصل بنا على:
البريد الإلكتروني: privacy@wasslniplus.com
الهاتف: 00972-0543596300
''';
  }

  String _getDefaultContentEn() {
    return '''
# Privacy Policy - Wasslni Plus

Last Updated: ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}

## 1. Data Collection
We collect the following information:
- Name and phone number
- Delivery address
- Parcel details
- Payment information

## 2. Data Usage
We use your data to:
- Provide delivery services
- Communicate about your parcels
- Improve our services
- Process payments

## 3. Data Sharing
We share your data only with:
- Assigned couriers for delivery
- Payment processors
- Legal authorities when required

## 4. Data Retention
We retain your data as long as your account is active and as required by law.

## 5. Your Rights
You have the right to:
- Access your data
- Correct your data
- Delete your data
- Withdraw consent

## Contact Us
For questions about this policy, contact us at:
Email: privacy@wasslniplus.com
Phone: 00972-0526041850
''';
  }
}

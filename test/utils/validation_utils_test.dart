import 'package:flutter_test/flutter_test.dart';
import 'package:wasslni_plus/utils/validation_utils.dart';

void main() {
  group('ValidationUtils', () {
    test('validateEmail works correctly', () {
      expect(ValidationUtils.validateEmail('test@example.com'), null);
      expect(ValidationUtils.validateEmail('invalid'),
          'Please enter a valid email address');
      expect(ValidationUtils.validateEmail(null), 'Email is required');
    });

    test('validatePassword enforces strong passwords', () {
      expect(ValidationUtils.validatePassword('weak'),
          'Password must be at least 6 characters');
      expect(ValidationUtils.validatePassword('abcde1'), null);
      expect(ValidationUtils.validatePassword('abcdef'),
          'Password must contain both letters and numbers');
      expect(ValidationUtils.validatePassword('123456'),
          'Password must contain both letters and numbers');
    });

    test('validatePhoneNumber works', () {
      expect(ValidationUtils.validatePhoneNumber('+1234567890'), null);
      expect(ValidationUtils.validatePhoneNumber('0501234567'), null);
      expect(ValidationUtils.validatePhoneNumber('123'),
          'Please enter a valid phone number (e.g., +1234567890)');
    });

    test('sanitizeString removes xss', () {
      expect(
          ValidationUtils.sanitizeString('<script>alert()</script>Hi'), 'Hi');
      expect(ValidationUtils.sanitizeString('   Trim   '), 'Trim');
    });

    test('validatePrice works', () {
      expect(ValidationUtils.validatePrice('100'), null);
      expect(
          ValidationUtils.validatePrice('-1'), 'Price must be greater than 0');
      expect(ValidationUtils.validatePrice(''), 'Price is required');
      expect(
          ValidationUtils.validatePrice('abc'), 'Please enter a valid amount');
    });
  });
}

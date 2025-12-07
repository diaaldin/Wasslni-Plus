/// Validation utility class for input validation
class ValidationUtils {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    // Check for at least one letter and one number
    if (!RegExp(r'[a-zA-Z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain both letters and numbers';
    }

    return null;
  }

  /// Validate phone number (international format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces, dashes, and parentheses
    final cleanedValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it starts with + and has 10-15 digits
    final phoneRegex = RegExp(r'^\+?[1-9]\d{9,14}$');

    if (!phoneRegex.hasMatch(cleanedValue)) {
      return 'Please enter a valid phone number (e.g., +1234567890)';
    }

    return null;
  }

  /// Validate name (letters and spaces only)
  static String? validateName(String? value, {required String fieldName}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < 2) {
      return '$fieldName must be at least 2 characters';
    }

    if (value.length > 50) {
      return '$fieldName must be less than 50 characters';
    }

    final nameRegex =
        RegExp(r"^[a-zA-Z\u0600-\u06FF\s]+$"); // Latin and Arabic letters

    if (!nameRegex.hasMatch(value)) {
      return '$fieldName can only contain letters and spaces';
    }

    return null;
  }

  /// Validate address
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }

    if (value.length < 10) {
      return 'Address must be at least 10 characters';
    }

    if (value.length > 200) {
      return 'Address must be less than 200 characters';
    }

    return null;
  }

  /// Validate parcel weight
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }

    final weight = double.tryParse(value);

    if (weight == null) {
      return 'Please enter a valid number';
    }

    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }

    if (weight > 100) {
      return 'Weight cannot exceed 100 kg';
    }

    return null;
  }

  /// Validate delivery fee
  static String? validateDeliveryFee(String? value) {
    if (value == null || value.isEmpty) {
      return 'Delivery fee is required';
    }

    final fee = double.tryParse(value);

    if (fee == null) {
      return 'Please enter a valid amount';
    }

    if (fee < 0) {
      return 'Delivery fee cannot be negative';
    }

    if (fee > 10000) {
      return 'Delivery fee seems too high';
    }

    return null;
  }

  /// Validate barcode format
  static String? validateBarcode(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Barcode is optional (will be generated)
    }

    if (value.length < 5) {
      return 'Barcode must be at least 5 characters';
    }

    if (value.length > 50) {
      return 'Barcode must be less than 50 characters';
    }

    // Allow alphanumeric and hyphens only
    final barcodeRegex = RegExp(r'^[A-Za-z0-9\-]+$');

    if (!barcodeRegex.hasMatch(value)) {
      return 'Barcode can only contain letters, numbers, and hyphens';
    }

    return null;
  }

  /// Validate notes/description
  static String? validateNotes(String? value, {int maxLength = 500}) {
    if (value == null || value.isEmpty) {
      return null; // Notes are optional
    }

    if (value.length > maxLength) {
      return 'Notes must be less than $maxLength characters';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate selection from dropdown
  static String? validateSelection(dynamic value, String fieldName) {
    if (value == null) {
      return 'Please select $fieldName';
    }
    return null;
  }

  /// Validate price/amount
  static String? validatePrice(String? value, {bool allowZero = false}) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);

    if (price == null) {
      return 'Please enter a valid amount';
    }

    if (!allowZero && price <= 0) {
      return 'Price must be greater than 0';
    }

    if (allowZero && price < 0) {
      return 'Price cannot be negative';
    }

    if (price > 1000000) {
      return 'Price seems too high';
    }

    return null;
  }

  /// Sanitize string input (remove dangerous characters)
  static String sanitizeString(String input) {
    // Remove HTML tags
    String sanitized = input.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove script tags and their content
    sanitized = sanitized.replaceAll(
        RegExp(r'<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>',
            caseSensitive: false),
        '');

    // Trim whitespace
    sanitized = sanitized.trim();

    return sanitized;
  }

  /// Validate and sanitize user input before Firestore write
  static Map<String, dynamic> sanitizeFirestoreData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};

    data.forEach((key, value) {
      if (value is String) {
        sanitized[key] = sanitizeString(value);
      } else if (value is Map) {
        sanitized[key] = sanitizeFirestoreData(value as Map<String, dynamic>);
      } else if (value is List) {
        sanitized[key] = value.map((item) {
          if (item is String) {
            return sanitizeString(item);
          } else if (item is Map) {
            return sanitizeFirestoreData(item as Map<String, dynamic>);
          }
          return item;
        }).toList();
      } else {
        sanitized[key] = value;
      }
    });

    return sanitized;
  }

  /// Validate rating (1-5 stars)
  static String? validateRating(double? value) {
    if (value == null) {
      return 'Rating is required';
    }

    if (value < 1 || value > 5) {
      return 'Rating must be between 1 and 5';
    }

    return null;
  }

  /// Validate coordinates
  static String? validateCoordinates(double? lat, double? lng) {
    if (lat == null || lng == null) {
      return 'Location coordinates are required';
    }

    if (lat < -90 || lat > 90) {
      return 'Invalid latitude';
    }

    if (lng < -180 || lng > 180) {
      return 'Invalid longitude';
    }

    return null;
  }
}

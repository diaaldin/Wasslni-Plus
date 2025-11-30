// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get privacy_intro =>
      'We are committed to protecting your data privacy and security. This policy explains how we handle your personal information.';

  @override
  String get data_collection => 'Data Collection';

  @override
  String get data_collection_desc =>
      'We collect data to provide and improve our services, personalize your experience, and keep you informed.';

  @override
  String get data_usage => 'Data Usage';

  @override
  String get data_usage_desc =>
      'Collected data is used solely to enhance app functionality, ensure security, and meet legal obligations.';

  @override
  String get data_sharing => 'Data Sharing';

  @override
  String get data_sharing_desc =>
      'Your data will not be shared with third parties unless legally required.';

  @override
  String get data_retention => 'Data Retention';

  @override
  String get data_retention_desc =>
      'We retain your data as long as you use our services or as required by law. You can request data deletion.';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get user_rights => 'User Rights';

  @override
  String get user_rights_desc =>
      'You have the right to access, modify, and delete your data. Contact us for any concerns or requests.';

  @override
  String get thank_you =>
      'Thank you for trusting us with your information. We strive to keep your data safe and transparent.';

  @override
  String get contact_support =>
      'For more details, feel free to contact our support team.';

  @override
  String get merchant_dashboard => 'Merchant Dashboard';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get sunny_mode => 'Sunny Mode';

  @override
  String get language => 'Language';

  @override
  String get main => 'Main';

  @override
  String get parcels => 'Parcels';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get general_serach_hint => 'Search...';

  @override
  String get clear_selection => 'Clear selection';

  @override
  String get add_parcel => 'Add Parcel';

  @override
  String get recipient_name => 'Recipient Name';

  @override
  String get recipient_phone => 'Recipient Phone';

  @override
  String get alt_phone => 'Alternate Phone (Optional)';

  @override
  String get region => 'Region';

  @override
  String get address => 'Address, City - Street';

  @override
  String get parcel_price => 'Parcel Price (without delivery)';

  @override
  String get parcel_description => 'Parcel Description';

  @override
  String get attach_barcode => 'Attach Barcode';

  @override
  String barcode_label(Object code) {
    return 'Barcode: $code';
  }

  @override
  String get total_price_label => 'Total Price (with delivery)';

  @override
  String get save_parcel => 'Save Parcel';

  @override
  String get choose_region_warning => 'Please select a region';

  @override
  String get invalid_price =>
      'Price must be a number greater than or equal to 0';

  @override
  String get enter_price => 'Please enter a price';

  @override
  String get enter_recipient_name => 'Please enter recipient name';

  @override
  String get enter_phone => 'Please enter recipient phone';

  @override
  String get invalid_phone => 'Invalid phone number';

  @override
  String get enter_address => 'Enter the address (City - Street)';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get joinUs => 'Join Us';

  @override
  String get joinUsDescription =>
      'This page is for business owners who want to join us.';

  @override
  String get acceptPolicyStart => 'I accept the ';

  @override
  String get dataPolicy => 'Data Policy';

  @override
  String get name => 'Name';

  @override
  String get message => 'Message';

  @override
  String get submit => 'Submit';

  @override
  String get logout => 'Logout';

  @override
  String get validation_phone_required => 'Please enter your phone number';

  @override
  String get no_internet_connection => '⚠ No internet connection';

  @override
  String get validation_phone_invalid =>
      'Phone number must be exactly 10 digits';

  @override
  String get app_name => 'Wasslni Plus';

  @override
  String get app_tagline => 'Fast & Reliable Delivery';

  @override
  String get welcome_to_app => 'Welcome to Wasslni Plus';
}

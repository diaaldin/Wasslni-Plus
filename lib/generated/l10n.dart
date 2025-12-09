// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `We are committed to protecting your data privacy and security. This policy explains how we handle your personal information.`
  String get privacy_intro {
    return Intl.message(
      'We are committed to protecting your data privacy and security. This policy explains how we handle your personal information.',
      name: 'privacy_intro',
      desc: '',
      args: [],
    );
  }

  /// `Data Collection`
  String get data_collection {
    return Intl.message(
      'Data Collection',
      name: 'data_collection',
      desc: '',
      args: [],
    );
  }

  /// `We collect data to provide and improve our services, personalize your experience, and keep you informed.`
  String get data_collection_desc {
    return Intl.message(
      'We collect data to provide and improve our services, personalize your experience, and keep you informed.',
      name: 'data_collection_desc',
      desc: '',
      args: [],
    );
  }

  /// `Data Usage`
  String get data_usage {
    return Intl.message('Data Usage', name: 'data_usage', desc: '', args: []);
  }

  /// `Collected data is used solely to enhance app functionality, ensure security, and meet legal obligations.`
  String get data_usage_desc {
    return Intl.message(
      'Collected data is used solely to enhance app functionality, ensure security, and meet legal obligations.',
      name: 'data_usage_desc',
      desc: '',
      args: [],
    );
  }

  /// `Data Sharing`
  String get data_sharing {
    return Intl.message(
      'Data Sharing',
      name: 'data_sharing',
      desc: '',
      args: [],
    );
  }

  /// `Your data will not be shared with third parties unless legally required.`
  String get data_sharing_desc {
    return Intl.message(
      'Your data will not be shared with third parties unless legally required.',
      name: 'data_sharing_desc',
      desc: '',
      args: [],
    );
  }

  /// `Data Retention`
  String get data_retention {
    return Intl.message(
      'Data Retention',
      name: 'data_retention',
      desc: '',
      args: [],
    );
  }

  /// `We retain your data as long as you use our services or as required by law. You can request data deletion.`
  String get data_retention_desc {
    return Intl.message(
      'We retain your data as long as you use our services or as required by law. You can request data deletion.',
      name: 'data_retention_desc',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `User Rights`
  String get user_rights {
    return Intl.message('User Rights', name: 'user_rights', desc: '', args: []);
  }

  /// `You have the right to access, modify, and delete your data. Contact us for any concerns or requests.`
  String get user_rights_desc {
    return Intl.message(
      'You have the right to access, modify, and delete your data. Contact us for any concerns or requests.',
      name: 'user_rights_desc',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for trusting us with your information. We strive to keep your data safe and transparent.`
  String get thank_you {
    return Intl.message(
      'Thank you for trusting us with your information. We strive to keep your data safe and transparent.',
      name: 'thank_you',
      desc: '',
      args: [],
    );
  }

  /// `For more details, feel free to contact our support team.`
  String get contact_support {
    return Intl.message(
      'For more details, feel free to contact our support team.',
      name: 'contact_support',
      desc: '',
      args: [],
    );
  }

  /// `Merchant Dashboard`
  String get merchant_dashboard {
    return Intl.message(
      'Merchant Dashboard',
      name: 'merchant_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message('Dark Mode', name: 'dark_mode', desc: '', args: []);
  }

  /// `Sunny Mode`
  String get sunny_mode {
    return Intl.message('Sunny Mode', name: 'sunny_mode', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Main`
  String get main {
    return Intl.message('Main', name: 'main', desc: '', args: []);
  }

  /// `Parcels`
  String get parcels {
    return Intl.message('Parcels', name: 'parcels', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get general_serach_hint {
    return Intl.message(
      'Search...',
      name: 'general_serach_hint',
      desc: '',
      args: [],
    );
  }

  /// `Clear selection`
  String get clear_selection {
    return Intl.message(
      'Clear selection',
      name: 'clear_selection',
      desc: '',
      args: [],
    );
  }

  /// `Add Parcel`
  String get add_parcel {
    return Intl.message('Add Parcel', name: 'add_parcel', desc: '', args: []);
  }

  /// `Recipient Name`
  String get recipient_name {
    return Intl.message(
      'Recipient Name',
      name: 'recipient_name',
      desc: '',
      args: [],
    );
  }

  /// `Recipient Phone`
  String get recipient_phone {
    return Intl.message(
      'Recipient Phone',
      name: 'recipient_phone',
      desc: '',
      args: [],
    );
  }

  /// `Alternate Phone (Optional)`
  String get alt_phone {
    return Intl.message(
      'Alternate Phone (Optional)',
      name: 'alt_phone',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get region {
    return Intl.message('Region', name: 'region', desc: '', args: []);
  }

  /// `Address, City - Street`
  String get address {
    return Intl.message(
      'Address, City - Street',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Parcel Price (without delivery)`
  String get parcel_price {
    return Intl.message(
      'Parcel Price (without delivery)',
      name: 'parcel_price',
      desc: '',
      args: [],
    );
  }

  /// `Parcel Description`
  String get parcel_description {
    return Intl.message(
      'Parcel Description',
      name: 'parcel_description',
      desc: '',
      args: [],
    );
  }

  /// `Attach Barcode`
  String get attach_barcode {
    return Intl.message(
      'Attach Barcode',
      name: 'attach_barcode',
      desc: '',
      args: [],
    );
  }

  /// `Barcode: {code}`
  String barcode_label(Object code) {
    return Intl.message(
      'Barcode: $code',
      name: 'barcode_label',
      desc: '',
      args: [code],
    );
  }

  /// `Total Price (with delivery)`
  String get total_price_label {
    return Intl.message(
      'Total Price (with delivery)',
      name: 'total_price_label',
      desc: '',
      args: [],
    );
  }

  /// `Save Parcel`
  String get save_parcel {
    return Intl.message('Save Parcel', name: 'save_parcel', desc: '', args: []);
  }

  /// `Please select a region`
  String get choose_region_warning {
    return Intl.message(
      'Please select a region',
      name: 'choose_region_warning',
      desc: '',
      args: [],
    );
  }

  /// `Price must be a number greater than or equal to 0`
  String get invalid_price {
    return Intl.message(
      'Price must be a number greater than or equal to 0',
      name: 'invalid_price',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a price`
  String get enter_price {
    return Intl.message(
      'Please enter a price',
      name: 'enter_price',
      desc: '',
      args: [],
    );
  }

  /// `Please enter recipient name`
  String get enter_recipient_name {
    return Intl.message(
      'Please enter recipient name',
      name: 'enter_recipient_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter recipient phone`
  String get enter_phone {
    return Intl.message(
      'Please enter recipient phone',
      name: 'enter_phone',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get invalid_phone {
    return Intl.message(
      'Invalid phone number',
      name: 'invalid_phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter the address (City - Street)`
  String get enter_address {
    return Intl.message(
      'Enter the address (City - Street)',
      name: 'enter_address',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Join Us`
  String get joinUs {
    return Intl.message('Join Us', name: 'joinUs', desc: '', args: []);
  }

  /// `This page is for business owners who want to join us.`
  String get joinUsDescription {
    return Intl.message(
      'This page is for business owners who want to join us.',
      name: 'joinUsDescription',
      desc: '',
      args: [],
    );
  }

  /// `I accept the `
  String get acceptPolicyStart {
    return Intl.message(
      'I accept the ',
      name: 'acceptPolicyStart',
      desc: '',
      args: [],
    );
  }

  /// `Data Policy`
  String get dataPolicy {
    return Intl.message('Data Policy', name: 'dataPolicy', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Please enter your phone number`
  String get validation_phone_required {
    return Intl.message(
      'Please enter your phone number',
      name: 'validation_phone_required',
      desc: '',
      args: [],
    );
  }

  /// `⚠ No internet connection`
  String get no_internet_connection {
    return Intl.message(
      '⚠ No internet connection',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Phone number must be exactly 10 digits`
  String get validation_phone_invalid {
    return Intl.message(
      'Phone number must be exactly 10 digits',
      name: 'validation_phone_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Wasslni Plus`
  String get app_name {
    return Intl.message('Wasslni Plus', name: 'app_name', desc: '', args: []);
  }

  /// `Fast & Reliable Delivery`
  String get app_tagline {
    return Intl.message(
      'Fast & Reliable Delivery',
      name: 'app_tagline',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Wasslni Plus`
  String get welcome_to_app {
    return Intl.message(
      'Welcome to Wasslni Plus',
      name: 'welcome_to_app',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Please enter email`
  String get enter_email {
    return Intl.message(
      'Please enter email',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address`
  String get invalid_email {
    return Intl.message(
      'Invalid email address',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get enter_password {
    return Intl.message(
      'Please enter password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Role`
  String get role {
    return Intl.message('Role', name: 'role', desc: '', args: []);
  }

  /// `Merchant`
  String get merchant {
    return Intl.message('Merchant', name: 'merchant', desc: '', args: []);
  }

  /// `Courier`
  String get courier {
    return Intl.message('Courier', name: 'courier', desc: '', args: []);
  }

  /// `Customer`
  String get customer {
    return Intl.message('Customer', name: 'customer', desc: '', args: []);
  }

  /// `Login Failed`
  String get login_failed {
    return Intl.message(
      'Login Failed',
      name: 'login_failed',
      desc: '',
      args: [],
    );
  }

  /// `Registration Failed`
  String get registration_failed {
    return Intl.message(
      'Registration Failed',
      name: 'registration_failed',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Already have an account? Login`
  String get already_have_account {
    return Intl.message(
      'Already have an account? Login',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? Register`
  String get dont_have_account {
    return Intl.message(
      'Don\'t have an account? Register',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get logout_confirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logout_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Error logging out. Please try again.`
  String get logout_error {
    return Intl.message(
      'Error logging out. Please try again.',
      name: 'logout_error',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `In Transit`
  String get in_transit {
    return Intl.message('In Transit', name: 'in_transit', desc: '', args: []);
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Returned`
  String get returned {
    return Intl.message('Returned', name: 'returned', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `Monthly Revenue`
  String get monthly_revenue {
    return Intl.message(
      'Monthly Revenue',
      name: 'monthly_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Recent Parcels`
  String get recent_parcels {
    return Intl.message(
      'Recent Parcels',
      name: 'recent_parcels',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get view_all {
    return Intl.message('View All', name: 'view_all', desc: '', args: []);
  }

  /// `No parcels yet`
  String get no_parcels_yet {
    return Intl.message(
      'No parcels yet',
      name: 'no_parcels_yet',
      desc: '',
      args: [],
    );
  }

  /// `Recipient`
  String get recipient {
    return Intl.message('Recipient', name: 'recipient', desc: '', args: []);
  }

  /// `Delivery Region`
  String get delivery_region {
    return Intl.message(
      'Delivery Region',
      name: 'delivery_region',
      desc: '',
      args: [],
    );
  }

  /// `Mark all as read`
  String get mark_all_read {
    return Intl.message(
      'Mark all as read',
      name: 'mark_all_read',
      desc: '',
      args: [],
    );
  }

  /// `No notifications`
  String get no_notifications {
    return Intl.message(
      'No notifications',
      name: 'no_notifications',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Unread`
  String get unread {
    return Intl.message('Unread', name: 'unread', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Edit Parcel`
  String get edit_parcel {
    return Intl.message('Edit Parcel', name: 'edit_parcel', desc: '', args: []);
  }

  /// `Update Parcel`
  String get update_parcel {
    return Intl.message(
      'Update Parcel',
      name: 'update_parcel',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Parcel`
  String get cancel_parcel {
    return Intl.message(
      'Cancel Parcel',
      name: 'cancel_parcel',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this parcel?`
  String get confirm_cancel_parcel {
    return Intl.message(
      'Are you sure you want to cancel this parcel?',
      name: 'confirm_cancel_parcel',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation Reason`
  String get cancellation_reason {
    return Intl.message(
      'Cancellation Reason',
      name: 'cancellation_reason',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Cancel`
  String get yes_cancel {
    return Intl.message('Yes, Cancel', name: 'yes_cancel', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Parcel updated successfully`
  String get parcel_updated_success {
    return Intl.message(
      'Parcel updated successfully',
      name: 'parcel_updated_success',
      desc: '',
      args: [],
    );
  }

  /// `Parcel created successfully`
  String get parcel_created_success {
    return Intl.message(
      'Parcel created successfully',
      name: 'parcel_created_success',
      desc: '',
      args: [],
    );
  }

  /// `Parcel cancelled successfully`
  String get parcel_cancelled_success {
    return Intl.message(
      'Parcel cancelled successfully',
      name: 'parcel_cancelled_success',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String error_occurred(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'error_occurred',
      desc: '',
      args: [error],
    );
  }

  /// `Parcel Details`
  String get parcel_details {
    return Intl.message(
      'Parcel Details',
      name: 'parcel_details',
      desc: '',
      args: [],
    );
  }

  /// `Status: {status}`
  String status_label(Object status) {
    return Intl.message(
      'Status: $status',
      name: 'status_label',
      desc: '',
      args: [status],
    );
  }

  /// `Delivery Fee`
  String get delivery_fee {
    return Intl.message(
      'Delivery Fee',
      name: 'delivery_fee',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Note: {note}`
  String note_label(Object note) {
    return Intl.message(
      'Note: $note',
      name: 'note_label',
      desc: '',
      args: [note],
    );
  }

  /// `Weight (kg)`
  String get weight {
    return Intl.message('Weight (kg)', name: 'weight', desc: '', args: []);
  }

  /// `Dimensions (cm)`
  String get dimensions {
    return Intl.message(
      'Dimensions (cm)',
      name: 'dimensions',
      desc: '',
      args: [],
    );
  }

  /// `Length`
  String get length {
    return Intl.message('Length', name: 'length', desc: '', args: []);
  }

  /// `Width`
  String get width {
    return Intl.message('Width', name: 'width', desc: '', args: []);
  }

  /// `Height`
  String get height {
    return Intl.message('Height', name: 'height', desc: '', args: []);
  }

  /// `Delivery Instructions (Optional)`
  String get delivery_instructions {
    return Intl.message(
      'Delivery Instructions (Optional)',
      name: 'delivery_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message('Optional', name: 'optional', desc: '', args: []);
  }

  /// `Images`
  String get images {
    return Intl.message('Images', name: 'images', desc: '', args: []);
  }

  /// `Add Image`
  String get add_image {
    return Intl.message('Add Image', name: 'add_image', desc: '', args: []);
  }

  /// `Preferred Delivery Time`
  String get delivery_time_slot {
    return Intl.message(
      'Preferred Delivery Time',
      name: 'delivery_time_slot',
      desc: '',
      args: [],
    );
  }

  /// `Morning (9AM - 12PM)`
  String get morning {
    return Intl.message(
      'Morning (9AM - 12PM)',
      name: 'morning',
      desc: '',
      args: [],
    );
  }

  /// `Afternoon (12PM - 5PM)`
  String get afternoon {
    return Intl.message(
      'Afternoon (12PM - 5PM)',
      name: 'afternoon',
      desc: '',
      args: [],
    );
  }

  /// `Evening (5PM - 9PM)`
  String get evening {
    return Intl.message(
      'Evening (5PM - 9PM)',
      name: 'evening',
      desc: '',
      args: [],
    );
  }

  /// `Any Time`
  String get anytime {
    return Intl.message('Any Time', name: 'anytime', desc: '', args: []);
  }

  /// `Requires Recipient Signature`
  String get requires_signature {
    return Intl.message(
      'Requires Recipient Signature',
      name: 'requires_signature',
      desc: '',
      args: [],
    );
  }

  /// `Courier must collect signature on delivery`
  String get signature_description {
    return Intl.message(
      'Courier must collect signature on delivery',
      name: 'signature_description',
      desc: '',
      args: [],
    );
  }

  /// `Print Label`
  String get print_label {
    return Intl.message('Print Label', name: 'print_label', desc: '', args: []);
  }

  /// `Print Receipt`
  String get print_receipt {
    return Intl.message(
      'Print Receipt',
      name: 'print_receipt',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Label`
  String get shipping_label {
    return Intl.message(
      'Shipping Label',
      name: 'shipping_label',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `Parcel Information`
  String get parcel_info {
    return Intl.message(
      'Parcel Information',
      name: 'parcel_info',
      desc: '',
      args: [],
    );
  }

  /// `Scan to Track`
  String get scan_to_track {
    return Intl.message(
      'Scan to Track',
      name: 'scan_to_track',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message('Export', name: 'export', desc: '', args: []);
  }

  /// `Export to PDF`
  String get export_pdf {
    return Intl.message(
      'Export to PDF',
      name: 'export_pdf',
      desc: '',
      args: [],
    );
  }

  /// `Export to Excel`
  String get export_excel {
    return Intl.message(
      'Export to Excel',
      name: 'export_excel',
      desc: '',
      args: [],
    );
  }

  /// `Export completed successfully`
  String get export_success {
    return Intl.message(
      'Export completed successfully',
      name: 'export_success',
      desc: '',
      args: [],
    );
  }

  /// `Export failed`
  String get export_error {
    return Intl.message(
      'Export failed',
      name: 'export_error',
      desc: '',
      args: [],
    );
  }

  /// `Parcels Report`
  String get parcels_report {
    return Intl.message(
      'Parcels Report',
      name: 'parcels_report',
      desc: '',
      args: [],
    );
  }

  /// `Total Parcels`
  String get total_parcels {
    return Intl.message(
      'Total Parcels',
      name: 'total_parcels',
      desc: '',
      args: [],
    );
  }

  /// `Date Range`
  String get date_range {
    return Intl.message('Date Range', name: 'date_range', desc: '', args: []);
  }

  /// `Bulk Upload`
  String get bulk_upload {
    return Intl.message('Bulk Upload', name: 'bulk_upload', desc: '', args: []);
  }

  /// `Upload CSV File`
  String get upload_csv {
    return Intl.message(
      'Upload CSV File',
      name: 'upload_csv',
      desc: '',
      args: [],
    );
  }

  /// `Download Template`
  String get download_template {
    return Intl.message(
      'Download Template',
      name: 'download_template',
      desc: '',
      args: [],
    );
  }

  /// `Select File`
  String get select_file {
    return Intl.message('Select File', name: 'select_file', desc: '', args: []);
  }

  /// `Upload completed successfully`
  String get upload_success {
    return Intl.message(
      'Upload completed successfully',
      name: 'upload_success',
      desc: '',
      args: [],
    );
  }

  /// `Upload failed`
  String get upload_error {
    return Intl.message(
      'Upload failed',
      name: 'upload_error',
      desc: '',
      args: [],
    );
  }

  /// `Processing file...`
  String get processing_file {
    return Intl.message(
      'Processing file...',
      name: 'processing_file',
      desc: '',
      args: [],
    );
  }

  /// `Parcels imported`
  String get parcels_imported {
    return Intl.message(
      'Parcels imported',
      name: 'parcels_imported',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message('Reports', name: 'reports', desc: '', args: []);
  }

  /// `Analytics`
  String get analytics {
    return Intl.message('Analytics', name: 'analytics', desc: '', args: []);
  }

  /// `Monthly Report`
  String get monthly_report {
    return Intl.message(
      'Monthly Report',
      name: 'monthly_report',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Statistics`
  String get delivery_statistics {
    return Intl.message(
      'Delivery Statistics',
      name: 'delivery_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Revenue Overview`
  String get revenue_overview {
    return Intl.message(
      'Revenue Overview',
      name: 'revenue_overview',
      desc: '',
      args: [],
    );
  }

  /// `Performance Metrics`
  String get performance_metrics {
    return Intl.message(
      'Performance Metrics',
      name: 'performance_metrics',
      desc: '',
      args: [],
    );
  }

  /// `Select Month`
  String get select_month {
    return Intl.message(
      'Select Month',
      name: 'select_month',
      desc: '',
      args: [],
    );
  }

  /// `Total Deliveries`
  String get total_deliveries {
    return Intl.message(
      'Total Deliveries',
      name: 'total_deliveries',
      desc: '',
      args: [],
    );
  }

  /// `Successful Deliveries`
  String get successful_deliveries {
    return Intl.message(
      'Successful Deliveries',
      name: 'successful_deliveries',
      desc: '',
      args: [],
    );
  }

  /// `Failed Deliveries`
  String get failed_deliveries {
    return Intl.message(
      'Failed Deliveries',
      name: 'failed_deliveries',
      desc: '',
      args: [],
    );
  }

  /// `Pending Deliveries`
  String get pending_deliveries {
    return Intl.message(
      'Pending Deliveries',
      name: 'pending_deliveries',
      desc: '',
      args: [],
    );
  }

  /// `Success Rate`
  String get success_rate {
    return Intl.message(
      'Success Rate',
      name: 'success_rate',
      desc: '',
      args: [],
    );
  }

  /// `Average Delivery Time`
  String get average_delivery_time {
    return Intl.message(
      'Average Delivery Time',
      name: 'average_delivery_time',
      desc: '',
      args: [],
    );
  }

  /// `Total Revenue`
  String get total_revenue {
    return Intl.message(
      'Total Revenue',
      name: 'total_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Fees Collected`
  String get delivery_fees_collected {
    return Intl.message(
      'Delivery Fees Collected',
      name: 'delivery_fees_collected',
      desc: '',
      args: [],
    );
  }

  /// `Success Rate Trend`
  String get success_rate_trend {
    return Intl.message(
      'Success Rate Trend',
      name: 'success_rate_trend',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Success Rate`
  String get weekly_success_rate {
    return Intl.message(
      'Weekly Success Rate',
      name: 'weekly_success_rate',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get no_data_available {
    return Intl.message(
      'No data available',
      name: 'no_data_available',
      desc: '',
      args: [],
    );
  }

  /// `Top Customers`
  String get top_customers {
    return Intl.message(
      'Top Customers',
      name: 'top_customers',
      desc: '',
      args: [],
    );
  }

  /// `Parcels Delivered`
  String get parcels_delivered {
    return Intl.message(
      'Parcels Delivered',
      name: 'parcels_delivered',
      desc: '',
      args: [],
    );
  }

  /// `Notification Settings`
  String get notification_settings {
    return Intl.message(
      'Notification Settings',
      name: 'notification_settings',
      desc: '',
      args: [],
    );
  }

  /// `Parcel Updates`
  String get parcel_updates {
    return Intl.message(
      'Parcel Updates',
      name: 'parcel_updates',
      desc: '',
      args: [],
    );
  }

  /// `Get notified when parcel status changes`
  String get parcel_updates_desc {
    return Intl.message(
      'Get notified when parcel status changes',
      name: 'parcel_updates_desc',
      desc: '',
      args: [],
    );
  }

  /// `Promotional Offers`
  String get promotional_offers {
    return Intl.message(
      'Promotional Offers',
      name: 'promotional_offers',
      desc: '',
      args: [],
    );
  }

  /// `Receive updates about new features and offers`
  String get promotional_offers_desc {
    return Intl.message(
      'Receive updates about new features and offers',
      name: 'promotional_offers_desc',
      desc: '',
      args: [],
    );
  }

  /// `System Announcements`
  String get system_announcements {
    return Intl.message(
      'System Announcements',
      name: 'system_announcements',
      desc: '',
      args: [],
    );
  }

  /// `Important updates about the platform`
  String get system_announcements_desc {
    return Intl.message(
      'Important updates about the platform',
      name: 'system_announcements_desc',
      desc: '',
      args: [],
    );
  }

  /// `Courier Dashboard`
  String get courier_dashboard {
    return Intl.message(
      'Courier Dashboard',
      name: 'courier_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Daily Assignments`
  String get daily_assignments {
    return Intl.message(
      'Daily Assignments',
      name: 'daily_assignments',
      desc: '',
      args: [],
    );
  }

  /// `Today's Deliveries`
  String get todays_deliveries {
    return Intl.message(
      'Today\'s Deliveries',
      name: 'todays_deliveries',
      desc: '',
      args: [],
    );
  }

  /// `Earnings Today`
  String get earnings_today {
    return Intl.message(
      'Earnings Today',
      name: 'earnings_today',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Pending Pickup`
  String get pending_pickup {
    return Intl.message(
      'Pending Pickup',
      name: 'pending_pickup',
      desc: '',
      args: [],
    );
  }

  /// `My Route`
  String get my_route {
    return Intl.message('My Route', name: 'my_route', desc: '', args: []);
  }

  /// `Start Delivery`
  String get start_delivery {
    return Intl.message(
      'Start Delivery',
      name: 'start_delivery',
      desc: '',
      args: [],
    );
  }

  /// `No assignments for today`
  String get no_assignments {
    return Intl.message(
      'No assignments for today',
      name: 'no_assignments',
      desc: '',
      args: [],
    );
  }

  /// `Route Map`
  String get route_map {
    return Intl.message('Route Map', name: 'route_map', desc: '', args: []);
  }

  /// `Delivery Points`
  String get delivery_points {
    return Intl.message(
      'Delivery Points',
      name: 'delivery_points',
      desc: '',
      args: [],
    );
  }

  /// `Navigate`
  String get navigate {
    return Intl.message('Navigate', name: 'navigate', desc: '', args: []);
  }

  /// `Map View`
  String get map_view {
    return Intl.message('Map View', name: 'map_view', desc: '', args: []);
  }

  /// `List View`
  String get list_view {
    return Intl.message('List View', name: 'list_view', desc: '', args: []);
  }

  /// `Delivery Location`
  String get delivery_location {
    return Intl.message(
      'Delivery Location',
      name: 'delivery_location',
      desc: '',
      args: [],
    );
  }

  /// `Current Location`
  String get current_location {
    return Intl.message(
      'Current Location',
      name: 'current_location',
      desc: '',
      args: [],
    );
  }

  /// `Show Route`
  String get show_route {
    return Intl.message('Show Route', name: 'show_route', desc: '', args: []);
  }

  /// `Hide Route`
  String get hide_route {
    return Intl.message('Hide Route', name: 'hide_route', desc: '', args: []);
  }

  /// `Optimized Route`
  String get optimized_route {
    return Intl.message(
      'Optimized Route',
      name: 'optimized_route',
      desc: '',
      args: [],
    );
  }

  /// `Distance`
  String get distance {
    return Intl.message('Distance', name: 'distance', desc: '', args: []);
  }

  /// `Estimated Time`
  String get estimated_time {
    return Intl.message(
      'Estimated Time',
      name: 'estimated_time',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Earnings`
  String get weekly_earnings {
    return Intl.message(
      'Weekly Earnings',
      name: 'weekly_earnings',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Earnings`
  String get monthly_earnings {
    return Intl.message(
      'Monthly Earnings',
      name: 'monthly_earnings',
      desc: '',
      args: [],
    );
  }

  /// `Total Earnings`
  String get total_earnings {
    return Intl.message(
      'Total Earnings',
      name: 'total_earnings',
      desc: '',
      args: [],
    );
  }

  /// `Earnings Breakdown`
  String get earnings_breakdown {
    return Intl.message(
      'Earnings Breakdown',
      name: 'earnings_breakdown',
      desc: '',
      args: [],
    );
  }

  /// `Today's Performance`
  String get todays_performance {
    return Intl.message(
      'Today\'s Performance',
      name: 'todays_performance',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Success Rate`
  String get delivery_success_rate {
    return Intl.message(
      'Delivery Success Rate',
      name: 'delivery_success_rate',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get failed {
    return Intl.message('Failed', name: 'failed', desc: '', args: []);
  }

  /// `minutes`
  String get minutes {
    return Intl.message('minutes', name: 'minutes', desc: '', args: []);
  }

  /// `hours`
  String get hours {
    return Intl.message('hours', name: 'hours', desc: '', args: []);
  }

  /// `days`
  String get days {
    return Intl.message('days', name: 'days', desc: '', args: []);
  }

  /// `View Details`
  String get view_details {
    return Intl.message(
      'View Details',
      name: 'view_details',
      desc: '',
      args: [],
    );
  }

  /// `Performance`
  String get performance {
    return Intl.message('Performance', name: 'performance', desc: '', args: []);
  }

  /// `This Week`
  String get this_week {
    return Intl.message('This Week', name: 'this_week', desc: '', args: []);
  }

  /// `This Month`
  String get this_month {
    return Intl.message('This Month', name: 'this_month', desc: '', args: []);
  }

  /// `Earnings Trend`
  String get earnings_trend {
    return Intl.message(
      'Earnings Trend',
      name: 'earnings_trend',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message('Statistics', name: 'statistics', desc: '', args: []);
  }

  /// `Delivery Queue`
  String get delivery_queue {
    return Intl.message(
      'Delivery Queue',
      name: 'delivery_queue',
      desc: '',
      args: [],
    );
  }

  /// `No Active Deliveries`
  String get no_active_deliveries {
    return Intl.message(
      'No Active Deliveries',
      name: 'no_active_deliveries',
      desc: '',
      args: [],
    );
  }

  /// `You're all caught up!`
  String get all_caught_up {
    return Intl.message(
      'You\'re all caught up!',
      name: 'all_caught_up',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message('Call', name: 'call', desc: '', args: []);
  }

  /// `Delivery Checklist`
  String get delivery_checklist {
    return Intl.message(
      'Delivery Checklist',
      name: 'delivery_checklist',
      desc: '',
      args: [],
    );
  }

  /// `Complete the following steps to proceed`
  String get complete_steps_to_proceed {
    return Intl.message(
      'Complete the following steps to proceed',
      name: 'complete_steps_to_proceed',
      desc: '',
      args: [],
    );
  }

  /// `Verify Recipient`
  String get verify_recipient {
    return Intl.message(
      'Verify Recipient',
      name: 'verify_recipient',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Location`
  String get confirm_location {
    return Intl.message(
      'Confirm Location',
      name: 'confirm_location',
      desc: '',
      args: [],
    );
  }

  /// `Check Package Condition`
  String get check_package_condition {
    return Intl.message(
      'Check Package Condition',
      name: 'check_package_condition',
      desc: '',
      args: [],
    );
  }

  /// `Ensure there is no visible damage`
  String get ensure_no_damage {
    return Intl.message(
      'Ensure there is no visible damage',
      name: 'ensure_no_damage',
      desc: '',
      args: [],
    );
  }

  /// `Collect Payment`
  String get collect_payment {
    return Intl.message(
      'Collect Payment',
      name: 'collect_payment',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Proof of Delivery`
  String get proceed_to_proof {
    return Intl.message(
      'Proceed to Proof of Delivery',
      name: 'proceed_to_proof',
      desc: '',
      args: [],
    );
  }

  /// `Proof of Delivery`
  String get proof_of_delivery {
    return Intl.message(
      'Proof of Delivery',
      name: 'proof_of_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo of the delivered package`
  String get take_photo_proof {
    return Intl.message(
      'Take a photo of the delivered package',
      name: 'take_photo_proof',
      desc: '',
      args: [],
    );
  }

  /// `Take Photo`
  String get take_photo {
    return Intl.message('Take Photo', name: 'take_photo', desc: '', args: []);
  }

  /// `Retake`
  String get retake {
    return Intl.message('Retake', name: 'retake', desc: '', args: []);
  }

  /// `Confirm Delivery`
  String get confirm_delivery {
    return Intl.message(
      'Confirm Delivery',
      name: 'confirm_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Uploading...`
  String get uploading {
    return Intl.message('Uploading...', name: 'uploading', desc: '', args: []);
  }

  /// `Delivery completed successfully!`
  String get delivery_completed_successfully {
    return Intl.message(
      'Delivery completed successfully!',
      name: 'delivery_completed_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Signature Required`
  String get signature_required {
    return Intl.message(
      'Signature Required',
      name: 'signature_required',
      desc: '',
      args: [],
    );
  }

  /// `Please sign below`
  String get please_sign_below {
    return Intl.message(
      'Please sign below',
      name: 'please_sign_below',
      desc: '',
      args: [],
    );
  }

  /// `Clear Signature`
  String get clear_signature {
    return Intl.message(
      'Clear Signature',
      name: 'clear_signature',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Signature`
  String get confirm_signature {
    return Intl.message(
      'Confirm Signature',
      name: 'confirm_signature',
      desc: '',
      args: [],
    );
  }

  /// `Signature uploaded successfully`
  String get signature_uploaded {
    return Intl.message(
      'Signature uploaded successfully',
      name: 'signature_uploaded',
      desc: '',
      args: [],
    );
  }

  /// `Delivery History`
  String get delivery_history {
    return Intl.message(
      'Delivery History',
      name: 'delivery_history',
      desc: '',
      args: [],
    );
  }

  /// `No delivery history found`
  String get no_history_found {
    return Intl.message(
      'No delivery history found',
      name: 'no_history_found',
      desc: '',
      args: [],
    );
  }

  /// `Error loading data`
  String get error_loading_data {
    return Intl.message(
      'Error loading data',
      name: 'error_loading_data',
      desc: '',
      args: [],
    );
  }

  /// `Timeline`
  String get timeline {
    return Intl.message('Timeline', name: 'timeline', desc: '', args: []);
  }

  /// `Created At`
  String get created_at {
    return Intl.message('Created At', name: 'created_at', desc: '', args: []);
  }

  /// `Delivered At`
  String get delivered_at {
    return Intl.message(
      'Delivered At',
      name: 'delivered_at',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Signature`
  String get signature {
    return Intl.message('Signature', name: 'signature', desc: '', args: []);
  }

  /// `Update Status`
  String get update_status {
    return Intl.message(
      'Update Status',
      name: 'update_status',
      desc: '',
      args: [],
    );
  }

  /// `Select Status`
  String get select_status {
    return Intl.message(
      'Select Status',
      name: 'select_status',
      desc: '',
      args: [],
    );
  }

  /// `Return Reason`
  String get return_reason {
    return Intl.message(
      'Return Reason',
      name: 'return_reason',
      desc: '',
      args: [],
    );
  }

  /// `Failure Reason`
  String get failure_reason {
    return Intl.message(
      'Failure Reason',
      name: 'failure_reason',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Delivered`
  String get mark_as_delivered {
    return Intl.message(
      'Mark as Delivered',
      name: 'mark_as_delivered',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Returned`
  String get mark_as_returned {
    return Intl.message(
      'Mark as Returned',
      name: 'mark_as_returned',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Cancelled`
  String get mark_as_cancelled {
    return Intl.message(
      'Mark as Cancelled',
      name: 'mark_as_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Ready to Ship`
  String get mark_as_ready_to_ship {
    return Intl.message(
      'Mark as Ready to Ship',
      name: 'mark_as_ready_to_ship',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Out for Delivery`
  String get mark_as_out_for_delivery {
    return Intl.message(
      'Mark as Out for Delivery',
      name: 'mark_as_out_for_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Mark as At Warehouse`
  String get mark_as_at_warehouse {
    return Intl.message(
      'Mark as At Warehouse',
      name: 'mark_as_at_warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Status updated successfully`
  String get status_updated_successfully {
    return Intl.message(
      'Status updated successfully',
      name: 'status_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a reason`
  String get please_enter_reason {
    return Intl.message(
      'Please enter a reason',
      name: 'please_enter_reason',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Status Update`
  String get confirm_status_update {
    return Intl.message(
      'Confirm Status Update',
      name: 'confirm_status_update',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to update the status to {status}?`
  String are_you_sure_update_status(Object status) {
    return Intl.message(
      'Are you sure you want to update the status to $status?',
      name: 'are_you_sure_update_status',
      desc: '',
      args: [status],
    );
  }

  /// `Yes, Update`
  String get yes_update {
    return Intl.message('Yes, Update', name: 'yes_update', desc: '', args: []);
  }

  /// `Awaiting Label`
  String get status_awaiting_label {
    return Intl.message(
      'Awaiting Label',
      name: 'status_awaiting_label',
      desc: '',
      args: [],
    );
  }

  /// `Ready to Ship`
  String get status_ready_to_ship {
    return Intl.message(
      'Ready to Ship',
      name: 'status_ready_to_ship',
      desc: '',
      args: [],
    );
  }

  /// `At Distributor's Warehouse`
  String get status_at_warehouse {
    return Intl.message(
      'At Distributor\'s Warehouse',
      name: 'status_at_warehouse',
      desc: '',
      args: [],
    );
  }

  /// `En Route to Distributor`
  String get status_en_route_distributor {
    return Intl.message(
      'En Route to Distributor',
      name: 'status_en_route_distributor',
      desc: '',
      args: [],
    );
  }

  /// `Out for Delivery`
  String get status_out_for_delivery {
    return Intl.message(
      'Out for Delivery',
      name: 'status_out_for_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Complete Delivery`
  String get complete_delivery {
    return Intl.message(
      'Complete Delivery',
      name: 'complete_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Route Optimized`
  String get route_optimized {
    return Intl.message(
      'Route Optimized',
      name: 'route_optimized',
      desc: '',
      args: [],
    );
  }

  /// `Availability`
  String get availability {
    return Intl.message(
      'Availability',
      name: 'availability',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `Offline`
  String get offline {
    return Intl.message('Offline', name: 'offline', desc: '', args: []);
  }

  /// `Vehicle Information`
  String get vehicle_info {
    return Intl.message(
      'Vehicle Information',
      name: 'vehicle_info',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Type`
  String get vehicle_type {
    return Intl.message(
      'Vehicle Type',
      name: 'vehicle_type',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Plate Number`
  String get vehicle_plate {
    return Intl.message(
      'Vehicle Plate Number',
      name: 'vehicle_plate',
      desc: '',
      args: [],
    );
  }

  /// `Working Regions`
  String get working_regions {
    return Intl.message(
      'Working Regions',
      name: 'working_regions',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get validation_required {
    return Intl.message(
      'This field is required',
      name: 'validation_required',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get save_changes {
    return Intl.message(
      'Save Changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profile_updated_success {
    return Intl.message(
      'Profile updated successfully',
      name: 'profile_updated_success',
      desc: '',
      args: [],
    );
  }

  /// `Active Deliveries`
  String get active_deliveries {
    return Intl.message(
      'Active Deliveries',
      name: 'active_deliveries',
      desc: '',
      args: [],
    );
  }

  /// `Last Updated`
  String get updated_at {
    return Intl.message('Last Updated', name: 'updated_at', desc: '', args: []);
  }

  /// `Order History`
  String get order_history {
    return Intl.message(
      'Order History',
      name: 'order_history',
      desc: '',
      args: [],
    );
  }

  /// `Search by barcode or name...`
  String get search_by_barcode_or_name {
    return Intl.message(
      'Search by barcode or name...',
      name: 'search_by_barcode_or_name',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get no_results_found {
    return Intl.message(
      'No results found',
      name: 'no_results_found',
      desc: '',
      args: [],
    );
  }

  /// `Reorder`
  String get reorder {
    return Intl.message('Reorder', name: 'reorder', desc: '', args: []);
  }

  /// `Reorder Parcel`
  String get reorder_parcel {
    return Intl.message(
      'Reorder Parcel',
      name: 'reorder_parcel',
      desc: '',
      args: [],
    );
  }

  /// `Original Order Details`
  String get original_order_details {
    return Intl.message(
      'Original Order Details',
      name: 'original_order_details',
      desc: '',
      args: [],
    );
  }

  /// `Merchant Information`
  String get merchant_info {
    return Intl.message(
      'Merchant Information',
      name: 'merchant_info',
      desc: '',
      args: [],
    );
  }

  /// `Merchant information unavailable`
  String get merchant_info_unavailable {
    return Intl.message(
      'Merchant information unavailable',
      name: 'merchant_info_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Contact the merchant to place a repeat order with the same delivery details`
  String get reorder_instructions {
    return Intl.message(
      'Contact the merchant to place a repeat order with the same delivery details',
      name: 'reorder_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Call Merchant`
  String get call_merchant {
    return Intl.message(
      'Call Merchant',
      name: 'call_merchant',
      desc: '',
      args: [],
    );
  }

  /// `Copy Number`
  String get copy_number {
    return Intl.message('Copy Number', name: 'copy_number', desc: '', args: []);
  }

  /// `Delivery Feedback`
  String get delivery_feedback {
    return Intl.message(
      'Delivery Feedback',
      name: 'delivery_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Rate Your Delivery Experience`
  String get rate_delivery_experience {
    return Intl.message(
      'Rate Your Delivery Experience',
      name: 'rate_delivery_experience',
      desc: '',
      args: [],
    );
  }

  /// `How was your delivery?`
  String get how_was_your_delivery {
    return Intl.message(
      'How was your delivery?',
      name: 'how_was_your_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Add Comment (Optional)`
  String get add_comment {
    return Intl.message(
      'Add Comment (Optional)',
      name: 'add_comment',
      desc: '',
      args: [],
    );
  }

  /// `Share your experience with this delivery...`
  String get share_your_experience {
    return Intl.message(
      'Share your experience with this delivery...',
      name: 'share_your_experience',
      desc: '',
      args: [],
    );
  }

  /// `Tip Your Courier`
  String get tip_courier {
    return Intl.message(
      'Tip Your Courier',
      name: 'tip_courier',
      desc: '',
      args: [],
    );
  }

  /// `Show appreciation for great service (optional)`
  String get tip_courier_description {
    return Intl.message(
      'Show appreciation for great service (optional)',
      name: 'tip_courier_description',
      desc: '',
      args: [],
    );
  }

  /// `No Tip`
  String get no_tip {
    return Intl.message('No Tip', name: 'no_tip', desc: '', args: []);
  }

  /// `Submit Feedback`
  String get submit_feedback {
    return Intl.message(
      'Submit Feedback',
      name: 'submit_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Submitting...`
  String get submitting {
    return Intl.message(
      'Submitting...',
      name: 'submitting',
      desc: '',
      args: [],
    );
  }

  /// `Please select a rating`
  String get please_select_rating {
    return Intl.message(
      'Please select a rating',
      name: 'please_select_rating',
      desc: '',
      args: [],
    );
  }

  /// `Courier not assigned to this parcel`
  String get courier_not_assigned {
    return Intl.message(
      'Courier not assigned to this parcel',
      name: 'courier_not_assigned',
      desc: '',
      args: [],
    );
  }

  /// `Feedback submitted successfully!`
  String get feedback_submitted_successfully {
    return Intl.message(
      'Feedback submitted successfully!',
      name: 'feedback_submitted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Poor`
  String get rating_poor {
    return Intl.message('Poor', name: 'rating_poor', desc: '', args: []);
  }

  /// `Fair`
  String get rating_fair {
    return Intl.message('Fair', name: 'rating_fair', desc: '', args: []);
  }

  /// `Good`
  String get rating_good {
    return Intl.message('Good', name: 'rating_good', desc: '', args: []);
  }

  /// `Very Good`
  String get rating_very_good {
    return Intl.message(
      'Very Good',
      name: 'rating_very_good',
      desc: '',
      args: [],
    );
  }

  /// `Excellent!`
  String get rating_excellent {
    return Intl.message(
      'Excellent!',
      name: 'rating_excellent',
      desc: '',
      args: [],
    );
  }

  /// `Leave Feedback`
  String get leave_feedback {
    return Intl.message(
      'Leave Feedback',
      name: 'leave_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Report Issue`
  String get report_issue {
    return Intl.message(
      'Report Issue',
      name: 'report_issue',
      desc: '',
      args: [],
    );
  }

  /// `Select Issue Type`
  String get select_issue_type {
    return Intl.message(
      'Select Issue Type',
      name: 'select_issue_type',
      desc: '',
      args: [],
    );
  }

  /// `What went wrong with your delivery?`
  String get what_went_wrong {
    return Intl.message(
      'What went wrong with your delivery?',
      name: 'what_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Damaged Package`
  String get issue_damaged_package {
    return Intl.message(
      'Damaged Package',
      name: 'issue_damaged_package',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Item`
  String get issue_wrong_item {
    return Intl.message(
      'Wrong Item',
      name: 'issue_wrong_item',
      desc: '',
      args: [],
    );
  }

  /// `Missing Items`
  String get issue_missing_items {
    return Intl.message(
      'Missing Items',
      name: 'issue_missing_items',
      desc: '',
      args: [],
    );
  }

  /// `Late Delivery`
  String get issue_late_delivery {
    return Intl.message(
      'Late Delivery',
      name: 'issue_late_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Poor Service`
  String get issue_poor_service {
    return Intl.message(
      'Poor Service',
      name: 'issue_poor_service',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get issue_other {
    return Intl.message('Other', name: 'issue_other', desc: '', args: []);
  }

  /// `Describe the Issue`
  String get describe_issue {
    return Intl.message(
      'Describe the Issue',
      name: 'describe_issue',
      desc: '',
      args: [],
    );
  }

  /// `Please provide details about the issue...`
  String get provide_details {
    return Intl.message(
      'Please provide details about the issue...',
      name: 'provide_details',
      desc: '',
      args: [],
    );
  }

  /// `Please select an issue type`
  String get please_select_issue_type {
    return Intl.message(
      'Please select an issue type',
      name: 'please_select_issue_type',
      desc: '',
      args: [],
    );
  }

  /// `Please describe the issue`
  String get please_describe_issue {
    return Intl.message(
      'Please describe the issue',
      name: 'please_describe_issue',
      desc: '',
      args: [],
    );
  }

  /// `Issue Reported`
  String get issue_reported {
    return Intl.message(
      'Issue Reported',
      name: 'issue_reported',
      desc: '',
      args: [],
    );
  }

  /// `Issue reported successfully. We'll look into it!`
  String get issue_reported_successfully {
    return Intl.message(
      'Issue reported successfully. We\'ll look into it!',
      name: 'issue_reported_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Your report will be sent to the merchant and our support team. We'll investigate and get back to you soon.`
  String get issue_report_info {
    return Intl.message(
      'Your report will be sent to the merchant and our support team. We\'ll investigate and get back to you soon.',
      name: 'issue_report_info',
      desc: '',
      args: [],
    );
  }

  /// `Submit Report`
  String get submit_report {
    return Intl.message(
      'Submit Report',
      name: 'submit_report',
      desc: '',
      args: [],
    );
  }

  /// `Report an Issue`
  String get report_an_issue {
    return Intl.message(
      'Report an Issue',
      name: 'report_an_issue',
      desc: '',
      args: [],
    );
  }

  /// `All notifications marked as read`
  String get all_notifications_marked_read {
    return Intl.message(
      'All notifications marked as read',
      name: 'all_notifications_marked_read',
      desc: '',
      args: [],
    );
  }

  /// `No delivery regions available`
  String get no_regions_available {
    return Intl.message(
      'No delivery regions available',
      name: 'no_regions_available',
      desc: '',
      args: [],
    );
  }

  /// `Regions initialized successfully!`
  String get regions_initialized {
    return Intl.message(
      'Regions initialized successfully!',
      name: 'regions_initialized',
      desc: '',
      args: [],
    );
  }

  /// `Initialize Regions`
  String get initialize_regions {
    return Intl.message(
      'Initialize Regions',
      name: 'initialize_regions',
      desc: '',
      args: [],
    );
  }

  /// `Addresses`
  String get addresses {
    return Intl.message('Addresses', name: 'addresses', desc: '', args: []);
  }

  /// `Add Address`
  String get add_address {
    return Intl.message('Add Address', name: 'add_address', desc: '', args: []);
  }

  /// `Edit Address`
  String get edit_address {
    return Intl.message(
      'Edit Address',
      name: 'edit_address',
      desc: '',
      args: [],
    );
  }

  /// `No Addresses Yet`
  String get no_addresses {
    return Intl.message(
      'No Addresses Yet',
      name: 'no_addresses',
      desc: '',
      args: [],
    );
  }

  /// `Add your first address to make deliveries easier`
  String get add_your_first_address {
    return Intl.message(
      'Add your first address to make deliveries easier',
      name: 'add_your_first_address',
      desc: '',
      args: [],
    );
  }

  /// `Address Label`
  String get address_label {
    return Intl.message(
      'Address Label',
      name: 'address_label',
      desc: '',
      args: [],
    );
  }

  /// `e.g., Home, Work, Mom's House`
  String get address_label_hint {
    return Intl.message(
      'e.g., Home, Work, Mom\'s House',
      name: 'address_label_hint',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Work`
  String get work {
    return Intl.message('Work', name: 'work', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Street, building number, floor, apartment`
  String get address_hint {
    return Intl.message(
      'Street, building number, floor, apartment',
      name: 'address_hint',
      desc: '',
      args: [],
    );
  }

  /// `Set as Default Address`
  String get set_as_default {
    return Intl.message(
      'Set as Default Address',
      name: 'set_as_default',
      desc: '',
      args: [],
    );
  }

  /// `Use this address as your primary delivery location`
  String get set_as_default_hint {
    return Intl.message(
      'Use this address as your primary delivery location',
      name: 'set_as_default_hint',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get default_address {
    return Intl.message('Default', name: 'default_address', desc: '', args: []);
  }

  /// `Address set as default successfully`
  String get address_set_as_default {
    return Intl.message(
      'Address set as default successfully',
      name: 'address_set_as_default',
      desc: '',
      args: [],
    );
  }

  /// `Save Address`
  String get save_address {
    return Intl.message(
      'Save Address',
      name: 'save_address',
      desc: '',
      args: [],
    );
  }

  /// `Update Address`
  String get update_address {
    return Intl.message(
      'Update Address',
      name: 'update_address',
      desc: '',
      args: [],
    );
  }

  /// `Delete Address`
  String get delete_address {
    return Intl.message(
      'Delete Address',
      name: 'delete_address',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this address?`
  String get delete_address_confirmation {
    return Intl.message(
      'Are you sure you want to delete this address?',
      name: 'delete_address_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Address deleted successfully`
  String get address_deleted {
    return Intl.message(
      'Address deleted successfully',
      name: 'address_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Address added successfully`
  String get address_added_success {
    return Intl.message(
      'Address added successfully',
      name: 'address_added_success',
      desc: '',
      args: [],
    );
  }

  /// `Address updated successfully`
  String get address_updated_success {
    return Intl.message(
      'Address updated successfully',
      name: 'address_updated_success',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Update your personal information`
  String get update_your_information {
    return Intl.message(
      'Update your personal information',
      name: 'update_your_information',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Update your password for security`
  String get update_password_security {
    return Intl.message(
      'Update your password for security',
      name: 'update_password_security',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get current_password {
    return Intl.message(
      'Current Password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get password_too_short {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'password_too_short',
      desc: '',
      args: [],
    );
  }

  /// `Passwords don't match`
  String get passwords_dont_match {
    return Intl.message(
      'Passwords don\'t match',
      name: 'passwords_dont_match',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get password_changed_success {
    return Intl.message(
      'Password changed successfully',
      name: 'password_changed_success',
      desc: '',
      args: [],
    );
  }

  /// `Password change failed: {error}`
  String password_change_failed(Object error) {
    return Intl.message(
      'Password change failed: $error',
      name: 'password_change_failed',
      desc: '',
      args: [error],
    );
  }

  /// `Danger Zone`
  String get danger_zone {
    return Intl.message('Danger Zone', name: 'danger_zone', desc: '', args: []);
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Permanently delete your account`
  String get permanently_delete_account {
    return Intl.message(
      'Permanently delete your account',
      name: 'permanently_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Warning: This action cannot be undone!`
  String get delete_account_warning {
    return Intl.message(
      'Warning: This action cannot be undone!',
      name: 'delete_account_warning',
      desc: '',
      args: [],
    );
  }

  /// `Deleting your account will:\n• Remove all your data\n• Cancel all pending orders\n• Deactivate your profile\n\nAre you absolutely sure?`
  String get delete_account_consequences {
    return Intl.message(
      'Deleting your account will:\n• Remove all your data\n• Cancel all pending orders\n• Deactivate your profile\n\nAre you absolutely sure?',
      name: 'delete_account_consequences',
      desc: '',
      args: [],
    );
  }

  /// `Manage your notification preferences`
  String get manage_notification_preferences {
    return Intl.message(
      'Manage your notification preferences',
      name: 'manage_notification_preferences',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get coming_soon {
    return Intl.message('Coming Soon', name: 'coming_soon', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Inactive`
  String get inactive {
    return Intl.message('Inactive', name: 'inactive', desc: '', args: []);
  }

  /// `Suspended`
  String get suspended {
    return Intl.message('Suspended', name: 'suspended', desc: '', args: []);
  }

  /// `Admin`
  String get admin {
    return Intl.message('Admin', name: 'admin', desc: '', args: []);
  }

  /// `Manager`
  String get manager {
    return Intl.message('Manager', name: 'manager', desc: '', args: []);
  }

  /// `Parcel Status`
  String get parcel_status {
    return Intl.message(
      'Parcel Status',
      name: 'parcel_status',
      desc: '',
      args: [],
    );
  }

  /// `Status History`
  String get status_history {
    return Intl.message(
      'Status History',
      name: 'status_history',
      desc: '',
      args: [],
    );
  }

  /// `Show Details`
  String get show_details {
    return Intl.message(
      'Show Details',
      name: 'show_details',
      desc: '',
      args: [],
    );
  }

  /// `Hide Details`
  String get hide_details {
    return Intl.message(
      'Hide Details',
      name: 'hide_details',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get status_delivered {
    return Intl.message(
      'Delivered',
      name: 'status_delivered',
      desc: '',
      args: [],
    );
  }

  /// `Returned`
  String get status_returned {
    return Intl.message(
      'Returned',
      name: 'status_returned',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get status_cancelled {
    return Intl.message(
      'Cancelled',
      name: 'status_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Current Status`
  String get current_status {
    return Intl.message(
      'Current Status',
      name: 'current_status',
      desc: '',
      args: [],
    );
  }

  /// `New Status`
  String get new_status {
    return Intl.message('New Status', name: 'new_status', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Enter location`
  String get enter_location {
    return Intl.message(
      'Enter location',
      name: 'enter_location',
      desc: '',
      args: [],
    );
  }

  /// `Enter reason`
  String get enter_reason {
    return Intl.message(
      'Enter reason',
      name: 'enter_reason',
      desc: '',
      args: [],
    );
  }

  /// `Add notes (optional)`
  String get add_notes_optional {
    return Intl.message(
      'Add notes (optional)',
      name: 'add_notes_optional',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

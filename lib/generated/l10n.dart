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

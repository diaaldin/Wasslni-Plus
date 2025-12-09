import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 's_ar.dart';
import 's_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/s.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @privacy_intro.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your data privacy and security. This policy explains how we handle your personal information.'**
  String get privacy_intro;

  /// No description provided for @data_collection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get data_collection;

  /// No description provided for @data_collection_desc.
  ///
  /// In en, this message translates to:
  /// **'We collect data to provide and improve our services, personalize your experience, and keep you informed.'**
  String get data_collection_desc;

  /// No description provided for @data_usage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get data_usage;

  /// No description provided for @data_usage_desc.
  ///
  /// In en, this message translates to:
  /// **'Collected data is used solely to enhance app functionality, ensure security, and meet legal obligations.'**
  String get data_usage_desc;

  /// No description provided for @data_sharing.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get data_sharing;

  /// No description provided for @data_sharing_desc.
  ///
  /// In en, this message translates to:
  /// **'Your data will not be shared with third parties unless legally required.'**
  String get data_sharing_desc;

  /// No description provided for @data_retention.
  ///
  /// In en, this message translates to:
  /// **'Data Retention'**
  String get data_retention;

  /// No description provided for @data_retention_desc.
  ///
  /// In en, this message translates to:
  /// **'We retain your data as long as you use our services or as required by law. You can request data deletion.'**
  String get data_retention_desc;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @user_rights.
  ///
  /// In en, this message translates to:
  /// **'User Rights'**
  String get user_rights;

  /// No description provided for @user_rights_desc.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, modify, and delete your data. Contact us for any concerns or requests.'**
  String get user_rights_desc;

  /// No description provided for @thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you for trusting us with your information. We strive to keep your data safe and transparent.'**
  String get thank_you;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'For more details, feel free to contact our support team.'**
  String get contact_support;

  /// No description provided for @merchant_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Merchant Dashboard'**
  String get merchant_dashboard;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @sunny_mode.
  ///
  /// In en, this message translates to:
  /// **'Sunny Mode'**
  String get sunny_mode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @parcels.
  ///
  /// In en, this message translates to:
  /// **'Parcels'**
  String get parcels;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @general_serach_hint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get general_serach_hint;

  /// No description provided for @clear_selection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clear_selection;

  /// No description provided for @add_parcel.
  ///
  /// In en, this message translates to:
  /// **'Add Parcel'**
  String get add_parcel;

  /// No description provided for @recipient_name.
  ///
  /// In en, this message translates to:
  /// **'Recipient Name'**
  String get recipient_name;

  /// No description provided for @recipient_phone.
  ///
  /// In en, this message translates to:
  /// **'Recipient Phone'**
  String get recipient_phone;

  /// No description provided for @alt_phone.
  ///
  /// In en, this message translates to:
  /// **'Alternate Phone (Optional)'**
  String get alt_phone;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address, City - Street'**
  String get address;

  /// No description provided for @parcel_price.
  ///
  /// In en, this message translates to:
  /// **'Parcel Price (without delivery)'**
  String get parcel_price;

  /// No description provided for @parcel_description.
  ///
  /// In en, this message translates to:
  /// **'Parcel Description'**
  String get parcel_description;

  /// No description provided for @attach_barcode.
  ///
  /// In en, this message translates to:
  /// **'Attach Barcode'**
  String get attach_barcode;

  /// No description provided for @barcode_label.
  ///
  /// In en, this message translates to:
  /// **'Barcode: {code}'**
  String barcode_label(Object code);

  /// No description provided for @total_price_label.
  ///
  /// In en, this message translates to:
  /// **'Total Price (with delivery)'**
  String get total_price_label;

  /// No description provided for @save_parcel.
  ///
  /// In en, this message translates to:
  /// **'Save Parcel'**
  String get save_parcel;

  /// No description provided for @choose_region_warning.
  ///
  /// In en, this message translates to:
  /// **'Please select a region'**
  String get choose_region_warning;

  /// No description provided for @invalid_price.
  ///
  /// In en, this message translates to:
  /// **'Price must be a number greater than or equal to 0'**
  String get invalid_price;

  /// No description provided for @enter_price.
  ///
  /// In en, this message translates to:
  /// **'Please enter a price'**
  String get enter_price;

  /// No description provided for @enter_recipient_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter recipient name'**
  String get enter_recipient_name;

  /// No description provided for @enter_phone.
  ///
  /// In en, this message translates to:
  /// **'Please enter recipient phone'**
  String get enter_phone;

  /// No description provided for @invalid_phone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalid_phone;

  /// No description provided for @enter_address.
  ///
  /// In en, this message translates to:
  /// **'Enter the address (City - Street)'**
  String get enter_address;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @joinUs.
  ///
  /// In en, this message translates to:
  /// **'Join Us'**
  String get joinUs;

  /// No description provided for @joinUsDescription.
  ///
  /// In en, this message translates to:
  /// **'This page is for business owners who want to join us.'**
  String get joinUsDescription;

  /// No description provided for @acceptPolicyStart.
  ///
  /// In en, this message translates to:
  /// **'I accept the '**
  String get acceptPolicyStart;

  /// No description provided for @dataPolicy.
  ///
  /// In en, this message translates to:
  /// **'Data Policy'**
  String get dataPolicy;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @validation_phone_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get validation_phone_required;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'⚠ No internet connection'**
  String get no_internet_connection;

  /// No description provided for @validation_phone_invalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be exactly 10 digits'**
  String get validation_phone_invalid;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Wasslni Plus'**
  String get app_name;

  /// No description provided for @app_tagline.
  ///
  /// In en, this message translates to:
  /// **'Fast & Reliable Delivery'**
  String get app_tagline;

  /// No description provided for @welcome_to_app.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Wasslni Plus'**
  String get welcome_to_app;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get enter_email;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalid_email;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enter_password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @merchant.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get merchant;

  /// No description provided for @courier.
  ///
  /// In en, this message translates to:
  /// **'Courier'**
  String get courier;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get login_failed;

  /// No description provided for @registration_failed.
  ///
  /// In en, this message translates to:
  /// **'Registration Failed'**
  String get registration_failed;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get already_have_account;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get dont_have_account;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logout_error.
  ///
  /// In en, this message translates to:
  /// **'Error logging out. Please try again.'**
  String get logout_error;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @in_transit.
  ///
  /// In en, this message translates to:
  /// **'In Transit'**
  String get in_transit;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @returned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get returned;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @monthly_revenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthly_revenue;

  /// No description provided for @recent_parcels.
  ///
  /// In en, this message translates to:
  /// **'Recent Parcels'**
  String get recent_parcels;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @no_parcels_yet.
  ///
  /// In en, this message translates to:
  /// **'No parcels yet'**
  String get no_parcels_yet;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @delivery_region.
  ///
  /// In en, this message translates to:
  /// **'Delivery Region'**
  String get delivery_region;

  /// No description provided for @mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get mark_all_read;

  /// No description provided for @no_notifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get no_notifications;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit_parcel.
  ///
  /// In en, this message translates to:
  /// **'Edit Parcel'**
  String get edit_parcel;

  /// No description provided for @update_parcel.
  ///
  /// In en, this message translates to:
  /// **'Update Parcel'**
  String get update_parcel;

  /// No description provided for @cancel_parcel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Parcel'**
  String get cancel_parcel;

  /// No description provided for @confirm_cancel_parcel.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this parcel?'**
  String get confirm_cancel_parcel;

  /// No description provided for @cancellation_reason.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get cancellation_reason;

  /// No description provided for @yes_cancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yes_cancel;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @parcel_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Parcel updated successfully'**
  String get parcel_updated_success;

  /// No description provided for @parcel_created_success.
  ///
  /// In en, this message translates to:
  /// **'Parcel created successfully'**
  String get parcel_created_success;

  /// No description provided for @parcel_cancelled_success.
  ///
  /// In en, this message translates to:
  /// **'Parcel cancelled successfully'**
  String get parcel_cancelled_success;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error_occurred(Object error);

  /// No description provided for @parcel_details.
  ///
  /// In en, this message translates to:
  /// **'Parcel Details'**
  String get parcel_details;

  /// No description provided for @status_label.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String status_label(Object status);

  /// No description provided for @delivery_fee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get delivery_fee;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @note_label.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String note_label(Object note);

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions (cm)'**
  String get dimensions;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @delivery_instructions.
  ///
  /// In en, this message translates to:
  /// **'Delivery Instructions (Optional)'**
  String get delivery_instructions;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @add_image.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get add_image;

  /// No description provided for @delivery_time_slot.
  ///
  /// In en, this message translates to:
  /// **'Preferred Delivery Time'**
  String get delivery_time_slot;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning (9AM - 12PM)'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon (12PM - 5PM)'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening (5PM - 9PM)'**
  String get evening;

  /// No description provided for @anytime.
  ///
  /// In en, this message translates to:
  /// **'Any Time'**
  String get anytime;

  /// No description provided for @requires_signature.
  ///
  /// In en, this message translates to:
  /// **'Requires Recipient Signature'**
  String get requires_signature;

  /// No description provided for @signature_description.
  ///
  /// In en, this message translates to:
  /// **'Courier must collect signature on delivery'**
  String get signature_description;

  /// No description provided for @print_label.
  ///
  /// In en, this message translates to:
  /// **'Print Label'**
  String get print_label;

  /// No description provided for @print_receipt.
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get print_receipt;

  /// No description provided for @shipping_label.
  ///
  /// In en, this message translates to:
  /// **'Shipping Label'**
  String get shipping_label;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @parcel_info.
  ///
  /// In en, this message translates to:
  /// **'Parcel Information'**
  String get parcel_info;

  /// No description provided for @scan_to_track.
  ///
  /// In en, this message translates to:
  /// **'Scan to Track'**
  String get scan_to_track;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @export_pdf.
  ///
  /// In en, this message translates to:
  /// **'Export to PDF'**
  String get export_pdf;

  /// No description provided for @export_excel.
  ///
  /// In en, this message translates to:
  /// **'Export to Excel'**
  String get export_excel;

  /// No description provided for @export_success.
  ///
  /// In en, this message translates to:
  /// **'Export completed successfully'**
  String get export_success;

  /// No description provided for @export_error.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get export_error;

  /// No description provided for @parcels_report.
  ///
  /// In en, this message translates to:
  /// **'Parcels Report'**
  String get parcels_report;

  /// No description provided for @total_parcels.
  ///
  /// In en, this message translates to:
  /// **'Total Parcels'**
  String get total_parcels;

  /// No description provided for @date_range.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get date_range;

  /// No description provided for @bulk_upload.
  ///
  /// In en, this message translates to:
  /// **'Bulk Upload'**
  String get bulk_upload;

  /// No description provided for @upload_csv.
  ///
  /// In en, this message translates to:
  /// **'Upload CSV File'**
  String get upload_csv;

  /// No description provided for @download_template.
  ///
  /// In en, this message translates to:
  /// **'Download Template'**
  String get download_template;

  /// No description provided for @select_file.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get select_file;

  /// No description provided for @upload_success.
  ///
  /// In en, this message translates to:
  /// **'Upload completed successfully'**
  String get upload_success;

  /// No description provided for @upload_error.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get upload_error;

  /// No description provided for @processing_file.
  ///
  /// In en, this message translates to:
  /// **'Processing file...'**
  String get processing_file;

  /// No description provided for @parcels_imported.
  ///
  /// In en, this message translates to:
  /// **'Parcels imported'**
  String get parcels_imported;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @monthly_report.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthly_report;

  /// No description provided for @delivery_statistics.
  ///
  /// In en, this message translates to:
  /// **'Delivery Statistics'**
  String get delivery_statistics;

  /// No description provided for @revenue_overview.
  ///
  /// In en, this message translates to:
  /// **'Revenue Overview'**
  String get revenue_overview;

  /// No description provided for @performance_metrics.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performance_metrics;

  /// No description provided for @select_month.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get select_month;

  /// No description provided for @total_deliveries.
  ///
  /// In en, this message translates to:
  /// **'Total Deliveries'**
  String get total_deliveries;

  /// No description provided for @successful_deliveries.
  ///
  /// In en, this message translates to:
  /// **'Successful Deliveries'**
  String get successful_deliveries;

  /// No description provided for @failed_deliveries.
  ///
  /// In en, this message translates to:
  /// **'Failed Deliveries'**
  String get failed_deliveries;

  /// No description provided for @pending_deliveries.
  ///
  /// In en, this message translates to:
  /// **'Pending Deliveries'**
  String get pending_deliveries;

  /// No description provided for @success_rate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get success_rate;

  /// No description provided for @average_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Average Delivery Time'**
  String get average_delivery_time;

  /// No description provided for @total_revenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get total_revenue;

  /// No description provided for @delivery_fees_collected.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fees Collected'**
  String get delivery_fees_collected;

  /// No description provided for @success_rate_trend.
  ///
  /// In en, this message translates to:
  /// **'Success Rate Trend'**
  String get success_rate_trend;

  /// No description provided for @weekly_success_rate.
  ///
  /// In en, this message translates to:
  /// **'Weekly Success Rate'**
  String get weekly_success_rate;

  /// No description provided for @no_data_available.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get no_data_available;

  /// No description provided for @top_customers.
  ///
  /// In en, this message translates to:
  /// **'Top Customers'**
  String get top_customers;

  /// No description provided for @parcels_delivered.
  ///
  /// In en, this message translates to:
  /// **'Parcels Delivered'**
  String get parcels_delivered;

  /// No description provided for @notification_settings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notification_settings;

  /// No description provided for @parcel_updates.
  ///
  /// In en, this message translates to:
  /// **'Parcel Updates'**
  String get parcel_updates;

  /// No description provided for @parcel_updates_desc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when parcel status changes'**
  String get parcel_updates_desc;

  /// No description provided for @promotional_offers.
  ///
  /// In en, this message translates to:
  /// **'Promotional Offers'**
  String get promotional_offers;

  /// No description provided for @promotional_offers_desc.
  ///
  /// In en, this message translates to:
  /// **'Receive updates about new features and offers'**
  String get promotional_offers_desc;

  /// No description provided for @system_announcements.
  ///
  /// In en, this message translates to:
  /// **'System Announcements'**
  String get system_announcements;

  /// No description provided for @system_announcements_desc.
  ///
  /// In en, this message translates to:
  /// **'Important updates about the platform'**
  String get system_announcements_desc;

  /// No description provided for @courier_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Courier Dashboard'**
  String get courier_dashboard;

  /// No description provided for @daily_assignments.
  ///
  /// In en, this message translates to:
  /// **'Daily Assignments'**
  String get daily_assignments;

  /// No description provided for @todays_deliveries.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Deliveries'**
  String get todays_deliveries;

  /// No description provided for @earnings_today.
  ///
  /// In en, this message translates to:
  /// **'Earnings Today'**
  String get earnings_today;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending_pickup.
  ///
  /// In en, this message translates to:
  /// **'Pending Pickup'**
  String get pending_pickup;

  /// No description provided for @my_route.
  ///
  /// In en, this message translates to:
  /// **'My Route'**
  String get my_route;

  /// No description provided for @start_delivery.
  ///
  /// In en, this message translates to:
  /// **'Start Delivery'**
  String get start_delivery;

  /// No description provided for @no_assignments.
  ///
  /// In en, this message translates to:
  /// **'No assignments for today'**
  String get no_assignments;

  /// No description provided for @route_map.
  ///
  /// In en, this message translates to:
  /// **'Route Map'**
  String get route_map;

  /// No description provided for @delivery_points.
  ///
  /// In en, this message translates to:
  /// **'Delivery Points'**
  String get delivery_points;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @map_view.
  ///
  /// In en, this message translates to:
  /// **'Map View'**
  String get map_view;

  /// No description provided for @list_view.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get list_view;

  /// No description provided for @delivery_location.
  ///
  /// In en, this message translates to:
  /// **'Delivery Location'**
  String get delivery_location;

  /// No description provided for @current_location.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get current_location;

  /// No description provided for @show_route.
  ///
  /// In en, this message translates to:
  /// **'Show Route'**
  String get show_route;

  /// No description provided for @hide_route.
  ///
  /// In en, this message translates to:
  /// **'Hide Route'**
  String get hide_route;

  /// No description provided for @optimized_route.
  ///
  /// In en, this message translates to:
  /// **'Optimized Route'**
  String get optimized_route;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @estimated_time.
  ///
  /// In en, this message translates to:
  /// **'Estimated Time'**
  String get estimated_time;

  /// No description provided for @weekly_earnings.
  ///
  /// In en, this message translates to:
  /// **'Weekly Earnings'**
  String get weekly_earnings;

  /// No description provided for @monthly_earnings.
  ///
  /// In en, this message translates to:
  /// **'Monthly Earnings'**
  String get monthly_earnings;

  /// No description provided for @total_earnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get total_earnings;

  /// No description provided for @earnings_breakdown.
  ///
  /// In en, this message translates to:
  /// **'Earnings Breakdown'**
  String get earnings_breakdown;

  /// No description provided for @todays_performance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Performance'**
  String get todays_performance;

  /// No description provided for @delivery_success_rate.
  ///
  /// In en, this message translates to:
  /// **'Delivery Success Rate'**
  String get delivery_success_rate;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get view_details;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get this_week;

  /// No description provided for @this_month.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get this_month;

  /// No description provided for @earnings_trend.
  ///
  /// In en, this message translates to:
  /// **'Earnings Trend'**
  String get earnings_trend;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @delivery_queue.
  ///
  /// In en, this message translates to:
  /// **'Delivery Queue'**
  String get delivery_queue;

  /// No description provided for @no_active_deliveries.
  ///
  /// In en, this message translates to:
  /// **'No Active Deliveries'**
  String get no_active_deliveries;

  /// No description provided for @all_caught_up.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get all_caught_up;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @delivery_checklist.
  ///
  /// In en, this message translates to:
  /// **'Delivery Checklist'**
  String get delivery_checklist;

  /// No description provided for @complete_steps_to_proceed.
  ///
  /// In en, this message translates to:
  /// **'Complete the following steps to proceed'**
  String get complete_steps_to_proceed;

  /// No description provided for @verify_recipient.
  ///
  /// In en, this message translates to:
  /// **'Verify Recipient'**
  String get verify_recipient;

  /// No description provided for @confirm_location.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirm_location;

  /// No description provided for @check_package_condition.
  ///
  /// In en, this message translates to:
  /// **'Check Package Condition'**
  String get check_package_condition;

  /// No description provided for @ensure_no_damage.
  ///
  /// In en, this message translates to:
  /// **'Ensure there is no visible damage'**
  String get ensure_no_damage;

  /// No description provided for @collect_payment.
  ///
  /// In en, this message translates to:
  /// **'Collect Payment'**
  String get collect_payment;

  /// No description provided for @proceed_to_proof.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Proof of Delivery'**
  String get proceed_to_proof;

  /// No description provided for @proof_of_delivery.
  ///
  /// In en, this message translates to:
  /// **'Proof of Delivery'**
  String get proof_of_delivery;

  /// No description provided for @take_photo_proof.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the delivered package'**
  String get take_photo_proof;

  /// No description provided for @take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get take_photo;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @confirm_delivery.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery'**
  String get confirm_delivery;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @delivery_completed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Delivery completed successfully!'**
  String get delivery_completed_successfully;

  /// No description provided for @signature_required.
  ///
  /// In en, this message translates to:
  /// **'Signature Required'**
  String get signature_required;

  /// No description provided for @please_sign_below.
  ///
  /// In en, this message translates to:
  /// **'Please sign below'**
  String get please_sign_below;

  /// No description provided for @clear_signature.
  ///
  /// In en, this message translates to:
  /// **'Clear Signature'**
  String get clear_signature;

  /// No description provided for @confirm_signature.
  ///
  /// In en, this message translates to:
  /// **'Confirm Signature'**
  String get confirm_signature;

  /// No description provided for @signature_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Signature uploaded successfully'**
  String get signature_uploaded;

  /// No description provided for @delivery_history.
  ///
  /// In en, this message translates to:
  /// **'Delivery History'**
  String get delivery_history;

  /// No description provided for @no_history_found.
  ///
  /// In en, this message translates to:
  /// **'No delivery history found'**
  String get no_history_found;

  /// No description provided for @error_loading_data.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get error_loading_data;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @created_at.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get created_at;

  /// No description provided for @delivered_at.
  ///
  /// In en, this message translates to:
  /// **'Delivered At'**
  String get delivered_at;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @update_status.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get update_status;

  /// No description provided for @select_status.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get select_status;

  /// No description provided for @return_reason.
  ///
  /// In en, this message translates to:
  /// **'Return Reason'**
  String get return_reason;

  /// No description provided for @failure_reason.
  ///
  /// In en, this message translates to:
  /// **'Failure Reason'**
  String get failure_reason;

  /// No description provided for @mark_as_delivered.
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get mark_as_delivered;

  /// No description provided for @mark_as_returned.
  ///
  /// In en, this message translates to:
  /// **'Mark as Returned'**
  String get mark_as_returned;

  /// No description provided for @mark_as_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Mark as Cancelled'**
  String get mark_as_cancelled;

  /// No description provided for @mark_as_ready_to_ship.
  ///
  /// In en, this message translates to:
  /// **'Mark as Ready to Ship'**
  String get mark_as_ready_to_ship;

  /// No description provided for @mark_as_out_for_delivery.
  ///
  /// In en, this message translates to:
  /// **'Mark as Out for Delivery'**
  String get mark_as_out_for_delivery;

  /// No description provided for @mark_as_at_warehouse.
  ///
  /// In en, this message translates to:
  /// **'Mark as At Warehouse'**
  String get mark_as_at_warehouse;

  /// No description provided for @status_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Status updated successfully'**
  String get status_updated_successfully;

  /// No description provided for @please_enter_reason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason'**
  String get please_enter_reason;

  /// No description provided for @confirm_status_update.
  ///
  /// In en, this message translates to:
  /// **'Confirm Status Update'**
  String get confirm_status_update;

  /// No description provided for @are_you_sure_update_status.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to update the status to {status}?'**
  String are_you_sure_update_status(Object status);

  /// No description provided for @yes_update.
  ///
  /// In en, this message translates to:
  /// **'Yes, Update'**
  String get yes_update;

  /// No description provided for @status_awaiting_label.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Label'**
  String get status_awaiting_label;

  /// No description provided for @status_ready_to_ship.
  ///
  /// In en, this message translates to:
  /// **'Ready to Ship'**
  String get status_ready_to_ship;

  /// No description provided for @status_at_warehouse.
  ///
  /// In en, this message translates to:
  /// **'At Distributor\'s Warehouse'**
  String get status_at_warehouse;

  /// No description provided for @status_en_route_distributor.
  ///
  /// In en, this message translates to:
  /// **'En Route to Distributor'**
  String get status_en_route_distributor;

  /// No description provided for @status_out_for_delivery.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get status_out_for_delivery;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @complete_delivery.
  ///
  /// In en, this message translates to:
  /// **'Complete Delivery'**
  String get complete_delivery;

  /// No description provided for @route_optimized.
  ///
  /// In en, this message translates to:
  /// **'Route Optimized'**
  String get route_optimized;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @vehicle_info.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicle_info;

  /// No description provided for @vehicle_type.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicle_type;

  /// No description provided for @vehicle_plate.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Plate Number'**
  String get vehicle_plate;

  /// No description provided for @working_regions.
  ///
  /// In en, this message translates to:
  /// **'Working Regions'**
  String get working_regions;

  /// No description provided for @validation_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validation_required;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @profile_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_success;

  /// No description provided for @active_deliveries.
  ///
  /// In en, this message translates to:
  /// **'Active Deliveries'**
  String get active_deliveries;

  /// No description provided for @updated_at.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get updated_at;

  /// No description provided for @order_history.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get order_history;

  /// No description provided for @search_by_barcode_or_name.
  ///
  /// In en, this message translates to:
  /// **'Search by barcode or name...'**
  String get search_by_barcode_or_name;

  /// No description provided for @no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results_found;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @reorder_parcel.
  ///
  /// In en, this message translates to:
  /// **'Reorder Parcel'**
  String get reorder_parcel;

  /// No description provided for @original_order_details.
  ///
  /// In en, this message translates to:
  /// **'Original Order Details'**
  String get original_order_details;

  /// No description provided for @merchant_info.
  ///
  /// In en, this message translates to:
  /// **'Merchant Information'**
  String get merchant_info;

  /// No description provided for @merchant_info_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Merchant information unavailable'**
  String get merchant_info_unavailable;

  /// No description provided for @reorder_instructions.
  ///
  /// In en, this message translates to:
  /// **'Contact the merchant to place a repeat order with the same delivery details'**
  String get reorder_instructions;

  /// No description provided for @call_merchant.
  ///
  /// In en, this message translates to:
  /// **'Call Merchant'**
  String get call_merchant;

  /// No description provided for @copy_number.
  ///
  /// In en, this message translates to:
  /// **'Copy Number'**
  String get copy_number;

  /// No description provided for @delivery_feedback.
  ///
  /// In en, this message translates to:
  /// **'Delivery Feedback'**
  String get delivery_feedback;

  /// No description provided for @rate_delivery_experience.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Delivery Experience'**
  String get rate_delivery_experience;

  /// No description provided for @how_was_your_delivery.
  ///
  /// In en, this message translates to:
  /// **'How was your delivery?'**
  String get how_was_your_delivery;

  /// No description provided for @add_comment.
  ///
  /// In en, this message translates to:
  /// **'Add Comment (Optional)'**
  String get add_comment;

  /// No description provided for @share_your_experience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with this delivery...'**
  String get share_your_experience;

  /// No description provided for @tip_courier.
  ///
  /// In en, this message translates to:
  /// **'Tip Your Courier'**
  String get tip_courier;

  /// No description provided for @tip_courier_description.
  ///
  /// In en, this message translates to:
  /// **'Show appreciation for great service (optional)'**
  String get tip_courier_description;

  /// No description provided for @no_tip.
  ///
  /// In en, this message translates to:
  /// **'No Tip'**
  String get no_tip;

  /// No description provided for @submit_feedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submit_feedback;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @please_select_rating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get please_select_rating;

  /// No description provided for @courier_not_assigned.
  ///
  /// In en, this message translates to:
  /// **'Courier not assigned to this parcel'**
  String get courier_not_assigned;

  /// No description provided for @feedback_submitted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully!'**
  String get feedback_submitted_successfully;

  /// No description provided for @rating_poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get rating_poor;

  /// No description provided for @rating_fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get rating_fair;

  /// No description provided for @rating_good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get rating_good;

  /// No description provided for @rating_very_good.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get rating_very_good;

  /// No description provided for @rating_excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent!'**
  String get rating_excellent;

  /// No description provided for @leave_feedback.
  ///
  /// In en, this message translates to:
  /// **'Leave Feedback'**
  String get leave_feedback;

  /// No description provided for @report_issue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get report_issue;

  /// No description provided for @select_issue_type.
  ///
  /// In en, this message translates to:
  /// **'Select Issue Type'**
  String get select_issue_type;

  /// No description provided for @what_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'What went wrong with your delivery?'**
  String get what_went_wrong;

  /// No description provided for @issue_damaged_package.
  ///
  /// In en, this message translates to:
  /// **'Damaged Package'**
  String get issue_damaged_package;

  /// No description provided for @issue_wrong_item.
  ///
  /// In en, this message translates to:
  /// **'Wrong Item'**
  String get issue_wrong_item;

  /// No description provided for @issue_missing_items.
  ///
  /// In en, this message translates to:
  /// **'Missing Items'**
  String get issue_missing_items;

  /// No description provided for @issue_late_delivery.
  ///
  /// In en, this message translates to:
  /// **'Late Delivery'**
  String get issue_late_delivery;

  /// No description provided for @issue_poor_service.
  ///
  /// In en, this message translates to:
  /// **'Poor Service'**
  String get issue_poor_service;

  /// No description provided for @issue_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get issue_other;

  /// No description provided for @describe_issue.
  ///
  /// In en, this message translates to:
  /// **'Describe the Issue'**
  String get describe_issue;

  /// No description provided for @provide_details.
  ///
  /// In en, this message translates to:
  /// **'Please provide details about the issue...'**
  String get provide_details;

  /// No description provided for @please_select_issue_type.
  ///
  /// In en, this message translates to:
  /// **'Please select an issue type'**
  String get please_select_issue_type;

  /// No description provided for @please_describe_issue.
  ///
  /// In en, this message translates to:
  /// **'Please describe the issue'**
  String get please_describe_issue;

  /// No description provided for @issue_reported.
  ///
  /// In en, this message translates to:
  /// **'Issue Reported'**
  String get issue_reported;

  /// No description provided for @issue_reported_successfully.
  ///
  /// In en, this message translates to:
  /// **'Issue reported successfully. We\'ll look into it!'**
  String get issue_reported_successfully;

  /// No description provided for @issue_report_info.
  ///
  /// In en, this message translates to:
  /// **'Your report will be sent to the merchant and our support team. We\'ll investigate and get back to you soon.'**
  String get issue_report_info;

  /// No description provided for @submit_report.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submit_report;

  /// No description provided for @report_an_issue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get report_an_issue;

  /// No description provided for @all_notifications_marked_read.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get all_notifications_marked_read;

  /// No description provided for @no_regions_available.
  ///
  /// In en, this message translates to:
  /// **'No delivery regions available'**
  String get no_regions_available;

  /// No description provided for @regions_initialized.
  ///
  /// In en, this message translates to:
  /// **'Regions initialized successfully!'**
  String get regions_initialized;

  /// No description provided for @initialize_regions.
  ///
  /// In en, this message translates to:
  /// **'Initialize Regions'**
  String get initialize_regions;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @add_address.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get add_address;

  /// No description provided for @edit_address.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get edit_address;

  /// No description provided for @no_addresses.
  ///
  /// In en, this message translates to:
  /// **'No Addresses Yet'**
  String get no_addresses;

  /// No description provided for @add_your_first_address.
  ///
  /// In en, this message translates to:
  /// **'Add your first address to make deliveries easier'**
  String get add_your_first_address;

  /// No description provided for @address_label.
  ///
  /// In en, this message translates to:
  /// **'Address Label'**
  String get address_label;

  /// No description provided for @address_label_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Home, Work, Mom\'s House'**
  String get address_label_hint;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @address_hint.
  ///
  /// In en, this message translates to:
  /// **'Street, building number, floor, apartment'**
  String get address_hint;

  /// No description provided for @set_as_default.
  ///
  /// In en, this message translates to:
  /// **'Set as Default Address'**
  String get set_as_default;

  /// No description provided for @set_as_default_hint.
  ///
  /// In en, this message translates to:
  /// **'Use this address as your primary delivery location'**
  String get set_as_default_hint;

  /// No description provided for @default_address.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default_address;

  /// No description provided for @address_set_as_default.
  ///
  /// In en, this message translates to:
  /// **'Address set as default successfully'**
  String get address_set_as_default;

  /// No description provided for @save_address.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get save_address;

  /// No description provided for @update_address.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get update_address;

  /// No description provided for @delete_address.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get delete_address;

  /// No description provided for @delete_address_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get delete_address_confirmation;

  /// No description provided for @address_deleted.
  ///
  /// In en, this message translates to:
  /// **'Address deleted successfully'**
  String get address_deleted;

  /// No description provided for @address_added_success.
  ///
  /// In en, this message translates to:
  /// **'Address added successfully'**
  String get address_added_success;

  /// No description provided for @address_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get address_updated_success;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @update_your_information.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get update_your_information;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @update_password_security.
  ///
  /// In en, this message translates to:
  /// **'Update your password for security'**
  String get update_password_security;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @password_too_short.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_too_short;

  /// No description provided for @passwords_dont_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwords_dont_match;

  /// No description provided for @password_changed_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed_success;

  /// No description provided for @password_change_failed.
  ///
  /// In en, this message translates to:
  /// **'Password change failed: {error}'**
  String password_change_failed(Object error);

  /// No description provided for @danger_zone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get danger_zone;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @permanently_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get permanently_delete_account;

  /// No description provided for @delete_account_warning.
  ///
  /// In en, this message translates to:
  /// **'Warning: This action cannot be undone!'**
  String get delete_account_warning;

  /// No description provided for @delete_account_consequences.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will:\n• Remove all your data\n• Cancel all pending orders\n• Deactivate your profile\n\nAre you absolutely sure?'**
  String get delete_account_consequences;

  /// No description provided for @manage_notification_preferences.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get manage_notification_preferences;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get coming_soon;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @suspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get suspended;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @parcel_status.
  ///
  /// In en, this message translates to:
  /// **'Parcel Status'**
  String get parcel_status;

  /// No description provided for @status_history.
  ///
  /// In en, this message translates to:
  /// **'Status History'**
  String get status_history;

  /// No description provided for @show_details.
  ///
  /// In en, this message translates to:
  /// **'Show Details'**
  String get show_details;

  /// No description provided for @hide_details.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get hide_details;

  /// No description provided for @status_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get status_delivered;

  /// No description provided for @status_returned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get status_returned;

  /// No description provided for @status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get status_cancelled;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

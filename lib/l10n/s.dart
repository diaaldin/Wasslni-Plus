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

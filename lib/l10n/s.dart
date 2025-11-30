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

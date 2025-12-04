// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(code) => "Barcode: ${code}";

  static String m1(error) => "Error: ${error}";

  static String m2(note) => "Note: ${note}";

  static String m3(status) => "Status: ${status}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "acceptPolicyStart": MessageLookupByLibrary.simpleMessage("I accept the "),
    "add_image": MessageLookupByLibrary.simpleMessage("Add Image"),
    "add_parcel": MessageLookupByLibrary.simpleMessage("Add Parcel"),
    "address": MessageLookupByLibrary.simpleMessage("Address, City - Street"),
    "afternoon": MessageLookupByLibrary.simpleMessage("Afternoon (12PM - 5PM)"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "Already have an account? Login",
    ),
    "alt_phone": MessageLookupByLibrary.simpleMessage(
      "Alternate Phone (Optional)",
    ),
    "anytime": MessageLookupByLibrary.simpleMessage("Any Time"),
    "app_name": MessageLookupByLibrary.simpleMessage("Wasslni Plus"),
    "app_tagline": MessageLookupByLibrary.simpleMessage(
      "Fast & Reliable Delivery",
    ),
    "attach_barcode": MessageLookupByLibrary.simpleMessage("Attach Barcode"),
    "barcode_label": m0,
    "bulk_upload": MessageLookupByLibrary.simpleMessage("Bulk Upload"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancel_parcel": MessageLookupByLibrary.simpleMessage("Cancel Parcel"),
    "cancellation_reason": MessageLookupByLibrary.simpleMessage(
      "Cancellation Reason",
    ),
    "cancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
    "choose_region_warning": MessageLookupByLibrary.simpleMessage(
      "Please select a region",
    ),
    "clear_selection": MessageLookupByLibrary.simpleMessage("Clear selection"),
    "confirm_cancel_parcel": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to cancel this parcel?",
    ),
    "contact_support": MessageLookupByLibrary.simpleMessage(
      "For more details, feel free to contact our support team.",
    ),
    "courier": MessageLookupByLibrary.simpleMessage("Courier"),
    "customer": MessageLookupByLibrary.simpleMessage("Customer"),
    "dark_mode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "dataPolicy": MessageLookupByLibrary.simpleMessage("Data Policy"),
    "data_collection": MessageLookupByLibrary.simpleMessage("Data Collection"),
    "data_collection_desc": MessageLookupByLibrary.simpleMessage(
      "We collect data to provide and improve our services, personalize your experience, and keep you informed.",
    ),
    "data_retention": MessageLookupByLibrary.simpleMessage("Data Retention"),
    "data_retention_desc": MessageLookupByLibrary.simpleMessage(
      "We retain your data as long as you use our services or as required by law. You can request data deletion.",
    ),
    "data_sharing": MessageLookupByLibrary.simpleMessage("Data Sharing"),
    "data_sharing_desc": MessageLookupByLibrary.simpleMessage(
      "Your data will not be shared with third parties unless legally required.",
    ),
    "data_usage": MessageLookupByLibrary.simpleMessage("Data Usage"),
    "data_usage_desc": MessageLookupByLibrary.simpleMessage(
      "Collected data is used solely to enhance app functionality, ensure security, and meet legal obligations.",
    ),
    "date_range": MessageLookupByLibrary.simpleMessage("Date Range"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "delivered": MessageLookupByLibrary.simpleMessage("Delivered"),
    "delivery_fee": MessageLookupByLibrary.simpleMessage("Delivery Fee"),
    "delivery_instructions": MessageLookupByLibrary.simpleMessage(
      "Delivery Instructions (Optional)",
    ),
    "delivery_region": MessageLookupByLibrary.simpleMessage("Delivery Region"),
    "delivery_time_slot": MessageLookupByLibrary.simpleMessage(
      "Preferred Delivery Time",
    ),
    "dimensions": MessageLookupByLibrary.simpleMessage("Dimensions (cm)"),
    "dont_have_account": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? Register",
    ),
    "download_template": MessageLookupByLibrary.simpleMessage(
      "Download Template",
    ),
    "edit_parcel": MessageLookupByLibrary.simpleMessage("Edit Parcel"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "enter_address": MessageLookupByLibrary.simpleMessage(
      "Enter the address (City - Street)",
    ),
    "enter_email": MessageLookupByLibrary.simpleMessage("Please enter email"),
    "enter_password": MessageLookupByLibrary.simpleMessage(
      "Please enter password",
    ),
    "enter_phone": MessageLookupByLibrary.simpleMessage(
      "Please enter recipient phone",
    ),
    "enter_price": MessageLookupByLibrary.simpleMessage("Please enter a price"),
    "enter_recipient_name": MessageLookupByLibrary.simpleMessage(
      "Please enter recipient name",
    ),
    "error_occurred": m1,
    "evening": MessageLookupByLibrary.simpleMessage("Evening (5PM - 9PM)"),
    "export": MessageLookupByLibrary.simpleMessage("Export"),
    "export_error": MessageLookupByLibrary.simpleMessage("Export failed"),
    "export_excel": MessageLookupByLibrary.simpleMessage("Export to Excel"),
    "export_pdf": MessageLookupByLibrary.simpleMessage("Export to PDF"),
    "export_success": MessageLookupByLibrary.simpleMessage(
      "Export completed successfully",
    ),
    "from": MessageLookupByLibrary.simpleMessage("From"),
    "general_serach_hint": MessageLookupByLibrary.simpleMessage("Search..."),
    "height": MessageLookupByLibrary.simpleMessage("Height"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "images": MessageLookupByLibrary.simpleMessage("Images"),
    "in_transit": MessageLookupByLibrary.simpleMessage("In Transit"),
    "invalid_email": MessageLookupByLibrary.simpleMessage(
      "Invalid email address",
    ),
    "invalid_phone": MessageLookupByLibrary.simpleMessage(
      "Invalid phone number",
    ),
    "invalid_price": MessageLookupByLibrary.simpleMessage(
      "Price must be a number greater than or equal to 0",
    ),
    "joinUs": MessageLookupByLibrary.simpleMessage("Join Us"),
    "joinUsDescription": MessageLookupByLibrary.simpleMessage(
      "This page is for business owners who want to join us.",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "length": MessageLookupByLibrary.simpleMessage("Length"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "login_failed": MessageLookupByLibrary.simpleMessage("Login Failed"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logout_confirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout?",
    ),
    "logout_error": MessageLookupByLibrary.simpleMessage(
      "Error logging out. Please try again.",
    ),
    "main": MessageLookupByLibrary.simpleMessage("Main"),
    "mark_all_read": MessageLookupByLibrary.simpleMessage("Mark all as read"),
    "merchant": MessageLookupByLibrary.simpleMessage("Merchant"),
    "merchant_dashboard": MessageLookupByLibrary.simpleMessage(
      "Merchant Dashboard",
    ),
    "message": MessageLookupByLibrary.simpleMessage("Message"),
    "monthly_revenue": MessageLookupByLibrary.simpleMessage("Monthly Revenue"),
    "morning": MessageLookupByLibrary.simpleMessage("Morning (9AM - 12PM)"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "⚠ No internet connection",
    ),
    "no_notifications": MessageLookupByLibrary.simpleMessage(
      "No notifications",
    ),
    "no_parcels_yet": MessageLookupByLibrary.simpleMessage("No parcels yet"),
    "note_label": m2,
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "optional": MessageLookupByLibrary.simpleMessage("Optional"),
    "parcel_cancelled_success": MessageLookupByLibrary.simpleMessage(
      "Parcel cancelled successfully",
    ),
    "parcel_created_success": MessageLookupByLibrary.simpleMessage(
      "Parcel created successfully",
    ),
    "parcel_description": MessageLookupByLibrary.simpleMessage(
      "Parcel Description",
    ),
    "parcel_details": MessageLookupByLibrary.simpleMessage("Parcel Details"),
    "parcel_info": MessageLookupByLibrary.simpleMessage("Parcel Information"),
    "parcel_price": MessageLookupByLibrary.simpleMessage(
      "Parcel Price (without delivery)",
    ),
    "parcel_updated_success": MessageLookupByLibrary.simpleMessage(
      "Parcel updated successfully",
    ),
    "parcels": MessageLookupByLibrary.simpleMessage("Parcels"),
    "parcels_imported": MessageLookupByLibrary.simpleMessage(
      "Parcels imported",
    ),
    "parcels_report": MessageLookupByLibrary.simpleMessage("Parcels Report"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
    "phone_number": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "print_label": MessageLookupByLibrary.simpleMessage("Print Label"),
    "print_receipt": MessageLookupByLibrary.simpleMessage("Print Receipt"),
    "privacy_intro": MessageLookupByLibrary.simpleMessage(
      "We are committed to protecting your data privacy and security. This policy explains how we handle your personal information.",
    ),
    "privacy_policy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "processing_file": MessageLookupByLibrary.simpleMessage(
      "Processing file...",
    ),
    "recent_parcels": MessageLookupByLibrary.simpleMessage("Recent Parcels"),
    "recipient": MessageLookupByLibrary.simpleMessage("Recipient"),
    "recipient_name": MessageLookupByLibrary.simpleMessage("Recipient Name"),
    "recipient_phone": MessageLookupByLibrary.simpleMessage("Recipient Phone"),
    "region": MessageLookupByLibrary.simpleMessage("Region"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registration_failed": MessageLookupByLibrary.simpleMessage(
      "Registration Failed",
    ),
    "requires_signature": MessageLookupByLibrary.simpleMessage(
      "Requires Recipient Signature",
    ),
    "role": MessageLookupByLibrary.simpleMessage("Role"),
    "save_parcel": MessageLookupByLibrary.simpleMessage("Save Parcel"),
    "scan_to_track": MessageLookupByLibrary.simpleMessage("Scan to Track"),
    "select_file": MessageLookupByLibrary.simpleMessage("Select File"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "shipping_label": MessageLookupByLibrary.simpleMessage("Shipping Label"),
    "signature_description": MessageLookupByLibrary.simpleMessage(
      "Courier must collect signature on delivery",
    ),
    "status_label": m3,
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "sunny_mode": MessageLookupByLibrary.simpleMessage("Sunny Mode"),
    "thank_you": MessageLookupByLibrary.simpleMessage(
      "Thank you for trusting us with your information. We strive to keep your data safe and transparent.",
    ),
    "to": MessageLookupByLibrary.simpleMessage("To"),
    "total_parcels": MessageLookupByLibrary.simpleMessage("Total Parcels"),
    "total_price_label": MessageLookupByLibrary.simpleMessage(
      "Total Price (with delivery)",
    ),
    "unread": MessageLookupByLibrary.simpleMessage("Unread"),
    "update_parcel": MessageLookupByLibrary.simpleMessage("Update Parcel"),
    "upload_csv": MessageLookupByLibrary.simpleMessage("Upload CSV File"),
    "upload_error": MessageLookupByLibrary.simpleMessage("Upload failed"),
    "upload_success": MessageLookupByLibrary.simpleMessage(
      "Upload completed successfully",
    ),
    "user_rights": MessageLookupByLibrary.simpleMessage("User Rights"),
    "user_rights_desc": MessageLookupByLibrary.simpleMessage(
      "You have the right to access, modify, and delete your data. Contact us for any concerns or requests.",
    ),
    "validation_phone_invalid": MessageLookupByLibrary.simpleMessage(
      "Phone number must be exactly 10 digits",
    ),
    "validation_phone_required": MessageLookupByLibrary.simpleMessage(
      "Please enter your phone number",
    ),
    "view_all": MessageLookupByLibrary.simpleMessage("View All"),
    "weight": MessageLookupByLibrary.simpleMessage("Weight (kg)"),
    "welcome_to_app": MessageLookupByLibrary.simpleMessage(
      "Welcome to Wasslni Plus",
    ),
    "width": MessageLookupByLibrary.simpleMessage("Width"),
    "yes_cancel": MessageLookupByLibrary.simpleMessage("Yes, Cancel"),
  };
}

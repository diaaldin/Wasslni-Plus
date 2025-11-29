# Translation Guidelines - Wasslni Plus

## 📋 Overview

**Wasslni Plus** supports two languages:
- **Arabic (AR)** - Primary language, RTL (Right-to-Left)
- **English (EN)** - Secondary language, LTR (Left-to-Right)

All UI text, messages, labels, buttons, and content MUST be available in both languages.

---

## 🗂️ Translation Files

### Location
- Arabic translations: `lib/l10n/intl_ar.arb`
- English translations: `lib/l10n/intl_en.arb`

### Format
ARB (Application Resource Bundle) files use JSON format:

```json
{
  "key_name": "Translation text",
  "@key_name": {
    "description": "Description of where/how this text is used"
  }
}
```

---

## ✅ Translation Workflow

### 1. Adding New Text to the App

When adding any new UI text:

1. **Open both translation files**:
   - `lib/l10n/intl_ar.arb`
   - `lib/l10n/intl_en.arb`

2. **Add the key to both files** with appropriate translations:

```json
// intl_ar.arb
{
  "welcome_message": "مرحباً بك في وصلني بلس"
}

// intl_en.arb
{
  "welcome_message": "Welcome to Wasslni Plus"
}
```

3. **Run the code generator**:
```bash
dart run intl_utils:generate
```

4. **Use in your code**:
```dart
import 'package:wasslni_plus/generated/l10n.dart';

Text(S.of(context).welcome_message)
```

### 2. Naming Conventions

#### ✅ Good Key Names
- Use lowercase with underscores: `welcome_message`, `add_parcel`, `delivery_status`
- Be descriptive: `merchant_dashboard_title` NOT `title1`
- Group related keys: `login_button`, `login_error`, `login_success`
- Use singular/plural suffixes: `parcel_count`, `parcels_count`

#### ❌ Bad Key Names
- CamelCase: `welcomeMessage`
- Spaces: `welcome message`
- Too vague: `text123`, `label`
- Too long: `this_is_the_welcome_message_shown_on_login_page`

### 3. Message Parameters

For dynamic text with variables:

```json
// intl_ar.arb
{
  "barcode_label": "الباركود: {code}",
  "@barcode_label": {
    "description": "Label showing barcode number",
    "placeholders": {
      "code": {
        "type": "String"
      }
    }
  }
}

// intl_en.arb  
{
  "barcode_label": "Barcode: {code}"
}
```

Usage:
```dart
Text(S.of(context).barcode_label('1234567890'))
```

### 4. Pluralization

For text that changes based on count:

```json
// intl_ar.arb
{
  "parcel_count": "{count, plural, =0{لا توجد طرود} =1{طرد واحد} other{{count} طرود}}",
  "@parcel_count": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}

// intl_en.arb
{
  "parcel_count": "{count, plural, =0{No parcels} =1{1 parcel} other{{count} parcels}}"
}
```

---

## 🎨 Translation Best Practices

### Arabic Specific
1. **Use proper Arabic grammar**
   - Use formal Arabic (فصحى) not dialect
   - Respect gender agreements
   - Use appropriate verb forms

2. **Numbers and Dates**
   - Use Eastern Arabic numerals (٠١٢٣٤٥٦٧٨٩) OR Western (0123456789) consistently
   - Format dates as: ٢٠٢٥/١١/٢٩ or 29/11/2025

3. **Punctuation**
   - Use Arabic comma: ،
   - Use Arabic question mark: ؟
   - Use Arabic semicolon: ؛

4. **Length Considerations**
   - Arabic text is often 20-30% longer than English
   - Ensure UI accommodates longer text
   - Test with actual translations, not Lorem Ipsum

### English Specific
1. **Use clear, concise language**
   - Prefer active voice
   - Use simple words when possible
   - Avoid idioms or cultural references

2. **Consistency**
   - Use same terminology throughout
   - Parcel (not package/shipment unless necessary)
   - Courier (not driver/delivery person)
   - Merchant (not seller/vendor)

3. **Tone**
   - Professional but friendly
   - Helpful, not commanding
   - Clear error messages with solutions

---

## 📝 Common Translation Pairs

### App Name & Branding
```
app_name: "Wasslni Plus" / "وصلني بلس"
app_tagline: "Fast & Reliable Delivery" / "توصيل سريع وموثوق"
```

### User Roles
```
admin: "Admin" / "مدير النظام"
manager: "Manager" / "مدير"
merchant: "Merchant" / "تاجر"
courier: "Courier" / "موزع"
customer: "Customer" / "عميل"
```

### Parcel Status
```
awaiting_label: "Awaiting Label" / "بانتظار الملصق"
ready_to_ship: "Ready to Ship" / "جاهز للإرسال"
en_route_distributor: "En Route to Distributor" / "في الطريق للموزع"
at_warehouse: "At Warehouse" / "مخزن الموزع"
out_for_delivery: "Out for Delivery" / "في الطريق للزبون"
delivered: "Delivered" / "تم التوصيل"
returned: "Returned" / "طرد راجع"
cancelled: "Cancelled" / "ملغي"
```

### Regions
```
jerusalem: "Jerusalem" / "القدس"
west_bank: "West Bank" / "الضفة"
inside: "Inside" / "الداخل"
```

### Common Actions
```
save: "Save" / "حفظ"
cancel: "Cancel" / "إلغاء"
delete: "Delete" / "حذف"
edit: "Edit" / "تعديل"
add: "Add" / "إضافة"
search: "Search" / "بحث"
filter: "Filter" / "تصفية"
submit: "Submit" / "إرسال"
confirm: "Confirm" / "تأكيد"
```

### Common Labels
```
name: "Name" / "الاسم"
phone: "Phone" / "الهاتف"
email: "Email" / "البريد الإلكتروني"
address: "Address" / "العنوان"
price: "Price" / "السعر"
date: "Date" / "التاريخ"
time: "Time" / "الوقت"
```

---

## ✅ Testing Translations

### Before Committing
1. **Run the generator**: `dart run intl_utils:generate`
2. **Check for errors** in terminal output
3. **Test language switching** in the app
4. **Verify RTL layout** for Arabic
5. **Check text truncation** on small screens
6. **Test with long Arabic text**
7. **Verify all placeholders** work correctly

### Checklist
- [ ] All new keys exist in both intl_ar.arb and intl_en.arb
- [ ] No duplicate keys
- [ ] All placeholders match between languages
- [ ] Special characters escaped properly
- [ ] Generator runs without errors
- [ ] Arabic displays correctly (RTL)
- [ ] English displays correctly (LTR)
- [ ] No hardcoded text in UI components
- [ ] Date/time formats appropriate for each language
- [ ] Currency symbols correct (₪)

---

## 🚫 Common Mistakes to Avoid

### ❌ DON'T
```dart
// Hardcoded text
Text('Welcome to Wasslni Plus')

// Mixed hardcoded and localized
Text('Total: ${S.of(context).parcels}')

// Wrong key naming
"WelcomeMsg": "Welcome"
```

### ✅ DO
```dart
// Fully localized
Text(S.of(context).welcome_message)

// Parameter in translation
Text(S.of(context).total_parcels(count))

// Proper key naming
"welcome_message": "Welcome"
```

---

## 📊 Translation Coverage

### Current Coverage
Track which sections have complete translations:

- [x] Login/Registration forms
- [x] Merchant parcel creation
- [x] Parcel status labels
- [x] Settings page basics
- [ ] Admin dashboard (TODO)
- [ ] Manager dashboard (TODO)
- [ ] Courier app (TODO)
- [ ] Customer app (TODO)
- [ ] Error messages (PARTIAL)
- [ ] Success messages (PARTIAL)
- [ ] Help/Support content (TODO)

---

## 🔄 Updating Existing Translations

When changing translations:

1. Update both AR and EN files
2. Test in both languages
3. Check if change affects layout
4. Verify in multiple screens
5. Update documentation if terminology changes

---

## 📚 Resources

- **Arabic Grammar**: Use [Arabic Language Academy](http://www.arabic-academy.org.il/)
- **Translation Tools**: Google Translate (verify with native speaker)
- **Arabic Numerals**: https://en.wikipedia.org/wiki/Eastern_Arabic_numerals
- **Flutter Localization**: https://docs.flutter.dev/development/accessibility-and-localization/internationalization

---

## 🤝 Contributing Translations

If you're adding new features:

1. Create feature branch
2. Add translations to both files
3. Test thoroughly
4. Document new keys in this guide if they're common
5. Submit PR with translations included

---

**Last Updated**: 2025-11-29  
**Maintained By**: Development Team

---

## Quick Commands

```bash
# Generate localization files after adding translations
dart run intl_utils:generate

# Or alternative command
flutter pub run intl_utils:generate

# Check the app in Arabic
# (Set device language to Arabic or use language switcher in app)

# Check the app in English
# (Set device language to English or use language switcher in app)
```

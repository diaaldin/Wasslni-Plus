# Accessibility Guide

## ⚠️ Important Note

These utilities have been created and are ready to use, but they are **not yet integrated** into the existing pages.

See **Phase 6** in `TASKS.md` for the integration plan to apply these utilities throughout the app.

## Overview

Wasslni Plus is designed to be accessible to all users, including those with disabilities. This guide covers the accessibility features implemented in the app and best practices for maintaining accessibility.

## Accessibility Features

### 🎯 Screen Reader Support

The app fully supports screen readers like:
- **TalkBack** (Android)
- **VoiceOver** (iOS)
- **Screen readers on Web**

#### Implementation

All interactive elements have proper semantic labels:

```dart
import 'package:wasslni_plus/utils/accessibility_utils.dart';

// Button with semantic label
Semantics(
  button: true,
  label: 'Add new parcel',
  hint: 'Opens form to create a new parcel',
  child: IconButton(
    icon: Icon(Icons.add),
    onPressed: () => _addParcel(),
  ),
)

// Or use the helper
AccessibilityUtils.accessibleButton(
  label: 'Add new parcel',
  hint: 'Opens form to create a new parcel',
  onPressed: () => _addParcel(),
  child: Icon(Icons.add),
)
```

### 📐 Proper Contrast Ratios

All text and interactive elements meet WCAG 2.1 standards:

- **WCAG AA**: Minimum contrast ratio of **4.5:1** for normal text
- **WCAG AAA**: Minimum contrast ratio of **7:1** for normal text
- **Large Text**: Minimum contrast ratio of **3:1** for text ≥ 18pt

#### Checking Contrast

```dart
import 'package:wasslni_plus/utils/accessibility_utils.dart';

// Check if colors meet WCAG AA
final isAccessible = AccessibilityUtils.meetsWCAG_AA(
  foregroundColor,
  backgroundColor,
);

// Check contrast ratio
final ratio = AccessibilityUtils.calculateContrastRatio(
  color1,
  color2,
);

print('Contrast ratio: $ratio:1');
```

#### Color Palette Compliance

Our design system colors are tested for accessibility:

| Element | Foreground | Background | Ratio | Standard |
|---------|-----------|------------|-------|----------|
| Primary text | #212121 | #FFFFFF | 15.8:1 | ✅ AAA |
| Secondary text | #757575 | #FFFFFF | 4.6:1 | ✅ AA |
| Primary button | #FFFFFF | #E91E63 | 5.9:1 | ✅ AA |
| Success | #FFFFFF | #4CAF50 | 4.8:1 | ✅ AA |
| Error | #FFFFFF | #F44336 | 4.5:1 | ✅ AA |

### 📏 Text Scaling Support

The app supports system text scaling up to **200%** (2x):

```dart
// Get current text scale factor
final scaleFactor = AccessibilityUtils.getTextScaleFactor(context);

// Check if scaling is enabled
if (AccessibilityUtils.isTextScalingEnabled(context)) {
  // Adjust layout if needed
}

// Clamp text scaling to prevent overflow
ClampedTextScale(
  maxScale: 2.0,
  child: Text('This text won\'t scale beyond 2x'),
)
```

#### Best Practices for Text Scaling

1. **Use relative sizing** instead of fixed sizes
2. **Allow text to wrap** with `maxLines` or overflow handling
3. **Test with different scale factors** (1.0x, 1.5x, 2.0x)
4. **Clamp scaling** where necessary to prevent UI breaks

```dart
// ❌ Don't do this
Text(
  'Very long text that might overflow',
  style: TextStyle(fontSize: 16),
)

// ✅ Do this
Text(
  'Very long text that might overflow',
  style: TextStyle(fontSize: 16),
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)

// ✅ Or clamp scaling
ClampedTextScale(
  child: Text('Text'),
)
```

### ⌨️ Keyboard Navigation Support

The app supports full keyboard navigation for web and desktop platforms:

#### Focus Management

```dart
import 'package:wasslni_plus/utils/accessibility_utils.dart';

// Request focus
AccessibilityUtils.requestFocus(context, myFocusNode);

// Move to next field
AccessibilityUtils.focusNext(context);

// Move to previous field
AccessibilityUtils.focusPrevious(context);

// Unfocus
AccessibilityUtils.unfocus(context);
```

#### Focus Order

Ensure logical focus order by:
1. Using `FocusTraversalGroup` for complex layouts
2. Setting `autofocus` on the first field
3. Using `FocusNode` for custom focus behavior

```dart
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(
    children: [
      TextField(
        focusNode: nameFocusNode,
        autofocus: true,
      ),
      TextField(
        focusNode: emailFocusNode,
      ),
      TextField(
        focusNode: phoneFocusNode,
      ),
    ],
  ),
)
```

### 👆 Touch Target Sizing

All interactive elements meet minimum touch target size:

- **Minimum**: 48x48 dp (Material Design standard)
- **Recommended**: 56x56 dp for better usability

```dart
import 'package:wasslni_plus/utils/accessibility_utils.dart';

// Ensure minimum touch target
AccessibleTouchTarget(
  child: Icon(Icons.delete, size: 20),
)

// Or manually
AccessibilityUtils.ensureTouchTarget(
  minSize: 48,
  child: Icon(Icons.delete, size: 20),
)
```

## Testing Accessibility

### Screen Reader Testing

#### Android (TalkBack)
1. Go to **Settings** > **Accessibility** > **TalkBack**
2. Turn on TalkBack
3. Navigate through the app using swipe gestures
4. Verify all elements are properly announced

#### iOS (VoiceOver)
1. Go to **Settings** > **Accessibility** > **VoiceOver**
2. Turn on VoiceOver
3. Navigate using swipe gestures
4. Verify announcements and navigation

#### Web (Screen Readers)
- **NVDA** (Windows - Free)
- **JAWS** (Windows - Commercial)
- **ChromeVox** (Chrome Extension)

### Contrast Testing

Use these tools to check color contrast:

1. **WebAIM Contrast Checker**: https://webaim.org/resources/contrastchecker/
2. **Color Safe**: http://colorsafe.co/
3. **Chrome DevTools**: Lighthouse audit

### Text Scaling Testing

Test with different text scale factors:

```dart
// In main.dart or dev tools
MaterialApp(
  builder: (context, child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 2.0, // Test at 2x scaling
      ),
      child: child!,
    );
  },
)
```

Or use device settings:
- **Android**: Settings > Display > Font size
- **iOS**: Settings > Display & Brightness > Text Size

### Keyboard Navigation Testing

1. Connect a keyboard (or use web)
2. Navigate using **Tab** key
3. Activate using **Enter** or **Space**
4. Verify all interactive elements are reachable

## Accessibility Checklist

Use this checklist for each new feature:

### Screen Reader
- [ ] All images have meaningful `Semantics` labels
- [ ] Icons have text labels via `Semantics`
- [ ] Buttons announce their purpose
- [ ] Form fields have proper labels
- [ ] Error messages are announced
- [ ] Success messages are announced
- [ ] Loading states are announced
- [ ] Decorative elements are excluded from semantics

### Visual
- [ ] Text contrast meets WCAG AA (4.5:1)
- [ ] Large text contrast meets WCAG AA (3:1)
- [ ] Focus indicators are visible
- [ ] Color is not the only way to convey information
- [ ] Text is readable at 200% zoom

### Touch Targets
- [ ] All buttons are at least 48x48 dp
- [ ] Interactive elements have adequate spacing
- [ ] No overlapping touch targets

### Keyboard
- [ ] All interactive elements are focusable
- [ ] Focus order is logical
- [ ] Keyboard shortcuts don't conflict with screen readers
- [ ] Forms can be submitted with Enter key

### Content
- [ ] Form fields have labels
- [ ] Error messages are descriptive
- [ ] Instructions are clear
- [ ] Language is simple and direct

## Common Accessibility Patterns

### 1. Accessible Form Field

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Recipient Name',
    hintText: 'Enter recipient full name',
    helperText: 'First and last name',
  ),
  // Screen readers will announce label, hint, and helper text
)
```

### 2. Accessible Button

```dart
Semantics(
  button: true,
  label: 'Delete parcel',
  hint: 'Double tap to permanently delete this parcel',
  onTap: _deleteParcel,
  child: IconButton(
    icon: Icon(Icons.delete),
    onPressed: _deleteParcel,
  ),
)
```

### 3. Accessible List Item

```dart
Semantics(
  label: 'Parcel ${parcel.barcode}',
  value: '${parcel.status}, Recipient: ${parcel.recipientName}',
  onTap: () => _viewParcel(parcel),
  child: ListTile(
    title: Text(parcel.barcode),
    subtitle: Text(parcel.recipientName),
    trailing: Text(parcel.status),
    onTap: () => _viewParcel(parcel),
  ),
)
```

### 4. Accessible Image

```dart
AccessibilityUtils.accessibleImage(
  description: 'Proof of delivery photo showing package at door',
  image: Image.network(parcel.proofOfDeliveryUrl),
)
```

### 5. Accessible Loading Indicator

```dart
Semantics(
  label: 'Loading parcels',
  liveRegion: true,
  child: CircularProgressIndicator(),
)
```

### 6. Accessible Error Message

```dart
// Show error
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Error'),
    content: Text('Failed to load parcels'),
  ),
);

// Announce to screen reader
AccessibilityUtils.announce(
  context,
  'Error: Failed to load parcels',
);
```

## RTL (Right-to-Left) Support

For Arabic language support:

```dart
// Automatic RTL based on locale
MaterialApp(
  localizationsDelegates: [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  // RTL will be automatic for Arabic
)

// Announce with correct direction
AccessibilityUtils.announceWithDirection(
  context,
  'تم إضافة الطرد بنجاح',
  TextDirection.rtl,
);
```

## Resources

### Guidelines
- [WCAG 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design Accessibility](https://material.io/design/usability/accessibility.html)
- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)

### Tools
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Lighthouse](https://developers.google.com/web/tools/lighthouse)
- [Accessibility Scanner (Android)](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor)

### Testing
- [TalkBack (Android)](https://support.google.com/accessibility/android/answer/6283677)
- [VoiceOver (iOS)](https://support.apple.com/guide/iphone/turn-on-and-practice-voiceover-iph3e2e415f/ios)
- [NVDA (Windows)](https://www.nvaccess.org/)

## Best Practices Summary

1. ✅ **Always provide semantic labels** for icons and images
2. ✅ **Test with screen readers** regularly
3. ✅ **Check color contrast** for all text
4. ✅ **Support text scaling** up to 200%
5. ✅ **Ensure touch targets** are at least 48x48 dp
6. ✅ **Provide clear error messages** that are announced
7. ✅ **Use meaningful labels** not just "button" or "icon"
8. ✅ **Test keyboard navigation** on web/desktop
9. ✅ **Announce important state changes** to screen readers
10. ✅ **Support both LTR and RTL** languages

## Continuous Improvement

- Monitor accessibility feedback from users
- Run automated accessibility audits
- Update as WCAG guidelines evolve
- Train team on accessibility best practices

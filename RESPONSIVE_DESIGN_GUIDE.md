# Responsive Design Guide

## ⚠️ Important Note

These utilities have been created and are ready to use, but they are **not yet integrated** into the existing pages.

See **Phase 6** in `TASKS.md` for the integration plan to apply these utilities throughout the app.

## Overview

Wasslni Plus is designed to work seamlessly across different screen sizes and device types:
- 📱 **Mobile** (width < 600px)
- 📱 **Tablet** (600px ≤ width < 1200px)
- 💻 **Desktop** (width ≥ 1200px)

The app also supports both **portrait** and **landscape** orientations.

## Design Tokens & Breakpoints

All responsive design values are defined in `lib/design_system/design_tokens.dart`:

```dart
// Breakpoints
static const double breakpointMobile = 600.0;
static const double breakpointTablet = 900.0;
static const double breakpointDesktop = 1200.0;
static const double breakpointWide = 1800.0;
```

## Responsive Utilities

The `lib/utils/responsive_utils.dart` file provides comprehensive utilities for building responsive layouts:

### Device Detection

```dart
// Check device type
if (ResponsiveUtils.isMobile(context)) {
  // Mobile layout
} else if (ResponsiveUtils.isTablet(context)) {
  // Tablet layout
} else if (ResponsiveUtils.isDesktop(context)) {
  // Desktop layout
}

// Check orientation
if (ResponsiveUtils.isLandscape(context)) {
  // Landscape layout
} else {
  // Portrait layout
}
```

### Responsive Builders

#### 1. Build Different Widgets

```dart
ResponsiveUtils.buildResponsive(
  context: context,
  mobile: MobileWidget(),
  tablet: TabletWidget(),  // Optional
  desktop: DesktopWidget(), // Optional
)
```

#### 2. Get Responsive Values

```dart
final columns = ResponsiveUtils.value<int>(
  context: context,
  mobile: 1,
  tablet: 2,
  desktop: 3,
);
```

#### 3. Responsive Builder Widget

```dart
ResponsiveBuilder(
  builder: (context, constraints) {
    // Build UI based on constraints
    return MyWidget();
  },
)
```

### Adaptive Components

#### 1. Adaptive Padding

```dart
AdaptivePadding(
  mobile: EdgeInsets.all(16),
  tablet: EdgeInsets.all(24),
  desktop: EdgeInsets.all(32),
  child: MyWidget(),
)
```

#### 2. Adaptive Grid

```dart
AdaptiveGrid(
  mobileColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
  ],
)
```

### Grid Layout Helpers

```dart
// Get number of columns for grids
final columns = ResponsiveUtils.gridCrossAxisCount(
  context,
  mobile: 1,
  tablet: 2,
  desktop: 3,
);

// Get columns based on orientation
final columns = ResponsiveUtils.columnsForOrientation(context);
// Mobile portrait: 1, landscape: 2
// Tablet portrait: 2, landscape: 3
// Desktop portrait: 3, landscape: 4
```

### Adaptive Sizing

```dart
// Responsive padding
final padding = ResponsiveUtils.responsivePadding(context);

// Responsive horizontal padding
final hPadding = ResponsiveUtils.responsiveHorizontalPadding(context);
// Mobile: 16px, Tablet: 32px, Desktop: 48px

// Responsive vertical padding
final vPadding = ResponsiveUtils.responsiveVerticalPadding(context);
// Mobile: 16px, Tablet: 24px, Desktop: 32px

// Responsive font size
final fontSize = ResponsiveUtils.responsiveFontSize(context, baseSize);
// Mobile: 1.0x, Tablet: 1.05x, Desktop: 1.1x

// Responsive icon size
final iconSize = ResponsiveUtils.responsiveIconSize(context);
```

### Dialog & Modal Sizing

```dart
// Responsive dialog width
final dialogWidth = ResponsiveUtils.dialogWidth(context);
// Mobile: 90% of screen width
// Tablet: 60% of screen width
// Desktop: 40% of screen width

// Responsive dialog max height
final maxHeight = ResponsiveUtils.dialogMaxHeight(context);
// Always 80% of screen height
```

## Best Practices

### 1. Use LayoutBuilder for Complex Layouts

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isWide = constraints.maxWidth > 600;
    
    if (isWide) {
      return Row(children: [...]);
    } else {
      return Column(children: [...]);
    }
  },
)
```

### 2. Use OrientationBuilder for Orientation-Specific Layouts

```dart
OrientationBuilder(
  builder: (context, orientation) {
    if (orientation == Orientation.landscape) {
      return LandscapeLayout();
    } else {
      return PortraitLayout();
    }
  },
)
```

### 3. Combine Both with ResponsiveBuilder

```dart
ResponsiveBuilder(
  builder: (context, constraints) {
    // Automatically handles both size and orientation changes
    return MyAdaptiveWidget();
  },
)
```

### 4. Use Centered Constrained Containers for Desktop

```dart
ResponsiveUtils.centeredConstrainedContainer(
  context: context,
  maxWidth: 1200,  // Optional, defaults to responsive max width
  child: MyWidget(),
)
```

### 5. Use Adaptive Spacing

Instead of hardcoded padding:
```dart
// ❌ Don't do this
Padding(
  padding: EdgeInsets.all(16),
  child: MyWidget(),
)

// ✅ Do this
AdaptivePadding(
  child: MyWidget(),
)
```

### 6. Use Grid Systems

For card grids or image galleries:
```dart
AdaptiveGrid(
  mobileColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  children: myCards,
)
```

## Testing Responsive Design

### Device Testing Checklist

Test the app on the following configurations:

#### Mobile Devices
- [ ] Small phone (360 x 640) - Portrait
- [ ] Small phone (360 x 640) - Landscape
- [ ] Medium phone (375 x 812) - Portrait
- [ ] Medium phone (375 x 812) - Landscape
- [ ] Large phone (414 x 896) - Portrait
- [ ] Large phone (414 x 896) - Landscape

#### Tablets
- [ ] Small tablet (600 x 1024) - Portrait
- [ ] Small tablet (600 x 1024) - Landscape
- [ ] Medium tablet (768 x 1024) - Portrait
- [ ] Medium tablet (768 x 1024) - Landscape
- [ ] Large tablet (1024 x 1366) - Portrait
- [ ] Large tablet (1024 x 1366) - Landscape

#### Desktop/Web
- [ ] Small desktop (1280 x 720)
- [ ] Medium desktop (1920 x 1080)
- [ ] Large desktop (2560 x 1440)

### Testing in Flutter

#### 1. Using Device Inspector

1. Run your app in debug mode
2. Open DevTools
3. Enable "Select Widget Mode"
4. Use the Device Inspector to test different sizes

#### 2. Using Device Preview (Package)

Add to `pubspec.yaml`:
```yaml
dependencies:
  device_preview: ^1.1.0
```

Wrap your app:
```dart
void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(),
    ),
  );
}
```

#### 3. Manual Testing Commands

```bash
# Run on web with specific size
flutter run -d chrome --web-browser-flag="--window-size=800,600"

# Run on Android emulator (create different AVDs)
flutter emulators

# Run on specific emulator
flutter run -d <emulator-id>
```

### Common Issues & Solutions

#### Issue 1: Text Overflow on Small Screens

❌ Problem:
```dart
Text('Very long text that might overflow on mobile')
```

✅ Solution:
```dart
Text(
  'Very long text that might overflow on mobile',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

#### Issue 2: Fixed Width Containers

❌ Problem:
```dart
Container(
  width: 400,  // Fixed width
  child: MyWidget(),
)
```

✅ Solution:
```dart
Container(
  width: MediaQuery.of(context).size.width * 0.9,  // Responsive width
  constraints: BoxConstraints(maxWidth: 400),
  child: MyWidget(),
)
```

#### Issue 3: Hardcoded Spacing

❌ Problem:
```dart
SizedBox(height: 20),
SizedBox(height: 20),
SizedBox(height: 20),
```

✅ Solution:
```dart
SizedBox(height: ResponsiveUtils.responsiveVerticalPadding(context)),
```

#### Issue 4: Non-Scrollable Content

❌ Problem:
```dart
Column(
  children: [
    LargeWidget(),
    AnotherLargeWidget(),
  ],
)
```

✅ Solution:
```dart
SingleChildScrollView(
  child: Column(
    children: [
      LargeWidget(),
      AnotherLargeWidget(),
    ],
  ),
)
```

## Landscape Mode Support

### Handling Orientation Changes

```dart
ResponsiveUtils.buildResponsive(
  context: context,
  mobile: OrientationBuilder(
    builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        return MobileLandscapeLayout();
      } else {
        return MobilePortraitLayout();
      }
    },
  ),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

### Lock Orientation (When Needed)

In some cases, you may want to lock orientation for specific pages:

```dart
import 'package:flutter/services.dart';

@override
void initState() {
  super.initState();
  // Lock to portrait
  SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

@override
void dispose() {
  // Reset to allow all orientations
  SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  super.dispose();
}
```

## Example Implementations

### Example 1: Responsive Dashboard

```dart
class ResponsiveDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(
            ResponsiveUtils.responsivePadding(context),
          ),
          child: Column(
            children: [
              // Stats cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = ResponsiveUtils.gridCrossAxisCount(
                    context,
                    mobile: 1,
                    tablet: 2,
                    desktop: 4,
                  );
                  
                  if (columns == 1) {
                    return Column(children: statCards);
                  } else {
                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: statCards,
                    );
                  }
                },
              ),
              
              SizedBox(height: DesignSystem.space6),
              
              // Charts
              ResponsiveUtils.buildResponsive(
                context: context,
                mobile: Column(children: charts),
                tablet: GridView.count(
                  crossAxisCount: 2,
                  children: charts,
                ),
                desktop: Row(
                  children: charts.map((c) => Expanded(child: c)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### Example 2: Responsive Form

```dart
class ResponsiveForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.centeredConstrainedContainer(
      context: context,
      maxWidth: 600,
      child: AdaptivePadding(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.responsiveVerticalPadding(context),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              // More fields...
            ],
          ),
        ),
      ),
    );
  }
}
```

## Accessibility Considerations

When implementing responsive design, also consider:

1. **Text Scaling**: Support device text scale settings
2. **Touch Targets**: Ensure buttons are at least 48x48 on mobile
3. **Contrast**: Maintain proper contrast ratios on all screen sizes
4. **Focus**: Ensure keyboard navigation works on larger screens

## Future Enhancements

- [ ] Add support for foldable devices
- [ ] Implement split-screen layouts for tablets
- [ ] Add desktop-specific navigation (sidebar)
- [ ] Optimize for ultra-wide displays

## Resources

- [Flutter Responsive Design](https://docs.flutter.dev/development/ui/layout/responsive)
- [Material Design Responsive Layout](https://material.io/design/layout/responsive-layout-grid.html)
- [Design System Documentation](./lib/design_system/design_tokens.dart)

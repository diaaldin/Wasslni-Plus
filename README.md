# Wasslni Plus - Package Delivery App

![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.5.4-blue.svg)
![License](https://img.shields.io/badge/license-Proprietary-red.svg)

## 📖 Overview

**Wasslni Plus** is a comprehensive package delivery management application built with Flutter. The app supports multi-role functionality including Admin, Manager, Merchant, Courier, and Customer roles, each with tailored interfaces and capabilities. The platform facilitates efficient package tracking, delivery management, and real-time status updates.

### Key Features

- 🔐 **Multi-role Authentication**: Separate interfaces for Admin, Manager, Merchant, Courier, and Customer
- 📦 **Package Management**: Create, track, and manage parcels with barcode support
- 🚚 **Delivery Tracking**: Real-time status updates with progress visualization
- 🗺️ **Route Map**: Interactive Google Maps integration for couriers to visualize delivery routes
- 🌍 **Regional Pricing**: Dynamic pricing based on delivery regions (القدس, الضفة, الداخل)
- 🌐 **Multi-language Support**: Arabic (Primary) and English localization
- 🌙 **Dark Mode**: Full dark/light theme support
- 📱 **Offline Detection**: Network-aware wrapper for connectivity monitoring
- 💳 **Cost Calculation**: Automatic calculation of delivery fees and total costs

### User Roles

1. **Admin**: System-wide control and oversight
2. **Manager**: Branch or region management
3. **Merchant**: Shop owners who send parcels
4. **Courier**: Delivery personnel responsible for transporting parcels
5. **Customer**: Recipients of parcels

## 🏗️ Architecture

### Project Structure

```
lib/
├── flow/                      # Main application flows
│   ├── admin/                 # Admin-specific screens
│   ├── manager/               # Manager-specific screens
│   ├── merchant/              # Merchant-specific screens
│   │   └── parcel/           # Parcel management pages
│   ├── courier/               # Courier-specific screens
│   ├── customer/              # Customer-specific screens
│   └── common/                # Shared screens (settings, privacy policy)
├── models/                    # Data models
│   └── user/                 # User-related models and enums
├── provider/                  # State management
│   └── app_settings_providor.dart
├── widgets/                   # Reusable UI components
│   ├── fields/               # Custom form fields
│   ├── molecules/            # Composite UI components
│   └── language/             # Language switching components
├── l10n/                     # Localization files
│   ├── intl_ar.arb          # Arabic translations
│   └── intl_en.arb          # English translations
├── generated/                # Auto-generated files
├── app_styles.dart           # Global styles and theme
├── config.dart               # App configuration
└── main.dart                 # Application entry point
```

### Technology Stack

- **Framework**: Flutter 3.24.5
- **Language**: Dart 3.5.4
- **State Management**: Provider
- **Localization**: intl & flutter_localizations
- **UI Components**: Material Design 3
- **Connectivity**: connectivity_plus

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  provider: ^6.0.0
  intl: ^0.19.0
  dropdown_search: ^5.0.3
  connectivity_plus: ^5.0.2
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  intl_utils: ^2.0.0
  flutter_lints: ^4.0.0
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.24.5 or higher
- Dart SDK 3.5.4 or higher
- Android Studio / Xcode (for mobile development)
- Node.js 18.19.1+ & npm 8.19.4+ (for Firebase Cloud Functions)
- Firebase CLI 13.27.0+ (for Firebase integration)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd wasslni_plus
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   dart run intl_utils:generate
   # or
   flutter pub run intl_utils:generate
   ```

4. **Run the application**
   ```bash
   flutter run
   # or use the [Run and Debug] menu in VS Code
   ```

## 📱 Development

### Adding New Packages

1. Add the package to `pubspec.yaml`
2. Run `flutter pub get`

### Resolving Package Conflicts

```bash
flutter clean
# or
flutter pub cache repair
flutter pub get
```

### Adding New Translations

1. Open `/lib/l10n/intl_ar.arb` and `/lib/l10n/intl_en.arb`
2. Add the new translation keys with their respective translations
3. Run the localization generator:
   ```bash
   dart run intl_utils:generate
   # or
   flutter pub run intl_utils:generate
   ```

## 🔥 Firebase Integration

### Install and Configure FlutterFire CLI

1. **Activate FlutterFire CLI globally**
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Configure Firebase for your project**
   ```bash
   flutterfire configure --project=<your-firebase-project-id>
   ```

### Firebase Tools

Update Firebase tools to the latest version:
```bash
npm install -g firebase-tools
```

### Cloud Functions

- **Node.js Version**: 18.19.1
- **NPM Version**: 8.19.4

#### Test Functions Locally
```bash
firebase emulators:start
```

#### View Function Logs
```bash
firebase functions:log
```

#### Deploy Functions
```bash
firebase deploy --only functions
```

## 🗺️ Google Maps Setup

The app uses Google Maps to display delivery routes for couriers. To enable this feature:

1. **Get API Keys**
   - Create a Google Cloud Platform (GCP) project
   - Enable Maps SDK for Android and iOS
   - Enable Geocoding API and Directions API
   - Create separate API keys for Android and iOS

2. **Configure Android**
   - Add API key to `android/app/src/main/AndroidManifest.xml`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your Android API key

3. **Configure iOS**
   - Add API key to `ios/Runner/AppDelegate.swift`
   - Add location permissions to `ios/Runner/Info.plist`

4. **Detailed Instructions**
   - See [GOOGLE_MAPS_SETUP.md](GOOGLE_MAPS_SETUP.md) for complete setup guide
   - Includes API key restrictions, security best practices, and troubleshooting

### Quick Test

After setting up API keys, test the map feature:
```bash
flutter run -d android  # or ios
```

Log in as a courier and tap the "Route Map" button to view delivery locations.

**Note:** Google Maps has a free tier with $200 monthly credit. Monitor usage in GCP Console.


## 🍎 iOS Development

### Install Pods (Apple M1 with Rosetta)

```bash
# For Apple M1 users
arch -x86_64 /usr/bin/env bash
cd ios
pod install
flutter run
```

### Clean iOS Build

If you encounter issues:

```bash
flutter clean
rm -rf ios/Pods
rm ios/Podfile.lock
arch -x86_64 /usr/bin/env bash  # For M1 Macs
cd ios
pod install
# or
arch -x86_64 pod install  # For M1 Macs
```

### Build for Release

```bash
flutter build ios --release
```

### Release to TestFlight

1. Open Xcode → Product → Archive (wait for build)
2. Open Organizer (opens automatically)
3. Click "Distribute App" → Select TestFlight or App Store
4. Continue with Apple Developer account

### Run as Production in Xcode

1. Open Xcode → Product → Scheme → Edit Scheme
2. In Run → Info → Set Build Configuration to **Release**

## 🤖 Android Development

### Prerequisites

- **Java Version**: 17.0.13
- **Gradle Version**: 8.0

### Configure Java Home

Add to `gradle.properties`:
```properties
org.gradle.java.home=/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home
```

### Configure Gradle

Update `gradle-wrapper.properties`:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-bin.zip
```

### Build Commands

```bash
flutter clean
cd android
./gradlew clean
./gradlew --stop
./gradlew build
# or
./gradlew clean build

# Check Gradle version
./gradlew -v

# Optional: Update Gradle wrapper
./gradlew wrapper --gradle-version 8.0

# Verify Flutter setup
flutter doctor --verbose

# Build APK
flutter build apk --release
# or
flutter build apk --debug

# Build App Bundle
flutter build appbundle --release
```

## 🔑 Publishing

### Generate Keystore for Google Play

```bash
keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias keyAlias
```

### Configure Signing in build.gradle

Add to `android/app/build.gradle`:

```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias 'keyAlias'
            keyPassword 'your_key_password'
            storeFile file('/path/to/your/my-release-key.jks')
            storePassword 'your_store_password'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## 📦 Version Management

### Using the Version Package

```bash
flutter pub add version
flutter pub run version:increment --build
```

### Manual Version Update Steps

1. **Clean and prepare**
   ```bash
   flutter clean
   flutter pub get
   arch -x86_64 pod install  # For iOS on M1
   ```

2. **Update version in files**:
   - `pubspec.yaml`
   - `android/app/build.gradle`:
     ```gradle
     versionCode 54
     versionName "5.2.34"
     ```
   - `ios/Flutter/AppFrameworkInfo.plist`:
     ```xml
     <key>CFBundleShortVersionString</key>
     <string>5.2.34</string>
     <key>CFBundleVersion</key>
     <string>54.0</string>
     ```

3. **Rebuild in Xcode** and verify version numbers

## 🔧 Troubleshooting

### Clean Rebuild for Android

```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH

rm -rf ~/.gradle/caches
rm -rf ~/.gradle/kotlin-dsl
rm -rf ~/.gradle/daemon
rm -rf ~/.gradle/native

rm -rf android/.gradle

flutter clean
flutter pub get

cd android
./gradlew clean

flutter build appbundle --release
```

### Flutter Compiler Issues

If Flutter stops working:

```bash
cd <path-to-flutter-installation>  # e.g., ~/dev/flutter
git status
git reset --hard
# or
git stash  # if you want to keep changes
```

### Change App Icon

```bash
flutter pub add flutter_launcher_icons
dart run flutter_launcher_icons
```

## 🌐 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Linux
- ✅ Windows

## 📝 License

This project is proprietary software. All rights reserved.

## 📧 Support

For issues, questions, or support requests, please contact the development team or open an issue in the repository.

---

**Built with ❤️ using Flutter**

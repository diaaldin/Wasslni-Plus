# Firebase Integration Quick Start Guide

This guide will help you quickly set up Firebase for the Wasslni Plus app.

## 🚀 Step-by-Step Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter project name: `wasslni-plus` (or your preferred name)
4. Disable Google Analytics (optional, can enable later)
5. Click "Create project"

### 2. Install Firebase CLI

```bash
npm install -g firebase-tools
```

Verify installation:
```bash
firebase --version
```

### 3. Login to Firebase

```bash
firebase login
```

### 4. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 5. Add Firebase Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  # Existing dependencies...
  
  # Firebase Core (required)
  firebase_core: ^2.24.2
  
  # Firebase Authentication
  firebase_auth: ^4.15.3
  
  # Cloud Firestore
  cloud_firestore: ^4.13.6
  
  # Cloud Storage
  firebase_storage: ^11.5.6
  
  # Cloud Messaging (Push Notifications)
  firebase_messaging: ^14.7.9
  
  # Firebase Analytics
  firebase_analytics: ^10.7.4
  
  # Crashlytics
  firebase_crashlytics: ^3.4.8
  
  # Optional: Phone Auth UI
  firebase_ui_auth: ^1.10.1
```

Then run:
```bash
flutter pub get
```

### 6. Configure FlutterFire

Run this command in your project root:

```bash
flutterfire configure --project=wasslni-plus
```

This will:
- Create `firebase_options.dart` file
- Download `google-services.json` for Android
- Download `GoogleService-Info.plist` for iOS
- Configure all platforms

Select the platforms you want to support (Android, iOS, Web, etc.)

### 7. Initialize Firebase in Your App

Update `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettingsProvidor(),
      child: const MyApp(),
    ),
  );
}
```

### 8. Enable Firebase Services

In Firebase Console:

#### Enable Authentication
1. Go to Authentication → Get Started
2. Enable Sign-in methods:
   - Phone
   - Email/Password
   - Google (optional)
   - Apple (optional for iOS)

#### Create Firestore Database
1. Go to Firestore Database → Create Database
2. Start in **test mode** (change to production later)
3. Choose a location (closest to your users)

#### Enable Cloud Storage
1. Go to Storage → Get Started
2. Start in **test mode** (change to production later)

#### Enable Cloud Messaging
1. Go to Cloud Messaging → Enable

### 9. Set Up Security Rules

#### Firestore Security Rules

Go to Firestore → Rules and replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    function hasRole(role) {
      return isSignedIn() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == role;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isOwner(userId) || hasRole('admin');
      allow delete: if hasRole('admin');
    }
    
    // Parcels collection
    match /parcels/{parcelId} {
      allow read: if isSignedIn();
      allow create: if hasRole('merchant') || hasRole('admin');
      allow update: if hasRole('merchant') || hasRole('courier') || 
                       hasRole('manager') || hasRole('admin');
      allow delete: if hasRole('admin') || hasRole('merchant');
    }
    
    // Regions collection
    match /regions/{regionId} {
      allow read: if true; // Public read
      allow write: if hasRole('admin');
    }
    
    // Notifications collection
    match /notifications/{notificationId} {
      allow read: if isOwner(resource.data.userId);
      allow create: if isSignedIn();
      allow update: if isOwner(resource.data.userId);
      allow delete: if isOwner(resource.data.userId) || hasRole('admin');
    }
    
    // Reviews collection
    match /reviews/{reviewId} {
      allow read: if isSignedIn();
      allow create: if hasRole('customer');
      allow update: if isOwner(resource.data.customerId);
      allow delete: if hasRole('admin');
    }
  }
}
```

#### Storage Security Rules

Go to Storage → Rules and replace with:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Helper function
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Profile photos
    match /profile_photos/{userId}/{fileName} {
      allow read: if true;
      allow write: if isSignedIn() && request.auth.uid == userId;
    }
    
    // Parcel images
    match /parcel_images/{parcelId}/{fileName} {
      allow read: if isSignedIn();
      allow write: if isSignedIn();
    }
    
    // Proof of delivery
    match /delivery_proof/{parcelId}/{fileName} {
      allow read: if isSignedIn();
      allow write: if isSignedIn();
    }
    
    // Business licenses
    match /business_licenses/{userId}/{fileName} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && request.auth.uid == userId;
    }
  }
}
```

### 10. Create Initial Data Structure

Create a file `lib/services/firebase_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Initialize default regions
  static Future<void> initializeDefaultRegions() async {
    final regions = [
      {
        'name': 'القدس',
        'nameAr': 'القدس',
        'nameEn': 'Jerusalem',
        'deliveryFee': 30,
        'isActive': true,
        'estimatedDeliveryDays': 1,
      },
      {
        'name': 'الضفة',
        'nameAr': 'الضفة',
        'nameEn': 'West Bank',
        'deliveryFee': 20,
        'isActive': true,
        'estimatedDeliveryDays': 1,
      },
      {
        'name': 'الداخل',
        'nameAr': 'الداخل',
        'nameEn': 'Inside',
        'deliveryFee': 70,
        'isActive': true,
        'estimatedDeliveryDays': 2,
      },
    ];
    
    final batch = _firestore.batch();
    for (var region in regions) {
      final docRef = _firestore.collection('regions').doc();
      batch.set(docRef, region);
    }
    await batch.commit();
  }
}
```

### 11. Test Firebase Connection

Create a simple test in your app to verify Firebase is working:

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> testFirebaseConnection() async {
  try {
    // Test Firestore
    await FirebaseFirestore.instance
        .collection('test')
        .add({'timestamp': FieldValue.serverTimestamp()});
    print('✅ Firestore connected successfully');
    
    // Test Auth
    final currentUser = FirebaseAuth.instance.currentUser;
    print('✅ Auth initialized. Current user: $currentUser');
    
  } catch (e) {
    print('❌ Firebase connection error: $e');
  }
}
```

### 12. Android Configuration

Ensure `android/app/build.gradle` has:

```gradle
dependencies {
    // ... other dependencies
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
}
```

And in `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

At the bottom of `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

### 13. iOS Configuration

1. Open `ios/Runner.xcworkspace` in Xcode
2. Verify `GoogleService-Info.plist` is in the Runner folder
3. Add push notification capability if using FCM

### 14. Initialize Cloud Functions (Optional)

```bash
firebase init functions
```

Select:
- Language: TypeScript or JavaScript
- Install dependencies: Yes

### 15. Deploy Security Rules

```bash
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

## ✅ Verification Checklist

- [ ] Firebase project created
- [ ] Firebase CLI installed and logged in
- [ ] FlutterFire CLI installed
- [ ] Firebase dependencies added to pubspec.yaml
- [ ] `flutterfire configure` executed successfully
- [ ] `firebase_options.dart` generated
- [ ] Firebase initialized in main.dart
- [ ] Authentication methods enabled
- [ ] Firestore database created
- [ ] Cloud Storage enabled
- [ ] Security rules configured
- [ ] Test connection successful

## 🎯 Next Steps

After completing this setup:

1. Create authentication screens and logic
2. Implement user registration/login
3. Create Firestore CRUD services
4. Build UI to interact with Firebase data
5. Implement real-time listeners
6. Add push notifications
7. Test thoroughly

## 📚 Useful Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Cloud Functions Documentation](https://firebase.google.com/docs/functions)

## 🆘 Troubleshooting

**Issue**: FlutterFire configure fails
- **Solution**: Ensure Firebase CLI is up to date: `npm install -g firebase-tools`

**Issue**: iOS build fails after adding Firebase
- **Solution**: Run `pod install` in the ios directory

**Issue**: Android build fails
- **Solution**: Check that `google-services.json` is in `android/app/`

**Issue**: Firebase not initializing
- **Solution**: Ensure `WidgetsFlutterBinding.ensureInitialized()` is called before Firebase.initializeApp()

---

**Created**: 2025-11-29  
**Last Updated**: 2025-11-29

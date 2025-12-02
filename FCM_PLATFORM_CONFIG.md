# Firebase Cloud Messaging (FCM) Platform Configuration

This guide provides step-by-step instructions for configuring Firebase Cloud Messaging on Android and iOS platforms.

## Prerequisites

- Firebase project created (see `FIREBASE_SETUP.md`)
- FCMService already implemented in `lib/services/fcm_service.dart`
- Flutter app configured with Firebase Core

## Android Configuration

### 1. Download google-services.json

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (`wani-plus`)
3. Go to **Project Settings** > **General**
4. Scroll to **Your apps** section
5. Click on your Android app
6. Click **Download google-services.json**
7. Place the file in `android/app/google-services.json`

### 2. Update AndroidManifest.xml

Add the following to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <!-- Existing content -->
        
        <!-- FCM Notification Channel (for Android 8.0+) -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="default_channel" />
        
        <!-- FCM Notification Icon -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_notification" />
            
        <!-- FCM Notification Color -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/primary" />
    </application>
</manifest>
```

### 3. Add Notification Icon

Create a notification icon at `android/app/src/main/res/drawable/ic_notification.xml`:

```xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24"
    android:tint="?attr/colorControlNormal">
    <path
        android:fillColor="@android:color/white"
        android:pathData="M12,22c1.1,0 2,-0.9 2,-2h-4c0,1.1 0.89,2 2,2zM18,16v-5c0,-3.07 -1.64,-5.64 -4.5,-6.32V4c0,-0.83 -0.67,-1.5 -1.5,-1.5s-1.5,0.67 -1.5,1.5v0.68C7.63,5.36 6,7.92 6,11v5l-2,2v1h16v-1l-2,-2z"/>
</vector>
```

### 4. Verify build.gradle

Ensure `android/app/build.gradle` has:

```gradle
dependencies {
    // Existing dependencies
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-messaging'
}

apply plugin: 'com.google.gms.google-services'
```

## iOS Configuration

### 1. Download GoogleService-Info.plist

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (`wani-plus`)
3. Go to **Project Settings** > **General**
4. Scroll to **Your apps** section
5. Click on your iOS app
6. Click **Download GoogleService-Info.plist**
7. Place the file in `ios/Runner/GoogleService-Info.plist`
8. Add it to Xcode project (right-click Runner folder → Add Files to "Runner")

### 2. Enable Push Notifications Capability

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** project in the navigator
3. Select the **Runner** target
4. Go to **Signing & Capabilities** tab
5. Click **+ Capability**
6. Add **Push Notifications**
7. Add **Background Modes** and check:
   - Remote notifications
   - Background fetch

### 3. Update AppDelegate.swift

Ensure `ios/Runner/AppDelegate.swift` has FCM setup:

```swift
import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    // Request notification permission
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func application(_ application: UIApplication, 
                           didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
}
```

### 4. Configure APNs

#### Development (Testing)

1. Go to [Apple Developer Portal](https://developer.apple.com/)
2. Go to **Certificates, IDs & Profiles**
3. Select **Keys**
4. Click **+** to create a new key
5. Name it "FCM Push Notifications Key"
6. Check **Apple Push Notifications service (APNs)**
7. Download the `.p8` key file
8. Note the **Key ID** and **Team ID**

#### Upload to Firebase

1. Go to Firebase Console
2. Select your project
3. Go to **Project Settings** > **Cloud Messaging**
4. Under **iOS app configuration**, click **Upload**
5. Upload your APNs `.p8` key file
6. Enter your **Key ID** and **Team ID**

#### Production (App Store)

For production, you'll need an APNs certificate:
1. Create a CSR (Certificate Signing Request) in Keychain Access
2. Go to Apple Developer Portal
3. Create an **Apple Push Notification service SSL (Production)** certificate
4. Download and install the certificate
5. Export as `.p12` file
6. Upload to Firebase Console

## Testing FCM

### Test on Android

```bash
# Send a test message from Firebase Console
# Or use curl:
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Test Notification",
      "body": "This is a test message"
    },
    "data": {
      "type": "test",
      "click_action": "FLUTTER_NOTIFICATION_CLICK"
    }
  }'
```

### Test on iOS

1. Run app on a physical device (push notifications don't work on simulator)
2. Accept notification permissions
3. Check FCM token in logs
4. Send test message from Firebase Console

## Troubleshooting

### Android Issues

**Problem**: Notifications not appearing
- Check `google-services.json` is in correct location
- Verify notification channel is created
- Check notification permissions in device settings

**Problem**: App crashes on startup
- Ensure Firebase is initialized before FCM
- Check all dependencies are added correctly

### iOS Issues

**Problem**: No FCM token
- Ensure APNs certificate/key is uploaded to Firebase
- Check device is physical (not simulator)
- Verify capabilities are enabled in Xcode

**Problem**: Notifications not appearing
- Check notification permissions are granted
- Verify APNs token is set in AppDelegate
- Ensure app is in background (foreground needs custom handling)

## Next Steps

1. Complete platform configuration
2. Test notifications on both platforms
3. Implement custom notification UI
4. Set up notification topics for targeted messaging
5. Monitor notification delivery in Firebase Console

## References

- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Firebase Messaging Plugin](https://firebase.flutter.dev/docs/messaging/overview)
- [APNs Overview](https://developer.apple.com/documentation/usernotifications)

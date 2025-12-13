# iOS Firebase Cloud Messaging (FCM) Setup Guide

This guide explains how to configure Firebase Cloud Messaging for iOS in the Wasslni Plus app.

## Prerequisites

- Apple Developer Account ($99/year)
- Access to Apple Developer Console
- Access to Firebase Console
- Xcode installed on macOS

---

## Step 1: Download GoogleService-Info.plist

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your **Wasslni Plus** project
3. Click the **iOS** app (or add one if it doesn't exist)
4. Download the `GoogleService-Info.plist` file
5. Copy it to: `d:\Wasslni-Plus\ios\Runner\GoogleService-Info.plist`

---

## Step 2: Configure Apple Push Notification Service (APNs)

### 2.1 Create APNs Authentication Key

1. Go to [Apple Developer Console](https://developer.apple.com/account/)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Keys** in the sidebar
4. Click the **+** button to create a new key
5. Give it a name (e.g., "Wasslni Plus APNs Key")
6. Check **Apple Push Notifications service (APNs)**
7. Click **Continue**, then **Register**
8. **Download the .p8 file** (you can only download it once!)
9. Note the **Key ID** shown on the page

### 2.2 Upload APNs Key to Firebase

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Select the **Cloud Messaging** tab
3. Scroll to **Apple app configuration**
4. Under **APNs Authentication Key**, click **Upload**
5. Upload the .p8 file you downloaded
6. Enter your **Team ID** (found in Apple Developer Console > Membership)
7. Enter the **Key ID** from step 2.1
8. Click **Upload**

---

## Step 3: Configure Xcode Project

### 3.1 Add Push Notification Capability

1. Open the project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Select the **Runner** target
3. Go to the **Signing & Capabilities** tab
4. Click **+ Capability**
5. Add **Push Notifications**
6. Add **Background Modes**
7. Under Background Modes, check:
   - **Remote notifications**
   - **Background fetch** (optional)

### 3.2 Update Info.plist

Add the following to `ios/Runner/Info.plist`:

```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

This allows manual handling of FCM tokens.

---

## Step 4: Update AppDelegate.swift

Replace the contents of `ios/Runner/AppDelegate.swift` with:

```swift
import UIKit
import Flutter
import Firebase
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase
    FirebaseApp.configure()
    
    // Request notification permissions (iOS 10+)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings =
      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle APNs token
  override func application(_ application: UIApplication, 
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  // Handle foreground notifications
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([[.alert, .sound, .badge]])
  }
  
  // Handle notification tap
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
```

---

## Step 5: Update Podfile

Ensure your `ios/Podfile` includes:

```ruby
platform :ios, '12.0'

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  # Add this if not present
  pod 'Firebase/Messaging'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

---

## Step 6: Install Pods

```bash
cd ios
pod install
pod update Firebase
cd ..
```

---

## Step 7: Configure App ID

1. Go to [Apple Developer Console](https://developer.apple.com/account/)
2. Navigate to **Identifiers**
3. Find or create your app identifier (e.g., `com.wasslniplus.app`)
4. Ensure **Push Notifications** capability is enabled
5. Click **Save**

---

## Step 8: Update Provisioning Profile

1. In Apple Developer Console, go to **Profiles**
2. Create or regenerate your provisioning profile
3. Ensure it includes the **Push Notifications** capability
4. Download and install the profile in Xcode

---

## Step 9: Test Notifications

### Using Firebase Console

1. Go to Firebase Console > **Cloud Messaging**
2. Click **Send your first message**
3. Enter notification title and text
4. Click **Send test message**
5. Enter your FCM token (get from Flutter app debug logs)
6. Click **Test**

### Using Flutter App

Run the app on an iOS device (not simulator - push notifications don't work on simulator):

```bash
flutter run --release
```

Check the console for the FCM token and test receiving notifications.

---

## Troubleshooting

### Token not received

- Ensure you're testing on a **real device** (not simulator)
- Check that Push Notifications capability is enabled in Xcode
- Verify APNs key is uploaded to Firebase
- Check `Info.plist` has `FirebaseAppDelegateProxyEnabled` set to false

### Notifications not appearing

- Ensure app is in background/killed state
- Check notification permissions are granted
- Verify payload format is correct
- Check Firebase Console > Cloud Messaging for delivery reports

### Build errors

- Run `pod deintegrate` then `pod install` in ios/ directory
- Clean build folder in Xcode (Product > Clean Build Folder)
- Delete `Podfile.lock` and `Pods` folder, then run `pod install`

### APNs errors in Firebase Console

- Verify Team ID is correct
- Ensure Key ID matches the uploaded .p8 file
- Check that the .p8 file is valid and not corrupted
- Regenerate APNs key if necessary

---

## Production Checklist

- [ ] APNs Authentication Key uploaded to Firebase
- [ ] Push Notifications capability enabled in Xcode
- [ ] Background Modes configured
- [ ] `GoogleService-Info.plist` added to project
- [ ] AppDelegate.swift updated with FCM handling
- [ ] Tested on real iOS device
- [ ] App registered for remote notifications
- [ ] FCM tokens being saved to Firestore
- [ ] Provisioning profile includes Push Notifications
- [ ] Production APNs certificate configured (if using certificates instead of auth key)

---

## Additional Resources

- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- [FCM for iOS](https://firebase.google.com/docs/cloud-messaging/ios/client)
- [APNs Overview](https://developer.apple.com/documentation/usernotifications)
- [Flutter Firebase Messaging](https://firebase.flutter.dev/docs/messaging/overview)

---

**Note**: This configuration is required for production iOS builds. For development and testing, you can use Android which has simpler FCM setup.

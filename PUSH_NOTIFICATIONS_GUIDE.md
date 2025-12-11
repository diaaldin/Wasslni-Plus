# Push Notifications Implementation Guide

## Overview

This document describes the push notification system implemented for the Wasslni Plus application. The system enables real-time notifications for parcel status changes and other important events.

## Architecture

The push notification system consists of three main components:

### 1. Firebase Cloud Messaging (FCM) Service
**File:** `lib/services/fcm_service.dart`

Handles:
- FCM initialization and permission requests
- Token management and updates
- Foreground and background message handling
- Topic subscriptions for role-based notifications

### 2. Notification Navigation Service
**File:** `lib/services/notification_navigation_service.dart`

Handles:
- Global navigator key management
- Notification action stream for UI navigation
- Foreground notification display as SnackBars
- Decoupling of FCM from UI navigation logic

### 3. Notification Navigation Listener
**File:** `lib/widgets/notification_navigation_listener.dart`

Handles:
- Listening to notification action streams
- Role-based navigation to appropriate pages
- Fetching parcel details from Firestore
- Error handling and user feedback

### 4. Firebase Cloud Functions
**File:** `functions/index.js`

Cloud functions that trigger notifications:
- `onParcelStatusChange` - Sends notifications when parcel status changes
- `onParcelDelivered` - Updates statistics and sends delivery confirmation
- `onParcelCreated` - Assigns barcode and sends welcome notification
- `onUserCreated` - Sends welcome notification to new users
- `sendDeliveryReminders` - Scheduled function for daily reminders

## Features

### Foreground Notifications
When the app is open, notifications appear as rich SnackBars with:
- Notification title and body
- "View" action button to navigate to related content
- Auto-dismiss after 5 seconds

### Background Notifications
When the app is in the background or terminated:
- System notifications appear in the notification tray
- Tapping a notification opens the app and navigates to related content
- Notification data is preserved for later processing

### Deep Linking
Notifications support deep linking to specific pages based on:
- **User Role:** Customers see tracking pages, merchants see parcel details, couriers see delivery details
-  **Notification Type:** Different notification types route to different pages
- **Parcel ID:** Automatically fetches and displays parcel information

## Notification Types

### 1. Parcel Status Update (`parcel_status_update`)
**Triggered when:** A parcel's status changes
**Sent to:** Customer, Merchant, Courier (if assigned)
**Navigates to:** 
- Customer: Tracking page
- Merchant/Admin: Parcel details page
- Courier: Delivery details page

**Data payload:**
```javascript
{
  type: 'parcel_status_update',
  parcelId: '<parcel_id>',
  status: '<new_status>'
}
```

### 2. New Parcel Assignment (`new_parcel_assignment`)
**Triggered when:** A courier is assigned to a parcel
**Sent to:** Assigned courier
**Navigates to:** Delivery details page

**Data payload:**
```javascript
{
  type: 'new_parcel_assignment',
  parcelId: '<parcel_id>'
}
```

### 3. Delivery Reminder (`delivery_reminder`)
**Triggered when:** Daily scheduled function runs
**Sent to:** Customer with delivery scheduled for today
**Navigates to:** Tracking page

**Data payload:**
```javascript
{
  type: 'delivery_reminder',
  parcelId: '<parcel_id>'
}
```

### 4. Promotional Notification (`promotional`)
**Triggered when:** Admin sends bulk promotional message
**Sent to:** Based on topic subscription

### 5. System Announcement (`system_announcement`)
**Triggered when:** Admin sends system-wide announcement
**Sent to:** All users via `all_users` topic

## How It Works

### 1. Initialization (App Startup)
```dart
// in main.dart
await FCMService().initialize();
```

- Requests notification permissions (iOS)
- Retrieves FCM token
- Saves token to Firestore user profile
- Sets up message handlers
- Subscribes to role-based topics

### 2. Cloud Function Triggers Notification
```javascript
// Firebase Cloud Function
const payload = {
  notification: {
    title: 'Parcel Status Update',
    body: 'Your parcel is now Out for Delivery.',
  },
  data: {
    type: 'parcel_status_update',
    parcelId: 'PKG123',
    status: 'outForDelivery',
  },
};

await admin.messaging().sendToDevice(fcmToken, payload);
```

### 3. FCM Service Receives Notification
```dart
// Foreground message
if (!isBackground && message.notification != null) {
  _navigationService.showForegroundNotification(
    title: message.notification!.title ?? '',
    body: message.notification!.body ?? '',
    data: message.data,
  );
}

// Background message tap
if (isBackground) {
  _navigationService.handleNotificationTap(message.data);
}
```

### 4. Navigation Service Emits Action
```dart
final action = NotificationAction(
  type: type,
  parcelId: parcelId,
  data: data,
);

_notificationActionController.add(action);
```

### 5. Navigation Listener Handles Action
```dart
_navigationService.notificationStream.listen((action) {
  switch (action.type) {
    case 'parcel_status_update':
      _navigateToParcelDetails(parcelId, userRole);
      break;
    // ... other cases
  }
});
```

### 6. Navigation to Target Page
- Fetches parcel details from Firestore
- Determines correct page based on user role
- Pushes the page onto navigation stack

## Topic Subscriptions

Users are automatically subscribed to topics based on their role:

### Role-based Topics
- `role_admin` - All admin users
- `role_manager` - All manager users
- `role_merchant` - All merchant users
- `role_courier` - All courier users
- `role_customer` - All customer users

### Universal Topic
- `all_users` - Every authenticated user

### Region-based Topics
- `region_jerusalem` - Users in Jerusalem region
- `region_westbank` - Users in West Bank region
- `region_israel` - Users in Israel region

Example subscription:
```dart
await FCMService().subscribeToRoleTopics('customer');
await FCMService().subscribeToRegionTopics(['jerusalem', 'westbank']);
```

## Testing Push Notifications

### Testing with Firebase Console
1. Go to **Firebase Console > Cloud Messaging**
2. Click **Send your first message**
3. Enter notification title and text
4. Select target (single device, topic, or condition)
5. Add custom data:
   ```
   type: parcel_status_update
   parcelId: <test_parcel_id>
   ```
6. Send the message

### Testing with Cloud Functions
1. Deploy cloud functions:
   ```bash
   cd functions
   npm install
   firebase deploy --only functions
   ```
2. Update a parcel status in Firestore
3. Cloud function automatically triggers and sends notification

### Testing Locally
1. Run the app on a physical device or emulator
2. Trigger a parcel status change
3. Observe foreground/background notification behavior

## Troubleshooting

### Notifications Not Received

**Problem:** User not receiving notifications

**Solutions:**
1. Check notification permissions:
   ```dart
   NotificationSettings settings = await messaging.requestPermission();
   print(settings.authorizationStatus);
   ```

2. Verify FCM token is saved:
   ```dart
   String? token = await FCMService().fcmToken;
   print('FCM Token: $token');
   ```

3. Check Firestore user document has `fcmToken` field

### Deep Linking Not Working

**Problem:** Tapping notification doesn't navigate

**Solutions:**
1. Verify `navigatorKey` is set on `MaterialApp`:
   ```dart
   MaterialApp(
     navigatorKey: NotificationNavigationService().navigatorKey,
     // ...
   )
   ```

2. Ensure `NotificationNavigationListener` wraps the app:
   ```dart
   home: const NotificationNavigationListener(
     child: AuthenticationHandler(),
   )
   ```

3. Check notification data payload contains required fields

### iOS Notifications Not Working

**Problem:** Notifications work on Android but not iOS

**Solutions:**
1. Configure APNs (Apple Push Notification service) in Firebase
2. Add `GoogleService-Info.plist` to iOS project
3. Enable Push Notifications capability in Xcode
4. Request permissions at runtime

##Future Enhancements

### Planned Features
- [ ] Rich notifications with images
- [ ] Notification grouping and channels
- [ ] Notification actionable buttons (e.g., "Mark as Read", "View Later")
- [ ] In-app notification center with history
- [ ] Notification preferences (mute, frequency, types)
- [ ] Sound and vibration customization
- [ ] Localized notification content (Arabic/English)

### Advanced Use Cases
- [ ] Geofencing notifications (when courier is nearby)
- [ ] Smart notification timing (based on user activity patterns)
- [ ] Notification analytics and engagement tracking
- [ ] A/B testing for notification content

## Security Considerations

1. **Token Management:**
   - Tokens are securely stored in Firestore
   - Tokens are refreshed automatically
   - Old tokens are deleted on logout

2. **Access Control:**
   - Cloud Functions validate user authentication
   - Firestore rules restrict token updates to authorized users

3. **Data Privacy:**
   - Notification payload doesn't contain sensitive information
    - Full data is fetched from Firestore post-navigation

## Performance Optimization

1. **Stream Management:**
   - Single broadcast stream for notification actions
   - Automatic stream disposal when app closes

2. **Efficient Navigation:**
   - Lazy loading of parcel details
   - Caching of frequently accessed data

3. **Token Refresh:**
   - Background token update without user interaction
   - Graceful handling of token refresh failures

## Conclusion

The push notification system is now fully integrated and operational. It provides:
- ✅ Real-time status updates
- ✅ Role-based deep linking
- ✅ Foreground and background support
- ✅ Topic-based bulk messaging
- ✅ Scheduled reminders
- ✅ Comprehensive error handling

For any issues or questions, refer to the Firebase documentation or the code comments.

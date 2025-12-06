# Google Maps Setup Guide

This guide will help you set up Google Maps for the Wasslni Plus app.

## Overview

The app uses Google Maps to display delivery routes and locations for couriers. To enable this functionality, you need to:
1. Create a Google Cloud Platform (GCP) project
2. Enable the required APIs
3. Create API keys for Android and iOS
4. Configure the API keys in your app

---

## Step 1: Create a Google Cloud Platform Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click on "Select a project" at the top
3. Click "New Project"
4. Enter project name: "Wasslni Plus" (or your preferred name)
5. Select your billing account (required for Maps API)
6. Click "Create"

---

## Step 2: Enable Required APIs

In your GCP project, enable the following APIs:

### 2.1 Enable Maps SDK for Android
1. Go to [Google Maps Platform](https://console.cloud.google.com/google/maps-apis/)
2. Click "Enable APIs"
3. Search for "Maps SDK for Android"
4. Click on it and press "Enable"

### 2.2 Enable Maps SDK for iOS
1. Search for "Maps SDK for iOS"
2. Click on it and press "Enable"

### 2.3 Enable Geocoding API (Optional but recommended)
1. Search for "Geocoding API"
2. Click on it and press "Enable"

### 2.4 Enable Directions API (Optional but recommended for route optimization)
1. Search for "Directions API"
2. Click on it and press "Enable"

---

## Step 3: Create API Keys

### 3.1 Create Android API Key

1. Go to [Credentials](https://console.cloud.google.com/apis/credentials)
2. Click "Create Credentials" → "API Key"
3. Copy the generated API key
4. Click "Edit API Key" (pencil icon)
5. Under "API restrictions":
   - Select "Restrict key"
   - Check: Maps SDK for Android, Geocoding API, Directions API
6. Under "Application restrictions":
   - Select "Android apps"
   - Click "Add an item"
   - Get your SHA-1 fingerprint:
     ```bash
     # For debug keystore (development)
     keytool -list -v -keystore "C:\Users\YOUR_USERNAME\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
     
     # For release keystore (production)
     keytool -list -v -keystore "path/to/your/release.keystore" -alias your_alias
     ```
   - Enter package name: `com.wasslni.plus` (or your actual package name)
   - Enter SHA-1 fingerprint
7. Click "Save"

### 3.2 Create iOS API Key

1. Go to [Credentials](https://console.cloud.google.com/apis/credentials)
2. Click "Create Credentials" → "API Key"
3. Copy the generated API key
4. Click "Edit API Key"
5. Under "API restrictions":
   - Select "Restrict key"
   - Check: Maps SDK for iOS, Geocoding API, Directions API
6. Under "Application restrictions":
   - Select "iOS apps"
   - Click "Add an item"
   - Enter iOS bundle ID: `com.wasslni.plus` (or your actual bundle ID)
7. Click "Save"

---

## Step 4: Configure API Keys in Your App

### 4.1 Android Configuration

**File:** `android/app/src/main/AndroidManifest.xml`

Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your Android API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ANDROID_API_KEY"/>
```

### 4.2 iOS Configuration

**File:** `ios/Runner/AppDelegate.swift`

Add the following import at the top:
```swift
import GoogleMaps
```

In the `application` method, add:
```swift
GMSServices.provideAPIKey("YOUR_IOS_API_KEY")
```

**File:** `ios/Runner/Info.plist`

Add location permissions:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to show delivery routes and navigate to delivery points.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to your location to track deliveries and provide accurate navigation.</string>
```

---

## Step 5: Security Best Practices

### 5.1 Protect Your API Keys

**IMPORTANT:** Never commit API keys to version control!

1. Create a local configuration file (already in `.gitignore`):
   - `android/local.properties` for Android secrets
   - Use environment variables or Flutter's `--dart-define`

2. For production:
   - Use different API keys for debug/release builds
   - Implement billing alerts in GCP
   - Monitor API usage regularly

### 5.2 Set Usage Limits

1. Go to [Quotas](https://console.cloud.google.com/apis/api/maps-backend.googleapis.com/quotas)
2. Set daily limits to prevent unexpected charges
3. Enable billing alerts

---

## Step 6: Testing

### 6.1 Test on Android
```bash
flutter run -d android
```

### 6.2 Test on iOS
```bash
flutter run -d ios
```

### 6.3 Verify Map Functionality

1. Log in as a courier
2. If you have delivery assignments, click the "Route Map" button
3. The map should load showing:
   - Your current location (blue marker)
   - Delivery points (colored markers based on status)
   - Map controls (zoom, location button, route toggle)

---

## Troubleshooting

### Map Not Displaying

**Android:**
- Verify API key is correct in `AndroidManifest.xml`
- Check SHA-1 fingerprint matches the one in GCP
- Ensure "Maps SDK for Android" is enabled
- Check Logcat for error messages

**iOS:**
- Verify API key is set in `AppDelegate.swift`
- Ensure bundle ID matches the one in GCP
- Check location permissions are granted

### "This page can't load Google Maps correctly"
- API key is invalid or not properly configured
- Billing is not enabled in GCP
- API restrictions are too strict

### Location Not Working
- Location permissions not granted
- Location services disabled on device
- GPS signal weak or unavailable

### Geocoding Errors
- Geocoding API not enabled
- API key doesn't have Geocoding API permission
- Address format is invalid

---

## Pricing Information

Google Maps Platform has a free tier with monthly credits:
- $200 free credit per month
- Maps SDK for Android/iOS: $7 per 1,000 map loads
- Geocoding API: $5 per 1,000 requests
- Directions API: $5 per 1,000 requests

**Tip:** The free $200 credit covers approximately:
- 28,500 map loads, OR
- 40,000 geocoding requests, OR
- 40,000 directions requests

Monitor usage in [GCP Billing](https://console.cloud.google.com/billing)

---

## Additional Resources

- [Google Maps Platform Documentation](https://developers.google.com/maps/documentation)
- [Maps SDK for Flutter](https://pub.dev/packages/google_maps_flutter)
- [Geocoding API Documentation](https://developers.google.com/maps/documentation/geocoding)
- [Directions API Documentation](https://developers.google.com/maps/documentation/directions)

---

## Notes for Production

1. **Store Coordinates in Firestore:** Instead of geocoding addresses every time, store latitude/longitude in the `ParcelModel` when creating/editing parcels
2. **Optimize API Calls:** Cache geocoding results
3. **Implement Route Optimization:** Use Directions API to create optimized delivery routes
4. **Add Offline Support:** Cache map tiles for offline viewing
5. **Real-time Tracking:** Implement courier location updates using Firestore

---

**Last Updated:** 2025-12-06

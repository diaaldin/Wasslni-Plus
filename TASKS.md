# Wasslni Plus - Development Tasks

## 📋 Project Status

This document outlines all tasks required to complete the **Wasslni Plus** package delivery app UI and integrate Firebase Firestore database.

**Note**: The app MUST support both **Arabic (primary)** and **English** languages. Every UI element, message, label, and text content must be translated to both languages.

---

## 🔧 Phase 0: Initial Setup & Branding (PRIORITY - COMPLETE FIRST!)

### 0.1 App Renaming & Configuration

- [x] **Rename App to "Wasslni Plus"**
  - [x] Update `pubspec.yaml`: Change `name` from `turoudi` to `wasslni_plus`
  - [x] Update package name in all import statements
  - [ ] Rename project folder from `turoudi` to `wasslni_plus` (optional but recommended)
  - [x] Update `AndroidManifest.xml`: Change `android:label` to "Wasslni Plus"
  - [x] Update iOS `Info.plist`: Change `CFBundleDisplayName` to "Wasslni Plus"
  - [x] Update iOS `Runner.xcodeproj`: Change product name
  - [x] Update app display name in all platform configs
  - [x] **Add Arabic translation**: "وصلني بلس" in localization files
  - [x] **Add English translation**: "Wasslni Plus" in localization files

- [x] **Update Branding Assets**
  - [x] Design new app icon with "Wasslni Plus" branding
  - [x] Update splash screen with new app name
  - [x] Create app logo assets (Arabic and English versions)
  - [x] Update color scheme if needed to match new brand
  - [x] Update `app_styles.dart` with brand colors
  - [x] Generate launcher icons using `flutter_launcher_icons`

### 0.2 Localization Setup (Arabic & English ONLY)

- [x] **Remove Hebrew Support**
  - [x] Delete `lib/l10n/intl_he.arb` file
  - [x] Update supported locales to only Arabic and English
  - [x] Remove Hebrew from language switcher UI
  - [x] Clean up any Hebrew-specific code

- [x] **Verify Arabic & English Localization Files**
  - [x] Review `lib/l10n/intl_ar.arb` for completeness
  - [x] Review `lib/l10n/intl_en.arb` for completeness
  - [x] Ensure all existing keys have both Arabic and English translations
  - [x] Add missing translations for existing UI elements
  - [x] Test language switching between Arabic and English
  - [x] Set Arabic as default language
  - [x] Ensure RTL (Right-to-Left) support for Arabic
  - [x] Test LTR (Left-to-Right) for English

- [x] **Add New Translation Keys for App Name**
  - [x] Add `app_name`: "Wasslni Plus" (en) / "وصلني بلس" (ar)
  - [x] Add `app_tagline`: "Fast & Reliable Delivery" (en) / "توصيل سريع وموثوق" (ar)
  - [x] Add `welcome_to_app`: "Welcome to Wasslni Plus" (en) / "مرحباً بك في وصلني بلس" (ar)
  - [x] Run `dart run intl_utils:generate` to generate localization classes

### 0.3 Documentation Updates

- [x] **Update All Documentation Files**
  - [x] Update README.md: Replace "Turoudi" with "Wasslni Plus"
  - [x] Update FIREBASE_SETUP.md: Replace project references
  - [x] Update DOCUMENTATION_SUMMARY.md: Update app name
  - [x] Add note about Arabic/English-only support
  - [x] Update Firebase project configuration instructions

- [x] **Update Code Comments**
  - [x] Search and replace "Turoudi" with "Wasslni Plus" in code comments
  - [x] Update file headers if any

### 0.4 Translation Requirements Documentation

- [x] **Create Translation Guidelines Document**
  - [x] Document naming conventions for translation keys
  - [x] Create list of all UI text that needs translation
  - [x] Define translation workflow for new features
  - [x] Add examples of good Arabic/English translations


- [ ] **Courier Management**
  - [ ] Create courier assignment interface
  - [ ] Build courier availability tracker
  - [ ] Add courier performance reports
  - [ ] Implement route optimization suggestions

- [ ] **Regional Analytics**
  - [ ] Build delivery success rate charts
  - [ ] Add time-based analytics
  - [ ] Create regional comparison views
  - [ ] Implement export functionality for reports

### 1.4 Merchant Dashboard (Enhance Existing)

- [x] **Merchant Main Page**
  - [x] Replace placeholder with actual dashboard
  - [x] Add quick stats (pending, in-transit, delivered)
  - [x] Display recent parcels list
  - [x] Add revenue tracking
  - [x] Implement monthly delivery summary

- [ ] **Parcels Management (Enhance)**
  - [x] Add bulk parcel upload (CSV/Excel)
  - [x] Implement parcel editing functionality
  - [x] Add parcel cancellation with reason
  - [x] Create parcel history/timeline view
  - [x] Add print label/receipt functionality
  - [x] Implement advanced filters (search, status, region)
  - [x] Add export to PDF/Excel

- [ ] **Add Parcel Page (Enhance)**
  - [x] Connect barcode scanner functionality
  - [x] Add image upload for parcel
  - [x] Implement package weight/dimensions fields
  - [x] Add delivery time slot selection
  - [x] Create delivery instructions field
  - [x] Add recipient signature requirement option

- [x] **Notifications Page**
  - [x] Build notification list view
  - [x] Add notification filtering
  - [x] Implement mark as read/unread
  - [x] Create notification settings

- [x] **Reports & Analytics**
  - [x] Create monthly delivery report
  - [x] Add revenue breakdown by region
  - [x] Implement delivery success rate chart
  - [x] Add top customers list

### 1.5 Courier Dashboard

- [ ] **Courier Main Page**
  - [x] Create daily assignment overview
  - [x] Display route map with delivery points
  - [x] Add earnings tracker
  - [x] Show today's delivery statistics

- [x] **Active Deliveries**
  - [x] Build delivery queue interface
  - [x] Add optimized route view
  - [x] Implement navigation integration (Google Maps/Waze)
  - [x] Create delivery checklist
  - [x] Add photo proof of delivery
  - [x] Implement signature capture

- [x] **Delivery History**
  - [x] Create completed deliveries list
  - [x] Add delivery details view
  - [x] Implement date-based filtering
  - [x] Add earnings summary

- [x] **Parcel Status Update**
  - [x] Build quick status change interface
  - [x] Add return parcel workflow with reason
  - [x] Implement failed delivery reason capture
  - [x] Create attempted delivery log

- [x] **Settings & Profile**
  - [x] Add availability toggle
  - [x] Create working hours configuration
  - [x] Build vehicle information form
  - [x] Add service regions selection

### 1.6 Customer Dashboard

- [x] **Customer Main Page**
  - [x] Create active deliveries view
  - [x] Display delivery tracking map
  - [x] Add expected delivery time
  - [x] Show courier contact information

- [x] **Order Tracking**
  - [x] Build detailed tracking timeline
  - [x] Add real-time location updates on map
  - [ ] Implement push notifications for status changes
  - [x] Create estimated arrival countdown

- [ ] **Order History**
  - [x] Build past deliveries list
  - [x] Add order details view
  - [ ] Implement search and filters
  - [ ] Create reorder functionality

- [ ] **Delivery Feedback**
  - [ ] Build rating and review interface
  - [ ] Add tip option for courier
  - [ ] Create report issue form

- [ ] **Address Management**
  - [ ] Create saved addresses list
  - [ ] Add new address form with map picker
  - [ ] Implement default address selection
  - [ ] Add address validation

### 1.7 Shared Components & Pages

- [ ] **Privacy Policy Page (Enhance)**
  - [ ] Add version tracking
  - [ ] Implement accept/decline flow
  - [ ] Add PDF export option

- [ ] **Settings Page (Enhance)**
  - [ ] Add profile editing
  - [ ] Implement password change
  - [ ] Add notification preferences
  - [ ] Create account deletion option

- [ ] **Notifications System**
  - [ ] Build notification center
  - [ ] Add badge counters
  - [ ] Implement notification types (info, warning, success)
  - [ ] Create notification preferences

- [ ] **Help & Support**
  - [ ] Create FAQ page
  - [ ] Add contact support form
  - [ ] Implement live chat (optional)
  - [ ] Build tutorial guide

### 1.8 Parcel Status Flow

- [ ] **Complete Progress Bar Component**
  - [ ] Add icons for each status
  - [ ] Implement animations for status changes
  - [ ] Add timestamp for each stage
  - [ ] Create expandable details view

- [ ] **Parcel Statuses to Implement**
  - [ ] بانتظار الملصق (Awaiting Label)
  - [ ] جاهز للارسال (Ready to Ship)
  - [ ] في الطريق للموزع (En Route to Distributor)
  - [ ] مخزن الموزع (At Distributor's Warehouse)
  - [ ] في الطريق للزبون (Out for Delivery)
  - [ ] تم التوصيل (Delivered)
  - [ ] طرد راجع (Returned)
  - [ ] ملغي (Cancelled)

### 1.9 UI/UX Improvements

- [ ] **Design System**
  - [ ] Create comprehensive design tokens
  - [ ] Build reusable widget library
  - [ ] Standardize spacing and sizing
  - [ ] Implement consistent color scheme

- [ ] **Responsive Design**
  - [ ] Test and optimize for tablets
  - [ ] Ensure proper layout on different screen sizes
  - [ ] Add landscape mode support

- [ ] **Accessibility**
  - [ ] Add screen reader support
  - [ ] Implement proper contrast ratios
  - [ ] Add text scaling support
  - [ ] Create keyboard navigation support

- [ ] **Loading States**
  - [ ] Create skeleton loaders
  - [ ] Add shimmer effects
  - [ ] Implement pull-to-refresh
  - [ ] Add infinite scroll for lists

- [ ] **Empty States**
  - [ ] Design empty state illustrations
  - [ ] Add helpful messages
  - [ ] Implement call-to-action buttons

- [ ] **Error Handling**
  - [ ] Create error state designs
  - [ ] Add retry mechanisms
  - [ ] Implement user-friendly error messages

### 1.10 Technical Cleanup & TODOs
- [ ] **Printing Services**
  - [x] Add `NotoSansArabic-Regular.ttf` to `assets/fonts/` to enable Arabic support in PDFs (Configured in code, file download required)
  - [ ] Verify PDF generation with Arabic text

- [ ] **Merchant Dashboard**
  - [ ] Implement navigation to Parcel Details page from Dashboard list (currently a TODO)

- [ ] **Notifications**
  - [ ] Review and address TODOs in `merchant_notifications_page.dart`

- [ ] **Courier Dashboard**
  - [ ] Review and address TODOs in `courier_dashboard_page.dart`


---

## 🔥 Phase 2: Firebase Integration

### 2.1 Firebase Setup

- [x] **Initial Configuration**
  - [x] Create Firebase project
  - [x] Configure FlutterFire for Android
  - [x] Configure FlutterFire for iOS
  - [x] Configure FlutterFire for Web
  - [x] Firebase Core initialized in main.dart
  - [x] Created AuthService for authentication
  - [x] Created FirestoreService for database operations
  - [x] Set up Cloud Storage
  - [x] Set up Firebase Cloud Messaging (FCM)
  - [x] Set up Firebase Analytics
  - [x] Set up Crashlytics

- [x] **Security Rules**
  - [x] Write Firestore security rules
  - [x] Write Storage security rules
  - [x] Test security rules with all user roles (deployed to production)

### 2.2 Authentication

- [x] **Task #8: Implement Firebase Authentication**
  - [x] Create login page (email/password, phone)
  - [x] Create registration page (with role selection)
  - [x] Implement password reset flow
  - [x] Translate all auth messages (Arabic/English)
  - [x] Implement user registration and login
  - [x] Create user profile on registration

- [ ] **User Session Management**
  - [x] Implement auto-login on app start (via AuthenticationHandler)
  - [x] Add token refresh logic
  - [x] Create logout functionality
  - [x] Handle auth state changes
  - [x] Implement session timeout

### 2.3 Firestore Database Structure

Design and implement the following collections:

- [x] **Users Collection**
  ```
  users/{userId}
    - uid: string
    - phoneNumber: string
    - email: string
    - name: string
    - role: enum (admin, manager, merchant, courier, customer)
    - profilePhotoUrl: string
    - createdAt: timestamp
    - lastLogin: timestamp
    - status: enum (active, inactive, suspended)
    - preferredLanguage: string
    - isDarkMode: boolean
    - fcmToken: string
    
    # Merchant-specific fields
    - businessName: string
    - businessAddress: string
    - businessLicense: string
    
    # Courier-specific fields
    - vehicleType: string
    - vehiclePlate: string
    - workingRegions: array
    - availability: boolean
    - rating: number
    - totalDeliveries: number
    
    # Manager-specific fields
    - managedRegions: array
    - branchId: string
  ```

- [x] **Parcels Collection**
  ```
  parcels/{parcelId}
    - barcode: string (unique)
    - merchantId: string (ref to users)
    - courierId: string (ref to users, nullable)
    - customerId: string (ref to users, nullable)
    
    # Recipient Information
    - recipientName: string
    - recipientPhone: string
    - recipientAltPhone: string
    - deliveryAddress: string
    - deliveryRegion: string (القدس, الضفة, الداخل)
    
    # Parcel Details
    - description: string
    - weight: number
    - dimensions: {length, width, height}
    - imageUrls: array
    - parcelPrice: number
    - deliveryFee: number
    - totalPrice: number
    
    # Status & Tracking
    - status: enum
    - statusHistory: array of {status, timestamp, updatedBy, location}
    - estimatedDeliveryTime: timestamp
    - actualDeliveryTime: timestamp
    
    # Delivery Details
    - proofOfDeliveryUrl: string
    - signatureUrl: string
    - deliveryNotes: string
    - deliveryInstructions: string
    - returnReason: string (if returned)
    - failureReason: string (if failed)
    
    # Metadata
    - createdAt: timestamp
    - updatedAt: timestamp
    - isDeleted: boolean
  ```

- [x] **Regions Collection**
  ```
  regions/{regionId}
    - name: string
    - nameAr: string
    - nameEn: string
    - nameHe: string
    - deliveryFee: number
    - isActive: boolean
    - estimatedDeliveryDays: number
  ```

- [x] **Notifications Collection**
  ```
  notifications/{notificationId}
    - userId: string (ref to users)
    - title: string
    - body: string
    - type: enum (info, warning, success, delivery_update)
    - isRead: boolean
    - relatedParcelId: string (optional)
    - createdAt: timestamp
    - actionUrl: string (optional)
  ```

- [x] **Reviews Collection**
  ```
  reviews/{reviewId}
    - parcelId: string (ref to parcels)
    - customerId: string (ref to users)
    - courierId: string (ref to users)
    - rating: number (1-5)
    - comment: string
    - tip: number (optional)
    - createdAt: timestamp
  ```

- [x] **Analytics Collection** (for admin/manager dashboards)
  ```
  analytics/daily/{date}
    - totalParcels: number
    - deliveredParcels: number
    - returnedParcels: number
    - failedParcels: number
    - totalRevenue: number
    - averageDeliveryTime: number
    - byRegion: map
    - byCourier: map
    - byStatus: map
  ```

### 2.4 CRUD Operations

- [x] **User Management**
  - [x] Create user profile on registration
  - [x] Read user data
  - [x] Update user profile
  - [x] Soft delete user account
  - [x] Query users by role
  - [x] Update FCM token

- [x] **Parcel Management**
  - [x] Create new parcel
  - [x] Read parcel details
  - [x] Update parcel information
  - [x] Delete/cancel parcel
  - [x] Update parcel status
  - [x] Assign courier to parcel
  - [x] Query parcels by merchant
  - [x] Query parcels by courier
  - [x] Query parcels by customer
  - [x] Query parcels by status
  - [x] Query parcels by region
  - [x] Search parcels by barcode
  - [x] Bulk parcel upload

- [x] **Region Management**
  - [x] Fetch all regions
  - [x] Update delivery fees (admin only)
  - [x] Add new region (admin only)
  - [x] Toggle region availability

- [x] **Notifications**
  - [x] Create notification
  - [x] Fetch user notifications
  - [x] Mark notification as read
  - [x] Delete notification
  - [x] Send bulk notifications

- [x] **Reviews**
  - [x] Create review
  - [x] Fetch courier reviews
  - [x] Calculate average courier rating

### 2.5 Real-time Updates

- [x] **Firestore Listeners**
  - [x] Listen to parcel status changes
  - [x] Listen to new notifications
  - [x] Listen to courier location updates (optional)
  - [x] Listen to new parcel assignments
  - [x] Update UI in real-time for all changes

### 2.6 Cloud Storage Integration

- [x] **File Upload**
  - [x] Upload profile photos
  - [x] Upload parcel images
  - [x] Upload proof of delivery
  - [x] Upload signatures
  - [x] Upload business licenses
  - [x] Compress images before upload

- [x] **File Management**
  - [x] Delete old files
  - [x] Generate download URLs
  - [x] Implement caching strategy

### 2.7 Cloud Functions

Create server-side logic for:

- [ ] **Trigger Functions**
  - [x] On parcel status change → send notification to relevant users
  - [x] On parcel created → assign barcode if not provided
  - [ ] On parcel delivered → update merchant stats
  - [ ] On user created → send welcome email/SMS
  - [x] On review created → update courier rating

- [ ] **Callable Functions**
  - [x] Generate daily/weekly/monthly reports
  - [x] Assign optimal courier to parcel
  - [ ] Calculate route optimization
  - [x] Send bulk notifications
  - [ ] Process refunds/payments (if applicable)

- [ ] **Scheduled Functions**
  - [x] Daily analytics aggregation
  - [x] Clean up old notifications
  - [x] Send delivery reminders
  - [ ] Generate performance reports

### 2.8 Push Notifications (FCM)

- [x] **Setup**
  - [ ] Configure FCM for Android (requires google-services.json)
  - [ ] Configure FCM for iOS (requires GoogleService-Info.plist & APNs)
  - [x] Handle foreground notifications
  - [x] Handle background notifications
  - [x] Implement notification tap handling

- [x] **Notification Types**
  - [x] Parcel status change notifications
  - [x] New parcel assignment (courier)
  - [x] Delivery reminders
  - [x] Promotional notifications
  - [x] System announcements

### 2.9 Analytics & Monitoring

- [x] **Firebase Analytics**
  - [x] Track screen views
  - [x] Track user actions (create parcel, update status, etc.)
  - [x] Track conversion events
  - [x] Create custom events
  - [x] Set user properties

- [x] **Crashlytics**
  - [x] Enable Crashlytics
  - [x] Add custom crash logs
  - [x] Monitor crash-free users
  - [x] Set up crash alerts

- [ ] **Performance Monitoring**
  - [ ] Enable Performance Monitoring
  - [ ] Track network requests
  - [ ] Monitor app startup time
  - [ ] Track custom traces

---

## 🔒 Phase 3: Security & Optimization

### 3.1 Security

- [x] **Data Validation**
  - [x] Validate all user inputs
  - [x] Sanitize data before Firestore write
  - [x] Implement rate limiting
  - [ ] Add CAPTCHA for registration (optional)

- [ ] **Secure Communication**
  - [ ] Ensure HTTPS for all requests
  - [ ] Implement certificate pinning (optional)
  - [ ] Encrypt sensitive local data

  - [ ] Handle offline writes
  - [ ] Implement sync conflict resolution

- [ ] **Local Caching**
  - [ ] Cache frequently accessed data
  - [ ] Implement cache invalidation
  - [ ] Show cached data while loading

- [ ] **Network Detection**
  - [ ] Enhance existing NetworkAwareWrapper
  - [ ] Show offline indicator
  - [ ] Queue actions when offline
  - [ ] Sync when back online

---

## 🧪 Phase 4: Testing

### 4.1 Unit Tests

- [ ] Test user authentication flows
- [ ] Test CRUD operations
- [ ] Test data validation logic
- [ ] Test utility functions
- [ ] Test business logic

### 4.2 Widget Tests

- [ ] Test login page
- [ ] Test registration flow
- [ ] Test parcel creation form
- [ ] Test parcel list views
- [ ] Test status update workflows
- [ ] Test navigation flows

### 4.3 Integration Tests

- [ ] Test end-to-end parcel creation flow
- [ ] Test parcel tracking flow
- [ ] Test courier assignment flow
- [ ] Test delivery completion flow
- [ ] Test notification delivery

### 4.4 Firebase Testing

- [ ] Test Firestore security rules
- [ ] Test Cloud Functions locally
- [ ] Test Cloud Functions in production
- [ ] Test push notifications
- [ ] Test offline scenarios

---

## 🚀 Phase 5: Deployment & Launch

### 5.1 Pre-Launch Checklist

- [ ] Complete all critical features
- [ ] Fix all known bugs
- [ ] Optimize app performance
- [ ] Test on multiple devices
- [ ] Complete security audit
- [ ] Prepare privacy policy and terms of service
- [ ] Create app screenshots and descriptions

### 5.2 Android Release

- [ ] Generate signed APK/App Bundle
- [ ] Create Google Play Console account
- [ ] Upload app to Google Play (internal testing)
- [ ] Test internal release
- [ ] Promote to closed beta
- [ ] Gather beta feedback
- [ ] Promote to production

### 5.3 iOS Release

- [ ] Build release IPA
- [ ] Create App Store Connect account
- [ ] Upload to TestFlight
- [ ] Test TestFlight build
- [ ] Gather beta feedback
- [ ] Submit for App Store review
- [ ] Release on App Store

### 5.4 Post-Launch

- [ ] Monitor crash reports
- [ ] Monitor user feedback
- [ ] Track analytics
- [ ] Plan updates and new features
- [ ] Set up customer support channels

---

## 📊 Progress Tracking

### Current Status
- **Phase 1 (UI Completion)**: ~30% Complete
  - ✅ Basic merchant dashboard structure
  - ✅ Parcel creation form
  - ✅ Parcel list view
  - ✅ Settings page structure
  - ⚠️ Most other screens are placeholders

- **Phase 2 (Firebase Integration)**: 0% Complete
  - ❌ No Firebase integration yet
  - ❌ Using mock data throughout

- **Phase 3 (Security & Optimization)**: 0% Complete

- **Phase 4 (Testing)**: 0% Complete

- **Phase 5 (Deployment)**: 0% Complete

---

## 🎯 Priority Tasks (MVP - Minimum Viable Product)

For a functional MVP, prioritize these tasks:

### 🔴 CRITICAL - Week 0 (Complete Phase 0 FIRST!)
**These tasks MUST be completed before starting any other development:**
1. **Rename app to "Wasslni Plus"** - Update all configs, package names, and platform settings
2. **Remove Hebrew Support** - Delete intl_he.arb, update locale configs
3. **Complete Arabic & English translations** - Verify all existing text has both languages
4. **Add new app name translations** - Add app_name, app_tagline, welcome_to_app keys (AR/EN)
5. **Update all documentation** - README, FIREBASE_SETUP, etc. with new app name
6. **Create Translation Guidelines** - Document translation workflow

### High Priority (Week 1-2)
7. Set up Firebase project and FlutterFire (use project name "wasslni-plus")
8. Implement Firebase Authentication (phone/email) - **Translate all auth messages (AR/EN)**
9. Design and create Firestore database structure
10. Implement user registration and login - **Translate all form labels (AR/EN)**
11. Complete merchant parcel creation with Firestore - **Translate all fields (AR/EN)**
12. Complete courier parcel assignment interface - **Translate all UI text (AR/EN)**
13. Implement parcel status update functionality - **Translate status names (AR/EN)**
14. Add real-time parcel tracking - **Translate tracking messages (AR/EN)**

### Medium Priority (Week 3-4)
15. Implement push notifications for status updates - **Translate notification messages (AR/EN)**
16. Complete all role dashboards (basic versions) - **Translate dashboard labels (AR/EN)**
17. Add barcode scanning functionality - **Translate scanner instructions (AR/EN)**
18. Implement proof of delivery capture -  **Translate capture prompts (AR/EN)**
19. Add user profile management - **Translate profile fields (AR/EN)**
20. Create basic analytics dashboard - **Translate chart labels (AR/EN)**
21. Implement search and filtering - **Translate filter options (AR/EN)**

### Low Priority (Week 5+)
22. Advanced analytics and reports - **Translate report headers (AR/EN)**
23. Bulk operations - **Translate bulk action messages (AR/EN)**
24. Route optimization - **Translate route suggestions (AR/EN)**
19. Tips and reviews system
20. Multi-language full support
21. Offline mode enhancements

---

## 📝 Notes

- This task list is comprehensive and should be adjusted based on project timeline and resources
- Each task can be broken down into smaller subtasks during sprint planning
- Regular code reviews and testing should be conducted throughout development
- Consider using a project management tool (Jira, Trello, Asana) to track progress
- Some features may be deferred to post-MVP releases based on priorities

---

**Last Updated**: 2025-11-29  
**Next Review**: Weekly during development

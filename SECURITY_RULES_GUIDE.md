# Firebase Security Rules Guide

This document explains the security rules for Firestore and Storage, and how to deploy and test them.

## Overview

Security rules are critical for protecting your data in Firebase. They ensure that:
- Users can only access data they're authorized to see
- Role-based access control is enforced
- File uploads are validated for size and type
- Sensitive operations are restricted to appropriate roles

## Firestore Security Rules

### User Roles

The app supports 5 user roles:
- **admin**: Full access to all data and operations
- **manager**: Can view all data, manage parcels and couriers
- **merchant**: Can create and manage their own parcels
- **courier**: Can view and update assigned parcels
- **customer**: Can view their own orders and create reviews

### Collection Rules

#### Users Collection
- Users can read and update their own profile (except role/status)
- Admins can read, create, update, and delete any user
- Managers can read all users

#### Parcels Collection
- Merchants can create parcels and read their own parcels
- Couriers can read and update parcels assigned to them
- Customers can read parcels where they are the customer
- Admins and managers have full access

#### Regions Collection
- Everyone can read active regions
- Only admins can create, update, or delete regions

#### Notifications Collection
- Users can read, update (mark as read), and delete their own notifications
- Admins and managers can create notifications

#### Reviews Collection
- Customers can create reviews for their deliveries
- Couriers can read reviews about them
- Reviews are immutable (cannot be updated or deleted)

#### Analytics Collection
- Only admins and managers can read analytics
- Only Cloud Functions can write analytics

## Storage Security Rules

### File Upload Rules

#### Profile Photos (`users/{userId}/profile.{extension}`)
- Max size: 5MB
- Must be an image
- Users can only upload/delete their own photos
- Anyone authenticated can read

#### Business Licenses (`users/{userId}/documents/license.{extension}`)
- Max size: 10MB
- Must be an image or PDF
- Only the owner can read, write, or delete

#### Parcel Images (`parcels/{parcelId}/images/{imageId}`)
- Max size: 5MB
- Must be an image
- Any authenticated user can upload (merchants/couriers)
- Any authenticated user can read

#### Proof of Delivery (`parcels/{parcelId}/proof_of_delivery/{imageId}`)
- Max size: 5MB
- Must be an image
- Couriers upload when delivering
- Any authenticated user can read

#### Signatures (`parcels/{parcelId}/signature/{imageId}`)
- Max size: 5MB
- Must be an image
- Captured during delivery
- Any authenticated user can read

## Deploying Security Rules

### Prerequisites
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login to Firebase: `firebase login`
3. Initialize Firebase in your project: `firebase init`

### Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

### Deploy Storage Rules
```bash
firebase deploy --only storage:rules
```

### Deploy Both
```bash
firebase deploy --only firestore:rules,storage:rules
```

## Testing Security Rules

### Using Firebase Emulator (Recommended)

1. **Start the emulator**:
```bash
firebase emulators:start
```

2. **Run tests** (create test files in `test/` directory):
```bash
firebase emulators:exec --only firestore "npm test"
```

### Manual Testing in Firebase Console

1. Go to Firebase Console → Firestore Database → Rules
2. Click "Rules Playground"
3. Test different scenarios:
   - Authenticated user reading their own data
   - User trying to access another user's data
   - Admin accessing all data
   - Unauthenticated access attempts

### Test Scenarios

#### Test 1: User can read their own profile
```javascript
// Should ALLOW
auth: { uid: "user123" }
path: /databases/(default)/documents/users/user123
method: get
```

#### Test 2: User cannot read another user's profile
```javascript
// Should DENY
auth: { uid: "user123" }
path: /databases/(default)/documents/users/user456
method: get
```

#### Test 3: Merchant can create parcel
```javascript
// Should ALLOW
auth: { uid: "merchant123" }
path: /databases/(default)/documents/parcels/parcel1
method: create
data: { merchantId: "merchant123", ... }
```

#### Test 4: User cannot update their role
```javascript
// Should DENY
auth: { uid: "user123" }
path: /databases/(default)/documents/users/user123
method: update
data: { role: "admin" }
```

#### Test 5: Courier can update assigned parcel
```javascript
// Should ALLOW
auth: { uid: "courier123" }
path: /databases/(default)/documents/parcels/parcel1
method: update
existing data: { courierId: "courier123", ... }
```

## Important Notes

1. **Never expose sensitive data**: Security rules don't filter data, they only allow/deny access
2. **Test thoroughly**: Always test rules before deploying to production
3. **Use emulators**: Test locally before deploying to avoid breaking production
4. **Monitor usage**: Check Firebase Console for denied requests
5. **Keep rules updated**: Update rules when adding new features

## Troubleshooting

### Common Issues

**Issue**: "Missing or insufficient permissions"
- **Solution**: Check that the user has the correct role and is authenticated

**Issue**: "File too large"
- **Solution**: Ensure files are within size limits (5MB for images, 10MB for documents)

**Issue**: "Invalid file type"
- **Solution**: Only upload images (JPEG, PNG) or PDFs for documents

**Issue**: Rules not updating
- **Solution**: Wait a few minutes for rules to propagate, or redeploy

## Next Steps

1. Deploy the rules to your Firebase project
2. Test with the emulator
3. Test in production with real users (start with test accounts)
4. Monitor the Firebase Console for any denied requests
5. Adjust rules as needed based on your app's requirements

## Resources

- [Firebase Security Rules Documentation](https://firebase.google.com/docs/rules)
- [Firestore Security Rules Guide](https://firebase.google.com/docs/firestore/security/get-started)
- [Storage Security Rules Guide](https://firebase.google.com/docs/storage/security)
- [Rules Playground](https://firebase.google.com/docs/rules/simulator)

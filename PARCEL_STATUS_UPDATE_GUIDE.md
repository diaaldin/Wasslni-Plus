# Parcel Status Update - Usage Guide

## Overview
This guide explains how to update parcel status in the Wasslni Plus app using the built-in components and services.

## Components Created

1. **ParcelStatusProgressBar** (`lib/widgets/parcel_status_progress_bar.dart`)
   - Visual component showing parcel journey
   - Animated progress tracking
   - Expandable timeline with full history

2. **UpdateStatusDialog** (`lib/widgets/update_status_dialog.dart`)
   - Dialog for updating parcel status
   - Handles validation and data collection
   - Works with FirestoreService

3. **FirestoreService.updateParcelStatus()** (Already exists in `lib/services/firestore_service.dart`)
   - Backend method that updates status in Firestore
   - Automatically maintains status history
   - Handles special cases (returned/cancelled)

## How to Update Status

### Example 1: When Merchant Adds Label

```dart
import 'package:wasslni_plus/widgets/update_status_dialog.dart';
import 'package:wasslni_plus/models/parcel_model.dart';

// In your merchant dashboard or parcel management page:
void _onAddLabel(ParcelModel parcel) async {
  // Show dialog to update status
  final updated = await showUpdateStatusDialog(
    context: context,
    parcel: parcel,
    newStatus: ParcelStatus.readyToShip, // Move from awaitingLabel to readyToShip
  );

  if (updated == true) {
    // Status was updated successfully
    // The UI will automatically refresh if using StreamBuilder
    print('Label added and status updated!');
  }
}
```

### Example 2: When Courier Picks Up Parcel

```dart
// In courier parcel list:
void _onPickupParcel(ParcelModel parcel) async {
  final updated = await showUpdateStatusBottomSheet( // Using bottom sheet for mobile
    context: context,
    parcel: parcel,
    newStatus: ParcelStatus.enRouteDistributor,
    suggestedLocation: 'Main Warehouse, Baghdad', // Pre-fill location
  );

  if (updated == true) {
    // Refresh courier task list
  }
}
```

### Example 3: When Parcel is Delivered

```dart
// In courier delivery screen:
void _onDeliverParcel(ParcelModel parcel) async {
  // First, get proof of delivery (signature/photo) - implement separately
  
  // Then update status
  final updated = await showUpdateStatusDialog(
    context: context,
    parcel: parcel,
    newStatus: ParcelStatus.delivered,
    suggestedLocation: parcel.deliveryAddress,
  );

  if (updated == true) {
    // Mark as complete, update courier stats, etc.
  }
}
```

### Example 4: When Parcel is Returned

```dart
// When customer rejects parcel:
void _onReturnParcel(ParcelModel parcel) async {
  // This will require a reason (validated by the dialog)
  final updated = await showUpdateStatusDialog(
    context: context,
    parcel: parcel,
    newStatus: ParcelStatus.returned,
  );

  if (updated == true) {
    // Handle return logistics
  }
}
```

### Example 5: Direct Service Call (Without Dialog)

If you want to update status programmatically without showing a dialog:

```dart
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/services/auth_service.dart';

Future<void> updateStatusDirectly(ParcelModel parcel) async {
  final firestoreService = FirestoreService();
  final authService = AuthService();
  
  try {
    await firestoreService.updateParcelStatus(
      parcel.id!,
      ParcelStatus.atWarehouse,
      authService.currentUser!.uid,
      location: 'Central Hub, Zone A',
      notes: 'Automatically scanned at warehouse',
    );
    print('Status updated successfully');
  } catch (e) {
    print('Error updating status: $e');
  }
}
```

## Displaying Status with Progress Bar

To show the beautiful status progress bar in your parcel details page:

```dart
import 'package:wasslni_plus/widgets/parcel_status_progress_bar.dart';

class ParcelDetailsPage extends StatelessWidget {
  final ParcelModel parcel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel #${parcel.barcode}'),
      ),
      body: ListView(
        children: [
          // Beautiful animated progress bar
          ParcelStatusProgressBar(
            currentStatus: parcel.status,
            statusHistory: parcel.statusHistory,
            showTimestamps: true,
            isExpandable: true,
          ),
          
          // Other parcel details...
          _buildParcelInfo(),
          _buildRecipientInfo(),
          
          // Action buttons
          if (parcel.status == ParcelStatus.awaitingLabel)
            ElevatedButton(
              onPressed: () => _onAddLabel(parcel),
              child: Text('Add Label & Update Status'),
            ),
        ],
      ),
    );
  }
}
```

## Status Flow

The typical parcel journey:

1. **awaitingLabel** → When merchant creates parcel
2. **readyToShip** → After label is added/printed
3. **enRouteDistributor** → Courier picks up and starts delivery
4. **atWarehouse** → Parcel arrives at distribution center
5. **outForDelivery** → Courier takes it for final delivery
6. **delivered** → Successfully delivered to customer

Special cases:
- **returned** → Customer rejected or address issue
- **cancelled** → Order cancelled before delivery

## Real-time Updates

If you're using `StreamBuilder` to display parcel data, status updates will automatically reflect in the UI:

```dart
StreamBuilder<ParcelModel?>(
  stream: FirestoreService().streamParcel(parcelId),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    
    final parcel = snapshot.data!;
    return ParcelStatusProgressBar(
      currentStatus: parcel.status,
      statusHistory: parcel.statusHistory,
    );
  },
)
```

## Key Features

✅ **Automatic History Tracking** - Every status change is recorded with timestamp
✅ **User Tracking** - System knows who updated the status
✅ **Location Tracking** - Optional location for each status update
✅ **Notes/Reasons** - Add context for status changes
✅ **Validation** - Required reasons for returned/cancelled
✅ **Bilingual** - Full Arabic & English support
✅ **Animated UI** - Beautiful transitions and progress indicators

## Tips

1. **Use bottom sheet on mobile** - Better UX than dialog
2. **Pre-fill location** - When you know the current location
3. **Handle errors gracefully** - Always wrap in try-catch
4. **Refresh UI** - Most times automatic with StreamBuilder
5. **Validate permissions** - Ensure user has rights to update status

## Complete Example in Action

```dart
class MerchantParcelCard extends StatelessWidget {
  final ParcelModel parcel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Parcel #${parcel.barcode}'),
            subtitle: Text(parcel.recipientName),
            trailing: _buildStatusChip(parcel.status),
          ),
          
          // Show quick actions based on current status
          if (parcel.status == ParcelStatus.awaitingLabel)
            ElevatedButton.icon(
              onPressed: () async {
                // Add label logic here...
                await _printLabel(parcel);
                
                // Update status
                final updated = await showUpdateStatusDialog(
                  context: context,
                  parcel: parcel,
                  newStatus: ParcelStatus.readyToShip,
                );
                
                if (updated == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Label printed and parcel ready!')),
                  );
                }
              },
              icon: Icon(Icons.print),
              label: Text('Print Label'),
            ),
        ],
      ),
    );
  }
}
```

This comprehensive system makes status management easy, consistent, and beautiful across the entire app!

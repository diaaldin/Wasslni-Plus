# Cloud Functions Usage Guide

This guide provides code examples for calling the Firebase Cloud Functions in the Wasslni Plus app.

---

## Setup

First, ensure Firebase Functions is initialized in your app:

```dart
import 'package:cloud_functions/cloud_functions.dart';

// Get instance
final functions = FirebaseFunctions.instance;

// For development/testing with emulator (optional)
// functions.useFunctionsEmulator('localhost', 5001);
```

---

## Callable Functions

### 1. Generate Reports

**Function**: `generateReports`  
**Access**: Admin and Manager only  
**Purpose**: Generate custom reports for specific date ranges

```dart
Future<Map<String, dynamic>> generateReport({
  required String type, // 'daily', 'weekly', 'monthly'
  required DateTime startDate,
  required DateTime endDate,
}) async {
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('generateReports')
        .call({
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });

    return {
      'success': true,
      'data': result.data,
    };
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

// Usage example
final report = await generateReport(
  type: 'weekly',
  startDate: DateTime.now().subtract(Duration(days: 7)),
  endDate: DateTime.now(),
);

if (report['success']) {
  print('Report URL: ${report['data']['url']}');
  print('Total Parcels: ${report['data']['summary']['totalParcels']}');
}
```

---

### 2. Assign Optimal Courier

**Function**: `assignOptimalCourier`  
**Access**: Authenticated users (typically merchants or admins)  
**Purpose**: Automatically assign the best available courier to a parcel

```dart
Future<Map<String, dynamic>> assignOptimalCourier(String parcelId) async {
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('assignOptimalCourier')
        .call({'parcelId': parcelId});

    final data = result.data as Map<String, dynamic>;
    
    if (data['success'] == true) {
      return {
        'success': true,
        'courierId': data['courierId'],
        'courierName': data['courierName'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'],
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

// Usage example
final result = await assignOptimalCourier('parcel_12345');

if (result['success']) {
  print('Assigned to: ${result['courierName']}');
  // Update UI or navigate
} else {
  showError(result['message'] ?? result['error']);
}
```

---

### 3. Calculate Route Optimization ⭐ NEW

**Function**: `calculateRouteOptimization`  
**Access**: Courier only  
**Purpose**: Optimize delivery route for assigned parcels

```dart
Future<Map<String, dynamic>> calculateRouteOptimization({
  List<String>? parcelIds,
}) async {
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('calculateRouteOptimization')
        .call({
      if (parcelIds != null) 'parcelIds': parcelIds,
    });

    final data = result.data as Map<String, dynamic>;
    
    if (data['success'] == true) {
      return {
        'success': true,
        'optimizedRoute': List<String>.from(data['optimizedRoute']),
        'summary': data['summary'],
        'details': data['details'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'],
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

// Usage example 1: Optimize all assigned parcels
final result = await calculateRouteOptimization();

if (result['success']) {
  final route = result['optimizedRoute'] as List<String>;
  final summary = result['summary'];
  
  print('Optimized route for ${summary['totalParcels']} parcels');
  print('Regions: ${summary['regions']}');
  
  // Update UI with optimized order
  setState(() {
    optimizedParcelIds = route;
  });
}

// Usage example 2: Optimize specific parcels
final selectedIds = ['parcel1', 'parcel2', 'parcel3'];
final result = await calculateRouteOptimization(parcelIds: selectedIds);

// Display optimized route
for (var detail in result['details']) {
  print('${detail['barcode']}: ${detail['deliveryAddress']}');
}
```

---

### 4. Send Bulk Notifications

**Function**: `sendBulkNotifications`  
**Access**: Admin only  
**Purpose**: Send notifications to multiple users by role or region

```dart
Future<Map<String, dynamic>> sendBulkNotifications({
  required String title,
  required String body,
  String? targetRole, // 'courier', 'merchant', 'customer'
  String? targetRegion, // 'القدس', 'الضفة', 'الداخل'
}) async {
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('sendBulkNotifications')
        .call({
      'title': title,
      'body': body,
      if (targetRole != null) 'targetRole': targetRole,
      if (targetRegion != null) 'targetRegion': targetRegion,
    });

    final data = result.data as Map<String, dynamic>;
    
    return {
      'success': data['success'] ?? false,
      'messageId': data['messageId'],
    };
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

// Usage example 1: Notify all couriers
final result = await sendBulkNotifications(
  title: 'System Maintenance',
  body: 'The app will be under maintenance tonight from 2-4 AM',
  targetRole: 'courier',
);

// Usage example 2: Notify users in a specific region
final result = await sendBulkNotifications(
  title: 'Regional Update',
  body: 'New delivery zone added in القدس',
  targetRegion: 'القدس',
);

// Usage example 3: Notify all users
final result = await sendBulkNotifications(
  title: 'New Feature',
  body: 'Check out our new route optimization feature!',
);
```

---

## Integration Examples

### Complete Route Optimization Flow

```dart
class CourierRoutePage extends StatefulWidget {
  @override
  _CourierRoutePageState createState() => _CourierRoutePageState();
}

class _CourierRoutePageState extends State<CourierRoutePage> {
  bool _isOptimizing = false;
  List<Map<String, dynamic>> _optimizedParcels = [];

  Future<void> _optimizeRoute() async {
    setState(() => _isOptimizing = true);

    try {
      final result = await calculateRouteOptimization();

      if (result['success']) {
        setState(() {
          _optimizedParcels = List<Map<String, dynamic>>.from(
            result['details']
          );
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Route optimized: ${result['summary']['totalParcels']} parcels'
            ),
          ),
        );
      } else {
        _showError(result['message'] ?? 'Optimization failed');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isOptimizing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Optimized Route'),
        actions: [
          IconButton(
            icon: Icon(Icons.route),
            onPressed: _isOptimizing ? null : _optimizeRoute,
          ),
        ],
      ),
      body: _isOptimizing
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _optimizedParcels.length,
              itemBuilder: (context, index) {
                final parcel = _optimizedParcels[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(parcel['recipientName'] ?? 'Unknown'),
                  subtitle: Text(parcel['deliveryAddress'] ?? ''),
                  trailing: Chip(label: Text(parcel['deliveryRegion'] ?? '')),
                );
              },
            ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
```

---

### Auto-Assign Courier on Parcel Creation

```dart
class ParcelService {
  Future<bool> createParcelWithAutoAssignment({
    required String merchantId,
    required String recipientName,
    required String deliveryAddress,
    required String deliveryRegion,
    // ... other fields
  }) async {
    try {
      // 1. Create parcel
      final parcelRef = await FirebaseFirestore.instance
          .collection('parcels')
          .add({
        'merchantId': merchantId,
        'recipientName': recipientName,
        'deliveryAddress': deliveryAddress,
        'deliveryRegion': deliveryRegion,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        // ... other fields
      });

      // 2. Auto-assign courier
      final assignmentResult = await assignOptimalCourier(parcelRef.id);

      if (assignmentResult['success']) {
        print('Auto-assigned to: ${assignmentResult['courierName']}');
        return true;
      } else {
        print('No courier available: ${assignmentResult['message']}');
        // Parcel created but not assigned - admin can assign later
        return true;
      }
    } catch (e) {
      print('Error creating parcel: $e');
      return false;
    }
  }
}
```

---

## Error Handling

All callable functions follow a consistent error pattern:

```dart
Future<T> callFunction<T>(
  String functionName,
  Map<String, dynamic> data,
) async {
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable(functionName)
        .call(data);
    
    return result.data as T;
  } on FirebaseFunctionsException catch (e) {
    // Handle Firebase-specific errors
    switch (e.code) {
      case 'unauthenticated':
        throw Exception('Please log in to continue');
      case 'permission-denied':
        throw Exception('You do not have permission for this action');
      case 'not-found':
        throw Exception('Resource not found');
      case 'internal':
        throw Exception('Server error. Please try again later');
      default:
        throw Exception('Error: ${e.message}');
    }
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}
```

---

## Testing Cloud Functions Locally

### Using Firebase Emulator

1. **Install Firebase Tools**:
   ```bash
   npm install -g firebase-tools
   ```

2. **Initialize Emulators**:
   ```bash
   firebase init emulators
   ```

3. **Start Emulators**:
   ```bash
   firebase emulators:start
   ```

4. **Connect Flutter App to Emulator**:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     
     // Use emulators in debug mode
     if (kDebugMode) {
       FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
       FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
     }
     
     runApp(MyApp());
   }
   ```

---

## Best Practices

1. **Always handle errors**:
   ```dart
   try {
     final result = await someFunction();
   } catch (e) {
     // Handle error appropriately
   }
   ```

2. **Show loading states**:
   ```dart
   setState(() => isLoading = true);
   try {
     await callFunction();
   } finally {
     setState(() => isLoading = false);
   }
   ```

3. **Validate data before calling**:
   ```dart
   if (parcelId.isEmpty) {
     showError('Parcel ID is required');
     return;
   }
   ```

4. **Use proper type casting**:
   ```dart
   final data = result.data as Map<String, dynamic>;
   final items = List<String>.from(data['items']);
   ```

5. **Implement retry logic for critical operations**:
   ```dart
   Future<T> retryOperation<T>(
     Future<T> Function() operation,
     {int maxAttempts = 3}
   ) async {
     for (int i = 0; i < maxAttempts; i++) {
       try {
         return await operation();
       } catch (e) {
         if (i == maxAttempts - 1) rethrow;
         await Future.delayed(Duration(seconds: i + 1));
       }
     }
     throw Exception('Max retry attempts reached');
   }
   ```

---

## Monitoring & Logging

View function logs in Firebase Console:

1. Go to **Firebase Console** > **Functions**
2. Click on a function name
3. Click **Logs** tab
4. View real-time execution logs

Or use Firebase CLI:
```bash
firebase functions:log --only generateReports
```

---

## Additional Resources

- [Firebase Cloud Functions Documentation](https://firebase.google.com/docs/functions)
- [Cloud Functions for Flutter](https://firebase.flutter.dev/docs/functions/usage)
- [Firebase Functions Samples](https://github.com/firebase/functions-samples)

---

**Created**: December 13, 2025  
**Last Updated**: December 13, 2025

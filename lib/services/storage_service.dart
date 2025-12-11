import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a file to Firebase Storage
  /// Returns the download URL
  Future<String> uploadFile({
    required XFile file,
    required String path,
    String? contentType,
    Map<String, String>? customMetadata,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = SettableMetadata(
        contentType: contentType,
        customMetadata: {
          'uploaded_at': DateTime.now().toIso8601String(),
          ...?customMetadata,
        },
      );

      final bytes = await file.readAsBytes();
      final uploadTask = await ref.putData(bytes, metadata);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  /// Upload profile photo
  /// Path: users/{userId}/profile.{ext}
  Future<String> uploadProfilePhoto(String userId, XFile file) async {
    final extension = path.extension(file.path);
    final filePath = 'users/$userId/profile$extension';
    return await uploadFile(
      file: file,
      path: filePath,
      contentType: 'image/${extension.replaceAll('.', '')}',
    );
  }

  /// Upload parcel image
  /// Path: parcels/{parcelId}/images/{timestamp}_{filename}
  Future<String> uploadParcelImage(String parcelId, XFile file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final filePath = 'parcels/$parcelId/images/$fileName';
    return await uploadFile(
      file: file,
      path: filePath,
      contentType:
          'image/jpeg', // Assuming mostly images, or detect from extension
    );
  }

  /// Upload proof of delivery
  /// Path: parcels/{parcelId}/proof_of_delivery/{timestamp}_{filename}
  Future<String> uploadProofOfDelivery(String parcelId, XFile file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_proof_${path.basename(file.path)}';
    final filePath = 'parcels/$parcelId/proof_of_delivery/$fileName';
    return await uploadFile(
      file: file,
      path: filePath,
      contentType: 'image/jpeg',
    );
  }

  /// Upload signature
  /// Path: parcels/{parcelId}/signature/{timestamp}_{filename}
  Future<String> uploadSignature(String parcelId, XFile file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_signature_${path.basename(file.path)}';
    final filePath = 'parcels/$parcelId/signature/$fileName';
    return await uploadFile(
      file: file,
      path: filePath,
      contentType: 'image/png', // Signatures are often PNGs
    );
  }

  /// Upload business license
  /// Path: users/{userId}/documents/license.{ext}
  Future<String> uploadBusinessLicense(String userId, XFile file) async {
    final extension = path.extension(file.path);
    final filePath = 'users/$userId/documents/license$extension';
    return await uploadFile(
      file: file,
      path: filePath,
      contentType: 'application/pdf', // Assuming PDF or image
    );
  }

  /// Delete file by URL
  Future<void> deleteFileByUrl(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {
      throw Exception('Error deleting file: $e');
    }
  }

  /// Delete file by path
  Future<void> deleteFileByPath(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      throw Exception('Error deleting file: $e');
    }
  }
}

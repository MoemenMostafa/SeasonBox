import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Compress image to ~80% quality
  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/${_uuid.v4()}_compressed.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );

    return result != null ? File(result.path) : file;
  }

  /// Generate thumbnail (300x300)
  Future<File> generateThumbnail(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/${_uuid.v4()}_thumb.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
      minWidth: 300,
      minHeight: 300,
    );

    return result != null ? File(result.path) : file;
  }

  /// Upload both full (compressed) and thumbnail versions
  Future<Map<String, String>> uploadImageWithThumbnail({
    required File file,
    required String userId,
    required String itemId,
  }) async {
    try {
      final uuid = _uuid.v4();

      // Compress full image
      final compressedFile = await compressImage(file);

      // Generate thumbnail
      final thumbnailFile = await generateThumbnail(file);

      // Upload full image
      final fullRef = _storage
          .ref()
          .child('users')
          .child(userId)
          .child('items')
          .child(itemId)
          .child('full_$uuid.jpg');

      await fullRef.putFile(compressedFile);
      final fullUrl = await fullRef.getDownloadURL();

      // Upload thumbnail
      final thumbRef = _storage
          .ref()
          .child('users')
          .child(userId)
          .child('items')
          .child(itemId)
          .child('thumb_$uuid.jpg');

      await thumbRef.putFile(thumbnailFile);
      final thumbUrl = await thumbRef.getDownloadURL();

      // Clean up temp files
      await compressedFile.delete();
      await thumbnailFile.delete();

      return {'full': fullUrl, 'thumb': thumbUrl};
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<String> uploadFile({
    required File file,
    required String userId,
    required String folder, // e.g., 'items'
  }) async {
    try {
      final String fileName =
          '${_uuid.v4()}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage
          .ref()
          .child('users')
          .child(userId)
          .child(folder)
          .child(fileName);

      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }
}

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seasonbox/data/services/posthog_service.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Compress image to ~80% quality
  Future<File> compressImage(File file) async {
    return await PostHogService().trackLatency('image_compression', () async {
      final dir = await getTemporaryDirectory();
      final targetPath = '${dir.path}/${_uuid.v4()}_compressed.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80,
      );

      return result != null ? File(result.path) : file;
    });
  }

  /// Generate thumbnail (300x300)
  Future<File> generateThumbnail(File file) async {
    return await PostHogService().trackLatency('thumbnail_generation',
        () async {
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
    });
  }

  Future<Map<String, String>> uploadPreProcessedImage({
    required File fullFile,
    required File thumbFile,
    required String userId,
    required String itemId,
  }) async {
    try {
      final uuid = _uuid.v4();

      return await PostHogService().trackLatency('upload_item_images',
          () async {
        // Upload full image
        final fullRef = _storage
            .ref()
            .child('users')
            .child(userId)
            .child('items')
            .child(itemId)
            .child('full_$uuid.jpg');

        await PostHogService.log('Storage UPLOAD START: ${fullRef.fullPath}',
            level: LogLevel.info, context: {'path': fullRef.fullPath});
        await fullRef.putFile(fullFile);
        final fullUrl = await fullRef.getDownloadURL();

        // Upload thumbnail
        final thumbRef = _storage
            .ref()
            .child('users')
            .child(userId)
            .child('items')
            .child(itemId)
            .child('thumb_$uuid.jpg');

        await PostHogService.log('Storage UPLOAD START: ${thumbRef.fullPath}',
            level: LogLevel.info, context: {'path': thumbRef.fullPath});
        await thumbRef.putFile(thumbFile);
        final thumbUrl = await thumbRef.getDownloadURL();

        await PostHogService.log('Storage UPLOAD SUCCESS: $itemId',
            level: LogLevel.info, context: {'itemId': itemId});

        return {'full': fullUrl, 'thumb': thumbUrl};
      });
    } catch (e) {
      PostHogService().logError('storage_upload_failed', e, context: {
        'userId': userId,
        'itemId': itemId,
      });
      throw Exception('Failed to upload pre-processed image: $e');
    }
  }

  /// Upload both full (compressed) and thumbnail versions
  Future<Map<String, String>> uploadImageWithThumbnail({
    required File file,
    required String userId,
    required String itemId,
  }) async {
    try {
      // Compress full image
      final compressedFile = await compressImage(file);

      // Generate thumbnail
      final thumbnailFile = await generateThumbnail(file);

      final result = await uploadPreProcessedImage(
        fullFile: compressedFile,
        thumbFile: thumbnailFile,
        userId: userId,
        itemId: itemId,
      );

      // Clean up temp files
      await compressedFile.delete();
      await thumbnailFile.delete();

      return result;
    } catch (e) {
      PostHogService().logError('storage_image_processing_failed', e);
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

      return await PostHogService().trackLatency('upload_file', () async {
        await PostHogService.log('Storage UPLOAD START: ${ref.fullPath}',
            level: LogLevel.info, context: {'path': ref.fullPath});
        final UploadTask uploadTask = ref.putFile(file);
        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      }, context: {'path': ref.fullPath});
    } catch (e) {
      PostHogService().logError('storage_file_upload_failed', e, context: {
        'userId': userId,
        'folder': folder,
      });
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Upload profile image (full and thumbnail)
  Future<String> uploadProfileImage({
    required File file,
    required String userId,
  }) async {
    try {
      final uuid = _uuid.v4();

      // Compress full image
      final compressedFile = await compressImage(file);

      // Generate thumbnail (we'll specifically use the thumbnail for profile display)
      final thumbnailFile = await generateThumbnail(file);

      // Upload thumbnail (as primary profile photo)
      final ref = _storage
          .ref()
          .child('users')
          .child(userId)
          .child('profile')
          .child('profile_$uuid.jpg');

      return await PostHogService().trackLatency('upload_profile_image',
          () async {
        await PostHogService.log('Storage UPLOAD START: ${ref.fullPath}',
            level: LogLevel.info, context: {'path': ref.fullPath});
        await ref.putFile(thumbnailFile);
        final downloadUrl = await ref.getDownloadURL();

        // Clean up temp files
        await compressedFile.delete();
        await thumbnailFile.delete();

        return downloadUrl;
      }, context: {'userId': userId});
    } catch (e) {
      PostHogService().logError('storage_profile_upload_failed', e,
          context: {'userId': userId});
      throw Exception('Failed to upload profile image: $e');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      await PostHogService().trackLatency('delete_file', () async {
        final Reference ref = _storage.refFromURL(fileUrl);
        await PostHogService.log('Storage DELETE START: ${ref.fullPath}',
            level: LogLevel.info, context: {'path': ref.fullPath});
        await ref.delete();
      }, context: {'url': fileUrl});
    } catch (e) {
      PostHogService().logError('storage_delete_failed', e, context: {
        'url': fileUrl,
      });
      throw Exception('Failed to delete file: $e');
    }
  }
}

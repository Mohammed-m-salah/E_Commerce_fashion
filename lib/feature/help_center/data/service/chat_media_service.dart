import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class ChatMediaService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

  static const String _bucketName = 'chat-media';

  Future<String> uploadImage(File file, String chatRoomId) async {
    return _uploadFile(file, chatRoomId, 'images');
  }

  Future<String> uploadVoice(File file, String chatRoomId) async {
    return _uploadFile(file, chatRoomId, 'voice');
  }

  Future<String> uploadFile(File file, String chatRoomId) async {
    return _uploadFile(file, chatRoomId, 'files');
  }

  Future<String> _uploadFile(File file, String chatRoomId, String folder) async {
    try {
      final fileExtension = path.extension(file.path);
      final fileName = '${_uuid.v4()}$fileExtension';
      final filePath = '$chatRoomId/$folder/$fileName';

      await _supabase.storage.from(_bucketName).upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final publicUrl = _supabase.storage.from(_bucketName).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> deleteMedia(String mediaUrl) async {
    try {
      final uri = Uri.parse(mediaUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf(_bucketName);
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        await _supabase.storage.from(_bucketName).remove([filePath]);
      }
    } catch (e) {
      throw Exception('Failed to delete media: $e');
    }
  }

  String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  bool isImageFile(String filePath) {
    final ext = getFileExtension(filePath);
    return ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(ext);
  }

  bool isAudioFile(String filePath) {
    final ext = getFileExtension(filePath);
    return ['.mp3', '.wav', '.m4a', '.aac', '.ogg', '.flac'].contains(ext);
  }
}

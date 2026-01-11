import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../service/chat_media_service.dart';

class ChatRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();
  final ChatMediaService _mediaService = ChatMediaService();

  Future<String> getOrCreateChatRoom(String userId) async {
    try {
      final response = await _supabase
          .from('chat_rooms')
          .select()
          .eq('user_id', userId)
          .eq('status', 'open')
          .maybeSingle();

      if (response != null) {
        return response['id'];
      }

      final newRoom = await _supabase
          .from('chat_rooms')
          .insert({
            'id': _uuid.v4(),
            'user_id': userId,
            'status': 'open',
          })
          .select()
          .single();

      return newRoom['id'];
    } catch (e) {
      throw Exception('فشل في إنشاء غرفة الدردشة: $e');
    }
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String message,
    required bool isAdmin,
  }) async {
    await _supabase.from('messages').insert({
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'message': message,
      'is_admin': isAdmin,
      'message_type': 'text',
    });

    // إرسال إشعار
    await _sendNotification(
      chatRoomId: chatRoomId,
      message: message,
      isAdmin: isAdmin,
    );
  }

  /// إرسال إشعار عبر Edge Function
  Future<void> _sendNotification({
    required String chatRoomId,
    required String message,
    required bool isAdmin,
  }) async {
    try {
      await _supabase.functions.invoke(
        'dynamic-function',
        body: {
          'record': {
            'chat_room_id': chatRoomId,
            'message': message,
            'is_admin': isAdmin,
          },
        },
      );
    } catch (e) {
      print('⚠️ Failed to send notification: $e');
    }
  }

  Future<void> sendImageMessage({
    required String chatRoomId,
    required String senderId,
    required File imageFile,
    required bool isAdmin,
  }) async {
    final mediaUrl = await _mediaService.uploadImage(imageFile, chatRoomId);
    await _supabase.from('messages').insert({
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'message': '📷 Image',
      'is_admin': isAdmin,
      'message_type': 'image',
      'media_url': mediaUrl,
    });
  }

  Future<void> sendVoiceMessage({
    required String chatRoomId,
    required String senderId,
    required File voiceFile,
    required int durationSeconds,
    required bool isAdmin,
  }) async {
    final mediaUrl = await _mediaService.uploadVoice(voiceFile, chatRoomId);
    await _supabase.from('messages').insert({
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'message': '🎤 Voice message',
      'is_admin': isAdmin,
      'message_type': 'voice',
      'media_url': mediaUrl,
      'voice_duration_seconds': durationSeconds,
    });
  }

  Future<void> sendFileMessage({
    required String chatRoomId,
    required String senderId,
    required File file,
    required String fileName,
    required int fileSizeBytes,
    required bool isAdmin,
  }) async {
    final mediaUrl = await _mediaService.uploadFile(file, chatRoomId);
    await _supabase.from('messages').insert({
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'message': '📎 $fileName',
      'is_admin': isAdmin,
      'message_type': 'file',
      'media_url': mediaUrl,
      'file_name': fileName,
      'file_size_bytes': fileSizeBytes,
    });
  }

  Stream<List<Map<String, dynamic>>> messagesStream(String chatRoomId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_room_id', chatRoomId)
        .order('created_at', ascending: true);
  }

  Future<List<Map<String, dynamic>>> getMessages(String chatRoomId) async {
    final response = await _supabase
        .from('messages')
        .select()
        .eq('chat_room_id', chatRoomId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> markAsRead(String chatRoomId, String recipientId) async {
    await _supabase
        .from('messages')
        .update({'is_read': true})
        .eq('chat_room_id', chatRoomId)
        .neq('sender_id', recipientId);
  }

  Future<void> deleteMessage(String messageId) async {
    await _supabase.from('messages').update({
      'is_deleted': true,
      'message': 'تم حذف هذه الرسالة',
    }).eq('id', messageId);
  }

  Future<void> updateMessage(String messageId, String newMessage) async {
    await _supabase.from('messages').update({
      'message': newMessage,
      'is_edited': true,
      'edited_at': DateTime.now().toIso8601String(),
    }).eq('id', messageId);
  }
}

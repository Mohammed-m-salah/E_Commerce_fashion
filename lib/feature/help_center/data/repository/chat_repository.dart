import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

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
}

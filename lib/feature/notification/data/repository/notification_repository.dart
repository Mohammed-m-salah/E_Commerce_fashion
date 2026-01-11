import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:e_commerce_fullapp/feature/notification/data/notification_model.dart';
import 'package:uuid/uuid.dart';

class NotificationRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      if (currentUserId == null) return [];

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', currentUserId!)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => NotificationModel.fromSupabase(json))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> saveNotification(NotificationModel notification) async {
    try {
      if (currentUserId == null) return;

      await _supabase.from('notifications').insert({
        'id': notification.id,
        'user_id': currentUserId,
        'title': notification.title,
        'body': notification.body,
        'type': notification.type.name,
        'is_read': notification.isRead,
        'data': notification.data,
        'created_at': notification.createdAt.toIso8601String(),
      });

      debugPrint('✅ Notification saved to Supabase');
    } catch (e) {
      debugPrint('❌ Error saving notification: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true}).eq('id', notificationId);
    } catch (e) {
      debugPrint('❌ Error marking as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      if (currentUserId == null) return;

      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', currentUserId!)
          .eq('is_read', false);

      debugPrint('✅ All notifications marked as read');
    } catch (e) {
      debugPrint('❌ Error marking all as read: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _supabase.from('notifications').delete().eq('id', notificationId);
    } catch (e) {
      debugPrint('❌ Error deleting notification: $e');
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      if (currentUserId == null) return;

      await _supabase
          .from('notifications')
          .delete()
          .eq('user_id', currentUserId!);

      debugPrint('🗑️ All notifications cleared');
    } catch (e) {
      debugPrint('❌ Error clearing notifications: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> notificationsStream() {
    if (currentUserId == null) {
      return const Stream.empty();
    }

    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUserId!)
        .order('created_at', ascending: false);
  }

  Future<int> getUnreadCount() async {
    try {
      if (currentUserId == null) return 0;

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', currentUserId!)
          .eq('is_read', false)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      debugPrint('❌ Error getting unread count: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('id, full_name, email, avatar_url')
          .order('full_name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ Error fetching users: $e');
      return [];
    }
  }

  /// ========== إرسال إشعار لمستخدم واحد (Push + Database) ==========
  Future<bool> sendNotificationToUser({
    required String targetUserId,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) async {
    try {
      // 1. إرسال Push Notification عبر Edge Function
      final pushResult = await _sendPushNotification(
        userIds: [targetUserId],
        title: title,
        body: body,
        type: type.name,
        data: data,
      );

      if (pushResult) {
        debugPrint('✅ Push notification sent to user: $targetUserId');
      }

      // 2. حفظ الإشعار في قاعدة البيانات (كإحتياط إذا فشل Edge Function في الحفظ)
      await _supabase.from('notifications').upsert({
        'id': _uuid.v4(),
        'user_id': targetUserId,
        'title': title,
        'body': body,
        'type': type.name,
        'is_read': false,
        'data': data,
        'created_at': DateTime.now().toIso8601String(),
      });

      debugPrint('✅ Notification saved for user: $targetUserId');
      return true;
    } catch (e) {
      debugPrint('❌ Error sending notification to user: $e');
      return false;
    }
  }

  /// ========== إرسال إشعار لعدة مستخدمين (Push + Database) ==========
  Future<int> sendNotificationToMultipleUsers({
    required List<String> targetUserIds,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) async {
    if (targetUserIds.isEmpty) return 0;

    try {
      // 1. إرسال Push Notifications عبر Edge Function
      final pushResult = await _sendPushNotification(
        userIds: targetUserIds,
        title: title,
        body: body,
        type: type.name,
        data: data,
      );

      if (pushResult) {
        debugPrint('✅ Push notifications sent to ${targetUserIds.length} users');
      }

      // 2. حفظ الإشعارات في قاعدة البيانات
      final notifications = targetUserIds
          .map((userId) => {
                'id': _uuid.v4(),
                'user_id': userId,
                'title': title,
                'body': body,
                'type': type.name,
                'is_read': false,
                'data': data,
                'created_at': DateTime.now().toIso8601String(),
              })
          .toList();

      await _supabase.from('notifications').upsert(notifications);

      debugPrint('✅ Notifications saved for ${targetUserIds.length} users');
      return targetUserIds.length;
    } catch (e) {
      debugPrint('❌ Error sending notifications to multiple users: $e');
      return 0;
    }
  }

  /// ========== إرسال إشعار لجميع المستخدمين ==========
  Future<int> sendNotificationToAllUsers({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) async {
    try {
      // إرسال عبر Edge Function مع send_to_all = true
      final pushResult = await _sendPushNotification(
        sendToAll: true,
        title: title,
        body: body,
        type: type.name,
        data: data,
      );

      if (pushResult) {
        debugPrint('✅ Push notifications sent to all users');
      }

      // جلب عدد المستخدمين للإرجاع
      final users = await getAllUsers();
      return users.length;
    } catch (e) {
      debugPrint('❌ Error sending notification to all users: $e');
      return 0;
    }
  }

  /// ========== إرسال Push Notification عبر Edge Function ==========
  Future<bool> _sendPushNotification({
    List<String>? userIds,
    bool sendToAll = false,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      final requestBody = <String, dynamic>{
        'title': title,
        'body': body,
        'type': type,
        if (data != null) 'data': data,
      };

      if (sendToAll) {
        requestBody['send_to_all'] = true;
      } else if (userIds != null && userIds.length == 1) {
        requestBody['user_id'] = userIds.first;
      } else if (userIds != null && userIds.isNotEmpty) {
        requestBody['user_ids'] = userIds;
      }

      final response = await _supabase.functions.invoke(
        'send-admin-notification',
        body: requestBody,
      );

      if (response.status == 200) {
        final result = response.data;
        debugPrint('📤 Push notification result: $result');
        return true;
      } else {
        debugPrint('⚠️ Push notification failed: ${response.status}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error calling Edge Function: $e');
      // لا نريد أن يفشل كل شيء إذا فشل Push
      // الإشعار سيُحفظ في DB على أي حال
      return false;
    }
  }
}

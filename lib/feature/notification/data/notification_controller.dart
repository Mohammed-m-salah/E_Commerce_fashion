import 'dart:async';
import 'package:e_commerce_fullapp/feature/notification/data/notification_model.dart';
import 'package:e_commerce_fullapp/feature/notification/data/repository/notification_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

class NotificationController extends GetxController {
  final storage = GetStorage();
  final NotificationRepository _repository = NotificationRepository();
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  StreamSubscription? _realtimeSubscription;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    _setupRealtimeListener();
  }

  @override
  void onClose() {
    _realtimeSubscription?.cancel();
    super.onClose();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      if (_repository.currentUserId != null) {
        final supabaseNotifications = await _repository.getNotifications();
        if (supabaseNotifications.isNotEmpty) {
          notifications.value = supabaseNotifications;
          _saveToLocal();
          debugPrint(
              '✅ Loaded ${notifications.length} notifications from Supabase');
          return;
        }
      }

      _loadFromLocal();
    } catch (e) {
      debugPrint('❌ Error loading notifications: $e');
      hasError.value = true;
      _loadFromLocal();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFromLocal() {
    try {
      final savedNotifications = storage.read('notifications');
      if (savedNotifications != null) {
        notifications.value = (savedNotifications as List)
            .map((json) =>
                NotificationModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        debugPrint(
            '✅ Loaded ${notifications.length} notifications from local storage');
      }
    } catch (e) {
      debugPrint('❌ Error loading from local: $e');
    }
  }

  void _saveToLocal() {
    try {
      final notificationsJson =
          notifications.map((notification) => notification.toJson()).toList();
      storage.write('notifications', notificationsJson);
    } catch (e) {
      debugPrint('❌ Error saving to local: $e');
    }
  }

  void _setupRealtimeListener() {
    if (_repository.currentUserId == null) return;

    _realtimeSubscription = _repository.notificationsStream().listen(
      (data) {
        notifications.value =
            data.map((json) => NotificationModel.fromSupabase(json)).toList();
        _saveToLocal();
        debugPrint('🔔 Realtime update: ${notifications.length} notifications');
      },
      onError: (e) {
        debugPrint('❌ Realtime error: $e');
      },
    );
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) async {
    const uuid = Uuid();
    final notification = NotificationModel(
      id: uuid.v4(),
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
      data: data,
    );

    notifications.insert(0, notification);
    _saveToLocal();

    await _repository.saveNotification(notification);

    debugPrint('🔔 Notification added: $title');
  }

  Future<void> markAsRead(String notificationId) async {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      _saveToLocal();
      await _repository.markAsRead(notificationId);
    }
  }

  Future<void> markAllAsRead() async {
    notifications.value =
        notifications.map((n) => n.copyWith(isRead: true)).toList();
    _saveToLocal();
    await _repository.markAllAsRead();
    debugPrint('✅ All notifications marked as read');
  }

  Future<void> deleteNotification(String notificationId) async {
    notifications.removeWhere((n) => n.id == notificationId);
    _saveToLocal();
    await _repository.deleteNotification(notificationId);
  }

  Future<void> clearAllNotifications() async {
    notifications.clear();
    _saveToLocal();
    await _repository.clearAllNotifications();
    debugPrint('🗑️ All notifications cleared');
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  bool get hasUnread => unreadCount > 0;

  List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return notifications.where((n) => n.type == type).toList();
  }
}

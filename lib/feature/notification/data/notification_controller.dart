import 'package:e_commerce_fullapp/feature/notification/data/notification_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// متحكم الإشعارات
/// ================
/// مسؤول عن:
/// 1. تحميل الإشعارات من التخزين المحلي
/// 2. حفظ الإشعارات في التخزين المحلي
/// 3. إضافة إشعارات جديدة
/// 4. تحديث حالة القراءة
/// 5. حذف الإشعارات
class NotificationController extends GetxController {
  // ============ المتغيرات ============
  final storage = GetStorage();

  // قائمة الإشعارات (Observable)
  var notifications = <NotificationModel>[].obs;

  // حالة التحميل
  var isLoading = false.obs;

  // ============ Lifecycle ============
  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  // ============ تحميل الإشعارات ============
  /// تحميل الإشعارات من التخزين المحلي
  void loadNotifications() {
    try {
      isLoading.value = true;
      final savedNotifications = storage.read('notifications');

      if (savedNotifications != null) {
        notifications.value = (savedNotifications as List)
            .map((json) => NotificationModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();

        // ترتيب حسب التاريخ (الأحدث أولاً)
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        print('✅ تم تحميل ${notifications.length} إشعار');
      }
    } catch (e) {
      print('❌ خطأ في تحميل الإشعارات: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============ حفظ الإشعارات ============
  /// حفظ الإشعارات في التخزين المحلي
  void saveNotifications() {
    try {
      final notificationsJson = notifications
          .map((notification) => notification.toJson())
          .toList();
      storage.write('notifications', notificationsJson);
      print('✅ تم حفظ ${notifications.length} إشعار');
    } catch (e) {
      print('❌ خطأ في حفظ الإشعارات: $e');
    }
  }

  // ============ إضافة إشعار جديد ============
  /// إضافة إشعار جديد للقائمة
  void addNotification({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
      data: data,
    );

    // إضافة في البداية (الأحدث أولاً)
    notifications.insert(0, notification);
    saveNotifications();

    print('🔔 تم إضافة إشعار: $title');
  }

  // ============ تحديث حالة القراءة ============
  /// تحديث إشعار كمقروء
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      saveNotifications();
    }
  }

  /// تحديث جميع الإشعارات كمقروءة
  void markAllAsRead() {
    notifications.value = notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    saveNotifications();
    print('✅ تم تحديث جميع الإشعارات كمقروءة');
  }

  // ============ حذف الإشعارات ============
  /// حذف إشعار معين
  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
    saveNotifications();
  }

  /// حذف جميع الإشعارات
  void clearAllNotifications() {
    notifications.clear();
    saveNotifications();
    print('🗑️ تم حذف جميع الإشعارات');
  }

  // ============ Getters ============
  /// عدد الإشعارات غير المقروءة
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  /// هل يوجد إشعارات غير مقروءة
  bool get hasUnread => unreadCount > 0;

  /// الإشعارات غير المقروءة فقط
  List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  /// الإشعارات حسب النوع
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return notifications.where((n) => n.type == type).toList();
  }
}

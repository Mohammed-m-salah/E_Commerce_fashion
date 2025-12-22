import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_fullapp/feature/notification/data/notification_controller.dart';
import 'package:e_commerce_fullapp/feature/notification/data/notification_model.dart';

/// خدمة الإشعارات المحلية
/// ================================
/// هذه الخدمة مسؤولة عن:
/// 1. تهيئة نظام الإشعارات
/// 2. إظهار الإشعارات للمستخدم
/// 3. التعامل مع النقر على الإشعارات
///
/// نستخدم نمط Singleton لضمان وجود نسخة واحدة فقط
class LocalNotificationService {
  // ============ Singleton Pattern ============
  // نمط Singleton يضمن وجود نسخة واحدة فقط من الخدمة
  static final LocalNotificationService _instance = LocalNotificationService._internal();

  // Factory constructor يرجع نفس النسخة دائماً
  factory LocalNotificationService() => _instance;

  // Constructor خاص للـ Singleton
  LocalNotificationService._internal();

  // ============ المتغيرات ============
  // الكائن الرئيسي للتعامل مع الإشعارات
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // متغير للتحقق من أن الخدمة تم تهيئتها
  bool _isInitialized = false;

  // ============ التهيئة (Initialization) ============
  /// تهيئة خدمة الإشعارات
  /// يجب استدعاء هذه الدالة مرة واحدة عند بدء التطبيق
  Future<void> initialize() async {
    // تجنب التهيئة المتكررة
    if (_isInitialized) return;

    // -------- إعدادات Android --------
    // نحدد أيقونة الإشعار (يجب أن تكون موجودة في android/app/src/main/res/drawable)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // -------- إعدادات iOS --------
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      // طلب الإذن عند التهيئة
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // -------- دمج الإعدادات --------
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // -------- تهيئة الـ Plugin --------
    await _notificationsPlugin.initialize(
      initSettings,
      // دالة تُستدعى عند النقر على الإشعار
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // طلب إذن الإشعارات على Android 13+
    await _requestPermissions();

    _isInitialized = true;
    debugPrint('✅ Local Notifications initialized successfully');
  }

  // ============ طلب الأذونات ============
  /// طلب إذن الإشعارات من المستخدم
  Future<void> _requestPermissions() async {
    // لـ Android 13+ نحتاج طلب إذن صريح
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  // ============ التعامل مع النقر على الإشعار ============
  /// تُستدعى عند نقر المستخدم على الإشعار
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📱 Notification tapped: ${response.payload}');
    // يمكنك هنا التنقل لصفحة معينة بناءً على payload
    // مثلاً: إذا كان payload = "order_123" -> انتقل لصفحة تفاصيل الطلب
  }

  // ============ إظهار إشعار ============
  /// إظهار إشعار للمستخدم
  ///
  /// Parameters:
  /// - [id]: معرف فريد للإشعار (لتحديثه أو إلغائه لاحقاً)
  /// - [title]: عنوان الإشعار
  /// - [body]: محتوى الإشعار
  /// - [payload]: بيانات إضافية (تُمرر عند النقر على الإشعار)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // التأكد من التهيئة
    if (!_isInitialized) {
      await initialize();
    }

    // -------- إعدادات الإشعار لـ Android --------
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'order_channel',          // Channel ID - معرف فريد للقناة
      'Order Notifications',    // Channel Name - اسم يظهر في إعدادات التطبيق
      channelDescription: 'Notifications for order updates',
      importance: Importance.high,  // أهمية عالية = يظهر في أعلى الشاشة
      priority: Priority.high,      // أولوية عالية
      showWhen: true,               // إظهار وقت الإشعار
      enableVibration: true,        // تفعيل الاهتزاز
      playSound: true,              // تشغيل صوت
      icon: '@mipmap/ic_launcher',  // أيقونة الإشعار
      color: Color(0xFFff5722),     // لون الأيقونة (البرتقالي)
    );

    // -------- إعدادات الإشعار لـ iOS --------
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,   // إظهار تنبيه
      presentBadge: true,   // إظهار badge
      presentSound: true,   // تشغيل صوت
    );

    // -------- دمج الإعدادات --------
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // -------- إظهار الإشعار --------
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    debugPrint('🔔 Notification shown: $title');
  }

  // ============ إشعار تأكيد الطلب ============
  /// إظهار إشعار عند تأكيد الطلب
  /// هذه دالة مخصصة لسهولة الاستخدام
  Future<void> showOrderConfirmedNotification({
    required String orderId,
    required double totalAmount,
  }) async {
    final title = 'Order Confirmed!';
    final body = 'Your order $orderId has been placed successfully. Total: \$${totalAmount.toStringAsFixed(2)}';

    // إظهار الإشعار المحلي (System Notification)
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: 'order_$orderId',
    );

    // حفظ الإشعار في التطبيق (In-App Notification)
    _saveToNotificationController(
      title: title,
      body: body,
      type: NotificationType.orderConfirmed,
      data: {'orderId': orderId, 'totalAmount': totalAmount},
    );
  }

  // ============ إشعار شحن الطلب ============
  /// إظهار إشعار عند شحن الطلب
  Future<void> showOrderShippedNotification({
    required String orderId,
  }) async {
    final title = 'Order Shipped!';
    final body = 'Your order $orderId has been shipped and is on its way.';

    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: 'order_$orderId',
    );

    _saveToNotificationController(
      title: title,
      body: body,
      type: NotificationType.orderShipped,
      data: {'orderId': orderId},
    );
  }

  // ============ إشعار خصم ============
  /// إظهار إشعار خصم
  Future<void> showDiscountNotification({
    required String title,
    required String body,
    String? promoCode,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: 'discount_$promoCode',
    );

    _saveToNotificationController(
      title: title,
      body: body,
      type: NotificationType.discount,
      data: {'promoCode': promoCode},
    );
  }

  // ============ حفظ الإشعار في المتحكم ============
  /// حفظ الإشعار في NotificationController لعرضه داخل التطبيق
  void _saveToNotificationController({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    try {
      // التأكد من وجود المتحكم
      if (Get.isRegistered<NotificationController>()) {
        final controller = Get.find<NotificationController>();
        controller.addNotification(
          title: title,
          body: body,
          type: type,
          data: data,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Could not save notification to controller: $e');
    }
  }

  // ============ إلغاء إشعار ============
  /// إلغاء إشعار معين بواسطة ID
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // ============ إلغاء جميع الإشعارات ============
  /// إلغاء جميع الإشعارات
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}

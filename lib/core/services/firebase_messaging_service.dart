import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:e_commerce_fullapp/core/services/local_notification_service.dart';
import 'package:e_commerce_fullapp/feature/notification/data/notification_controller.dart';
import 'package:e_commerce_fullapp/feature/notification/data/notification_model.dart';

/// معالج الرسائل في الخلفية (Background)
/// يجب أن يكون top-level function (خارج أي class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📬 Background message received: ${message.messageId}');
  debugPrint('   Title: ${message.notification?.title}');
  debugPrint('   Body: ${message.notification?.body}');
  // الإشعار سيظهر تلقائياً من Firebase
}

/// خدمة Firebase Cloud Messaging
/// ================================
/// مسؤولة عن:
/// 1. تهيئة FCM والحصول على التوكن
/// 2. استقبال الإشعارات (Foreground/Background)
/// 3. التعامل مع النقر على الإشعارات
class FirebaseMessagingService {
  // ============ Singleton Pattern ============
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  // ============ المتغيرات ============
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _fcmToken;
  bool _isInitialized = false;

  // Getter للتوكن
  String? get fcmToken => _fcmToken;

  // ============ التهيئة ============
  /// تهيئة خدمة FCM
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. طلب الأذونات
      await _requestPermission();

      // 2. الحصول على التوكن
      await _getToken();

      // 3. تسجيل معالج الخلفية
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 4. الاستماع للرسائل في الـ Foreground
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 5. الاستماع للنقر على الإشعارات
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // 6. التحقق من إشعار فتح التطبيق
      await _checkInitialMessage();

      // 7. الاستماع لتحديث التوكن
      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      _isInitialized = true;
      debugPrint('✅ Firebase Messaging initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing FCM: $e');
    }
  }

  // ============ طلب الأذونات ============
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('⚠️ User granted provisional permission');
    } else {
      debugPrint('❌ User denied permission');
    }
  }

  // ============ الحصول على التوكن ============
  Future<void> _getToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      if (_fcmToken != null) {
        debugPrint('🔑 FCM Token: $_fcmToken');
        // يمكنك إرسال التوكن للسيرفر هنا
        await _sendTokenToServer(_fcmToken!);
      }
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
    }
  }

  // ============ تحديث التوكن ============
  void _onTokenRefresh(String newToken) {
    debugPrint('🔄 FCM Token refreshed: $newToken');
    _fcmToken = newToken;
    _sendTokenToServer(newToken);
  }

  // ============ إرسال التوكن للسيرفر ============
  Future<void> _sendTokenToServer(String token) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        debugPrint('⚠️ No user logged in, skipping token save');
        return;
      }

      await supabase.from('user_tokens').upsert(
        {
          'user_id': userId,
          'fcm_token': token,
          'platform': Platform.isAndroid ? 'android' : 'ios',
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id, fcm_token',
      );

      debugPrint('✅ FCM Token saved to Supabase');
    } catch (e) {
      debugPrint('❌ Error saving token: $e');
    }
  }

  // ============ معالجة الرسائل في الـ Foreground ============
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📱 Foreground message received!');
    debugPrint('   Title: ${message.notification?.title}');
    debugPrint('   Body: ${message.notification?.body}');
    debugPrint('   Data: ${message.data}');

    final notification = message.notification;
    if (notification != null) {
      // إظهار إشعار محلي (لأن FCM لا يظهر إشعار تلقائياً في Foreground)
      LocalNotificationService().showNotification(
        id: message.hashCode,
        title: notification.title ?? 'New Notification',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );

      // حفظ في NotificationController
      _saveToNotificationController(
        title: notification.title ?? 'New Notification',
        body: notification.body ?? '',
        data: message.data,
      );
    }
  }

  // ============ معالجة النقر على الإشعار ============
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('👆 Notification tapped!');
    debugPrint('   Data: ${message.data}');

    // التنقل بناءً على البيانات
    final data = message.data;
    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'order':
          // Navigate to order details
          // Get.toNamed('/order-details', arguments: data['order_id']);
          break;
        case 'offer':
          // Navigate to offers
          // Get.toNamed('/offers');
          break;
        case 'chat':
          // Navigate to chat
          // Get.toNamed('/chat');
          break;
        default:
          // Navigate to notifications
          // Get.toNamed('/notifications');
          break;
      }
    }
  }

  // ============ التحقق من الإشعار الأولي ============
  Future<void> _checkInitialMessage() async {
    // إذا فتح المستخدم التطبيق من إشعار
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('📬 App opened from notification');
      _handleNotificationTap(initialMessage);
    }
  }

  // ============ حفظ في NotificationController ============
  void _saveToNotificationController({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    try {
      if (Get.isRegistered<NotificationController>()) {
        final controller = Get.find<NotificationController>();

        // تحديد نوع الإشعار من البيانات
        NotificationType type = NotificationType.general;
        if (data != null && data.containsKey('type')) {
          switch (data['type']) {
            case 'order_confirmed':
              type = NotificationType.orderConfirmed;
              break;
            case 'order_shipped':
              type = NotificationType.orderShipped;
              break;
            case 'discount':
              type = NotificationType.discount;
              break;
          }
        }

        controller.addNotification(
          title: title,
          body: body,
          type: type,
          data: data,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Could not save notification: $e');
    }
  }

  // ============ الاشتراك في موضوع ============
  /// الاشتراك في موضوع لاستقبال إشعارات مجمعة
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Error subscribing to topic: $e');
    }
  }

  // ============ إلغاء الاشتراك من موضوع ============
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Error unsubscribing from topic: $e');
    }
  }
}

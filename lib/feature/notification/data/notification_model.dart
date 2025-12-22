/// نموذج الإشعار
/// ===============
/// يحتوي على جميع بيانات الإشعار الواحد
///
/// الحقول:
/// - id: معرف فريد للإشعار
/// - title: عنوان الإشعار
/// - body: محتوى الإشعار
/// - type: نوع الإشعار (order_confirmed, order_shipped, discount, payment)
/// - createdAt: تاريخ ووقت الإشعار
/// - isRead: هل تم قراءة الإشعار
/// - data: بيانات إضافية (مثل orderId)
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  /// إنشاء نسخة معدلة من الإشعار
  /// مفيد لتحديث حالة isRead
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  /// تحويل من JSON (للتخزين المحلي)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  /// تحويل إلى JSON (للتخزين المحلي)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'data': data,
    };
  }

  /// حساب الوقت النسبي (مثل "منذ ساعة")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

/// أنواع الإشعارات
/// ================
/// كل نوع له أيقونة ولون مختلف
enum NotificationType {
  orderConfirmed,  // تأكيد الطلب
  orderShipped,    // شحن الطلب
  orderDelivered,  // توصيل الطلب
  orderCancelled,  // إلغاء الطلب
  payment,         // دفع
  discount,        // خصم
  general,         // عام
}

/// Extension لإضافة خصائص لكل نوع إشعار
extension NotificationTypeExtension on NotificationType {
  /// الحصول على اسم النوع بالإنجليزية
  String get displayName {
    switch (this) {
      case NotificationType.orderConfirmed:
        return 'Order Confirmed';
      case NotificationType.orderShipped:
        return 'Order Shipped';
      case NotificationType.orderDelivered:
        return 'Order Delivered';
      case NotificationType.orderCancelled:
        return 'Order Cancelled';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.discount:
        return 'Discount';
      case NotificationType.general:
        return 'Notification';
    }
  }
}

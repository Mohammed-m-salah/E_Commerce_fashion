import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/notification/data/notification_controller.dart';
import 'package:e_commerce_fullapp/feature/notification/data/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Gap(10),

            // --- Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    'Notifications',
                    style: AppTextStyle.h3.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => controller.markAllAsRead(),
                    child: Text(
                      'Mark All as read',
                      style: AppTextStyle.bodylarge.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(20),

            // --- Notifications List ---
            Expanded(
              child: Obx(() {
                // حالة التحميل
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // حالة عدم وجود إشعارات
                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const Gap(16),
                        Text(
                          'No notifications yet',
                          style: AppTextStyle.h3.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Your notifications will appear here',
                          style: AppTextStyle.bodylarge.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // عرض الإشعارات
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.notifications.length,
                  separatorBuilder: (_, __) => const Gap(12),
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    final iconData = _getIconForType(notification.type);

                    return Dismissible(
                      key: Key(notification.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) {
                        controller.deleteNotification(notification.id);
                      },
                      child: GestureDetector(
                        onTap: () {
                          controller.markAsRead(notification.id);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: notification.isRead
                                ? (isDark ? Colors.grey.shade800 : Colors.grey.shade100)
                                : (isDark ? Colors.amber.shade900.withOpacity(0.3) : Colors.amber.shade100),
                            borderRadius: BorderRadius.circular(12),
                            border: notification.isRead
                                ? null
                                : Border.all(
                                    color: Colors.amber.shade300,
                                    width: 1,
                                  ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ICON
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: iconData['bgColor'],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  iconData['icon'],
                                  color: iconData['iconColor'],
                                ),
                              ),

                              const Gap(16),

                              // TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification.title,
                                            style: AppTextStyle.h2.copyWith(
                                              fontSize: 16,
                                              color: theme.textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                        ),
                                        if (!notification.isRead)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const Gap(4),
                                    Text(
                                      notification.body,
                                      style: AppTextStyle.bodylarge.copyWith(
                                        color: isDark
                                            ? Colors.grey.shade300
                                            : Colors.black87,
                                      ),
                                    ),
                                    const Gap(6),
                                    Text(
                                      notification.timeAgo,
                                      style: AppTextStyle.bodylarge.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// الحصول على الأيقونة واللون حسب نوع الإشعار
  Map<String, dynamic> _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.orderConfirmed:
        return {
          'icon': Icons.check_circle_outline,
          'iconColor': Colors.green,
          'bgColor': const Color(0xFFE8F5E9),
        };
      case NotificationType.orderShipped:
        return {
          'icon': Icons.local_shipping_outlined,
          'iconColor': Colors.blue,
          'bgColor': const Color(0xFFE3F2FD),
        };
      case NotificationType.orderDelivered:
        return {
          'icon': Icons.inventory_2_outlined,
          'iconColor': Colors.teal,
          'bgColor': const Color(0xFFE0F2F1),
        };
      case NotificationType.orderCancelled:
        return {
          'icon': Icons.cancel_outlined,
          'iconColor': Colors.red,
          'bgColor': const Color(0xFFFFEBEE),
        };
      case NotificationType.payment:
        return {
          'icon': Icons.payment_outlined,
          'iconColor': Colors.purple,
          'bgColor': const Color(0xFFF3E5F5),
        };
      case NotificationType.discount:
        return {
          'icon': Icons.local_offer_outlined,
          'iconColor': Colors.orange,
          'bgColor': const Color(0xFFFFF3E0),
        };
      case NotificationType.general:
        return {
          'icon': Icons.notifications_outlined,
          'iconColor': Colors.grey,
          'bgColor': const Color(0xFFF5F5F5),
        };
    }
  }
}

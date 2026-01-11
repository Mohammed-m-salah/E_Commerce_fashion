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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    'Notifications',
                    style: AppTextStyle.h3.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Spacer(),
                  // عداد الإشعارات غير المقروءة
                  Obx(() {
                    if (controller.unreadCount > 0) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${controller.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const Gap(8),
                  // قائمة الخيارات
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'read_all':
                          controller.markAllAsRead();
                          break;
                        case 'clear_all':
                          _showClearAllDialog(context, controller);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'read_all',
                        child: Row(
                          children: [
                            Icon(Icons.done_all, size: 20),
                            Gap(8),
                            Text('Mark all as read'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'clear_all',
                        child: Row(
                          children: [
                            Icon(Icons.delete_sweep, size: 20, color: Colors.red),
                            Gap(8),
                            Text('Clear all', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Gap(16),

            // --- Notifications List ---
            Expanded(
              child: Obx(() {
                // حالة التحميل
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // حالة الخطأ
                if (controller.hasError.value) {
                  return _buildErrorState(controller, isDark);
                }

                // حالة عدم وجود إشعارات
                if (controller.notifications.isEmpty) {
                  return _buildEmptyState(isDark);
                }

                // عرض الإشعارات مع Pull to Refresh
                return RefreshIndicator(
                  onRefresh: controller.refreshNotifications,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (_, __) => const Gap(12),
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return _buildNotificationItem(
                        context,
                        notification,
                        controller,
                        isDark,
                        theme,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء عنصر الإشعار
  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
    NotificationController controller,
    bool isDark,
    ThemeData theme,
  ) {
    final iconData = _getIconForType(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Notification'),
            content: const Text('Are you sure you want to delete this notification?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        controller.deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                controller.addNotification(
                  title: notification.title,
                  body: notification.body,
                  type: notification.type,
                  data: notification.data,
                );
              },
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          controller.markAsRead(notification.id);
          _handleNotificationTap(context, notification);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDark ? Colors.grey.shade800 : Colors.white)
                : (isDark
                    ? Colors.blue.shade900.withAlpha(77)
                    : Colors.blue.shade50),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? (isDark ? Colors.grey.shade700 : Colors.grey.shade200)
                  : Colors.blue.shade200,
              width: 1,
            ),
            boxShadow: [
              if (!notification.isRead)
                BoxShadow(
                  color: Colors.blue.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconData['bgColor'],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  iconData['icon'],
                  color: iconData['iconColor'],
                  size: 24,
                ),
              ),

              const Gap(14),

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
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withAlpha(102),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const Gap(4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const Gap(4),
                        Text(
                          notification.timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: iconData['bgColor'],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            notification.type.displayName,
                            style: TextStyle(
                              fontSize: 10,
                              color: iconData['iconColor'],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// حالة عدم وجود إشعارات
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const Gap(24),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const Gap(8),
          Text(
            'When you receive notifications,\nthey will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// حالة الخطأ
  Widget _buildErrorState(NotificationController controller, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red.shade400,
          ),
          const Gap(16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Failed to load notifications',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const Gap(24),
          ElevatedButton.icon(
            onPressed: controller.refreshNotifications,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// مربع حوار حذف الكل
  void _showClearAllDialog(
    BuildContext context,
    NotificationController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to delete all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearAllNotifications();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// التعامل مع النقر على الإشعار
  void _handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) {
    final data = notification.data;
    if (data == null) return;

    // يمكنك إضافة التنقل المناسب هنا
    switch (notification.type) {
      case NotificationType.orderConfirmed:
      case NotificationType.orderShipped:
      case NotificationType.orderDelivered:
      case NotificationType.orderCancelled:
        if (data.containsKey('order_id')) {
          // Get.toNamed('/order-details', arguments: data['order_id']);
        }
        break;
      case NotificationType.discount:
        // Get.toNamed('/offers');
        break;
      default:
        break;
    }
  }

  /// الحصول على الأيقونة واللون حسب نوع الإشعار
  Map<String, dynamic> _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.orderConfirmed:
        return {
          'icon': Icons.check_circle,
          'iconColor': Colors.green.shade600,
          'bgColor': Colors.green.shade50,
        };
      case NotificationType.orderShipped:
        return {
          'icon': Icons.local_shipping,
          'iconColor': Colors.blue.shade600,
          'bgColor': Colors.blue.shade50,
        };
      case NotificationType.orderDelivered:
        return {
          'icon': Icons.inventory_2,
          'iconColor': Colors.teal.shade600,
          'bgColor': Colors.teal.shade50,
        };
      case NotificationType.orderCancelled:
        return {
          'icon': Icons.cancel,
          'iconColor': Colors.red.shade600,
          'bgColor': Colors.red.shade50,
        };
      case NotificationType.payment:
        return {
          'icon': Icons.payment,
          'iconColor': Colors.purple.shade600,
          'bgColor': Colors.purple.shade50,
        };
      case NotificationType.discount:
        return {
          'icon': Icons.local_offer,
          'iconColor': Colors.orange.shade600,
          'bgColor': Colors.orange.shade50,
        };
      case NotificationType.general:
        return {
          'icon': Icons.notifications,
          'iconColor': Colors.grey.shade600,
          'bgColor': Colors.grey.shade100,
        };
    }
  }
}

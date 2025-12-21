import 'package:e_commerce_fullapp/feature/check_out/data/checkout_controller.dart';
import 'package:e_commerce_fullapp/feature/my_order/view/order_details_view.dart';
import 'package:e_commerce_fullapp/feature/my_order/view/widgets/Order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// عرض الطلبات الملغاة
class CancelledOrder extends StatelessWidget {
  const CancelledOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.find<CheckoutController>();

    return Obx(() {
      final cancelledOrders = checkoutController.cancelledOrders;

      // إذا لم توجد طلبات ملغاة
      if (cancelledOrders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cancel_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const Gap(16),
              Text(
                'No Cancelled Orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const Gap(8),
              Text(
                'Your cancelled orders will appear here',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }

      // عرض قائمة الطلبات الملغاة
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cancelledOrders.length,
        separatorBuilder: (_, __) => const Gap(12),
        itemBuilder: (context, index) {
          final order = cancelledOrders[index];
          final formattedDate = DateFormat('dd MMM yyyy').format(order.orderDate);

          // استخدام صورة المنتج الأول في الطلب
          final imageUrl = order.items.isNotEmpty
              ? order.items.first.product.imageUrl
              : '';

          return GestureDetector(
            onTap: () {
              // Navigate to order details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsView(order: order),
                ),
              );
            },
            child: OrderCard(
              orderId: order.id,
              date: formattedDate,
              total: order.total,
              image: imageUrl,
              status: 'Cancelled',
              statusColor: Colors.red,
              statusBg: Colors.red.shade100,
            ),
          );
        },
      );
    });
  }
}

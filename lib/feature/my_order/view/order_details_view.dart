import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/checkout_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/order_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// صفحة تفاصيل الطلب - تعرض كل معلومات الطلب
class OrderDetailsView extends StatelessWidget {
  final Order order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(order.orderDate);
    final formattedTime = DateFormat('hh:mm a').format(order.orderDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: AppTextStyle.h3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info Card
            _buildInfoCard(context, formattedDate, formattedTime),
            const Gap(20),

            // Order Items
            Text('Order Items', style: AppTextStyle.h3),
            const Gap(12),
            ...order.items.map((item) => _buildOrderItem(context, item)),

            const Gap(20),

            // Order Summary
            _buildOrderSummary(context),

            const Gap(20),

            // Shipping Address
            _buildShippingAddress(context),

            const Gap(20),

            // Action Buttons (only for Active orders)
            if (order.status == 'Active') ...[
              Row(
                children: [
                  // Confirm Order Button
                  Expanded(
                    child: _buildConfirmButton(context),
                  ),
                  const Gap(12),
                  // Cancel Button
                  Expanded(
                    child: _buildCancelButton(context),
                  ),
                ],
              ),
            ],

            const Gap(20),
          ],
        ),
      ),
    );
  }

  /// بطاقة معلومات الطلب
  Widget _buildInfoCard(BuildContext context, String date, String time) {
    Color statusColor;
    Color statusBg;

    switch (order.status) {
      case 'Active':
        statusColor = Colors.orange;
        statusBg = Colors.orange.shade100;
        break;
      case 'Completed':
        statusColor = Colors.green;
        statusBg = Colors.green.shade100;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        statusBg = Colors.red.shade100;
        break;
      default:
        statusColor = Colors.grey;
        statusBg = Colors.grey.shade100;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order ID', style: TextStyle(color: Colors.grey.shade600)),
              Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date', style: TextStyle(color: Colors.grey.shade600)),
              Text(date, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Time', style: TextStyle(color: Colors.grey.shade600)),
              Text(time, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status', style: TextStyle(color: Colors.grey.shade600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// عنصر منتج في الطلب
  Widget _buildOrderItem(BuildContext context, item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade700
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade700
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.product.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
            ),
          ),
          const Gap(12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '\$${item.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFff5722),
            ),
          ),
        ],
      ),
    );
  }

  /// ملخص الطلب
  Widget _buildOrderSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTextStyle.h3),
          const Gap(12),
          _buildSummaryRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
          const Gap(8),
          _buildSummaryRow('Shipping', '\$${order.shipping.toStringAsFixed(2)}'),
          const Gap(8),
          _buildSummaryRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
          const Divider(height: 20),
          _buildSummaryRow(
            'Total',
            '\$${order.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  /// صف ملخص السعر
  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? null : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xFFff5722) : null,
          ),
        ),
      ],
    );
  }

  /// عنوان الشحن
  Widget _buildShippingAddress(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFFff5722)),
              const Gap(8),
              Text('Shipping Address', style: AppTextStyle.h3),
            ],
          ),
          const Gap(12),
          Text(
            order.shippingAddress,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
          const Gap(12),
          Row(
            children: [
              const Icon(Icons.payment, color: Color(0xFFff5722)),
              const Gap(8),
              Text('Payment Method', style: AppTextStyle.h3),
            ],
          ),
          const Gap(8),
          Text(
            order.paymentMethod,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  /// زر تأكيد الطلب
  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _showConfirmDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Confirm Order',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// زر إلغاء الطلب
  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _showCancelDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Cancel Order',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// عرض نافذة تأكيد الطلب
  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Text('Are you sure you want to mark order ${order.id} as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              final checkoutController = Get.find<CheckoutController>();
              checkoutController.completeOrder(order.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to orders list
            },
            child: const Text(
              'Yes, Confirm',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  /// عرض نافذة تأكيد الإلغاء
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel order ${order.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              final checkoutController = Get.find<CheckoutController>();
              checkoutController.cancelOrder(order.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to orders list
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

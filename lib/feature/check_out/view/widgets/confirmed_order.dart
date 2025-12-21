import 'package:e_commerce_fullapp/feature/check_out/data/order_model.dart';
import 'package:e_commerce_fullapp/feature/my_order/view/my_order_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

/// صفحة تأكيد الطلب - تظهر بعد إتمام الطلب بنجاح
class ConfirmedOrder extends StatelessWidget {
  final Order order; // الطلب الذي تم إنشاؤه

  const ConfirmedOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // تنسيق التاريخ
    final formattedDate = DateFormat('MMM dd, yyyy').format(order.orderDate);
    final formattedTime = DateFormat('hh:mm a').format(order.orderDate);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // أيقونة النجاح
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xff00C989).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Color(0xff00C989),
                ),
              ),

              const Gap(24),

              // العنوان
              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Gap(12),

              // الوصف مع رقم الطلب الحقيقي
              Text(
                'Your order ${order.id} has been placed successfully.\nWe will process it shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),

              const Gap(30),

              // تفاصيل الطلب
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // رقم الطلب
                    _buildDetailRow('Order ID', order.id),
                    const Divider(height: 20),

                    // التاريخ والوقت
                    _buildDetailRow('Date', formattedDate),
                    const Gap(8),
                    _buildDetailRow('Time', formattedTime),
                    const Divider(height: 20),

                    // عدد المنتجات
                    _buildDetailRow(
                      'Items',
                      '${order.itemCount} items',
                    ),
                    const Divider(height: 20),

                    // المبلغ الإجمالي
                    _buildDetailRow(
                      'Total Amount',
                      '\$${order.total.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // الأزرار
              Column(
                children: [
                  // تتبع الطلب
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFff5722),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // الانتقال لصفحة الطلبات
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyOrderView(),
                          ),
                          (route) => route.isFirst,
                        );
                      },
                      child: const Text(
                        'View My Orders',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const Gap(12),

                  // متابعة التسوق
                  TextButton(
                    onPressed: () {
                      // العودة للصفحة الرئيسية
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFff5722),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء صف تفاصيل
  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

import 'package:e_commerce_fullapp/feature/check_out/data/checkout_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/box_decoration.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/summery_row.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// ملخص الطلب - يعرض تفاصيل الأسعار والمجموع
class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على CheckoutController لحساب الأسعار
    final checkoutController = Get.find<CheckoutController>();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: checkoutBoxDecoration(context),
      child: Obx(() {
        // استخدام Obx للتحديث التلقائي عند تغيير السلة
        return Column(
          children: [
            // المجموع الفرعي (مجموع أسعار المنتجات)
            SummaryRow(
              title: 'Subtotal',
              value: '\$${checkoutController.subtotal.toStringAsFixed(2)}',
            ),
            const Gap(8),

            // تكلفة الشحن
            SummaryRow(
              title: 'Shipping',
              value: '\$${checkoutController.shippingCost.toStringAsFixed(2)}',
            ),
            const Gap(8),

            // الضريبة (5%)
            SummaryRow(
              title: 'Tax (5%)',
              value: '\$${checkoutController.tax.toStringAsFixed(2)}',
            ),
            const Divider(height: 20),

            // المجموع الكلي
            SummaryRow(
              title: 'Total',
              value: '\$${checkoutController.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        );
      }),
    );
  }
}

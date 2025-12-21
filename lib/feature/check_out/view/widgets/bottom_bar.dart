import 'package:e_commerce_fullapp/feature/check_out/data/checkout_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/payment_method_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/confirmed_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// شريط الزر السفلي لإتمام الطلب
class CheckoutBottomBar extends StatelessWidget {
  const CheckoutBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.find<CheckoutController>();
    final paymentMethodController = Get.find<PaymentMethodController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Obx(() {
        // التحقق من حالة معالجة الطلب
        final isProcessing = checkoutController.isProcessingOrder.value;

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFff5722),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // تعطيل الزر أثناء المعالجة
            disabledBackgroundColor: Colors.grey,
          ),
          onPressed: isProcessing
              ? null // تعطيل الزر أثناء المعالجة
              : () async {
                  // تحديد طريقة الدفع المحددة
                  final selectedPaymentMethod = paymentMethodController.selectedPaymentMethod.value;
                  final paymentType = selectedPaymentMethod?.type ?? '';

                  // استخدام Stripe للبطاقات، أو الطريقة العادية للدفع عند الاستلام
                  final order = (paymentType == 'Credit Card' || paymentType == 'Debit Card')
                      ? await checkoutController.processOrderWithStripe()
                      : await checkoutController.processOrder();

                  // إذا تم إنشاء الطلب بنجاح، الانتقال لصفحة التأكيد
                  if (order != null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmedOrder(order: order),
                      ),
                    );
                  }
                },
          child: isProcessing
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Processing Order...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : const Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        );
      }),
    );
  }
}

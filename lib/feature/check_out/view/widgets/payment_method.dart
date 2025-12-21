import 'package:e_commerce_fullapp/feature/check_out/data/payment_method_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/payment_method_list_view.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentMethodController = Get.find<PaymentMethodController>();

    return Obx(() {
      final selectedPaymentMethod = paymentMethodController.selectedPaymentMethod.value;

      return GestureDetector(
        onTap: () {
          // الانتقال لصفحة قائمة طرق الدفع
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PaymentMethodListView(),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(16),
          decoration: checkoutBoxDecoration(context),
          child: Row(
            children: [
              // أيقونة طريقة الدفع
              _buildPaymentIcon(selectedPaymentMethod?.type ?? 'Credit Card'),
              const Gap(10),
              // معلومات طريقة الدفع
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedPaymentMethod?.displayText ?? 'No Payment Method',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (selectedPaymentMethod != null && selectedPaymentMethod.type != 'Cash on Delivery') ...[
                      const Gap(4),
                      Row(
                        children: [
                          Text(
                            'Expires: ${selectedPaymentMethod.expiryDate}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Gap(8),
                          if (selectedPaymentMethod.isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(8),
              // أيقونة التعديل أو الإضافة
              Icon(
                selectedPaymentMethod != null ? Icons.edit : Icons.add,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      );
    });
  }

  /// بناء أيقونة طريقة الدفع
  Widget _buildPaymentIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'Credit Card':
        icon = Icons.credit_card;
        color = Colors.blue;
        break;
      case 'Debit Card':
        icon = Icons.credit_card;
        color = Colors.green;
        break;
      case 'PayPal':
        icon = Icons.account_balance_wallet;
        color = Colors.indigo;
        break;
      case 'Cash on Delivery':
        icon = Icons.local_shipping_outlined;
        color = Colors.orange;
        break;
      default:
        icon = Icons.payment;
        color = const Color(0xFFff5722);
    }

    return Icon(icon, color: color, size: 24);
  }
}

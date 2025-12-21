import 'package:e_commerce_fullapp/feature/check_out/data/payment_method_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/payment_method_model.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/add_edit_payment_method_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// صفحة قائمة طرق الدفع
class PaymentMethodListView extends StatelessWidget {
  const PaymentMethodListView({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentMethodController = Get.find<PaymentMethodController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
        actions: [
          // زر إضافة طريقة دفع جديدة
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditPaymentMethodView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final paymentMethods = paymentMethodController.paymentMethods;

        // إذا لم توجد طرق دفع
        if (paymentMethods.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.payment_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const Gap(16),
                Text(
                  'No Payment Methods Yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Gap(8),
                Text(
                  'Add your first payment method',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                const Gap(24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddEditPaymentMethodView(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Payment Method'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
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

        // عرض قائمة طرق الدفع
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: paymentMethods.length,
          separatorBuilder: (_, __) => const Gap(12),
          itemBuilder: (context, index) {
            final paymentMethod = paymentMethods[index];
            final isSelected = paymentMethodController.selectedPaymentMethod.value?.id == paymentMethod.id;

            return _PaymentMethodCard(
              paymentMethod: paymentMethod,
              isSelected: isSelected,
              onTap: () {
                // اختيار طريقة الدفع
                paymentMethodController.selectPaymentMethod(paymentMethod);
                // العودة للصفحة السابقة
                Navigator.pop(context);
              },
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditPaymentMethodView(paymentMethod: paymentMethod),
                  ),
                );
              },
              onDelete: () {
                _showDeleteDialog(context, paymentMethod);
              },
              onSetDefault: () {
                paymentMethodController.setDefaultPaymentMethod(paymentMethod.id);
              },
            );
          },
        );
      }),
      // زر عائم لإضافة طريقة دفع جديدة
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditPaymentMethodView(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Payment'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  /// إظهار حوار تأكيد الحذف
  void _showDeleteDialog(BuildContext context, PaymentMethod paymentMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text('Are you sure you want to delete this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.find<PaymentMethodController>().deletePaymentMethod(paymentMethod.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// بطاقة طريقة الدفع
class _PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _PaymentMethodCard({
    required this.paymentMethod,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صف النوع والأيقونات
            Row(
              children: [
                // أيقونة النوع
                _buildPaymentIcon(),
                const Gap(12),
                // النوع
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentMethod.type,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (paymentMethod.type != 'Cash on Delivery') ...[
                        const Gap(4),
                        Text(
                          paymentMethod.maskedCardNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // شارة الافتراضي
                if (paymentMethod.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                const Gap(8),
                // أيقونة الاختيار
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
              ],
            ),

            if (paymentMethod.type != 'Cash on Delivery') ...[
              const Gap(12),
              // اسم صاحب البطاقة
              Text(
                paymentMethod.cardHolderName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const Gap(4),
              // تاريخ الانتهاء
              Row(
                children: [
                  Text(
                    'Expires: ${paymentMethod.expiryDate}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      paymentMethod.cardBrand,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const Gap(16),

            // أزرار الإجراءات
            Row(
              children: [
                // زر التعديل
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                // زر الحذف
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const Gap(8),
                // زر تعيين كافتراضي
                if (!paymentMethod.isDefault)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSetDefault,
                      icon: const Icon(Icons.star_outline, size: 18),
                      label: const Text('Default'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// بناء أيقونة طريقة الدفع
  Widget _buildPaymentIcon() {
    IconData icon;
    Color color;

    switch (paymentMethod.type) {
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
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

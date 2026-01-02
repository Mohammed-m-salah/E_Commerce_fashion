import 'package:e_commerce_fullapp/feature/check_out/data/checkout_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// ويدجت إدخال كود الخصم
class DiscountCodeWidget extends StatefulWidget {
  const DiscountCodeWidget({super.key});

  @override
  State<DiscountCodeWidget> createState() => _DiscountCodeWidgetState();
}

class _DiscountCodeWidgetState extends State<DiscountCodeWidget> {
  final TextEditingController _codeController = TextEditingController();
  final checkoutController = Get.find<CheckoutController>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: checkoutBoxDecoration(context),
      child: Obx(() {
        final hasDiscount = checkoutController.hasDiscount;
        final isValidating = checkoutController.isValidatingCode.value;

        // إذا كان هناك خصم مطبق، إظهار تفاصيل الخصم
        if (hasDiscount) {
          return _buildAppliedDiscount(isDark);
        }

        // إظهار حقل إدخال الكود
        return _buildCodeInput(isDark, isValidating);
      }),
    );
  }

  /// بناء حقل إدخال الكود
  Widget _buildCodeInput(bool isDark, bool isValidating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان
        Row(
          children: [
            Icon(
              Icons.discount_outlined,
              size: 20,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
            const Gap(8),
            Text(
              'Have a discount code?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const Gap(12),

        // حقل الإدخال والزر
        Row(
          children: [
            // حقل الإدخال
            Expanded(
              child: TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Enter code',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const Gap(12),

            // زر التطبيق
            SizedBox(
              height: 48,
              width: 80,
              child: ElevatedButton(
                onPressed: isValidating
                    ? null
                    : () async {
                        final code = _codeController.text.trim();
                        final success = await checkoutController.applyDiscountCode(code);
                        if (success) {
                          _codeController.clear();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade400,
                ),
                child: isValidating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Apply',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// بناء عرض الخصم المطبق
  Widget _buildAppliedDiscount(bool isDark) {
    final offer = checkoutController.appliedOffer.value!;
    final discount = checkoutController.discountAmount.value;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.green.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        children: [
          // أيقونة النجاح
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
          const Gap(12),

          // تفاصيل الخصم
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discount Applied!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const Gap(2),
                Text(
                  '${offer.title} (${offer.discountText})',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                  ),
                ),
                if (checkoutController.discountCode.value.isNotEmpty)
                  Text(
                    'Code: ${checkoutController.discountCode.value.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // مبلغ الخصم وزر الإزالة
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-\$${discount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const Gap(4),
              GestureDetector(
                onTap: () => checkoutController.removeDiscountCode(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

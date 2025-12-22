import 'package:e_commerce_fullapp/feature/check_out/data/address_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/address_list_view.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = Get.find<AddressController>();

    return Obx(() {
      final selectedAddress = addressController.selectedAddress.value;

      return GestureDetector(
        onTap: () {
          // الانتقال لصفحة قائمة العناوين
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddressListView(),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(16),
          decoration: checkoutBoxDecoration(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Color(0xFFff5722)),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // التسمية والاسم
                    Row(
                      children: [
                        Text(
                          selectedAddress?.label ?? 'No Address',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (selectedAddress?.isDefault ?? false) ...[
                          const Gap(8),
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
                      ],
                    ),
                    const Gap(4),
                    // الاسم الكامل
                    if (selectedAddress != null)
                      Text(
                        selectedAddress.fullName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                        ),
                      ),
                    const Gap(4),
                    // رقم الهاتف
                    if (selectedAddress != null)
                      Text(
                        selectedAddress.phoneNumber,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    const Gap(4),
                    // العنوان المختصر
                    Text(
                      selectedAddress?.fullAddress ?? 'Tap to add shipping address',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Icon(
                selectedAddress != null ? Icons.edit : Icons.add,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      );
    });
  }
}

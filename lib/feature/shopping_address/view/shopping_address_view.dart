import 'package:e_commerce_fullapp/feature/check_out/data/address_controller.dart';
import 'package:e_commerce_fullapp/feature/shopping_address/view/widgets/add_address.dart';
import 'package:e_commerce_fullapp/feature/shopping_address/view/widgets/header_shooping_address.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ShoppingAddressView extends StatelessWidget {
  const ShoppingAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final addressController = Get.find<AddressController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeaderShoppingAddress(),
            const Gap(16),
            Expanded(
              child: Obx(() {
                final addresses = addressController.addresses;

                if (addresses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off_outlined,
                          size: 80,
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                        ),
                        const Gap(16),
                        Text(
                          'No addresses yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Add your first shipping address',
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const Gap(24),
                        ElevatedButton.icon(
                          onPressed: () => AddAdressBottomSheet(context),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Add Address',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFff5722),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => const Gap(12),
                  itemBuilder: (context, index) {
                    final address = addresses[index];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.2)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ICON
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFFff5722).withOpacity(0.2)
                                      : Colors.orange.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFFff5722),
                                ),
                              ),

                              const Gap(12),

                              // TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          address.label,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: theme.textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                        const Gap(8),
                                        if (address.isDefault)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.green.shade900.withOpacity(0.3)
                                                  : Colors.green.shade100,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'Default',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDark
                                                    ? Colors.green.shade300
                                                    : Colors.green,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const Gap(4),
                                    Text(
                                      address.fullName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    const Gap(2),
                                    Text(
                                      address.phoneNumber,
                                      style: TextStyle(
                                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      '${address.streetAddress}, ${address.city}, ${address.state} ${address.postalCode}',
                                      style: TextStyle(
                                        color: isDark ? Colors.grey.shade400 : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 140,
                                height: 50,
                                child: CustomButton(
                                  text: 'Edit',
                                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                  textColor: const Color(0xFFff5722),
                                  icon: const Icon(Icons.edit, color: Color(0xFFff5722)),
                                  onPressed: () {
                                    AddAdressBottomSheet(
                                      context,
                                      addressId: address.id,
                                      label: address.label,
                                      fullName: address.fullName,
                                      phoneNumber: address.phoneNumber,
                                      fullAddress: address.streetAddress,
                                      city: address.city,
                                      state: address.state,
                                      zip: address.postalCode,
                                      isDefault: address.isDefault,
                                    );
                                  },
                                ),
                              ),
                              const Gap(10),
                              SizedBox(
                                width: 140,
                                height: 50,
                                child: CustomButton(
                                  text: 'Delete',
                                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                  textColor: Colors.red,
                                  icon: const Icon(Icons.delete_outline_outlined, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
                                        title: Text(
                                          'Delete Address',
                                          style: TextStyle(
                                            color: theme.textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                        content: Text(
                                          'Are you sure you want to delete this address?',
                                          style: TextStyle(
                                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: isDark ? Colors.grey.shade400 : Colors.grey,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              addressController.deleteAddress(address.id);
                                              Navigator.of(context).pop();
                                              Get.snackbar(
                                                'Deleted',
                                                'Address deleted successfully',
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                duration: const Duration(seconds: 2),
                                              );
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        if (addressController.addresses.isEmpty) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: () => AddAdressBottomSheet(context),
          backgroundColor: const Color(0xFFff5722),
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
    );
  }
}

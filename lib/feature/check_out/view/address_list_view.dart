import 'package:e_commerce_fullapp/feature/check_out/data/address_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/address_model.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/add_edit_address_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// صفحة قائمة العناوين
class AddressListView extends StatelessWidget {
  const AddressListView({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = Get.find<AddressController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
        actions: [
          // زر إضافة عنوان جديد
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditAddressView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final addresses = addressController.addresses;

        // إذا لم توجد عناوين
        if (addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const Gap(16),
                Text(
                  'No Addresses Yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Gap(8),
                Text(
                  'Add your first shipping address',
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
                        builder: (_) => const AddEditAddressView(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Address'),
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

        // عرض قائمة العناوين
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: addresses.length,
          separatorBuilder: (_, __) => const Gap(12),
          itemBuilder: (context, index) {
            final address = addresses[index];
            final isSelected = addressController.selectedAddress.value?.id == address.id;

            return _AddressCard(
              address: address,
              isSelected: isSelected,
              onTap: () {
                // اختيار العنوان
                addressController.selectAddress(address);
                // العودة للصفحة السابقة
                Navigator.pop(context);
              },
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditAddressView(address: address),
                  ),
                );
              },
              onDelete: () {
                _showDeleteDialog(context, address);
              },
              onSetDefault: () {
                addressController.setDefaultAddress(address.id);
              },
            );
          },
        );
      }),
      // زر عائم لإضافة عنوان جديد
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditAddressView(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  /// إظهار حوار تأكيد الحذف
  void _showDeleteDialog(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete "${address.label}" address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.find<AddressController>().deleteAddress(address.id);
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

/// بطاقة العنوان
class _AddressCard extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
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
            // صف العنوان والأيقونات
            Row(
              children: [
                // أيقونة النوع والتسمية
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForLabel(address.label),
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Gap(4),
                      Text(
                        address.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                // شارة الافتراضي
                if (address.isDefault)
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
                const Spacer(),
                // أيقونة الاختيار
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
              ],
            ),
            const Gap(12),

            // الاسم الكامل
            Text(
              address.fullName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(4),

            // رقم الهاتف
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const Gap(4),
                Text(
                  address.phoneNumber,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const Gap(8),

            // العنوان الكامل
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const Gap(4),
                Expanded(
                  child: Text(
                    address.fullAddress,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
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
                if (!address.isDefault)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSetDefault,
                      icon: const Icon(Icons.star_outline, size: 18),
                      label: const Text('Set Default'),
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

  /// الحصول على أيقونة بناءً على التسمية
  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Home':
        return Icons.home_outlined;
      case 'Work':
        return Icons.work_outline;
      default:
        return Icons.location_on_outlined;
    }
  }
}

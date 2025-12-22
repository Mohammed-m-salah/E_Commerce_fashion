import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/address_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/address_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void AddAdressBottomSheet(
  BuildContext context, {
  String? addressId,
  String? label,
  String? fullName,
  String? phoneNumber,
  String? fullAddress,
  String? city,
  String? state,
  String? zip,
  bool isDefault = false,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final addressController = Get.find<AddressController>();
  final isEditing = addressId != null;

  final TextEditingController labelController =
      TextEditingController(text: label ?? '');
  final TextEditingController fullNameController =
      TextEditingController(text: fullName ?? '');
  final TextEditingController phoneController =
      TextEditingController(text: phoneNumber ?? '');
  final TextEditingController fullAddressController =
      TextEditingController(text: fullAddress ?? '');
  final TextEditingController cityController =
      TextEditingController(text: city ?? '');
  final TextEditingController stateController =
      TextEditingController(text: state ?? '');
  final TextEditingController zipController =
      TextEditingController(text: zip ?? '');

  bool setAsDefault = isDefault;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? 'Edit Address' : 'Add New Address',
                          style: AppTextStyle.h3.copyWith(
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),

                    // Label
                    _buildTextField(
                      controller: labelController,
                      label: 'Label (e.g., Home, Office)',
                      icon: Icons.label_outline,
                      isDark: isDark,
                    ),
                    const Gap(12),

                    // Full Name
                    _buildTextField(
                      controller: fullNameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      isDark: isDark,
                    ),
                    const Gap(12),

                    // Phone Number
                    _buildTextField(
                      controller: phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isDark: isDark,
                    ),
                    const Gap(12),

                    // Street Address
                    _buildTextField(
                      controller: fullAddressController,
                      label: 'Street Address',
                      icon: Icons.home_outlined,
                      isDark: isDark,
                    ),
                    const Gap(12),

                    // City
                    _buildTextField(
                      controller: cityController,
                      label: 'City',
                      icon: Icons.location_city_outlined,
                      isDark: isDark,
                    ),
                    const Gap(12),

                    // State and ZIP
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: stateController,
                            label: 'State',
                            icon: Icons.map_outlined,
                            isDark: isDark,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: _buildTextField(
                            controller: zipController,
                            label: 'ZIP Code',
                            icon: Icons.local_post_office_outlined,
                            keyboardType: TextInputType.number,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),

                    // Set as Default Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: setAsDefault,
                          activeColor: const Color(0xFFff5722),
                          onChanged: (value) {
                            setState(() {
                              setAsDefault = value ?? false;
                            });
                          },
                        ),
                        Text(
                          'Set as default address',
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final newLabel = labelController.text.trim();
                          final newFullName = fullNameController.text.trim();
                          final newPhone = phoneController.text.trim();
                          final newAddress = fullAddressController.text.trim();
                          final newCity = cityController.text.trim();
                          final newState = stateController.text.trim();
                          final newZip = zipController.text.trim();

                          // Validation
                          if (newLabel.isEmpty ||
                              newFullName.isEmpty ||
                              newPhone.isEmpty ||
                              newAddress.isEmpty ||
                              newCity.isEmpty ||
                              newState.isEmpty ||
                              newZip.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please fill all fields',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                            );
                            return;
                          }

                          final address = Address(
                            id: addressId ?? DateTime.now().millisecondsSinceEpoch.toString(),
                            label: newLabel,
                            fullName: newFullName,
                            phoneNumber: newPhone,
                            streetAddress: newAddress,
                            city: newCity,
                            state: newState,
                            country: 'Palestine',
                            postalCode: newZip,
                            isDefault: setAsDefault,
                          );

                          if (isEditing) {
                            addressController.updateAddress(addressId!, address);
                          } else {
                            addressController.addAddress(address);
                          }

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFff5722),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isEditing ? 'Update Address' : 'Save Address',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required bool isDark,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    style: TextStyle(
      color: isDark ? Colors.white : Colors.black,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFff5722),
      ),
      filled: true,
      fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFff5722), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}

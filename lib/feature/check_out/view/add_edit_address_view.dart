import 'package:e_commerce_fullapp/feature/check_out/data/address_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/address_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// صفحة إضافة أو تعديل عنوان الشحن
class AddEditAddressView extends StatefulWidget {
  final Address? address; // إذا كان null معناها إضافة، إذا كان موجود معناها تعديل

  const AddEditAddressView({super.key, this.address});

  @override
  State<AddEditAddressView> createState() => _AddEditAddressViewState();
}

class _AddEditAddressViewState extends State<AddEditAddressView> {
  final _formKey = GlobalKey<FormState>();
  final addressController = Get.find<AddressController>();

  // Controllers للحقول
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController postalCodeController;

  String selectedLabel = 'Home'; // التسمية المحددة
  bool isDefault = false; // هل هذا العنوان افتراضي

  @override
  void initState() {
    super.initState();

    // إذا كنا في وضع التعديل، نملأ الحقول بالبيانات الموجودة
    if (widget.address != null) {
      fullNameController = TextEditingController(text: widget.address!.fullName);
      phoneController = TextEditingController(text: widget.address!.phoneNumber);
      streetController = TextEditingController(text: widget.address!.streetAddress);
      cityController = TextEditingController(text: widget.address!.city);
      stateController = TextEditingController(text: widget.address!.state);
      countryController = TextEditingController(text: widget.address!.country);
      postalCodeController = TextEditingController(text: widget.address!.postalCode);
      selectedLabel = widget.address!.label;
      isDefault = widget.address!.isDefault;
    } else {
      // في وضع الإضافة، نبدأ بحقول فارغة
      fullNameController = TextEditingController();
      phoneController = TextEditingController();
      streetController = TextEditingController();
      cityController = TextEditingController();
      stateController = TextEditingController();
      countryController = TextEditingController();
      postalCodeController = TextEditingController();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  /// حفظ العنوان
  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        label: selectedLabel,
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        streetAddress: streetController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        country: countryController.text.trim(),
        postalCode: postalCodeController.text.trim(),
        isDefault: isDefault,
      );

      if (widget.address != null) {
        // تحديث عنوان موجود
        addressController.updateAddress(widget.address!.id, address);
      } else {
        // إضافة عنوان جديد
        addressController.addAddress(address);
      }

      // العودة للصفحة السابقة
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address != null ? 'Edit Address' : 'Add New Address'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // اختيار تسمية العنوان
            Text(
              'Address Label',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              children: ['Home', 'Work', 'Other'].map((label) {
                return ChoiceChip(
                  label: Text(label),
                  selected: selectedLabel == label,
                  onSelected: (selected) {
                    setState(() {
                      selectedLabel = label;
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: selectedLabel == label ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                  ),
                );
              }).toList(),
            ),
            const Gap(20),

            // الاسم الكامل
            _buildTextField(
              controller: fullNameController,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter full name';
                }
                return null;
              },
            ),
            const Gap(16),

            // رقم الهاتف
            _buildTextField(
              controller: phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            const Gap(16),

            // عنوان الشارع
            _buildTextField(
              controller: streetController,
              label: 'Street Address',
              icon: Icons.home_outlined,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter street address';
                }
                return null;
              },
            ),
            const Gap(16),

            // المدينة
            _buildTextField(
              controller: cityController,
              label: 'City',
              icon: Icons.location_city_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter city';
                }
                return null;
              },
            ),
            const Gap(16),

            // المحافظة/الولاية
            _buildTextField(
              controller: stateController,
              label: 'State / Province',
              icon: Icons.map_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter state/province';
                }
                return null;
              },
            ),
            const Gap(16),

            // الدولة
            _buildTextField(
              controller: countryController,
              label: 'Country',
              icon: Icons.flag_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter country';
                }
                return null;
              },
            ),
            const Gap(16),

            // الرمز البريدي
            _buildTextField(
              controller: postalCodeController,
              label: 'Postal Code',
              icon: Icons.markunread_mailbox_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter postal code';
                }
                return null;
              },
            ),
            const Gap(20),

            // تعيين كعنوان افتراضي
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: const Text('Set as default address'),
                subtitle: const Text('This address will be used by default for checkout'),
                value: isDefault,
                onChanged: (value) {
                  setState(() {
                    isDefault = value ?? false;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
            const Gap(30),

            // زر الحفظ
            ElevatedButton(
              onPressed: _saveAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.address != null ? 'Update Address' : 'Save Address',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء حقل إدخال نصي
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
      ),
    );
  }
}

import 'package:e_commerce_fullapp/feature/check_out/data/payment_method_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/payment_method_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// صفحة إضافة أو تعديل طريقة الدفع
class AddEditPaymentMethodView extends StatefulWidget {
  final PaymentMethod? paymentMethod; // إذا كان null معناها إضافة، إذا كان موجود معناها تعديل

  const AddEditPaymentMethodView({super.key, this.paymentMethod});

  @override
  State<AddEditPaymentMethodView> createState() => _AddEditPaymentMethodViewState();
}

class _AddEditPaymentMethodViewState extends State<AddEditPaymentMethodView> {
  final _formKey = GlobalKey<FormState>();
  final paymentMethodController = Get.find<PaymentMethodController>();

  // Controllers للحقول
  late TextEditingController cardHolderNameController;
  late TextEditingController cardNumberController;
  late TextEditingController expiryDateController;
  late TextEditingController cvvController;

  String selectedType = 'Credit Card'; // النوع المحدد
  bool isDefault = false; // هل هذه طريقة الدفع الافتراضية

  @override
  void initState() {
    super.initState();

    // إذا كنا في وضع التعديل، نملأ الحقول بالبيانات الموجودة
    if (widget.paymentMethod != null) {
      cardHolderNameController = TextEditingController(text: widget.paymentMethod!.cardHolderName);
      cardNumberController = TextEditingController(text: widget.paymentMethod!.cardNumber);
      expiryDateController = TextEditingController(text: widget.paymentMethod!.expiryDate);
      cvvController = TextEditingController();
      selectedType = widget.paymentMethod!.type;
      isDefault = widget.paymentMethod!.isDefault;
    } else {
      // في وضع الإضافة، نبدأ بحقول فارغة
      cardHolderNameController = TextEditingController();
      cardNumberController = TextEditingController();
      expiryDateController = TextEditingController();
      cvvController = TextEditingController();
    }
  }

  @override
  void dispose() {
    cardHolderNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  /// حفظ طريقة الدفع
  void _savePaymentMethod() {
    if (_formKey.currentState!.validate()) {
      final paymentMethod = PaymentMethod(
        id: widget.paymentMethod?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: selectedType,
        cardHolderName: cardHolderNameController.text.trim(),
        cardNumber: cardNumberController.text.trim().replaceAll(' ', ''),
        expiryDate: expiryDateController.text.trim(),
        cvv: cvvController.text.trim(), // لن يتم حفظه
        isDefault: isDefault,
      );

      if (widget.paymentMethod != null) {
        // تحديث طريقة دفع موجودة
        paymentMethodController.updatePaymentMethod(widget.paymentMethod!.id, paymentMethod);
      } else {
        // إضافة طريقة دفع جديدة
        paymentMethodController.addPaymentMethod(paymentMethod);
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
        title: Text(widget.paymentMethod != null ? 'Edit Payment Method' : 'Add Payment Method'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // اختيار نوع طريقة الدفع
            Text(
              'Payment Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              children: ['Credit Card', 'Debit Card', 'PayPal', 'Cash on Delivery'].map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: selectedType == type,
                  onSelected: (selected) {
                    setState(() {
                      selectedType = type;
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: selectedType == type ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                  ),
                );
              }).toList(),
            ),
            const Gap(20),

            // إذا كان النوع Cash on Delivery، لا نحتاج لبقية الحقول
            if (selectedType == 'Cash on Delivery') ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        'Pay with cash when your order is delivered',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // اسم صاحب البطاقة
              _buildTextField(
                controller: cardHolderNameController,
                label: 'Card Holder Name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              const Gap(16),

              // رقم البطاقة
              _buildTextField(
                controller: cardNumberController,
                label: 'Card Number',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter card number';
                  }
                  final cardNumber = value.replaceAll(' ', '');
                  if (cardNumber.length < 13 || cardNumber.length > 16) {
                    return 'Invalid card number';
                  }
                  return null;
                },
              ),
              const Gap(16),

              // تاريخ الانتهاء و CVV
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: expiryDateController,
                      label: 'Expiry Date (MM/YY)',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                          return 'Invalid format';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: _buildTextField(
                      controller: cvvController,
                      label: 'CVV',
                      icon: Icons.lock_outline,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (value.length < 3) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const Gap(16),

              // ملاحظة أمان CVV
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security, size: 16, color: Colors.blue),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'CVV is not stored for security reasons',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Gap(20),

            // تعيين كطريقة دفع افتراضية
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: const Text('Set as default payment method'),
                subtitle: const Text('This payment method will be used by default for checkout'),
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
              onPressed: _savePaymentMethod,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.paymentMethod != null ? 'Update Payment Method' : 'Save Payment Method',
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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

/// Formatter لرقم البطاقة (إضافة مسافات كل 4 أرقام)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

/// Formatter لتاريخ الانتهاء (MM/YY)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    if (text.length <= 2) {
      return newValue;
    }

    final buffer = StringBuffer();
    buffer.write(text.substring(0, 2));
    buffer.write('/');
    buffer.write(text.substring(2));

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

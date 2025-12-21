import 'package:e_commerce_fullapp/feature/check_out/data/payment_method_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// المتحكم بإدارة طرق الدفع
class PaymentMethodController extends GetxController {
  final storage = GetStorage();

  // قائمة طرق الدفع
  var paymentMethods = <PaymentMethod>[].obs;

  // طريقة الدفع المحددة حالياً
  var selectedPaymentMethod = Rxn<PaymentMethod>();

  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
  }

  /// تحميل طرق الدفع من التخزين المحلي
  void loadPaymentMethods() {
    try {
      final savedPaymentMethods = storage.read('payment_methods');
      if (savedPaymentMethods != null) {
        paymentMethods.value = (savedPaymentMethods as List)
            .map((pm) => PaymentMethod.fromJson(pm))
            .toList();

        // تعيين طريقة الدفع الافتراضية كطريقة محددة
        final defaultPM = paymentMethods.firstWhere(
          (pm) => pm.isDefault,
          orElse: () => paymentMethods.isNotEmpty ? paymentMethods.first : _getDefaultPaymentMethod(),
        );
        selectedPaymentMethod.value = defaultPM;

        print('✅ تم تحميل ${paymentMethods.length} طريقة دفع');
      } else {
        // إضافة طريقة دفع افتراضية إذا لم توجد طرق دفع
        _addDefaultPaymentMethod();
      }
    } catch (e) {
      print('❌ خطأ في تحميل طرق الدفع: $e');
      _addDefaultPaymentMethod();
    }
  }

  /// حفظ طرق الدفع في التخزين المحلي
  void savePaymentMethods() {
    try {
      final paymentMethodsJson = paymentMethods.map((pm) => pm.toJson()).toList();
      storage.write('payment_methods', paymentMethodsJson);
      print('✅ تم حفظ ${paymentMethods.length} طريقة دفع');
    } catch (e) {
      print('❌ خطأ في حفظ طرق الدفع: $e');
    }
  }

  /// إضافة طريقة دفع افتراضية
  void _addDefaultPaymentMethod() {
    final defaultPM = _getDefaultPaymentMethod();
    paymentMethods.add(defaultPM);
    selectedPaymentMethod.value = defaultPM;
    savePaymentMethods();
  }

  /// الحصول على طريقة دفع افتراضية
  PaymentMethod _getDefaultPaymentMethod() {
    return PaymentMethod(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'Credit Card',
      cardHolderName: 'John Doe',
      cardNumber: '4242424242424242',
      expiryDate: '12/25',
      isDefault: true,
    );
  }

  /// إضافة طريقة دفع جديدة
  void addPaymentMethod(PaymentMethod paymentMethod) {
    // إذا كانت طريقة الدفع الجديدة افتراضية، إلغاء التعيين الافتراضي للطرق الأخرى
    if (paymentMethod.isDefault) {
      _clearDefaultPaymentMethods();
    }

    paymentMethods.add(paymentMethod);
    savePaymentMethods();

    // تعيين طريقة الدفع الجديدة كطريقة محددة
    selectedPaymentMethod.value = paymentMethod;

    Get.snackbar(
      'Success',
      'Payment method added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// تحديث طريقة دفع موجودة
  void updatePaymentMethod(String paymentMethodId, PaymentMethod updatedPaymentMethod) {
    final index = paymentMethods.indexWhere((pm) => pm.id == paymentMethodId);
    if (index != -1) {
      // إذا كانت طريقة الدفع المحدثة افتراضية، إلغاء التعيين الافتراضي للطرق الأخرى
      if (updatedPaymentMethod.isDefault) {
        _clearDefaultPaymentMethods();
      }

      paymentMethods[index] = updatedPaymentMethod;
      savePaymentMethods();

      // تحديث طريقة الدفع المحددة إذا كانت هي نفس الطريقة المحدثة
      if (selectedPaymentMethod.value?.id == paymentMethodId) {
        selectedPaymentMethod.value = updatedPaymentMethod;
      }

      Get.snackbar(
        'Success',
        'Payment method updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// حذف طريقة دفع
  void deletePaymentMethod(String paymentMethodId) {
    paymentMethods.removeWhere((pm) => pm.id == paymentMethodId);
    savePaymentMethods();

    // إذا تم حذف طريقة الدفع المحددة، اختيار طريقة أخرى
    if (selectedPaymentMethod.value?.id == paymentMethodId) {
      if (paymentMethods.isNotEmpty) {
        selectedPaymentMethod.value = paymentMethods.first;
      } else {
        selectedPaymentMethod.value = null;
        _addDefaultPaymentMethod();
      }
    }

    Get.snackbar(
      'Deleted',
      'Payment method deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// تعيين طريقة دفع كطريقة افتراضية
  void setDefaultPaymentMethod(String paymentMethodId) {
    _clearDefaultPaymentMethods();

    final index = paymentMethods.indexWhere((pm) => pm.id == paymentMethodId);
    if (index != -1) {
      paymentMethods[index] = paymentMethods[index].copyWith(isDefault: true);
      selectedPaymentMethod.value = paymentMethods[index];
      savePaymentMethods();

      Get.snackbar(
        'Success',
        'Default payment method updated',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// اختيار طريقة دفع
  void selectPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  /// إلغاء التعيين الافتراضي لجميع طرق الدفع
  void _clearDefaultPaymentMethods() {
    for (int i = 0; i < paymentMethods.length; i++) {
      if (paymentMethods[i].isDefault) {
        paymentMethods[i] = paymentMethods[i].copyWith(isDefault: false);
      }
    }
  }

  /// الحصول على طريقة الدفع الافتراضية
  PaymentMethod? get defaultPaymentMethod {
    try {
      return paymentMethods.firstWhere((pm) => pm.isDefault);
    } catch (e) {
      return paymentMethods.isNotEmpty ? paymentMethods.first : null;
    }
  }

  /// التحقق من وجود طرق دفع
  bool get hasPaymentMethods => paymentMethods.isNotEmpty;

  /// الحصول على عدد طرق الدفع
  int get paymentMethodCount => paymentMethods.length;
}

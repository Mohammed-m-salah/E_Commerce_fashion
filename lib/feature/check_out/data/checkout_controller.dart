import 'package:e_commerce_fullapp/core/services/stripe_payment_service.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/address_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/order_model.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/payment_method_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// المتحكم بعملية الشراء والدفع
class CheckoutController extends GetxController {
  final storage = GetStorage();
  final cartController = Get.find<CartController>();
  final addressController = Get.find<AddressController>();
  final paymentMethodController = Get.find<PaymentMethodController>();

  // قائمة الطلبات
  var orders = <Order>[].obs;

  // تكاليف الشحن الثابتة
  final double shippingCost = 10.0;

  // نسبة الضريبة (5%)
  final double taxRate = 0.05;

  // حالة معالجة الطلب
  var isProcessingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  /// تحميل الطلبات من التخزين المحلي
  void loadOrders() {
    try {
      final savedOrders = storage.read('orders');
      if (savedOrders != null) {
        orders.value = (savedOrders as List)
            .map((order) => Order.fromJson(order))
            .toList();
        print('✅ تم تحميل ${orders.length} طلب');
      }
    } catch (e) {
      print('❌ خطأ في تحميل الطلبات: $e');
    }
  }

  /// حفظ الطلبات في التخزين المحلي
  void saveOrders() {
    try {
      final ordersJson = orders.map((order) => order.toJson()).toList();
      storage.write('orders', ordersJson);
      print('✅ تم حفظ ${orders.length} طلب');
    } catch (e) {
      print('❌ خطأ في حفظ الطلبات: $e');
    }
  }

  /// حساب المجموع الفرعي (مجموع أسعار المنتجات فقط)
  double get subtotal {
    return cartController.totalPrice;
  }

  /// حساب قيمة الضريبة
  double get tax {
    return subtotal * taxRate;
  }

  /// حساب المجموع الكلي
  double get total {
    return subtotal + shippingCost + tax;
  }

  /// التحقق من إمكانية إتمام الطلب
  bool validateCheckout() {
    // التحقق من وجود منتجات في السلة
    if (cartController.cartItems.isEmpty) {
      Get.snackbar(
        'السلة فارغة',
        'يرجى إضافة منتجات للسلة قبل إتمام الطلب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    }

    // التحقق من وجود عنوان شحن
    if (addressController.selectedAddress.value == null) {
      Get.snackbar(
        'Shipping Address Required',
        'Please add a shipping address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    }

    // التحقق من وجود طريقة دفع
    if (paymentMethodController.selectedPaymentMethod.value == null) {
      Get.snackbar(
        'Payment Method Required',
        'Please select a payment method',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    }

    return true;
  }

  /// معالجة الدفع عبر Stripe وإنشاء الطلب
  ///
  /// هذه الدالة تقوم بـ:
  /// 1. التحقق من صحة البيانات
  /// 2. معالجة الدفع عبر Stripe
  /// 3. إنشاء الطلب بعد نجاح الدفع
  Future<Order?> processOrderWithStripe() async {
    // التحقق من صحة البيانات
    if (!validateCheckout()) {
      return null;
    }

    // بدء معالجة الطلب
    isProcessingOrder.value = true;

    try {
      print('💳 بدء معالجة الدفع عبر Stripe...');

      // حساب المبلغ بالسنتات (Stripe يستخدم السنتات)
      // مثال: $50.00 = 5000 سنت
      final amountInCents = (total * 100).toInt();

      // إنشاء وصف للطلب
      final orderId = _generateOrderId();
      final description = 'Order $orderId - ${cartController.cartItems.length} items';

      // معالجة الدفع عبر Stripe
      final paymentResult = await StripePaymentService.instance.processPayment(
        amount: amountInCents,
        currency: 'usd',
        description: description,
      );

      // إذا فشل الدفع
      if (!paymentResult['success']) {
        isProcessingOrder.value = false;

        // إذا ألغى المستخدم العملية
        if (paymentResult['cancelled'] == true) {
          Get.snackbar(
            'تم الإلغاء',
            'تم إلغاء عملية الدفع',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          return null;
        }

        // خطأ في الدفع
        Get.snackbar(
          'فشل الدفع',
          paymentResult['error'] ?? 'حدث خطأ أثناء معالجة الدفع',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return null;
      }

      print('✅ تم الدفع بنجاح عبر Stripe');
      print('   Payment Intent ID: ${paymentResult['paymentIntentId']}');

      // الحصول على العنوان المحدد
      final selectedAddress = addressController.selectedAddress.value!;
      final fullAddressString = '${selectedAddress.fullName}, ${selectedAddress.phoneNumber}, ${selectedAddress.fullAddress}';

      // الحصول على طريقة الدفع المحددة
      final selectedPaymentMethod = paymentMethodController.selectedPaymentMethod.value!;
      final paymentMethodString = '${selectedPaymentMethod.displayText} (Stripe)';

      // إنشاء الطلب
      final order = Order(
        id: orderId,
        items: List.from(cartController.cartItems),
        subtotal: subtotal,
        shipping: shippingCost,
        tax: tax,
        total: total,
        status: 'Active',
        orderDate: DateTime.now(),
        shippingAddress: fullAddressString,
        paymentMethod: paymentMethodString,
      );

      // إضافة الطلب لقائمة الطلبات
      orders.insert(0, order);
      saveOrders();

      // مسح السلة بعد إتمام الطلب
      cartController.clearCart();

      // إظهار رسالة نجاح
      Get.snackbar(
        'تم الدفع بنجاح',
        'تم إنشاء الطلب رقم: $orderId',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      isProcessingOrder.value = false;
      return order;
    } catch (e) {
      print('❌ خطأ في معالجة الدفع: $e');

      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      isProcessingOrder.value = false;
      return null;
    }
  }

  /// معالجة وإنشاء الطلب (بدون Stripe - للطرق الأخرى)
  Future<Order?> processOrder() async {
    // التحقق من صحة البيانات
    if (!validateCheckout()) {
      return null;
    }

    // بدء معالجة الطلب
    isProcessingOrder.value = true;

    try {
      // محاكاة عملية معالجة الدفع (يمكن إضافة API هنا)
      await Future.delayed(const Duration(seconds: 1));

      // إنشاء معرف فريد للطلب
      final orderId = _generateOrderId();

      // الحصول على العنوان المحدد
      final selectedAddress = addressController.selectedAddress.value!;
      final fullAddressString = '${selectedAddress.fullName}, ${selectedAddress.phoneNumber}, ${selectedAddress.fullAddress}';

      // الحصول على طريقة الدفع المحددة
      final selectedPaymentMethod = paymentMethodController.selectedPaymentMethod.value!;
      final paymentMethodString = selectedPaymentMethod.displayText;

      // إنشاء الطلب
      final order = Order(
        id: orderId,
        items: List.from(cartController.cartItems), // نسخ المنتجات من السلة
        subtotal: subtotal,
        shipping: shippingCost,
        tax: tax,
        total: total,
        status: 'Active', // حالة الطلب: نشط
        orderDate: DateTime.now(),
        shippingAddress: fullAddressString,
        paymentMethod: paymentMethodString,
      );

      // إضافة الطلب لقائمة الطلبات
      orders.insert(0, order); // إضافة في البداية
      saveOrders();

      // مسح السلة بعد إتمام الطلب
      cartController.clearCart();

      // إظهار رسالة نجاح
      Get.snackbar(
        'تم إنشاء الطلب بنجاح',
        'رقم الطلب: $orderId',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      isProcessingOrder.value = false;
      return order;
    } catch (e) {
      print('❌ خطأ في معالجة الطلب: $e');

      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء معالجة الطلب. يرجى المحاولة مرة أخرى',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      isProcessingOrder.value = false;
      return null;
    }
  }

  /// توليد معرف فريد للطلب
  String _generateOrderId() {
    final now = DateTime.now();
    final random = (now.millisecondsSinceEpoch % 10000).toString();
    return '#${now.year}${now.month}${now.day}$random';
  }

  /// تحديث حالة الطلب
  void updateOrderStatus(String orderId, String newStatus) {
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      orders[index] = orders[index].copyWith(status: newStatus);
      saveOrders();

      Get.snackbar(
        'تم تحديث الطلب',
        'تم تحديث حالة الطلب إلى: $newStatus',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// إلغاء الطلب
  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, 'Cancelled');
  }

  /// إتمام الطلب
  void completeOrder(String orderId) {
    updateOrderStatus(orderId, 'Completed');
  }

  /// الحصول على الطلبات حسب الحالة
  List<Order> getOrdersByStatus(String status) {
    return orders.where((order) => order.status == status).toList();
  }

  /// الحصول على الطلبات النشطة
  List<Order> get activeOrders => getOrdersByStatus('Active');

  /// الحصول على الطلبات المكتملة
  List<Order> get completedOrders => getOrdersByStatus('Completed');

  /// الحصول على الطلبات الملغاة
  List<Order> get cancelledOrders => getOrdersByStatus('Cancelled');
}

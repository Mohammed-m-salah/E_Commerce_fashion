import 'dart:convert';
import 'package:e_commerce_fullapp/core/config/stripe_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

/// خدمة الدفع باستخدام Stripe
///
/// هذه الخدمة تتعامل مع كل عمليات الدفع عبر Stripe:
/// 1. إنشاء Payment Intent (نية الدفع)
/// 2. عرض نموذج الدفع
/// 3. تأكيد الدفع
/// 4. معالجة النتيجة
class StripePaymentService {
  StripePaymentService._();
  static final StripePaymentService instance = StripePaymentService._();

  /// تهيئة Stripe
  /// يجب استدعاء هذه الدالة مرة واحدة عند بدء التطبيق
  Future<void> initialize() async {
    try {
      Stripe.publishableKey = StripeConfig.publishableKey;
      Stripe.merchantIdentifier = StripeConfig.merchantIdentifier;
      await Stripe.instance.applySettings();
      print('✅ Stripe initialized successfully');
    } catch (e) {
      print('❌ Error initializing Stripe: $e');
      rethrow;
    }
  }

  /// معالجة الدفع الكامل
  ///
  /// [amount] المبلغ بالسنتات (مثال: 100 = $1.00)
  /// [currency] العملة (مثال: 'usd')
  /// [description] وصف الدفعة
  /// [customerEmail] البريد الإلكتروني للعميل (اختياري)
  ///
  /// مثال:
  /// ```dart
  /// final result = await StripePaymentService.instance.processPayment(
  ///   amount: 5000, // $50.00
  ///   currency: 'usd',
  ///   description: 'Order #123456',
  /// );
  /// ```
  Future<Map<String, dynamic>> processPayment({
    required int amount,
    String currency = 'usd',
    required String description,
    String? customerEmail,
  }) async {
    try {
      print('💳 بدء معالجة الدفع...');
      print('   المبلغ: ${amount / 100} $currency');
      print('   الوصف: $description');

      // الخطوة 1: إنشاء Payment Intent
      final paymentIntent = await _createPaymentIntent(
        amount: amount,
        currency: currency,
        description: description,
        customerEmail: customerEmail,
      );

      if (paymentIntent == null) {
        return {
          'success': false,
          'error': 'فشل إنشاء نية الدفع',
        };
      }

      print('✅ تم إنشاء Payment Intent: ${paymentIntent['id']}');

      // الخطوة 2: تهيئة Payment Sheet
      await _initializePaymentSheet(
        paymentIntent: paymentIntent,
        customerEmail: customerEmail,
      );

      print('✅ تم تهيئة Payment Sheet');

      // الخطوة 3: عرض Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      print('✅ تم إكمال الدفع بنجاح');

      // الدفع ناجح
      return {
        'success': true,
        'paymentIntentId': paymentIntent['id'],
        'amount': amount,
        'currency': currency,
      };
    } on StripeException catch (e) {
      print('❌ خطأ Stripe: ${e.error.localizedMessage}');

      // المستخدم ألغى العملية
      if (e.error.code == FailureCode.Canceled) {
        return {
          'success': false,
          'error': 'تم إلغاء العملية',
          'cancelled': true,
        };
      }

      return {
        'success': false,
        'error': e.error.localizedMessage ?? 'حدث خطأ في الدفع',
      };
    } catch (e) {
      print('❌ خطأ غير متوقع: $e');
      return {
        'success': false,
        'error': 'حدث خطأ غير متوقع: ${e.toString()}',
      };
    }
  }

  /// إنشاء Payment Intent على الخادم
  ///
  /// ملاحظة مهمة:
  /// في بيئة الإنتاج، يجب إنشاء Payment Intent على الخادم (Backend)
  /// وليس في التطبيق مباشرة، لأسباب أمنية.
  ///
  /// هذا مثال تطويري فقط. في الإنتاج:
  /// 1. أنشئ API endpoint على الخادم
  /// 2. استخدم Secret Key على الخادم (ليس في التطبيق)
  /// 3. أرجع client_secret فقط للتطبيق
  Future<Map<String, dynamic>?> _createPaymentIntent({
    required int amount,
    required String currency,
    required String description,
    String? customerEmail,
  }) async {
    try {
      // البيانات المطلوبة لإنشاء Payment Intent
      final body = {
        'amount': amount.toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': description,
        if (customerEmail != null) 'receipt_email': customerEmail,
      };

      // إرسال طلب إلى Stripe API
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${StripeConfig.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('❌ فشل إنشاء Payment Intent: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ خطأ في إنشاء Payment Intent: $e');
      return null;
    }
  }

  /// تهيئة Payment Sheet
  Future<void> _initializePaymentSheet({
    required Map<String, dynamic> paymentIntent,
    String? customerEmail,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // معلومات التاجر
        merchantDisplayName: StripeConfig.merchantDisplayName,

        // Client Secret من Payment Intent
        paymentIntentClientSecret: paymentIntent['client_secret'],

        // بريد العميل (اختياري)
        customerEphemeralKeySecret: null,
        customerId: null,

        // تفعيل Google Pay (للأندرويد)
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          currencyCode: 'usd',
          testEnv: true, // false في الإنتاج
        ),

        // تفعيل Apple Pay (للـ iOS)
        applePay: PaymentSheetApplePay(
          merchantCountryCode: StripeConfig.country,
        ),

        // تخصيص المظهر
        style: ThemeMode.system,

        // السماح بحفظ بطاقات الدفع (اختياري)
        allowsDelayedPaymentMethods: true,
      ),
    );
  }

  /// إنشاء عميل Stripe (Customer)
  /// يستخدم لحفظ معلومات الدفع للاستخدام المستقبلي
  Future<String?> createCustomer({
    required String email,
    String? name,
  }) async {
    try {
      final body = {
        'email': email,
        if (name != null) 'name': name,
      };

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization': 'Bearer ${StripeConfig.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final customer = jsonDecode(response.body);
        return customer['id'];
      }
      return null;
    } catch (e) {
      print('❌ خطأ في إنشاء العميل: $e');
      return null;
    }
  }

  /// استرجاع معلومات Payment Intent
  Future<Map<String, dynamic>?> retrievePaymentIntent(
      String paymentIntentId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
        headers: {
          'Authorization': 'Bearer ${StripeConfig.secretKey}',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ خطأ في استرجاع Payment Intent: $e');
      return null;
    }
  }
}

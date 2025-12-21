import 'package:flutter_dotenv/flutter_dotenv.dart';

/// إعدادات Stripe - تحتوي على المفاتيح اللازمة للاتصال بـ Stripe
///
/// ملاحظة مهمة:
/// - يجب إضافة المفاتيح في ملف .env
/// - STRIPE_PUBLISHABLE_KEY: المفتاح العام (يستخدم في التطبيق)
/// - STRIPE_SECRET_KEY: المفتاح السري (يستخدم في الخادم فقط)
///
/// للحصول على المفاتيح:
/// 1. سجل دخول إلى https://dashboard.stripe.com
/// 2. انتقل إلى Developers -> API keys
/// 3. انسخ Publishable key و Secret key
/// 4. ضعها في ملف .env
class StripeConfig {
  /// المفتاح العام لـ Stripe (Publishable Key)
  /// يستخدم لتهيئة Stripe في التطبيق
  /// هذا المفتاح آمن للاستخدام في التطبيق لأنه عام
  static String get publishableKey {
    // في وضع الاختبار نستخدم Test Publishable Key
    // في وضع الإنتاج نستخدم Live Publishable Key
    return dotenv.env['STRIPE_PUBLISHABLE_KEY'] ??
           'pk_test_51QRxLtA6PYc6ofWVKbVmWaSMOqAkH7SiGrwHO5iNxzh1234567890'; // مفتاح تجريبي للتطوير
  }

  /// المفتاح السري لـ Stripe (Secret Key)
  /// يستخدم لإنشاء Payment Intents على الخادم
  /// تحذير: لا تشارك هذا المفتاح أبداً ولا تضعه في كود التطبيق
  /// في الإنتاج، يجب استخدام خادم خلفي (Backend) لإنشاء Payment Intents
  static String get secretKey {
    return dotenv.env['STRIPE_SECRET_KEY'] ??
           'sk_test_51QRxLtA6PYc6ofWVabcdefghijklmnop1234567890'; // مفتاح تجريبي للتطوير
  }

  /// Merchant Identifier (مطلوب لـ Apple Pay)
  static String get merchantIdentifier {
    return 'merchant.com.example.ecommerce';
  }

  /// Merchant Display Name
  static String get merchantDisplayName {
    return 'E-Commerce App';
  }

  /// عنوان URL للخادم الخلفي (Backend Server)
  /// في الإنتاج، يجب أن يكون لديك خادم يقوم بإنشاء Payment Intents
  /// هذا أكثر أماناً من إنشائها في التطبيق مباشرة
  static String get backendUrl {
    return dotenv.env['BACKEND_URL'] ?? 'http://localhost:3000';
  }

  /// العملة المستخدمة (USD = الدولار الأمريكي)
  static String get currency {
    return 'usd';
  }

  /// البلد (US = الولايات المتحدة)
  static String get country {
    return 'US';
  }
}

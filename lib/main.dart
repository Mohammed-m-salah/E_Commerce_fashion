import 'package:e_commerce_fullapp/core/config/supabase_config.dart';
import 'package:e_commerce_fullapp/core/services/local_notification_service.dart';
import 'package:e_commerce_fullapp/core/services/stripe_payment_service.dart';
import 'package:e_commerce_fullapp/core/theme/app_theme.dart';
import 'package:e_commerce_fullapp/core/theme/them_controller.dart';
import 'package:e_commerce_fullapp/feature/auth/view/sign_in_view.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/address_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/checkout_controller.dart';
import 'package:e_commerce_fullapp/feature/check_out/data/payment_method_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/category_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/banner_controller.dart';
import 'package:e_commerce_fullapp/feature/offers/data/offer_controller.dart';
import 'package:e_commerce_fullapp/feature/notification/data/notification_controller.dart';
import 'package:e_commerce_fullapp/feature/wishlist/data/wishlist_controller.dart';
import 'package:e_commerce_fullapp/firebase_options.dart';
import 'package:e_commerce_fullapp/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Local Notifications
    // تهيئة خدمة الإشعارات المحلية
    await LocalNotificationService().initialize();
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );

    // Initialize Stripe
    await StripePaymentService.instance.initialize();

    await GetStorage.init();
    Get.put(ThemeController());
    Get.put(ProductController());
    Get.put(CategoryController()); // تهيئة متحكم الفئات
    Get.put(BannerController()); // تهيئة متحكم البانرات
    Get.put(OfferController()); // تهيئة متحكم العروض
    Get.put(WishlistController());
    Get.put(CartController());
    Get.put(NotificationController()); // تهيئة متحكم الإشعارات
    Get.put(AddressController()); // تهيئة متحكم العناوين
    Get.put(PaymentMethodController()); // تهيئة متحكم طرق الدفع
    Get.put(
        CheckoutController()); // تهيئة متحكم الدفع (must be after AddressController & PaymentMethodController)
    runApp(const MyApp());
  } catch (e) {
    print('❌ Initialization Error: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text(
                    'Initialization Error',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    // Listen to auth state changes for email verification and deep links
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      // When user confirms email or completes authentication via deep link
      if (event == AuthChangeEvent.signedIn && session != null) {
        // Navigate to home screen
        Get.offAllNamed('/home');
      } else if (event == AuthChangeEvent.signedOut) {
        // Navigate to sign in screen when user signs out
        Get.offAllNamed('/signin');
      } else if (event == AuthChangeEvent.passwordRecovery) {
        // Handle password recovery deep link
        Get.snackbar(
          'Password Recovery',
          'Please enter your new password',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  // Check if user is already logged in
  String _getInitialRoute() {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        print('✅ User is logged in, navigating to /home');
        return '/home';
      } else {
        print('ℹ️ User is not logged in, navigating to /signin');
        return '/signin';
      }
    } catch (e) {
      print('❌ Error checking auth status: $e');
      return '/signin';
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(
      builder: (_) {
        return GetMaterialApp(
          title: 'E-Commerce App',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode:
              themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          defaultTransition: Transition.fade,
          initialRoute: _getInitialRoute(),
          getPages: [
            GetPage(name: '/signin', page: () => const Sigin_view()),
            GetPage(name: '/home', page: () => const Root()),
          ],
        );
      },
    );
  }
}

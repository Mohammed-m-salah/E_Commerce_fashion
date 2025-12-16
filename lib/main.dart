import 'package:e_commerce_fullapp/core/config/supabase_config.dart';
import 'package:e_commerce_fullapp/core/theme/app_theme.dart';
import 'package:e_commerce_fullapp/core/theme/them_controller.dart';
import 'package:e_commerce_fullapp/feature/auth/view/sign_in_view.dart';
import 'package:e_commerce_fullapp/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

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

  await GetStorage.init();
  Get.put(ThemeController());
  runApp(const MyApp());
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
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      // When user confirms email or completes authentication via deep link
      if (event == AuthChangeEvent.signedIn && session != null) {
        // Navigate to home screen
        Get.offAllNamed('/home');
      } else if (event == AuthChangeEvent.passwordRecovery) {
        // Handle password recovery deep link
        // You can navigate to a password reset screen here if needed
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

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeController.theme,
      defaultTransition: Transition.fade,
      initialRoute: '/signin',
      getPages: [
        GetPage(name: '/signin', page: () => const Sigin_view()),
        GetPage(name: '/home', page: () => const Root()),
      ],
    );
  }
}

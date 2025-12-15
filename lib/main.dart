import 'package:e_commerce_fullapp/core/theme/app_theme.dart';
import 'package:e_commerce_fullapp/core/theme/them_controller.dart';
import 'package:e_commerce_fullapp/feature/auth/view/sign_in_view.dart';
import 'package:e_commerce_fullapp/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await GetStorage.init();
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: Sigin_view(),
    );
  }
}

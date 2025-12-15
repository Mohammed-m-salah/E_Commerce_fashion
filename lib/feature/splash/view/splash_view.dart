import 'package:e_commerce_fullapp/feature/home/view/home_view.dart';
import 'package:e_commerce_fullapp/feature/on_boarding/view/on_boarding_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      final box = GetStorage();
      final seenOnboard = box.read('seenOnboard') ?? false;

      if (seenOnboard) {
        Get.off(() => const HomeView());
      } else {
        Get.off(() => const OnboardingView());
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
              Theme.of(context).primaryColor.withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // يجعل المحتوى بالمنتصف
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fashion',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 10),
            ),
            const Text(
              'Store',
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  // fontStyle: FontStyle.italic,
                  letterSpacing: 5),
            ),
            const Text(
              'Style Meets Simplicity',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  // fontStyle: FontStyle.italic,
                  letterSpacing: 5),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:e_commerce_fullapp/core/theme/them_controller.dart';
import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/help_center/view/help_center.dart';
import 'package:e_commerce_fullapp/feature/my_order/view/my_order_view.dart';
import 'package:e_commerce_fullapp/feature/shopping_address/view/shopping_address_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BodyProfile extends StatelessWidget {
  const BodyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ProfileItem(
            title: 'My Orders',
            icon: Icons.shopping_bag_outlined,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return MyOrderView();
              }));
            },
          ),
          ProfileItem(
            title: 'Shopping Address',
            icon: Icons.location_on_outlined,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ShoppingAddressView();
              }));
            },
          ),
          ProfileItem(
            title: 'Help Center',
            icon: Icons.help_outline_rounded,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return HelpCenter();
              }));
            },
          ),
          // Dark Mode Toggle
          GetBuilder<ThemeController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      controller.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: const Color(0xFFff5722),
                    ),
                    const Gap(20),
                    Text(
                      'Dark Mode',
                      style: AppTextStyle.bodylarge,
                    ),
                    const Spacer(),
                    Switch(
                      value: controller.isDarkMode,
                      onChanged: (value) {
                        controller.toggelTheme();
                      },
                      activeColor: const Color(0xFFff5722),
                    ),
                  ],
                ),
              );
            },
          ),
          ProfileItem(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFff5722),
            ),
            const Gap(20),
            Text(
              title,
              style: AppTextStyle.bodylarge,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

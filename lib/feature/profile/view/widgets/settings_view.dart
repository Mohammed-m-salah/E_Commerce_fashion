import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/core/theme/them_controller.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/privecy_policy_page.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/terms_of_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool pushNotifications = true;
  bool emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //header=====================
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const Gap(30),
                    Text(
                      'Settings',
                      style: AppTextStyle.h3.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              //Appearance=====================
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      'Appearance',
                      style: AppTextStyle.buttonLarge.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              // dark and light mode
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.dark_mode,
                      color: Color(0xFFff5722),
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Dark Mode',
                      style: AppTextStyle.buttonLarge.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const Spacer(),
                    GetBuilder<ThemeController>(
                      builder: (controller) => Switch(
                        value: controller.isDarkMode,
                        activeColor: const Color(0xFFff5722),
                        onChanged: (value) {
                          controller.toggelTheme();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              //Notifications=====================
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      'Notifications',
                      style: AppTextStyle.buttonLarge.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Push Notifications',
                            style: AppTextStyle.buttonLarge.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            'Receive Push Notifications',
                            style: AppTextStyle.bodymedium.copyWith(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            'about orders and promotions',
                            style: AppTextStyle.bodymedium.copyWith(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Switch(
                          value: pushNotifications,
                          activeColor: const Color(0xFFff5722),
                          onChanged: (value) {
                            setState(() {
                              pushNotifications = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Notifications',
                            style: AppTextStyle.buttonLarge.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            'Receive email updates about',
                            style: AppTextStyle.bodymedium.copyWith(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            'Your orders',
                            style: AppTextStyle.bodymedium.copyWith(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Switch(
                          value: emailNotifications,
                          activeColor: const Color(0xFFff5722),
                          onChanged: (value) {
                            setState(() {
                              emailNotifications = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Privacy=====================
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      'Privacy',
                      style: AppTextStyle.buttonLarge.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Column(
                      children: [
                        Icon(
                          Icons.privacy_tip_outlined,
                          color: Color(0xFFff5722),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacy Policy',
                            style: AppTextStyle.buttonLarge.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            'View our privacy policy',
                            style: AppTextStyle.bodymedium.copyWith(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return PrivacyPolicy();
                                  },
                                ),
                              );
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Column(
                      children: [
                        Icon(
                          Icons.file_open_outlined,
                          color: Color(0xFFff5722),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terms of Service',
                            style: AppTextStyle.buttonLarge.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            'Read our terms of service',
                            style: AppTextStyle.bodymedium.copyWith(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return TermsOfService();
                                  },
                                ),
                              );
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //About=====================
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      'About',
                      style: AppTextStyle.buttonLarge.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFFff5722),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App version',
                            style: AppTextStyle.buttonLarge.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            '1.0.0',
                            style: AppTextStyle.bodymedium.copyWith(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

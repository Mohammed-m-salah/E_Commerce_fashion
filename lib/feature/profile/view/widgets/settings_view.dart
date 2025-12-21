import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/privecy_policy_page.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/terms_of_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    child: const Icon(Icons.arrow_back_ios)),
                const Gap(30),
                Text(
                  'Settings',
                  style: AppTextStyle.h3,
                ),
              ],
            ),
          ),
          //Apperance=====================
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(
                  'Apperance',
                  style: AppTextStyle.buttonLarge,
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
                  style: AppTextStyle.buttonLarge,
                ),
                const Spacer(),
                Switch(
                  value: darkMode,
                  activeColor: const Color(0xFFff5722),
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
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
                  style: AppTextStyle.buttonLarge,
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
                        style: AppTextStyle.buttonLarge,
                      ),
                      Text(
                        'Recive Push Notifications',
                        style: AppTextStyle.bodymedium,
                      ),
                      Text(
                        'about orders and promations',
                        style: AppTextStyle.bodymedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Switch(
                      value: darkMode,
                      activeColor: const Color(0xFFff5722),
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
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
                        style: AppTextStyle.buttonLarge,
                      ),
                      Text(
                        'Recive email updates about',
                        style: AppTextStyle.bodymedium,
                      ),
                      Text(
                        'Your orders',
                        style: AppTextStyle.bodymedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Switch(
                      value: darkMode,
                      activeColor: const Color(0xFFff5722),
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          //priavcy=====================
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(
                  'priavcy',
                  style: AppTextStyle.buttonLarge,
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
                        style: AppTextStyle.buttonLarge,
                      ),
                      Text(
                        'View our privacy policy',
                        style: AppTextStyle.bodymedium,
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
                        child: const Icon(Icons.arrow_forward_ios),
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
                        'Terms of service ',
                        style: AppTextStyle.buttonLarge,
                      ),
                      Text(
                        'read our  terms of service ',
                        style: AppTextStyle.bodymedium,
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
                          child: const Icon(Icons.arrow_forward_ios)),
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
                  style: AppTextStyle.buttonLarge,
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
                        style: AppTextStyle.buttonLarge,
                      ),
                      Text(
                        '1.0.0',
                        style: AppTextStyle.bodymedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

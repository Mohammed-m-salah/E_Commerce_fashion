import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/auth/view/sign_in_view.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:e_commerce_fullapp/shared/custome_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Sigup_view extends StatefulWidget {
  const Sigup_view({super.key});

  @override
  State<Sigup_view> createState() => _Sigup_viewState();
}

class _Sigup_viewState extends State<Sigup_view> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 20),
              child: Text(
                'Creat Account',
                style: AppTextStyle.withColor(AppTextStyle.h1,
                    Theme.of(context).textTheme.bodyLarge!.color!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1, left: 20),
              child: Text(
                'Sign up to get started',
                style: AppTextStyle.withColor(AppTextStyle.bodylarge,
                    isDark ? Colors.grey[400]! : Colors.grey[600]!),
              ),
            ),
            Gap(50),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: CustomTextFormField(
                hintText: "Full name",
                prefixIcon: const Icon(Icons.person_2_outlined),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: CustomTextFormField(
                hintText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: CustomTextFormField(
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock_outlined),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: CustomTextFormField(
                hintText: "Confirm Password",
                prefixIcon: const Icon(Icons.lock_outlined),
                obscureText: true,
              ),
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButton(text: 'Sign up', onPressed: () {}),
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: AppTextStyle.withColor(AppTextStyle.buttonmedium,
                        isDark ? Colors.grey[400]! : Colors.grey[600]!),
                  ),
                  Gap(10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return Sigin_view();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: AppTextStyle.withColor(AppTextStyle.buttonmedium,
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

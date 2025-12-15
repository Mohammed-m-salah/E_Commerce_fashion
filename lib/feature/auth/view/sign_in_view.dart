import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/auth/view/reset_password.dart';
import 'package:e_commerce_fullapp/feature/auth/view/sign_up_view.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:e_commerce_fullapp/shared/custome_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Sigin_view extends StatefulWidget {
  const Sigin_view({super.key});

  @override
  State<Sigin_view> createState() => _Sigin_viewState();
}

class _Sigin_viewState extends State<Sigin_view> {
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
                'Welcome Back!',
                style: AppTextStyle.withColor(AppTextStyle.h1,
                    Theme.of(context).textTheme.bodyLarge!.color!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1, left: 20),
              child: Text(
                'Sign in to continue shopping',
                style: AppTextStyle.withColor(AppTextStyle.bodylarge,
                    isDark ? Colors.grey[400]! : Colors.grey[600]!),
              ),
            ),
            Gap(50),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
              child: CustomTextFormField(
                hintText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
              child: CustomTextFormField(
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock_outlined),
                obscureText: true,
              ),
            ),
            Gap(10),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 30,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return ResetPassword();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Forget Password',
                      style: AppTextStyle.withColor(AppTextStyle.buttonmedium,
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButton(text: 'Sign in', onPressed: () {}),
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
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
                            return Sigup_view();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Sign up',
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

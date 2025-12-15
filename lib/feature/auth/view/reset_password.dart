import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:e_commerce_fullapp/shared/custome_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 20),
              child: Text(
                'Reset Password',
                style: AppTextStyle.withColor(AppTextStyle.h1,
                    Theme.of(context).textTheme.bodyLarge!.color!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1, left: 20),
              child: Text(
                'Enter your email to reaset your password',
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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButton(text: 'Send reset link', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}

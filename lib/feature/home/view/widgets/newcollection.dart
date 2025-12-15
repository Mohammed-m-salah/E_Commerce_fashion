import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:flutter/material.dart';

class newcollection extends StatelessWidget {
  const newcollection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFFff5722),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Your\nSpecial Sale\nUp to 40%',
                      style:
                          AppTextStyle.withColor(AppTextStyle.h2, Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    color: Colors.white,
                    text: 'Shop naw ',
                    textColor: Colors.black,
                    onPressed: () {
                      // TODO: navigate to collection or sale page
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

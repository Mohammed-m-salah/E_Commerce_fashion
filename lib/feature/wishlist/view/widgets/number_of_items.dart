import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:flutter/material.dart';

class NumberOfItems extends StatelessWidget {
  const NumberOfItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xffF3F3F3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '3 Item\'s ',
                    style: AppTextStyle.h2,
                  ),
                  Text('in your WishList'),
                ],
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: SizedBox(
                width: 180,
                height: 48,
                child: CustomButton(
                  text: 'Add All To Cart',
                  onPressed: () {},
                  color: Color(0xFFff5722),
                  textColor: Colors.white,
                  borderRadius: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

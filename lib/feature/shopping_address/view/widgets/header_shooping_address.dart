import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/shopping_address/view/widgets/add_address.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderShoppingAddress extends StatelessWidget {
  const HeaderShoppingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Gap(10),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          const Gap(30),
          Text(
            'Shopping Address',
            style: AppTextStyle.h3,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              AddAdressBottomSheet(context);
            },
            child: const Icon(Icons.add_circle_outline_sharp),
          ),
        ],
      ),
    );
  }
}

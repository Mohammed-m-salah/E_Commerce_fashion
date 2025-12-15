import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderWishList extends StatelessWidget {
  const HeaderWishList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Gap(10),
          Text(
            'My WishList',
            style: AppTextStyle.h2,
          ),
          Spacer(),
          Icon(Icons.search),
          //body

          //items
        ],
      ),
    );
  }
}

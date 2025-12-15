import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderShooping extends StatelessWidget {
  const HeaderShooping({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Gap(10),
          Text(
            'SHopping',
            style: AppTextStyle.h2,
          ),
          Spacer(),
          Icon(Icons.search),
          Gap(20),
          Icon(Icons.filter_list),
        ],
      ),
    );
  }
}

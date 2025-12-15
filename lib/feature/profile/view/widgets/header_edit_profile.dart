import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderEditProfile extends StatelessWidget {
  const HeaderEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Gap(10),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          Gap(30),
          Text(
            'Edit Profile',
            style: AppTextStyle.h3,
          )
        ],
      ),
    );
  }
}

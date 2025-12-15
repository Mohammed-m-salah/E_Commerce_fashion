import 'package:e_commerce_fullapp/feature/profile/view/widgets/body_profile.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/header_profile.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/user_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //header
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HeaderProfile(),
          ),
          //user data
          UserData(),
          //body
          Gap(10),
          BodyProfile(),
        ],
      ),
    );
  }
}

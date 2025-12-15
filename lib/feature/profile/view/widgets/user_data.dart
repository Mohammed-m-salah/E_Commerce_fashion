import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/edit_profile.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserData extends StatelessWidget {
  const UserData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
      ),
      child: Column(
        children: [
          Gap(20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
            ),
          ),
          Text(
            'Mohammed salah',
            style: AppTextStyle.h2,
          ),
          Text(
            'Mohammed20mh1@gmail.com',
            style: AppTextStyle.bodymedium,
          ),
          Gap(10),
          SizedBox(
            width: 140,
            height: 50,
            child: CustomButton(
              text: 'Edit profile',
              borderRadius: 20,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return EditProfile();
                }));
              },
            ),
          )
        ],
      ),
    );
  }
}

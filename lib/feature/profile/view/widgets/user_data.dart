import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/profile/data/profile_controller.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/edit_profile.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  late final ProfileController profileController;

  @override
  void initState() {
    super.initState();
    // Use find if already exists, otherwise put new instance
    if (Get.isRegistered<ProfileController>()) {
      profileController = Get.find<ProfileController>();
    } else {
      profileController = Get.put(ProfileController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
      ),
      child: Obx(
        () => Column(
          children: [
            const Gap(20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileController.userAvatarUrl.value.isNotEmpty
                    ? NetworkImage(profileController.userAvatarUrl.value)
                    : const AssetImage('assets/images/avatar.jpg') as ImageProvider,
              ),
            ),
            Text(
              profileController.userName.value.isNotEmpty
                  ? profileController.userName.value
                  : 'User',
              style: AppTextStyle.h2,
            ),
            Text(
              profileController.userEmail.value,
              style: AppTextStyle.bodymedium,
            ),
            const Gap(10),
            SizedBox(
              width: 140,
              height: 50,
              child: CustomButton(
                text: 'Edit profile',
                borderRadius: 20,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const EditProfile();
                  }));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

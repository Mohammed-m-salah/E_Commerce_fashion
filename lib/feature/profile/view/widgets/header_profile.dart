import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Gap(10),
          Text(
            'My Account',
            style: AppTextStyle.h2,
          ),
          Spacer(),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return SettingsView();
                  }),
                );
              },
              child: Icon(Icons.settings)),
        ],
      ),
    );
  }
}

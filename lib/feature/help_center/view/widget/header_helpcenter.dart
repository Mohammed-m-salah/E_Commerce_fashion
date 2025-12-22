import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderHelpCenter extends StatelessWidget {
  const HeaderHelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Gap(10),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const Gap(30),
          Text(
            'Help Center',
            style: AppTextStyle.h3.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          )
        ],
      ),
    );
  }
}

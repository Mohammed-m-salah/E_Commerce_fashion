import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/shopping_address/view/widgets/add_address.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderShoppingAddress extends StatelessWidget {
  const HeaderShoppingAddress({super.key});

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
            'Shopping Address',
            style: AppTextStyle.h3.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              AddAdressBottomSheet(context);
            },
            child: Icon(
              Icons.add_circle_outline_sharp,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PopularQuestions extends StatelessWidget {
  const PopularQuestions({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: MediaQuery.of(context).size.width * .95,
      height: 70,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Gap(5),
          const Icon(
            Icons.fire_truck_outlined,
            color: Colors.red,
            size: 40,
          ),
          const Gap(30),
          Text(
            text,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ],
      ),
    );
  }
}

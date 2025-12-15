import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:flutter/material.dart';

class CategoriesHome extends StatefulWidget {
  const CategoriesHome({super.key});

  @override
  State<CategoriesHome> createState() => _CategoriesHomeState();
}

class _CategoriesHomeState extends State<CategoriesHome> {
  final List<String> categories = [
    'All',
    'Men',
    'Women',
    'Kids',
    'Girls',
  ];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return
        // categories (horizontal)
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            categories.length,
            (index) {
              final selected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFff5722) // active background
                        : Color(0xffF4F4F4), // inactive background
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : const Color(0xFFff5722).withOpacity(0.25),
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: AppTextStyle.withColor(
                        AppTextStyle.bodymedium,
                        selected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    'Electronics',
    'Fashion',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return Padding(
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
                  // Filter products by selected category
                  productController.filterByCategory(categories[index]);
                },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      height: 40,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFff5722) // active background
                            : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade800
                                : const Color(0xffF4F4F4)), // inactive background
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
                            selected
                                ? Colors.white
                                : (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
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

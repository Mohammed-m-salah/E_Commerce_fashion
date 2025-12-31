import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/home/data/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesHome extends StatelessWidget {
  const CategoriesHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 45,
        child: Obx(() {
          if (categoryController.isLoading.value) {
            return _buildLoadingSkeleton();
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              return Obx(() {
                final category = categoryController.categories[index];
                final isSelected =
                    categoryController.selectedIndex.value == index;

                return GestureDetector(
                  onTap: () => categoryController.selectCategory(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFff5722)
                          : (isDark
                              ? Colors.grey.shade800
                              : const Color(0xffF4F4F4)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : const Color(0xFFff5722).withOpacity(0.25),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFff5722).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        category.name,
                        style: AppTextStyle.withColor(
                          AppTextStyle.bodymedium,
                          isSelected
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          );
        }),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Category'),
          );
        },
      ),
    );
  }
}

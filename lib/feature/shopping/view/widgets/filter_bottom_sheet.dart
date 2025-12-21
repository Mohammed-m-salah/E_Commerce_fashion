import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final maxPrice = productController.getMaxPrice();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Text('Filter Products', style: AppTextStyle.h3),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    productController.resetFilters();
                    Get.back();
                  },
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset Filters',
                ),
              ],
            ),
            const Gap(20),

            // Category Filter
            Text('Category', style: AppTextStyle.buttonLarge),
            const Gap(10),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: productController.categories.map((category) {
                    final isSelected =
                        productController.selectedCategory.value == category;
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        productController.selectedCategory.value = category;
                      },
                      selectedColor: const Color(0xFFff5722).withOpacity(0.3),
                      checkmarkColor: const Color(0xFFff5722),
                    );
                  }).toList(),
                )),
            const Gap(20),

            // Price Range Filter
            Text('Price Range', style: AppTextStyle.buttonLarge),
            const Gap(10),
            Obx(() {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${productController.minPrice.value.toStringAsFixed(0)}',
                        style: AppTextStyle.bodymedium,
                      ),
                      Text(
                        '\$${productController.maxPrice.value.toStringAsFixed(0)}',
                        style: AppTextStyle.bodymedium,
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(
                      productController.minPrice.value,
                      productController.maxPrice.value,
                    ),
                    min: 0,
                    max: maxPrice,
                    divisions: 100,
                    activeColor: const Color(0xFFff5722),
                    onChanged: (RangeValues values) {
                      productController.minPrice.value = values.start;
                      productController.maxPrice.value = values.end;
                    },
                  ),
                ],
              );
            }),
            const Gap(20),

            // Rating Filter
            Text('Minimum Rating', style: AppTextStyle.buttonLarge),
            const Gap(10),
            Obx(() {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${productController.minRating.value.toStringAsFixed(1)} ⭐',
                        style: AppTextStyle.bodymedium,
                      ),
                    ],
                  ),
                  Slider(
                    value: productController.minRating.value,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    activeColor: const Color(0xFFff5722),
                    label: productController.minRating.value.toStringAsFixed(1),
                    onChanged: (value) {
                      productController.minRating.value = value;
                    },
                  ),
                ],
              );
            }),
            const Gap(20),

            // Stock Filter
            Obx(() => CheckboxListTile(
                  title: const Text('In Stock Only'),
                  value: productController.showInStockOnly.value,
                  activeColor: const Color(0xFFff5722),
                  onChanged: (value) {
                    productController.showInStockOnly.value = value ?? false;
                  },
                  contentPadding: EdgeInsets.zero,
                )),
            const Gap(20),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  productController.applyFilters();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFff5722),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

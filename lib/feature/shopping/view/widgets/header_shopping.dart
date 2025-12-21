import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:e_commerce_fullapp/feature/shopping/view/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HeaderShooping extends StatefulWidget {
  const HeaderShooping({super.key});

  @override
  State<HeaderShooping> createState() => _HeaderShoopingState();
}

class _HeaderShoopingState extends State<HeaderShooping> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  final productController = Get.find<ProductController>();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        productController.searchInShoppingPage('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isSearching
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          productController.searchInShoppingPage('');
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      productController.searchInShoppingPage(value);
                    },
                  ),
                ),
                const Gap(10),
                GestureDetector(
                  onTap: _toggleSearch,
                  child: const Icon(Icons.close),
                ),
              ],
            )
          : Row(
              children: [
                const Gap(10),
                Text(
                  'Shopping',
                  style: AppTextStyle.h2,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _toggleSearch,
                  child: const Icon(Icons.search),
                ),
                const Gap(20),
                GestureDetector(
                  onTap: () => _showFilterBottomSheet(context),
                  child: const Icon(Icons.filter_list),
                ),
              ],
            ),
    );
  }
}

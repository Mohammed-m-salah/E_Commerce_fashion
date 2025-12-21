import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/categoris.dart';
import 'package:e_commerce_fullapp/feature/shopping/view/widgets/header_shopping.dart';
import 'package:e_commerce_fullapp/feature/shopping/view/widgets/shopping_product_grid.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Shoppingview extends StatelessWidget {
  const Shoppingview({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //header with search
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: HeaderShooping(),
            ),
            //categories
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CategoriesHome(),
            ),
            const Gap(20),
            // grid products (using shoppingPageProducts)
            const ShoppingProductGrid(),
          ],
        ),
      ),
    );
  }
}

import 'package:e_commerce_fullapp/feature/home/view/widgets/categoris.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/product_grid.dart';
import 'package:e_commerce_fullapp/feature/shopping/view/widgets/header_shopping.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Shoppingview extends StatelessWidget {
  const Shoppingview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //header
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: HeaderShooping(),
            ),
            //categories
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: CategoriesHome(),
            ),
            Gap(20),
            // grid products
            ProductGrid(),
          ],
        ),
      ),
    );
  }
}

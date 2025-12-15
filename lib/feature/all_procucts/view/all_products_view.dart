import 'package:e_commerce_fullapp/feature/all_procucts/view/widgets/header_all_product.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AllProductsView extends StatefulWidget {
  const AllProductsView({super.key});

  @override
  State<AllProductsView> createState() => _AllProductsViewViewState();
}

class _AllProductsViewViewState extends State<AllProductsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //header
            HeaderAllProduct(),
            Gap(20),
            // all products
            ProductGrid(),
          ],
        ),
      ),
    );
  }
}

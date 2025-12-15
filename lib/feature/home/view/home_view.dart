import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/all_procucts/view/all_products_view.dart';
import 'package:e_commerce_fullapp/feature/cart/view/cart_view.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/categoris.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/header.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/newcollection.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/nofification_view.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/product_grid.dart';
import 'package:e_commerce_fullapp/shared/custome_searchfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Homeheader(
                onNotificationTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return NotificationView();
                  }));
                },
                onCartTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return CartView();
                  }));
                },
                userName: 'mohammed',
                avatarAssetPath: 'assets/images/avatar.jpg',
              ),
              CustomSearchField(
                onChanged: (value) => debugPrint("Searching: $value"),
                onFilterTap: () => debugPrint("Filter tapped"),
              ),
              const Gap(5),
              const CategoriesHome(),
              const Gap(16),
              const newcollection(),
              const Gap(2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Text(
                      'Popular Product',
                      style: AppTextStyle.h2,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return AllProductsView();
                        }));
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFFff5722),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              ProductGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

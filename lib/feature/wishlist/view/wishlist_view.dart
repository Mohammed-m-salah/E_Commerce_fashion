import 'package:e_commerce_fullapp/feature/wishlist/data/wishlist_controller.dart';
import 'package:e_commerce_fullapp/feature/wishlist/view/widgets/header_wishlis.dart';
import 'package:e_commerce_fullapp/feature/wishlist/view/widgets/item_wishlist.dart';
import 'package:e_commerce_fullapp/feature/wishlist/view/widgets/number_of_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListView extends StatelessWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();

    return Scaffold(
      body: Column(
        children: [
          //header
          HeaderWishList(),
          // number of items
          NumberOfItems(),
          //items wishlist

          Expanded(
            child: Obx(() {
              if (wishlistController.wishlistItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Your wishlist is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: wishlistController.wishlistItems.length,
                itemBuilder: (context, index) {
                  final product = wishlistController.wishlistItems[index];
                  return ItemWishlist(product: product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

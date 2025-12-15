import 'package:e_commerce_fullapp/feature/wishlist/view/widgets/header_wishlis.dart';
import 'package:e_commerce_fullapp/feature/wishlist/view/widgets/item_wishlist.dart';
import 'package:e_commerce_fullapp/feature/wishlist/view/widgets/number_of_items.dart';
import 'package:flutter/material.dart';

class WishListView extends StatelessWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //header
          HeaderWishList(),
          // number of items
          NumberOfItems(),
          //items wishlist

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: 1,
              itemBuilder: (context, index) {
                return ItemWishlist();
              },
            ),
          ),
        ],
      ),
    );
  }
}

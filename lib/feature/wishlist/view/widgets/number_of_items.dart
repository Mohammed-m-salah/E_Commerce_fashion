import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_controller.dart';
import 'package:e_commerce_fullapp/feature/wishlist/data/wishlist_controller.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NumberOfItems extends StatelessWidget {
  const NumberOfItems({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();

    return Obx(() {
      final itemCount = wishlistController.wishlistCount;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '$itemCount Item${itemCount != 1 ? 's' : ''}',
                      style: AppTextStyle.h2,
                    ),
                    Text(
                      'in your WishList',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 180,
                  height: 48,
                  child: Opacity(
                    opacity: itemCount > 0 ? 1.0 : 0.5,
                    child: CustomButton(
                      text: 'Add All To Cart',
                      onPressed: () {
                        if (itemCount > 0) {
                          final cartController = Get.find<CartController>();

                          // Create a copy of the wishlist items
                          final itemsToMove =
                              List.from(wishlistController.wishlistItems);

                          // Move each item to cart
                          for (var product in itemsToMove) {
                            cartController.addToCart(product);
                          }

                          // Clear wishlist after moving all items
                          wishlistController.clearWishlist();

                          Get.snackbar(
                            'Success',
                            '${itemsToMove.length} item${itemsToMove.length != 1 ? 's' : ''} moved to cart',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                          );
                        }
                      },
                      color: const Color(0xFFff5722),
                      textColor: Colors.white,
                      borderRadius: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

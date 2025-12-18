import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_model.dart';
import 'package:e_commerce_fullapp/feature/wishlist/data/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ItemWishlist extends StatelessWidget {
  final Product product;

  const ItemWishlist({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();

    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Color(0xffF4F5F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image_not_supported, color: Colors.grey);
                      },
                    )
                  : Icon(Icons.image, color: Colors.grey),
            ),
          ),
          Gap(10),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(10),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTextStyle.buttonmedium.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              // Move to Cart button
              IconButton(
                onPressed: () {
                  final cartController = Get.find<CartController>();
                  cartController.moveFromWishlistToCart(product);
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFFff5722),
                ),
              ),
              // Remove from Wishlist button
              IconButton(
                onPressed: () {
                  wishlistController.removeFromWishlist(product.id);
                },
                icon: Icon(Icons.delete_outline, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

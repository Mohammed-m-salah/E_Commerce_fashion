import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_model.dart';
import 'package:e_commerce_fullapp/feature/wishlist/data/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ItemWishlist extends StatelessWidget {
  final Product product;

  const ItemWishlist({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(0xffF4F5F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: product.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Bone.square(size: 100),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(Icons.image, size: 40, color: Colors.grey),
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
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(10),
                if (product.hasDiscount) ...[
                  Row(
                    children: [
                      Text(
                        '\$${product.displayOriginalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${product.effectivePrice.toStringAsFixed(2)}',
                        style: AppTextStyle.buttonmedium.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    '\$${product.effectivePrice.toStringAsFixed(2)}',
                    style: AppTextStyle.buttonmedium,
                  ),
                ],
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
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFFff5722),
                ),
              ),
              // Remove from Wishlist button
              IconButton(
                onPressed: () {
                  wishlistController.removeFromWishlist(product.id);
                },
                icon: Icon(Icons.delete_outline, color: Theme.of(context).iconTheme.color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

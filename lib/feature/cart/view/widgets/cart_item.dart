import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_controller.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              child: cartItem.product.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: cartItem.product.imageUrl,
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
                  cartItem.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(10),
                // Show discounted price if applicable
                if (cartItem.product.hasDiscount) ...[
                  Row(
                    children: [
                      Text(
                        '\$${cartItem.product.displayOriginalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${cartItem.product.effectivePrice.toStringAsFixed(2)}',
                        style: AppTextStyle.buttonmedium.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    '\$${cartItem.product.effectivePrice.toStringAsFixed(2)}',
                    style: AppTextStyle.buttonmedium,
                  ),
                ],
              ],
            ),
          ),

          // Delete & Quantity Controls
          Column(
            children: [
              IconButton(
                onPressed: () {
                  cartController.removeFromCart(cartItem.product.id);
                },
                icon: Icon(Icons.delete_outline),
              ),
              Container(
                height: 40,
                width: 140,
                decoration: BoxDecoration(
                  color: const Color(0xffFFEEEA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        cartController.decrementQuantity(cartItem.product.id);
                      },
                      icon: const Icon(Icons.remove, color: Color(0xffCEA5A0)),
                    ),
                    Obx(() {
                      // Find current quantity (in case it was updated)
                      final currentItem = cartController.getCartItem(cartItem.product.id);
                      final quantity = currentItem?.quantity ?? cartItem.quantity;

                      return Text(
                        '$quantity',
                        style: const TextStyle(color: Color(0xffCEA5A0)),
                      );
                    }),
                    IconButton(
                      onPressed: () {
                        cartController.incrementQuantity(cartItem.product.id);
                      },
                      icon: const Icon(Icons.add, color: Color(0xffCEA5A0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

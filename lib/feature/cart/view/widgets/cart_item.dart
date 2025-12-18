import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_controller.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
              color: Color(0xffF4F5F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: cartItem.product.imageUrl.isNotEmpty
                  ? Image.network(
                      cartItem.product.imageUrl,
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
                  cartItem.product.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(10),
                Text(
                  '\$${cartItem.product.price.toStringAsFixed(2)}',
                  style: AppTextStyle.buttonmedium,
                ),
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
                  color: Color(0xffFFEEEA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        cartController.decrementQuantity(cartItem.product.id);
                      },
                      icon: Icon(Icons.remove, color: Color(0xffCEA5A0)),
                    ),
                    Obx(() {
                      // Find current quantity (in case it was updated)
                      final currentItem = cartController.getCartItem(cartItem.product.id);
                      final quantity = currentItem?.quantity ?? cartItem.quantity;

                      return Text(
                        '$quantity',
                        style: TextStyle(color: Color(0xffCEA5A0)),
                      );
                    }),
                    IconButton(
                      onPressed: () {
                        cartController.incrementQuantity(cartItem.product.id);
                      },
                      icon: Icon(Icons.add, color: Color(0xffCEA5A0)),
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

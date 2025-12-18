import 'package:e_commerce_fullapp/feature/cart/data/cart_controller.dart';
import 'package:e_commerce_fullapp/feature/cart/view/widgets/cart_item.dart';
import 'package:e_commerce_fullapp/feature/cart/view/widgets/header_cart.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/checkout_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      body: Column(
        children: [
          // Header
          HeaderCart(),
          const Gap(20),

          // List of cart items with scroll
          Expanded(
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartController.cartItems[index];
                  return CartItemWidget(cartItem: cartItem);
                },
              );
            }),
          ),
        ],
      ),

      // Footer
      bottomNavigationBar: Obx(() {
        final itemCount = cartController.cartCount;
        final total = cartController.totalPrice;

        return Container(
          height: 150,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Total ($itemCount item${itemCount != 1 ? 's' : ''})'),
                  Spacer(),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFFff5722),
                    ),
                  ),
                ],
              ),
              const Gap(40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: itemCount > 0
                      ? () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return CheckOutView();
                          }));
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff5722),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Proceed To Checkout'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

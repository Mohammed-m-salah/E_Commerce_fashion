import 'package:e_commerce_fullapp/feature/cart/view/widgets/cart_item.dart';
import 'package:e_commerce_fullapp/feature/cart/view/widgets/header_cart.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/checkout_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          HeaderCart(),
          const Gap(20),
          // List of cart items with scroll
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: 1,
              itemBuilder: (context, index) {
                return CartItem();
              },
            ),
          ),
        ],
      ),
      // Footer
      bottomNavigationBar: Container(
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
                Text('Total (4 items)'),
                Spacer(),
                Text(
                  '\$300.00',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFFff5722)),
                ),
              ],
            ),
            const Gap(40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return CheckOutView();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFff5722),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Proceed To Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

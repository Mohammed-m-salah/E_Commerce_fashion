import 'package:e_commerce_fullapp/feature/check_out/view/widgets/box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: checkoutBoxDecoration(),
      child: Row(
        children: [
          Image.asset(
            'assets/images/mastercard.png',
            scale: 20,
          ),
          // Icon(Icons.credit_card, color: Color(0xFFff5722)),
          Gap(10),
          Text(
            'Visa **** 4242',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }
}

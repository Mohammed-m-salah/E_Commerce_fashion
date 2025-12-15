import 'package:e_commerce_fullapp/feature/check_out/view/widgets/box_decoration.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/summery_row.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: checkoutBoxDecoration(),
      child: Column(
        children: const [
          SummaryRow(title: 'Subtotal', value: '\$120.00'),
          Gap(8),
          SummaryRow(title: 'Shipping', value: '\$10.00'),
          Gap(8),
          SummaryRow(title: 'Tax', value: '\$5.00'),
          Divider(height: 20),
          SummaryRow(
            title: 'Total',
            value: '\$135.00',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

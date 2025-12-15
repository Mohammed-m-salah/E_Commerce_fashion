import 'package:e_commerce_fullapp/feature/my_order/view/widgets/Order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ActiveOrder extends StatelessWidget {
  const ActiveOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orders = [
      {
        'id': '#X501',
        'date': '05 Sep 2025',
        'total': 120.0,
        'image': 'assets/images/shoe-removebg-preview.png',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (context, index) {
        final order = orders[index];

        return OrderCard(
          orderId: order['id'],
          date: order['date'],
          image: order['image'], // 👈 الصورة

          total: order['total'],
          status: 'Active',
          statusColor: Colors.orange,
          statusBg: Colors.orange.shade100,
        );
      },
    );
  }
}

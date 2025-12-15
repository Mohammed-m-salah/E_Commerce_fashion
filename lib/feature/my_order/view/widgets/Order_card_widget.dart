import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final double total;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String image; // 👈 جديد

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.total,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // IMAGE
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(image, fit: BoxFit.contain),
          ),

          const SizedBox(width: 12),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderId,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Text('\$$total',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // STATUS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});
  final List<Map<String, dynamic>> notifications = const [
    {
      "title": "Order Confirmed",
      "body": "Your order #12321 has been confirmed and is being prepared.",
      "time": "1 hour ago",
      "icon": Icons.check_circle_outline,
      "iconColor": Colors.green,
      "bgColor": Color(0xFFE8F5E9),
    },
    {
      "title": "Order Shipped",
      "body": "Your package is on the way. Expected delivery tomorrow.",
      "time": "5 hours ago",
      "icon": Icons.local_shipping_outlined,
      "iconColor": Colors.blue,
      "bgColor": Color(0xFFE3F2FD),
    },
    {
      "title": "New Discount",
      "body": "A new 20% discount is available on selected products.",
      "time": "Yesterday",
      "icon": Icons.local_offer_outlined,
      "iconColor": Colors.orange,
      "bgColor": Color(0xFFFFF3E0),
    },
    {
      "title": "Payment Successful",
      "body": "Your payment for order #1220 was successful.",
      "time": "2 days ago",
      "icon": Icons.payment_outlined,
      "iconColor": Colors.purple,
      "bgColor": Color(0xFFF3E5F5),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Gap(10),

            // --- Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Gap(20),
                  Text('Notifications', style: AppTextStyle.h3),
                  const Spacer(),
                  Text(
                    'Mark All as read',
                    style: AppTextStyle.bodylarge.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(20),

            // --- Notifications List ---
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, index) {
                  final item = notifications[index];

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ICON
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: item["bgColor"],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            item["icon"],
                            color: item["iconColor"],
                          ),
                        ),

                        const Gap(16),

                        // TEXT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"]!,
                                style: AppTextStyle.h2.copyWith(fontSize: 16),
                              ),
                              const Gap(4),
                              Text(
                                item["body"]!,
                                style: AppTextStyle.bodylarge.copyWith(
                                  color: Colors.black87,
                                ),
                              ),
                              const Gap(6),
                              Text(
                                item["time"]!,
                                style: AppTextStyle.bodylarge.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

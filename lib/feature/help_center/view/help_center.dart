import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/help_center/view/widget/header_helpcenter.dart';
import 'package:e_commerce_fullapp/feature/help_center/view/widget/popular_qusetions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridItems = [
      {'icon': Icons.help_outline, 'text': 'FAQ'},
      {'icon': Icons.payment_outlined, 'text': 'Payment'},
      {'icon': Icons.local_shipping_outlined, 'text': 'Shipping'},
      {'icon': Icons.person_outline, 'text': 'Profile'},
    ];

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeaderHelpCenter(),
            const Gap(20),

            // Popular Questions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text('Popular Questions', style: AppTextStyle.h4),
                ],
              ),
            ),
            const Gap(10),
            const PopularQuestions(text: 'How to track my order?'),
            const Gap(10),
            const PopularQuestions(text: 'How to return item?'),
            const Gap(20),

            // Help Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text('Help Categories', style: AppTextStyle.h4),
                ],
              ),
            ),
            const Gap(10),

            // GridView with fixed height
            SizedBox(
              height:
                  screenHeight * 0.4, // رفع الارتفاع قليلاً لتناسب كل العناصر
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: gridItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.4, // مربعات مثالية
                ),
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              const Color(0xFFff5722).withOpacity(0.1),
                          child: Icon(
                            item['icon'],
                            size: 28,
                            color: const Color(0xFFff5722),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['text'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // Bottom help section
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.headphones_outlined, size: 28),
                  Gap(4),
                  Text(
                    'Still need help?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Contact our support team'),
                ],
              ),
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}

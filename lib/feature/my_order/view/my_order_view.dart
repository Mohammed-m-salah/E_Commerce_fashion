import 'package:e_commerce_fullapp/feature/my_order/view/widgets/active_order.dart';
import 'package:e_commerce_fullapp/feature/my_order/view/widgets/cancelld_order.dart';
import 'package:e_commerce_fullapp/feature/my_order/view/widgets/completed_order.dart';
import 'package:e_commerce_fullapp/feature/my_order/view/widgets/header_order.dart';
import 'package:flutter/material.dart';

class MyOrderView extends StatelessWidget {
  const MyOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            // HEADER
            const HeaderOrder(),

            const SizedBox(height: 8),

            // TAB BAR (بدون Container)
            const TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Color(0xFFff5722),
                  width: 3,
                ),
                insets: EdgeInsets.symmetric(horizontal: 32),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Color(0xFFff5722),
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              tabs: [
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),

            const SizedBox(height: 12),

            // TAB BAR VIEW
            const Expanded(
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  ActiveOrder(),
                  CompletedOrder(),
                  CancelledOrder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

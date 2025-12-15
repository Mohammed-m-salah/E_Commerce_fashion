import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/bottom_bar.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/order_summery.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/payment_method.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/selection_tile.dart';
import 'package:e_commerce_fullapp/feature/check_out/view/widgets/shooping_address.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CheckOutView extends StatelessWidget {
  const CheckOutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CheckoutBottomBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const Gap(20),
                  Text('Checkout', style: AppTextStyle.h3),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    SectionTitle(title: 'Shipping Address'),
                    AddressCard(),
                    Gap(20),
                    SectionTitle(title: 'Payment Method'),
                    PaymentCard(),
                    Gap(20),
                    SectionTitle(title: 'Order Summary'),
                    OrderSummary(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

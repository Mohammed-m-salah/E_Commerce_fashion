import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/product_details/view/widgets/header_product_details.dart';
import 'package:e_commerce_fullapp/feature/product_details/view/widgets/list_size.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              HeaderProductDetails(),
              const Gap(30),

              // Product Image
              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  color: Color(0xffF0F0F0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Image.asset(
                    'assets/images/shoe-removebg-preview.png',
                    scale: .1,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const Gap(10),

              // Title & Price
              Row(
                children: [
                  Text('Shoes', style: AppTextStyle.h2),
                  Spacer(),
                  Text(' \$69.00', style: AppTextStyle.h2),
                ],
              ),

              const Gap(5),

              // Category
              Text('Foatwear', style: AppTextStyle.bodylarge),

              const Gap(10),

              // Size selection
              Text(
                'Select Size',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Gap(5),
              ListSize(),

              const Gap(10),

              // Description
              Text('Description', style: AppTextStyle.buttonLarge),
              const Gap(5),
              Text('This is description of product one'),

              const Gap(100),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      borderColor: Colors.black,
                      color: Colors.white,
                      textColor: Colors.black,
                      text: 'Add To Cart',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      borderRadius: 10,
                      color: Color(0xFFff5722),
                      textColor: Colors.white,
                      text: 'Buy Now',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

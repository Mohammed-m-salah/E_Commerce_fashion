import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ItemWishlist extends StatefulWidget {
  const ItemWishlist({super.key});

  @override
  State<ItemWishlist> createState() => _ItemWishlistState();
}

class _ItemWishlistState extends State<ItemWishlist> {
  List<Map<String, dynamic>> itemWishlist = [
    {
      'name': 'Jorden shoes',
      'price': 200.0,
      'image': 'assets/images/shoe-removebg-preview.png'
    },
    {
      'name': 'Watch',
      'price': 200.0,
      'image': 'assets/images/shoe-removebg-preview.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemWishlist.length,
      padding: EdgeInsets.all(12),
      itemBuilder: (context, index) {
        var item = itemWishlist[index];

        return Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade500,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xffF4F5F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(item['image'], fit: BoxFit.contain),
              ),
              Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: TextStyle(color: Colors.white)),
                    Gap(10),
                    Text(
                      '\$${item['price'].toStringAsFixed(2)}',
                      style: AppTextStyle.buttonmedium
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFFff5722),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // itemWishlist.removeAt(index);
                      });
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

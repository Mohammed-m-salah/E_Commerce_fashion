import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  List<Map<String, dynamic>> cartItemslist = [
    {
      'name': 'Watch',
      'price': 200.0,
      'quantity': 1,
      'image': 'assets/images/shoe-removebg-preview.png'
    },
    {
      'name': 'Watch',
      'price': 200.0,
      'quantity': 1,
      'image': 'assets/images/shoe-removebg-preview.png'
    },
    {
      'name': 'Watch',
      'price': 200.0,
      'quantity': 1,
      'image': 'assets/images/shoe-removebg-preview.png'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // مهم حتى لا يحاول ListView أخذ كل المساحة
      physics:
          NeverScrollableScrollPhysics(), // يمنع التمرير داخلي لأن ListView ستبقى داخل ScrollView
      itemCount: cartItemslist.length,
      padding: EdgeInsets.all(12),
      itemBuilder: (context, index) {
        var item = cartItemslist[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // صورة المنتج
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
              // اسم وسعر المنتج
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name']),
                    Gap(10),
                    Text(
                      ' \$${item['price'].toStringAsFixed(2)}',
                      style: AppTextStyle.buttonmedium,
                    ),
                  ],
                ),
              ),
              // زر الحذف والكمية
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // cartItemslist.removeAt(index);
                      });
                    },
                    icon: Icon(Icons.delete_outline),
                  ),
                  Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Color(0xffFFEEEA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (item['quantity'] > 1) item['quantity']--;
                            });
                          },
                          icon: Icon(Icons.remove, color: Color(0xffCEA5A0)),
                        ),
                        Text(
                          '${item['quantity']}',
                          style: TextStyle(color: Color(0xffCEA5A0)),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              item['quantity']++;
                            });
                          },
                          icon: Icon(Icons.add, color: Color(0xffCEA5A0)),
                        ),
                      ],
                    ),
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

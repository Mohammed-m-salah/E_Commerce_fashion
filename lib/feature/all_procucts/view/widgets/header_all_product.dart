import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:e_commerce_fullapp/shared/custome_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderAllProduct extends StatelessWidget {
  const HeaderAllProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Gap(10),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
          Gap(50),
          Text(
            'All Products',
            style: AppTextStyle.h3,
          ),
          Spacer(),
          Icon(Icons.search),
          Gap(30),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  TextEditingController minPriceController =
                      TextEditingController();
                  TextEditingController maxPriceController =
                      TextEditingController();

                  // قائمة الفئات 5 عناصر
                  List<Map<String, dynamic>> categories = [
                    {'name': 'All', 'active': true},
                    {'name': 'Shoes', 'active': false},
                    {'name': 'Clothes', 'active': false},
                    {'name': 'Bags', 'active': false},
                    {'name': 'Watches', 'active': false},
                  ];

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Filter Products',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.close))
                                ],
                              ),
                              const Gap(20),

                              // Price TextFields
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                        hintText: 'mix price',
                                        controller: minPriceController),
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: CustomTextField(
                                        hintText: 'max price',
                                        controller: maxPriceController),
                                  ),
                                ],
                              ),
                              const Gap(20),

                              Text(
                                'Categories',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Gap(10),

                              // Buttons in 2 rows using Wrap with fixed spacing
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: categories.map((category) {
                                  bool isActive = category['active'];
                                  return SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            60) /
                                        3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isActive
                                            ? Color(0xFFff5722)
                                            : Colors.grey[200],
                                        foregroundColor: isActive
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          category['active'] =
                                              !category['active'];
                                        });
                                      },
                                      child: Text(category['name']),
                                    ),
                                  );
                                }).toList(),
                              ),

                              const Gap(20),

                              // Apply button
                              CustomButton(
                                  textColor: Colors.white,
                                  color: Color(0xFFff5722),
                                  text: 'Applay Changes',
                                  onPressed: () {
                                    //make change when filtering
                                  }),

                              const Gap(20),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Icon(Icons.filter_list_sharp),
          ),
        ],
      ),
    );
  }
}

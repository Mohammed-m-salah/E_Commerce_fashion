import 'package:e_commerce_fullapp/feature/shopping_address/view/widgets/add_address.dart';
import 'package:e_commerce_fullapp/feature/shopping_address/view/widgets/header_shooping_address.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ShoppingAddressView extends StatelessWidget {
  const ShoppingAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> addresses = [
      {
        'title': 'Home',
        'address': 'Gaza, Al-Rimal Street, Building 12',
        'isDefault': true,
      },
      {
        'title': 'Work',
        'address': 'Gaza, Industrial Area, Office 4',
        'isDefault': false,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeaderShoppingAddress(),
            const Gap(16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: addresses.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, index) {
                  final item = addresses[index];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ICON
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFFff5722),
                              ),
                            ),

                            const Gap(12),

                            // TEXT
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Gap(8),
                                      if (item['isDefault'])
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade100,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'Default',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const Gap(6),
                                  Text(
                                    item['address'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 50,
                              child: CustomButton(
                                text: 'Edit',
                                color: Colors.grey.shade100,
                                textColor: const Color(0xFFff5722),
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  AddAdressBottomSheet(
                                    context,
                                    label: item['title'],
                                    fullAddress: item['address'],
                                    city: 'Gaza',
                                    state: 'Al-Rimal',
                                    zip: '12345',
                                  );
                                },
                              ),
                            ),
                            Gap(10),
                            SizedBox(
                                width: 140,
                                height: 50,
                                child: CustomButton(
                                  text: 'Delete',
                                  color: Colors.grey.shade100,
                                  textColor: const Color(0xFFff5722),
                                  icon:
                                      const Icon(Icons.delete_outline_outlined),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Item'),
                                        content: const Text(
                                            'Are you sure you want to delete this item?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )),
                          ],
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

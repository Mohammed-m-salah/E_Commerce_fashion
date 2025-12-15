import 'package:e_commerce_fullapp/feature/check_out/view/widgets/box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: checkoutBoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on, color: Color(0xFFff5722)),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
                Gap(4),
                Text('Gaza, Palestine'),
                Text('Street 10, Building 5'),
              ],
            ),
          ),
          const Icon(Icons.edit, size: 20),
        ],
      ),
    );
  }
}

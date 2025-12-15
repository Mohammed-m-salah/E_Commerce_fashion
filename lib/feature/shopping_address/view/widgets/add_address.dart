import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void AddAdressBottomSheet(
  BuildContext context, {
  String? label,
  String? fullAddress,
  String? city,
  String? state,
  String? zip,
}) {
  final TextEditingController labelController =
      TextEditingController(text: label ?? '');
  final TextEditingController fullAddressController =
      TextEditingController(text: fullAddress ?? '');
  final TextEditingController cityController =
      TextEditingController(text: city ?? '');
  final TextEditingController stateController =
      TextEditingController(text: state ?? '');
  final TextEditingController zipController =
      TextEditingController(text: zip ?? '');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label == null ? 'Add New Address' : 'Edit Address',
                style: AppTextStyle.h3,
              ),
              const Gap(16),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: 'Label (e.g., Home, Office)',
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const Gap(8),
              TextField(
                controller: fullAddressController,
                decoration: const InputDecoration(
                  labelText: 'Full Address',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
              ),
              const Gap(8),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: TextField(
                      controller: zipController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code',
                        prefixIcon: Icon(Icons.local_post_office_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final newLabel = labelController.text.trim();
                    final newAddress = fullAddressController.text.trim();
                    final newCity = cityController.text.trim();
                    final newState = stateController.text.trim();
                    final newZip = zipController.text.trim();

                    if (newLabel.isNotEmpty &&
                        newAddress.isNotEmpty &&
                        newCity.isNotEmpty &&
                        newState.isNotEmpty &&
                        newZip.isNotEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Address "$newLabel" has been updated successfully!'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFff5722),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

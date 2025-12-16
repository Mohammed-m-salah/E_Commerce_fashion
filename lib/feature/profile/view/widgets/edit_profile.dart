import 'dart:io';
import 'package:e_commerce_fullapp/feature/profile/data/profile_controller.dart';
import 'package:e_commerce_fullapp/feature/profile/view/widgets/header_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final ProfileController profileController;

  @override
  void initState() {
    super.initState();
    // Use find if already exists, otherwise put new instance
    if (Get.isRegistered<ProfileController>()) {
      profileController = Get.find<ProfileController>();
    } else {
      profileController = Get.put(ProfileController());
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                profileController.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                profileController.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => profileController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const HeaderEditProfile(),
                        const Gap(30),

                        // Circle Avatar
                        GetBuilder<ProfileController>(
                          builder: (controller) {
                            ImageProvider backgroundImage;

                            if (controller.profileImage != null) {
                              backgroundImage = FileImage(controller.profileImage!);
                            } else if (controller.userAvatarUrl.value.isNotEmpty) {
                              backgroundImage = NetworkImage(controller.userAvatarUrl.value);
                            } else {
                              backgroundImage = const AssetImage('assets/images/avatar.jpg');
                            }

                            return GestureDetector(
                              onTap: _showImagePickerOptions,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: backgroundImage,
                                child: controller.profileImage == null &&
                                        controller.userAvatarUrl.value.isEmpty
                                    ? const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 30,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Name TextField
                        TextField(
                          controller: profileController.nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Email TextField (Read-only)
                        TextField(
                          controller: profileController.emailController,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                            helperText: 'Email cannot be changed',
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Phone TextField
                        TextField(
                          controller: profileController.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            prefixIcon: Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const Gap(30),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              await profileController.updateProfile();
                              if (!profileController.isLoading.value) {
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFff5722),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

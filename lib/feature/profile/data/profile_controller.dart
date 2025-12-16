import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userAvatarUrl = ''.obs;

  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  File? profileImage;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // Load user profile data
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;
      if (user == null) {
        Get.snackbar(
          'Error',
          'No user logged in',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Get user metadata
      userName.value = user.userMetadata?['full_name'] ?? '';
      userEmail.value = user.email ?? '';
      userPhone.value = user.userMetadata?['phone'] ?? '';
      userAvatarUrl.value = user.userMetadata?['avatar_url'] ?? '';

      // Update text controllers
      nameController.text = userName.value;
      emailController.text = userEmail.value;
      phoneController.text = userPhone.value;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        update(); // Notify listeners
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Upload profile image to Supabase Storage
  Future<String?> uploadProfileImage() async {
    if (profileImage == null) return null;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final fileName = 'profile_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'avatars/$fileName';

      // Upload to Supabase Storage
      await supabase.storage.from('profiles').upload(
            filePath,
            profileImage!,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      // Get public URL
      final imageUrl = supabase.storage.from('profiles').getPublicUrl(filePath);

      return imageUrl;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Update user profile
  Future<void> updateProfile() async {
    if (!_validateProfile()) return;

    try {
      isLoading.value = true;

      String? avatarUrl = userAvatarUrl.value;

      // Upload new image if selected
      if (profileImage != null) {
        final uploadedUrl = await uploadProfileImage();
        if (uploadedUrl != null) {
          avatarUrl = uploadedUrl;
        }
      }

      // Update user metadata
      final updates = {
        'full_name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        if (avatarUrl.isNotEmpty) 'avatar_url': avatarUrl,
      };

      await supabase.auth.updateUser(
        UserAttributes(
          data: updates,
        ),
      );

      // Update local values
      userName.value = nameController.text.trim();
      userPhone.value = phoneController.text.trim();
      if (avatarUrl != null) userAvatarUrl.value = avatarUrl;

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Reload profile to ensure sync
      await loadUserProfile();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validate profile data
  bool _validateProfile() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Email cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

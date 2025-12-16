import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Sign up with email and password
  Future<void> signUp() async {
    if (!_validateSignUp()) return;

    try {
      isLoading.value = true;

      // Check if email already exists by attempting to sign in
      final emailExists = await _checkEmailExists(emailController.text.trim());

      if (emailExists) {
        Get.snackbar(
          'Error',
          'This email is already registered. Please use a different email or sign in.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        isLoading.value = false;
        return;
      }

      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        data: {
          'full_name': nameController.text.trim(),
        },
      );

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Account created! Please check your email to verify your account.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        _clearControllers();
      }
    } on AuthException catch (e) {
      // Check for duplicate email error
      String errorMessage = e.message;

      if (e.message.toLowerCase().contains('already registered') ||
          e.message.toLowerCase().contains('user already registered') ||
          e.message.toLowerCase().contains('email address already in use')) {
        errorMessage = 'This email is already registered. Please use a different email or sign in.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Check if email already exists
  Future<bool> _checkEmailExists(String email) async {
    try {
      // Try to initiate password reset - this only works if email exists
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.ecommerce://reset-password',
      );
      // If no error, email exists
      return true;
    } on AuthException catch (e) {
      // Check various error messages
      if (e.message.toLowerCase().contains('not found') ||
          e.message.toLowerCase().contains('invalid') ||
          e.message.toLowerCase().contains('no user') ||
          e.message.toLowerCase().contains('user not found')) {
        return false;
      }
      // For any other error, assume email might exist to be safe
      return true;
    } catch (e) {
      // On any error, assume email exists to prevent duplicates
      return true;
    }
  }

  // Sign in with email and password
  Future<void> signIn() async {
    if (!_validateSignIn()) return;

    try {
      isLoading.value = true;

      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Welcome back!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        _clearControllers();
        // Navigate to home or main screen
        Get.offAllNamed('/home'); // Make sure to define this route
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Reset password
  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(),
        redirectTo: 'io.supabase.ecommerce://reset-password',
      );

      Get.snackbar(
        'Success',
        'Password reset link sent to your email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      _clearControllers();
      Get.back(); // Navigate back to sign in
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      Get.offAllNamed('/signin'); // Navigate to sign in page
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get current user
  User? get currentUser => supabase.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Validation methods
  bool _validateSignUp() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  bool _validateSignIn() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
  }
}

import 'package:e_commerce_fullapp/feature/cart/data/cart_item_model.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_model.dart';
import 'package:e_commerce_fullapp/feature/wishlist/data/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController {
  final storage = GetStorage();
  var cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  // Load cart from storage
  void loadCart() {
    try {
      final savedCart = storage.read('cart');
      if (savedCart != null) {
        cartItems.value = (savedCart as List)
            .map((item) => CartItem.fromJson(item))
            .toList();
        print('✅ Loaded ${cartItems.length} items from cart');
      }
    } catch (e) {
      print('❌ Error loading cart: $e');
    }
  }

  // Save cart to storage
  void saveCart() {
    try {
      final cartJson = cartItems.map((item) => item.toJson()).toList();
      storage.write('cart', cartJson);
      print('✅ Saved ${cartItems.length} items to cart');
    } catch (e) {
      print('❌ Error saving cart: $e');
    }
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return cartItems.any((item) => item.product.id == productId);
  }

  // Get cart item by product ID
  CartItem? getCartItem(String productId) {
    try {
      return cartItems.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Move product from wishlist to cart
  void moveFromWishlistToCart(Product product, {int quantity = 1}) {
    addToCart(product, quantity: quantity);

    // Remove from wishlist after adding to cart
    try {
      final wishlistController = Get.find<WishlistController>();
      wishlistController.removeFromWishlist(product.id);
    } catch (e) {
      print('❌ Error accessing WishlistController: $e');
    }
  }

  // Add product to cart
  void addToCart(Product product, {int quantity = 1}) {
    // Validate stock
    if (product.stock < 1) {
      Get.snackbar(
        'Out of Stock',
        '${product.name} is currently unavailable',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final existingItem = getCartItem(product.id);

    if (existingItem != null) {
      // Check if we can add more
      final newQuantity = existingItem.quantity + quantity;
      if (newQuantity > product.stock) {
        Get.snackbar(
          'Stock Limit',
          'Only ${product.stock} units available',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      updateQuantity(product.id, newQuantity);
    } else {
      // Validate initial quantity
      if (quantity > product.stock) {
        Get.snackbar(
          'Stock Limit',
          'Only ${product.stock} units available',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      cartItems.add(CartItem(product: product, quantity: quantity));
      saveCart();
      Get.snackbar(
        'Added to Cart',
        '${product.name} has been added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Remove product from cart
  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    saveCart();
    Get.snackbar(
      'Removed from Cart',
      'Product has been removed from your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Update quantity of cart item
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(quantity: newQuantity);
      saveCart();
    }
  }

  // Increment quantity
  void incrementQuantity(String productId) {
    final item = getCartItem(productId);
    if (item != null) {
      // Check stock limit
      if (item.quantity >= item.product.stock) {
        Get.snackbar(
          'Stock Limit',
          'Maximum quantity (${item.product.stock}) reached',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      updateQuantity(productId, item.quantity + 1);
    }
  }

  // Decrement quantity
  void decrementQuantity(String productId) {
    final item = getCartItem(productId);
    if (item != null) {
      updateQuantity(productId, item.quantity - 1);
    }
  }

  // Clear all cart items
  void clearCart() {
    cartItems.clear();
    saveCart();
    Get.snackbar(
      'Cart Cleared',
      'All items have been removed from your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Get total number of items in cart (sum of quantities)
  int get cartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Get total price of all items in cart
  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Get number of unique products in cart
  int get uniqueItemCount => cartItems.length;
}

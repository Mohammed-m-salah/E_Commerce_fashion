import 'package:e_commerce_fullapp/feature/home/data/product_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WishlistController extends GetxController {
  final storage = GetStorage();
  var wishlistItems = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  // Load wishlist from storage
  void loadWishlist() {
    try {
      final savedWishlist = storage.read('wishlist');
      if (savedWishlist != null) {
        wishlistItems.value = (savedWishlist as List)
            .map((item) => Product.fromJson(item))
            .toList();
        print('✅ Loaded ${wishlistItems.length} items from wishlist');
      }
    } catch (e) {
      print('❌ Error loading wishlist: $e');
    }
  }

  // Save wishlist to storage
  void saveWishlist() {
    try {
      final wishlistJson = wishlistItems.map((item) => item.toJson()).toList();
      storage.write('wishlist', wishlistJson);
      print('✅ Saved ${wishlistItems.length} items to wishlist');
    } catch (e) {
      print('❌ Error saving wishlist: $e');
    }
  }

  // Check if product is in wishlist
  bool isInWishlist(String productId) {
    return wishlistItems.any((item) => item.id == productId);
  }

  // Add product to wishlist
  void addToWishlist(Product product) {
    if (!isInWishlist(product.id)) {
      wishlistItems.add(product);
      saveWishlist();
      Get.snackbar(
        'Added to Wishlist',
        '${product.name} has been added to your wishlist',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Remove product from wishlist
  void removeFromWishlist(String productId) {
    wishlistItems.removeWhere((item) => item.id == productId);
    saveWishlist();
    Get.snackbar(
      'Removed from Wishlist',
      'Product has been removed from your wishlist',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Toggle wishlist status
  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      addToWishlist(product);
    }
  }

  // Clear all wishlist items
  void clearWishlist() {
    wishlistItems.clear();
    saveWishlist();
    Get.snackbar(
      'Wishlist Cleared',
      'All items have been removed from your wishlist',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Get wishlist count
  int get wishlistCount => wishlistItems.length;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_model.dart';

class ProductController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs; // For home page (category filter only)
  var shoppingPageProducts = <Product>[].obs; // For shopping page (advanced filters)
  var categories = <String>['All'].obs;

  // Filter options (for shopping page only)
  var selectedCategory = 'All'.obs;
  var minPrice = 0.0.obs;
  var maxPrice = 1000.0.obs;
  var minRating = 0.0.obs;
  var showInStockOnly = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
  }

  // Fetch all products from Supabase
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('products')
          .select()
          .order('created_at', ascending: false);

      products.value = (response as List)
          .map((json) => Product.fromJson(json))
          .toList();

      filteredProducts.value = products;
      shoppingPageProducts.value = products; // Initialize shopping page products

      // Initialize max price based on actual products
      if (products.isNotEmpty) {
        final actualMaxPrice = getMaxPrice();
        maxPrice.value = actualMaxPrice;
      }

      print('✅ Loaded ${products.length} products');
    } catch (e) {
      print('❌ Error fetching products: $e');
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch unique categories from products
  Future<void> fetchCategories() async {
    try {
      final response = await supabase
          .from('products')
          .select('category')
          .order('category');

      if (response != null) {
        final uniqueCategories = <String>{'All'};
        for (var item in response as List) {
          if (item['category'] != null && item['category'].toString().isNotEmpty) {
            uniqueCategories.add(item['category'].toString());
          }
        }
        categories.value = uniqueCategories.toList();
        print('✅ Loaded ${categories.length} categories: ${categories.join(", ")}');
      }
    } catch (e) {
      print('❌ Error fetching categories: $e');
    }
  }

  // Filter products by category (for home page only)
  void filterByCategory(String category) {
    if (category.isEmpty || category == 'All') {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products
          .where((product) => product.category == category)
          .toList();
    }
  }

  // Search products in shopping page
  void searchInShoppingPage(String query) {
    searchQuery.value = query;
    applyShoppingFilters();
  }

  // Search products (deprecated - use searchInShoppingPage instead)
  void searchProducts(String query) {
    searchInShoppingPage(query);
  }

  // Advanced filter with multiple criteria (for shopping page only)
  void applyFilters() {
    applyShoppingFilters();
  }

  // Apply all filters to shopping page
  void applyShoppingFilters() {
    shoppingPageProducts.value = products.where((product) {
      // Search filter
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final matchesSearch = product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
        if (!matchesSearch) return false;
      }

      // Category filter
      if (selectedCategory.value != 'All' &&
          product.category != selectedCategory.value) {
        return false;
      }

      // Price range filter
      if (product.price < minPrice.value || product.price > maxPrice.value) {
        return false;
      }

      // Rating filter
      if (product.rating < minRating.value) {
        return false;
      }

      // Stock filter
      if (showInStockOnly.value && product.stock <= 0) {
        return false;
      }

      return true;
    }).toList();

    print('✅ Filtered shopping page to ${shoppingPageProducts.length} products');
  }

  // Reset all filters
  void resetFilters() {
    selectedCategory.value = 'All';
    minPrice.value = 0.0;
    maxPrice.value = getMaxPrice();
    minRating.value = 0.0;
    showInStockOnly.value = false;
    searchQuery.value = '';
    shoppingPageProducts.value = products;
  }

  // Get max price from products for slider
  double getMaxPrice() {
    if (products.isEmpty) return 1000.0;
    final max = products.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    return max + 10; // Add small buffer
  }

  // Get product by ID
  Product? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await fetchProducts();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_model.dart';

class ProductController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var categories = <String>['All'].obs;

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

  // Filter products by category
  void filterByCategory(String category) {
    if (category.isEmpty || category == 'All') {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products
          .where((product) => product.category == category)
          .toList();
    }
  }

  // Search products
  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
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

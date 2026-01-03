import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'category_model.dart';
import 'product_controller.dart';

class CategoryController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;

  var categories = <Category>[].obs;

  var selectedCategory = Rxn<Category>();

  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final response = await supabase.from('categories').select();

      final fetchedCategories =
          (response as List).map((json) => Category.fromJson(json)).toList();

      categories.value = [
        Category.allCategory,
        ...fetchedCategories,
      ];

      selectedCategory.value = categories.first;
      selectedIndex.value = 0;

      print('✅ تم تحميل ${categories.length} فئة');
    } on PostgrestException catch (e) {
      print('❌ خطأ Supabase: ${e.message}');
      _handleError('فشل في تحميل الفئات', e.message);

      await _fetchCategoriesFromProducts();
    } catch (e) {
      print('❌ خطأ غير متوقع: $e');
      _handleError('خطأ غير متوقع', e.toString());

      // في حالة الخطأ، نحمّل الفئات من المنتجات
      await _fetchCategoriesFromProducts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchCategoriesFromProducts() async {
    try {
      final response =
          await supabase.from('products').select('category').order('category');

      if (response != null) {
        final uniqueCategories = <String>{};
        for (var item in response as List) {
          if (item['category'] != null &&
              item['category'].toString().isNotEmpty) {
            uniqueCategories.add(item['category'].toString());
          }
        }

        // تحويل الأسماء إلى Category objects
        categories.value = [
          Category.allCategory,
          ...uniqueCategories.map((name) => Category(
                id: name.toLowerCase().replaceAll(' ', '_'),
                name: name,
              )),
        ];

        selectedCategory.value = categories.first;
        print('✅ تم تحميل ${categories.length} فئة من المنتجات');
      }
    } catch (e) {
      print('❌ فشل في تحميل الفئات من المنتجات: $e');
      // تعيين فئات افتراضية
      categories.value = [Category.allCategory];
    }
  }

  void selectCategory(int index) {
    if (index < 0 || index >= categories.length) return;

    selectedIndex.value = index;
    selectedCategory.value = categories[index];

    // تصفية المنتجات
    _filterProducts();

    print('📌 تم اختيار الفئة: ${selectedCategory.value?.name}');
  }

  /// اختيار فئة بالاسم
  void selectCategoryByName(String name) {
    final index = categories.indexWhere(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
    );
    if (index != -1) {
      selectCategory(index);
    }
  }

  /// اختيار فئة بالـ ID
  void selectCategoryById(String id) {
    final index = categories.indexWhere((cat) => cat.id == id);
    if (index != -1) {
      selectCategory(index);
    }
  }

  void _filterProducts() {
    try {
      final productController = Get.find<ProductController>();
      final categoryName = selectedCategory.value?.name ?? 'All';

      // تحديث الفئة المختارة في ProductController
      productController.selectedCategory.value = categoryName;

      // تطبيق الفلترة على shoppingPageProducts
      productController.applyShoppingFilters();

      // أيضاً تحديث filteredProducts للصفحة الرئيسية
      productController.filterByCategory(categoryName);
    } catch (e) {
      print('⚠️ ProductController غير موجود: $e');
    }
  }

  void resetSelection() {
    selectCategory(0);
  }

  Future<void> refreshCategories() async {
    await fetchCategories();
  }

  void _handleError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  bool get isAllSelected => selectedIndex.value == 0;

  String get selectedCategoryName => selectedCategory.value?.name ?? 'All';

  int get categoriesCount => categories.length - 1;
}

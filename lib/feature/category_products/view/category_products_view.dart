import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/home/data/category_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_model.dart';
import 'package:e_commerce_fullapp/feature/product_details/view/product_details_view.dart';
import 'package:e_commerce_fullapp/feature/wishlist/data/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryProductsView extends StatelessWidget {
  // معرف الفئة (من البانر link_id)
  final String categoryId;

  const CategoryProductsView({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final categoryController = Get.find<CategoryController>();
    final wishlistController = Get.find<WishlistController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // البحث عن الفئة باستخدام ID للحصول على الاسم
    final category = categoryController.categories.firstWhereOrNull(
      (cat) => cat.id == categoryId,
    );

    // اسم الفئة (إذا لم يُعثر عليها، نستخدم الـ ID كاسم)
    final categoryName = category?.name ?? categoryId;

    // تصفية المنتجات حسب اسم الفئة
    final categoryProducts = productController.products
        .where((product) =>
            product.category.toLowerCase() == categoryName.toLowerCase())
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header مع اسم الفئة
            _buildHeader(context, isDark, categoryName, categoryProducts.length),
            const Gap(16),

            // عرض المنتجات
            Expanded(
              child: categoryProducts.isEmpty
                  ? _buildEmptyState(categoryName)
                  : _buildProductsGrid(
                      categoryProducts,
                      wishlistController,
                      isDark,
                      context,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, bool isDark, String categoryName, int productCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // زر الرجوع
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
            ),
          ),
          const Gap(16),

          // اسم الفئة وعدد المنتجات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: AppTextStyle.h2.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '$productCount products',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // أيقونة الفئة
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFff5722).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(categoryName),
              color: const Color(0xFFff5722),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String categoryName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const Gap(16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const Gap(8),
          Text(
            'No products available in $categoryName',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(
    List<Product> products,
    WishlistController wishlistController,
    bool isDark,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final crossAxisCount = screenWidth > 600 ? 3 : 2;
          final itemWidth =
              (screenWidth - (crossAxisCount - 1) * 12) / crossAxisCount;
          final itemHeight = itemWidth * 1.25;

          return GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemBuilder: (context, index) {
              final product = products[index];

              return GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetailsView(product: product));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // صورة المنتج
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                color:
                                    isDark ? Colors.grey.shade900 : Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: product.imageUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: product.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        placeholder: (context, url) =>
                                            const Bone.square(size: 120),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            // زر المفضلة
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 2,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Obx(() => IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        wishlistController
                                                .isInWishlist(product.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        wishlistController
                                            .toggleWishlist(product);
                                      },
                                    )),
                              ),
                            ),
                            // شارة الخصم
                            if (product.hasDiscount)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-${product.calculatedDiscount.toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            // علامة المخزون المنخفض (تظهر أسفل شارة الخصم)
                            if (product.stock < 10 && product.stock > 0)
                              Positioned(
                                top: product.hasDiscount ? 32 : 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFff5722),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Only ${product.stock} left',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // معلومات المنتج
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // اسم المنتج
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // السعر والتقييم
                              Row(
                                children: [
                                  // عرض الأسعار
                                  Expanded(
                                    child: product.hasDiscount
                                        ? Row(
                                            children: [
                                              // السعر بعد الخصم
                                              Text(
                                                '\$${product.effectivePrice.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Color(0xFFff5722),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              // السعر الأصلي (مشطوب)
                                              Text(
                                                '\$${product.displayOriginalPrice.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade500,
                                                  decoration:
                                                      TextDecoration.lineThrough,
                                                  decorationColor:
                                                      Colors.grey.shade500,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            '\$${product.effectivePrice.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                  ),
                                  // التقييم
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        product.rating.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final lowerCategory = category.toLowerCase();
    if (lowerCategory.contains('electronic') || lowerCategory.contains('tech')) {
      return Icons.devices;
    } else if (lowerCategory.contains('cloth') || lowerCategory.contains('fashion')) {
      return Icons.checkroom;
    } else if (lowerCategory.contains('shoe') || lowerCategory.contains('foot')) {
      return Icons.directions_run;
    } else if (lowerCategory.contains('watch') || lowerCategory.contains('accessor')) {
      return Icons.watch;
    } else if (lowerCategory.contains('home') || lowerCategory.contains('furniture')) {
      return Icons.home;
    } else if (lowerCategory.contains('sport')) {
      return Icons.sports_basketball;
    } else if (lowerCategory.contains('book')) {
      return Icons.menu_book;
    } else if (lowerCategory.contains('beauty') || lowerCategory.contains('cosmetic')) {
      return Icons.face;
    } else if (lowerCategory.contains('food') || lowerCategory.contains('grocery')) {
      return Icons.restaurant;
    }
    return Icons.category;
  }
}

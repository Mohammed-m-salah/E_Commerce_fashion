import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_model.dart';
import 'package:e_commerce_fullapp/feature/product_details/view/product_details_view.dart';
import 'package:e_commerce_fullapp/feature/wishlist/data/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductGrid extends StatelessWidget {
  final int? maxItems;

  const ProductGrid({super.key, this.maxItems});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final wishlistController = Get.find<WishlistController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.filteredProducts.isEmpty && !controller.isLoading.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const Gap(16),
                Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final itemCount = controller.isLoading.value
          ? 6
          : (maxItems != null && controller.filteredProducts.length > maxItems!
              ? maxItems!
              : controller.filteredProducts.length);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Skeletonizer(
          enabled: controller.isLoading.value,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final crossAxisCount = screenWidth > 600 ? 3 : 2;
              final itemWidth =
                  (screenWidth - (crossAxisCount - 1) * 12) / crossAxisCount;
              final itemHeight = itemWidth * 1.25;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: itemWidth / itemHeight,
                ),
                itemBuilder: (context, index) {
                  final product = controller.isLoading.value
                      ? _getDummyProduct()
                      : controller.filteredProducts[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ProductDetailsView(product: product);
                      }));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image with favorite icon
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
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
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
                                if (product.stock < 10 && product.stock > 0)
                                  Positioned(
                                    top: 8,
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

                          // Product Info
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Product Name
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  // Category
                                  Text(
                                    product.category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                  ),

                                  // Price row with rating
                                  Row(
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
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
        ),
      );
    });
  }

  static Product _getDummyProduct() {
    return Product(
      id: '0',
      name: 'Loading Product',
      description: 'Loading description',
      category: 'Category',
      price: 99.99,
      rating: 4.5,
      imageUrl: '',
      stock: 10,
    );
  }
}

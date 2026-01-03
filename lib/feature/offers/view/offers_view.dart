import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_model.dart';
import 'package:e_commerce_fullapp/feature/offers/data/offer_controller.dart';
import 'package:e_commerce_fullapp/feature/offers/data/offer_model.dart';
import 'package:e_commerce_fullapp/feature/product_details/view/product_details_view.dart';
import 'package:e_commerce_fullapp/feature/wishlist/data/wishlist_controller.dart';
import 'package:e_commerce_fullapp/feature/offers/view/category_offer_view.dart';

class OffersView extends StatefulWidget {
  const OffersView({super.key});

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offerController = Get.find<OfferController>();
    final productController = Get.find<ProductController>();
    final wishlistController = Get.find<WishlistController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isDark, offerController),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await offerController.refreshOffers();
                  await productController.refreshProducts();
                },
                child: Obx(() {
                  if (offerController.isLoading.value) {
                    return _buildLoadingState();
                  }

                  if (offerController.offers.isEmpty) {
                    return _buildEmptyState(isDark);
                  }

                  return _buildOffersContent(
                    offerController,
                    productController,
                    wishlistController,
                    isDark,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, OfferController offerController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.red.shade900, Colors.orange.shade900]
              : [Colors.red.shade600, Colors.orange.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Gap(16),

          // Title and count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Colors.yellow,
                        size: 28,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Hot Deals',
                      style: AppTextStyle.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  final count = offerController.offers.length;
                  return Text(
                    '$count exclusive offers',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Refresh button
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => offerController.refreshOffers(),
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersContent(
    OfferController offerController,
    ProductController productController,
    WishlistController wishlistController,
    bool isDark,
  ) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Offers Section
          Text(
            'Available Offers',
            style: AppTextStyle.h3.copyWith(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),

          // Offers List
          if (offerController.offers.isNotEmpty)
            ...offerController.offers.map((offer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildOfferCard(offer, isDark),
            )),

          const Gap(24),

          // Discounted Products Section
          Obx(() {
            final discountedProducts = productController.products
                .where((product) => product.hasDiscount)
                .toList();

            if (discountedProducts.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discounted Products',
                  style: AppTextStyle.h3.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: discountedProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (context, index) {
                    final product = discountedProducts[index];
                    return _buildProductCard(product, wishlistController, isDark);
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOfferCard(OfferModel offer, bool isDark) {
    return GestureDetector(
      onTap: () => _navigateToOffer(offer),
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: offer.isEndingSoon
              ? [Colors.orange.shade600, Colors.red.shade600]
              : [Colors.blue.shade600, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (offer.isEndingSoon ? Colors.orange : Colors.blue)
                .withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Discount Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Icon(
                        offer.isPercentage ? Icons.percent : Icons.attach_money,
                        color: Colors.red.shade600,
                        size: 18,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      offer.discountText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Ending Soon Badge
              if (offer.isEndingSoon)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer, color: Colors.white, size: 14),
                      Gap(4),
                      Text(
                        'Ending Soon!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const Gap(16),

          // Title
          Text(
            offer.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Gap(8),

          // Details Row
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              // Code (if available)
              if (offer.code != null && offer.code!.isNotEmpty)
                _buildOfferDetail(
                  Icons.confirmation_number,
                  'Code: ${offer.code}',
                ),

              // Minimum Purchase
              if (offer.minimumPurchase != null)
                _buildOfferDetail(
                  Icons.shopping_cart,
                  'Min: \$${offer.minimumPurchase!.toStringAsFixed(0)}',
                ),

              // Max Discount
              if (offer.maximumDiscount != null)
                _buildOfferDetail(
                  Icons.savings,
                  'Max: \$${offer.maximumDiscount!.toStringAsFixed(0)}',
                ),

              // Target
              if (offer.target != null)
                _buildOfferDetail(
                  _getTargetIcon(offer.target!),
                  _getTargetText(offer.target!),
                ),
            ],
          ),

          // Remaining Time
          if (offer.remainingTime != null && offer.remainingTime!.inSeconds > 0) ...[
            const Gap(12),
            _buildCountdownRow(offer.remainingTime!),
          ],

          // Usage Info
          if (offer.usageLimit != null) ...[
            const Gap(12),
            LinearProgressIndicator(
              value: offer.usedCount / offer.usageLimit!,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              borderRadius: BorderRadius.circular(4),
            ),
            const Gap(4),
            Text(
              '${offer.usedCount}/${offer.usageLimit} used',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }

  void _navigateToOffer(OfferModel offer) {
    final productController = Get.find<ProductController>();

    // إذا كان العرض لمنتج معين
    if (offer.productId != null && offer.productId!.isNotEmpty) {
      final product = productController.getProductById(offer.productId!);
      if (product != null) {
        Get.to(() => ProductDetailsView(product: product));
      } else {
        Get.snackbar(
          'Product Not Found',
          'The product for this offer is no longer available',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
    // إذا كان العرض لفئة معينة
    else if (offer.categoryName != null && offer.categoryName!.isNotEmpty) {
      // البحث عن الفئة المطابقة (case-insensitive)
      final matchingCategory = productController.categories.firstWhere(
        (cat) => cat.toLowerCase() == offer.categoryName!.toLowerCase(),
        orElse: () => offer.categoryName!,
      );

      debugPrint('🏷️ Offer categoryName: ${offer.categoryName}');
      debugPrint('🏷️ Matching category: $matchingCategory');

      // التوجيه لصفحة عرض منتجات الفئة (بدون إمكانية تغيير الفئة)
      Get.to(() => CategoryOfferView(
            categoryName: matchingCategory,
            offer: offer,
          ));
    }
    // fallback: إذا كان categoryId موجود لكن categoryName غير متاح
    else if (offer.categoryId != null && offer.categoryId!.isNotEmpty) {
      Get.snackbar(
        'Category Offer',
        'This offer applies to a specific category. Use code: ${offer.code ?? "N/A"}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    // إذا كان العرض لجميع المنتجات - فقط نظهر رسالة عن الكود
    else {
      if (offer.code != null && offer.code!.isNotEmpty) {
        Get.snackbar(
          'Use Code: ${offer.code}',
          'Apply this code at checkout to get ${offer.discountText} off!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Offer Applied',
          'This offer of ${offer.discountText} applies to all products!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Widget _buildOfferDetail(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const Gap(4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownRow(Duration remaining) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    return Row(
      children: [
        const Icon(Icons.access_time, color: Colors.white, size: 16),
        const Gap(8),
        Text(
          'Ends in: ${hours}h ${minutes}m ${seconds}s',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  IconData _getTargetIcon(String target) {
    switch (target.toLowerCase()) {
      case 'product':
        return Icons.inventory_2;
      case 'category':
        return Icons.category;
      default:
        return Icons.all_inclusive;
    }
  }

  String _getTargetText(String target) {
    switch (target.toLowerCase()) {
      case 'product':
        return 'Specific Product';
      case 'category':
        return 'Category';
      default:
        return 'All Products';
    }
  }

  Widget _buildLoadingState() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_offer_outlined,
              size: 80,
              color: Colors.red.shade400,
            ),
          ),
          const Gap(24),
          Text(
            'No Offers Available',
            style: AppTextStyle.h3.copyWith(
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const Gap(8),
          Text(
            'Check back later for amazing deals!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const Gap(24),
          ElevatedButton.icon(
            onPressed: () => Get.find<OfferController>().refreshOffers(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    Product product,
    WishlistController wishlistController,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsView(product: product)),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: product.imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => const Icon(
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

                  // Discount Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade600, Colors.orange.shade600],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '-${product.calculatedDiscount.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  // Wishlist Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Obx(() => IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              wishlistController.isInWishlist(product.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              wishlistController.toggleWishlist(product);
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),

            // Product Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${product.displayOriginalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          '\$${product.effectivePrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < product.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 12,
                            color: Colors.amber,
                          );
                        }),
                        const Gap(4),
                        Text(
                          '(${product.rating})',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
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
  }
}

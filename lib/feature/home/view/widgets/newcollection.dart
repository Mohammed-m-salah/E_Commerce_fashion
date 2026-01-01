import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/home/data/banner_controller.dart';
import 'package:e_commerce_fullapp/feature/home/data/banner_model.dart';
import 'package:e_commerce_fullapp/feature/category_products/view/category_products_view.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:e_commerce_fullapp/feature/product_details/view/product_details_view.dart';
import 'package:e_commerce_fullapp/shared/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewCollection extends StatefulWidget {
  const NewCollection({super.key});

  @override
  State<NewCollection> createState() => _NewCollectionState();
}

class _NewCollectionState extends State<NewCollection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  // جلب الـ BannerController
  late final BannerController _bannerController;

  @override
  void initState() {
    super.initState();
    _bannerController = Get.find<BannerController>();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && _bannerController.banners.isNotEmpty) {
        final nextPage = (_currentPage + 1) % _bannerController.banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(() {
        // عرض skeleton أثناء التحميل
        if (_bannerController.isLoading.value) {
          return _buildLoadingSkeleton();
        }

        final banners = _bannerController.banners;

        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  return _buildBannerCard(banners[index]);
                },
              ),
            ),
            const SizedBox(height: 12),
            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFFff5722)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Container(
            height: 160,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 0 ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(BannerModel banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [banner.gradientStart, banner.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: banner.gradientStart.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (banner.imageUrl.isNotEmpty)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: banner.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.transparent,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          if (banner.imageUrl.isNotEmpty)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      banner.gradientStart.withOpacity(0.8),
                      banner.gradientEnd.withOpacity(0.6),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          if (banner.imageUrl.isEmpty)
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                _getIconForBanner(banner.title),
                size: 140,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          // المحتوى
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        banner.title,
                        style: AppTextStyle.withColor(
                          AppTextStyle.h3,
                          Colors.white,
                        ).copyWith(
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (banner.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          banner.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: CustomButton(
                      color: Colors.white,
                      text: _getButtonText(banner.linkType),
                      textColor: banner.gradientStart,
                      height: 48,
                      borderRadius: 12,
                      onPressed: () {
                        _bannerController.recordClick(banner.id);
                        _handleBannerTap(banner);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(String? linkType) {
    switch (linkType) {
      case 'product':
        return 'View';
      case 'category':
        return 'Explore';
      case 'offer':
        return 'Get Deal';
      default:
        return 'Shop Now';
    }
  }

  void _handleBannerTap(BannerModel banner) {
    // التحقق من وجود نوع الرابط و معرف الرابط
    if (banner.linkType == null || banner.linkId == null) {
      debugPrint('No link configured for banner: ${banner.id}');
      return;
    }

    switch (banner.linkType) {
      case 'product':
        // جلب المنتج من ProductController باستخدام linkId
        final productController = Get.find<ProductController>();
        final product = productController.getProductById(banner.linkId!);

        if (product != null) {
          // الانتقال إلى صفحة تفاصيل المنتج
          Get.to(() => ProductDetailsView(product: product));
        } else {
          // في حالة عدم العثور على المنتج
          Get.snackbar(
            'Error',
            'Product not found',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        break;
      case 'category':
        // الانتقال إلى صفحة الفئة مع عرض اسم الفئة ومنتجاتها
        Get.to(() => CategoryProductsView(categoryId: banner.linkId!));
        break;
      case 'offer':
        debugPrint('Navigate to offer: ${banner.linkId}');
        break;
      default:
        debugPrint('Unknown link type: ${banner.linkType}');
    }
  }

  IconData _getIconForBanner(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('sale') || lowerTitle.contains('discount')) {
      return Icons.local_offer_outlined;
    } else if (lowerTitle.contains('new') ||
        lowerTitle.contains('collection')) {
      return Icons.new_releases_outlined;
    } else if (lowerTitle.contains('shipping') ||
        lowerTitle.contains('delivery')) {
      return Icons.local_shipping_outlined;
    } else if (lowerTitle.contains('flash') || lowerTitle.contains('limited')) {
      return Icons.flash_on_outlined;
    }
    return Icons.star_outline;
  }
}

import 'package:e_commerce_fullapp/core/theme/them_controller.dart';
import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/all_procucts/view/all_products_view.dart';
import 'package:e_commerce_fullapp/feature/cart/view/cart_view.dart';
import 'package:e_commerce_fullapp/feature/home/data/product_controller.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/categoris.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/header.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/newcollection.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/notification_view.dart';
import 'package:e_commerce_fullapp/feature/home/view/widgets/product_grid.dart';
import 'package:e_commerce_fullapp/feature/offers/view/offers_view.dart';
import 'package:e_commerce_fullapp/feature/offers/data/offer_controller.dart';
import 'package:e_commerce_fullapp/shared/custome_searchfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final supabase = Supabase.instance.client;
  String userName = 'User';
  String userAvatar = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.userMetadata?['full_name'] ??
            user.email?.split('@')[0] ??
            'User';
        userAvatar = user.userMetadata?['avatar_url'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Homeheader(
                onNotificationTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return NotificationView();
                  }));
                },
                onCartTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return CartView();
                  }));
                },
                onThemeToggleTap: () {
                  themeController.toggelTheme();
                },
                userName: userName,
                avatarAssetPath: userAvatar.isNotEmpty
                    ? userAvatar
                    : 'assets/images/avatar.jpg',
              ),
              CustomSearchField(
                onChanged: (value) {
                  productController.searchProducts(value);
                },
                onFilterTap: () => debugPrint("Filter tapped"),
              ),
              const Gap(5),
              const CategoriesHome(),
              const Gap(16),
              const NewCollection(),
              const Gap(16),
              _buildHotDealsBanner(context),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Text(
                      'Popular Product',
                      style: AppTextStyle.h2,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return AllProductsView();
                        }));
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFFff5722),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              const ProductGrid(maxItems: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotDealsBanner(BuildContext context) {
    final productController = Get.find<ProductController>();
    final offerController = Get.find<OfferController>();

    return Obx(() {
      final discountCount =
          productController.products.where((p) => p.hasDiscount).length;
      final offersCount = offerController.offers.length;

      if (discountCount == 0 && offersCount == 0)
        return const SizedBox.shrink();

      final totalDeals = discountCount + offersCount;

      return GestureDetector(
        onTap: () => Get.to(() => const OffersView()),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.shade600,
                Colors.orange.shade500,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.yellow,
                  size: 28,
                ),
              ),
              const Gap(16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hot Deals',
                      style: AppTextStyle.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '$totalDeals deals & offers available!',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow & Discount Badge
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'UP TO 70%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

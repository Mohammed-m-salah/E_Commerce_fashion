import 'package:e_commerce_fullapp/core/theme/them_controller.dart';
import 'package:e_commerce_fullapp/feature/cart/data/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Homeheader extends StatelessWidget {
  final String userName;
  final String greeting;
  final String avatarAssetPath;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onThemeToggleTap;

  const Homeheader({
    super.key,
    required this.userName,
    this.greeting = "Good Morning",
    required this.avatarAssetPath,
    this.onNotificationTap,
    this.onCartTap,
    this.onThemeToggleTap,
  });

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.amber[300],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: _isNetworkImage(avatarAssetPath)
                  ? CachedNetworkImage(
                      imageUrl: avatarAssetPath,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                      placeholder: (context, url) => Bone.circle(size: 70),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/avatar.jpg',
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    )
                  : Image.asset(
                      avatarAssetPath,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello $userName',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                greeting,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: onNotificationTap,
            icon: Icon(Icons.notifications_none_outlined,
                size: 28, color: Colors.grey.shade600),
          ),
          Builder(
            builder: (context) {
              final cartController = Get.find<CartController>();

              return Obx(() {
                final cartCount = cartController.uniqueItemCount;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: onCartTap,
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        size: 28,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xFFff5722),
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              cartCount > 99 ? '99+' : '$cartCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              });
            },
          ),
          GetBuilder<ThemeController>(
            builder: (themeController) {
              return IconButton(
                onPressed: () {
                  themeController.toggelTheme();
                },
                icon: Icon(
                  themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  size: 28,
                  color: Colors.grey.shade600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

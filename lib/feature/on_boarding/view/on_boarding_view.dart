import 'package:e_commerce_fullapp/feature/on_boarding/data/on_boarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/images/intro.png',
      title: 'Discover Latest Trends',
      subtitle: 'Explore the newest fashion trends\nand find your unique style',
      color: const Color(0xFFff5722),
    ),
    OnboardingData(
      image: 'assets/images/intro1.png',
      title: 'Quality Products',
      subtitle: 'Shop premium quality products\nfrom top brands worldwide',
      color: const Color(0xFF7C4DFF),
    ),
    OnboardingData(
      image: 'assets/images/intro2.png',
      title: 'Easy Shopping',
      subtitle: 'Simple and secure shopping\nexperience at your fingertips',
      color: const Color(0xFF00BCD4),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Obx(() {
            final currentColor = _pages[controller.pageIndex.value].color;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.grey.shade900,
                          Colors.black,
                        ]
                      : [
                          currentColor.withOpacity(0.1),
                          Colors.white,
                        ],
                ),
              ),
            );
          }),

          SafeArea(
            child: Column(
              children: [
                // Skip Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: controller.skip,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFff5722),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      controller.pageIndex.value = index;
                      _animationController.reset();
                      _animationController.forward();
                    },
                    itemBuilder: (context, index) {
                      return _buildPage(
                        _pages[index],
                        size,
                        isDark,
                      );
                    },
                  ),
                ),

                // Bottom Section
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                  child: Column(
                    children: [
                      // Page Indicator
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pages.length, (index) {
                            final isActive =
                                controller.pageIndex.value == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: isActive ? 32 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFFff5722)
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFff5722)
                                              .withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                            );
                          }),
                        );
                      }),

                      const SizedBox(height: 32),

                      // Next/Get Started Button
                      Obx(() {
                        final isLastPage = controller.pageIndex.value == 2;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isLastPage) {
                                controller.finishOnboarding();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFff5722),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor:
                                  const Color(0xFFff5722).withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isLastPage ? 'Get Started' : 'Next',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (!isLastPage) ...[
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data, Size size, bool isDark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image with decoration
              Container(
                height: size.height * 0.38,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle decoration
                    Positioned(
                      child: Container(
                        width: size.width * 0.7,
                        height: size.width * 0.7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              data.color.withOpacity(0.2),
                              data.color.withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Image
                    Image.asset(
                      data.image,
                      height: size.height * 0.32,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Title
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;
  final Color color;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

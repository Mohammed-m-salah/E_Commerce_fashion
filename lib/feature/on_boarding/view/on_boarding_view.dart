import 'package:e_commerce_fullapp/feature/on_boarding/data/on_boarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    final pages = [
      _buildPage(
        image: 'assets/images/intro.png',
        title: "Discover Latest Trends",
        subtitle:
            "Explore the newest fashion trends \n and find your uniqe style",
      ),
      _buildPage(
        image: 'assets/images/intro1.png',
        title: "Quality products ",
        subtitle: "shop premuim quality products form \n top brands worldwide",
      ),
      _buildPage(
        image: 'assets/images/intro2.png',
        title: "Easy Shopping",
        subtitle: "simple and secure shopping \n experince at your fingratpis",
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          // Skip Button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, right: 20),
              child: TextButton(
                onPressed: controller.skip,
                child: const Text("Skip"),
              ),
            ),
          ),

          // PageView
          Expanded(
            child: PageView.builder(
              itemCount: 3,
              onPageChanged: (index) {
                controller.pageIndex.value = index;
              },
              itemBuilder: (_, index) {
                return pages[index];
              },
            ),
          ),

          // Page Indicator
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(4),
                  width: controller.pageIndex.value == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.pageIndex.value == index
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            );
          }),

          const SizedBox(height: 20),

          // Next Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: controller.nextPage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Obx(() {
                return Text(
                  controller.pageIndex.value == 2 ? "Get Started" : "Next",
                  style: const TextStyle(fontSize: 18),
                );
              }),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildPage(
      {required String image,
      required String title,
      required String subtitle}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 260),
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          textAlign: TextAlign.center,
          subtitle,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    );
  }
}

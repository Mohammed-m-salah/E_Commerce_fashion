import 'package:e_commerce_fullapp/feature/wishlist/view/wishlist_view.dart';
import 'package:e_commerce_fullapp/feature/home/view/home_view.dart';
import 'package:e_commerce_fullapp/feature/profile/view/profile_view.dart';
import 'package:e_commerce_fullapp/feature/shopping/view/shopping_view.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late PageController controller;
  int currentScreen = 0;

  final List<Widget> screens = const [
    HomeView(),
    Shoppingview(),
    WishListView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // لون الظل أقوى
              blurRadius: 20, // نعومة الظل
              spreadRadius: 2, // امتداد الظل
              offset: const Offset(0, 10), // موقع الظل
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: currentScreen,
            onTap: (index) {
              setState(() {
                currentScreen = index;
              });
              controller.jumpToPage(index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFFff5722),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 28),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined, size: 28),
                label: "Shopping",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined, size: 28),
                label: "Favourit",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 28),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

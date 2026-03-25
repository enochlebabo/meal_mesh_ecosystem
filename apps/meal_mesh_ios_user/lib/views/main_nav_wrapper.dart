import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home/home_view.dart';
import 'profile_view.dart'; 

class MainNavWrapper extends StatelessWidget {
  MainNavWrapper({super.key});

  final RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(), 
      const Center(child: Text("Orders coming soon")), 
      const ProfileView(), 
    ];

    return Scaffold(
      body: Obx(() => pages[currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: currentIndex.value,
          onTap: (index) => currentIndex.value = index,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

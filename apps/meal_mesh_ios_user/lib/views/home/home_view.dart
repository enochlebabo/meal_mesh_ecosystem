import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/restaurant_controller.dart';
import '../../routes/app_routes.dart';

class HomeView extends GetView<RestaurantController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text("Anand, Gujarat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Search for 'Burger' or 'Pizza'",
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20),
                  children: [
                    _buildCategoryItem("Burgers", ""),
                    _buildCategoryItem("Pizza", ""),
                    _buildCategoryItem("Biryani", ""),
                    _buildCategoryItem("Drinks", ""),
                    _buildCategoryItem("Deserts", ""),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text("Popular Restaurants", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                // FIX: Wrapped in SliverFillRemaining
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Colors.orange)),
                );
              }
              if (controller.restaurants.isEmpty) {
                // FIX: Wrapped in SliverFillRemaining
                return const SliverFillRemaining(
                  child: Center(child: Text("No restaurants found.")),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var doc = controller.restaurants[index];
                    var data = doc.data() as Map<String, dynamic>;
                    return _buildRestaurantCard(
                      id: doc.id,
                      name: data['name'] ?? 'Unnamed',
                      address: data['address'] ?? 'Unknown location',
                      image: data['image'] ?? '',
                    );
                  },
                  childCount: controller.restaurants.length,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, String emoji) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard({required String id, required String name, required String address, required String image, required String rating}) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.RESTAURANT_MENU, arguments: {"id": id, "name": name, "image": image}),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(image, height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          children: [
                            Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            const Icon(Icons.star, color: Colors.white, size: 12),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(address, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

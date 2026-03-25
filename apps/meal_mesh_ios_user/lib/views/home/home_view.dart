import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/restaurant_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the existing controller
    final resC = Get.put(RestaurantController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Meal Mesh Delivery", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        // Logical check: If Admin has nothing approved/active, show a clear state
        if (resC.restaurants.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.storefront_outlined, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text("No restaurants available right now.", 
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
                const Text("Check back soon!", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: resC.restaurants.length,
          itemBuilder: (context, index) {
            var doc = resC.restaurants[index];
            var data = doc.data() as Map<String, dynamic>;
            
            return GestureDetector(
              onTap: () => Get.toNamed('/restaurant-menu', arguments: {
                'id': doc.id,
                'name': data['name'] ?? 'Unnamed',
              }),
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    // Dynamic Image from Admin Dashboard
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        color: Colors.grey.shade200,
                        image: data['imageUrl'] != null 
                          ? DecorationImage(image: NetworkImage(data['imageUrl']), fit: BoxFit.cover)
                          : null,
                      ),
                      child: data['imageUrl'] == null 
                        ? const Center(child: Icon(Icons.image, color: Colors.grey)) 
                        : null,
                    ),
                    ListTile(
                      title: Text(data['name'] ?? 'Unnamed', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text(data['address'] ?? 'No address set'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

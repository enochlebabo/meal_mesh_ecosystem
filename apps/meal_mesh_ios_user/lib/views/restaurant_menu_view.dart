import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import '../controllers/cart_controller.dart';

class RestaurantMenuView extends StatelessWidget {
  const RestaurantMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize/Find controllers
    final menuC = Get.put(RestaurantMenuController());
    final cartC = Get.find<CartController>();
    
    // Retrieve the dynamic ID and Name passed from the Home Card
    final String resId = Get.arguments['id'];
    final String resName = Get.arguments['name'];

    // Start the live sync for this specific menu
    menuC.bindMenuStream(resId);

    return Scaffold(
      appBar: AppBar(
        title: Text(resName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (menuC.menuItems.isEmpty) {
          return const Center(child: Text("Loading live menu..."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: menuC.menuItems.length,
          itemBuilder: (context, index) {
            var data = menuC.menuItems[index].data() as Map<String, dynamic>;
            String name = data['name'] ?? 'Item';
            String price = data['price']?.toString() ?? '0';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("₹$price"),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () => cartC.addToCart(name),
                  child: const Text("ADD", style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

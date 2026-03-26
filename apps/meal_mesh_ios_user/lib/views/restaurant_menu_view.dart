import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/restaurant_controller.dart';
import '../controllers/cart_controller.dart';

class RestaurantMenuView extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;

  const RestaurantMenuView({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RestaurantController>();
    final cartController = Get.find<CartController>();

    // Professional Trigger: Fetch menu immediately on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRestaurantMenu(restaurantId);
    });

    return Scaffold(
      appBar: AppBar(title: Text(restaurantName)),
      body: Obx(() {
        if (controller.isMenuLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.menuItems.isEmpty) {
          return const Center(child: Text("No items found in menu."));
        }

        return ListView.builder(
          itemCount: controller.menuItems.length,
          itemBuilder: (context, index) {
            var item = controller.menuItems[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(item['name'] ?? 'Item'),
              subtitle: Text("R₹{item['price']}"),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // Connect to your CartController logic here
                  cartController.addToCart(controller.menuItems[index].id, item["name"] ?? "Item", (item["price"] ?? 0).toDouble());
                },
              ),
            );
          },
        );
      }),
    );
  }
}

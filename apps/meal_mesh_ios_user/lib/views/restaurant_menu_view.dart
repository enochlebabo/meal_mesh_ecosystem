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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRestaurantMenu(restaurantId);
    });

    return Scaffold(
      appBar: AppBar(title: Text(restaurantName), centerTitle: true),
      body: Obx(() {
        if (controller.isMenuLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }
        return ListView.builder(
          itemCount: controller.menuItems.length,
          itemBuilder: (context, index) {
            final item = controller.menuItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(item.image, width: 60, height: 60, fit: BoxFit.cover, 
                    errorBuilder: (ctx, err, stack) => const Icon(Icons.fastfood, size: 40)),
                ),
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text("₹${item.price}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.orange, size: 30),
                  onPressed: () => cartController.addToCart(item.id, item.name, item.price),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

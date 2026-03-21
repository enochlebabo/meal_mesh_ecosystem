import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';

class VendorCatalogView extends StatelessWidget {
  const VendorCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final m = Get.put(MenuController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Digital Menu Catalog", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: () => _showAddDialog(m),
              icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
              label: const Text("NEW MENU ITEM", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.all(20)),
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // MESH GRID OF DISHES
        Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            childAspectRatio: 0.8, 
            crossAxisSpacing: 24, 
            mainAxisSpacing: 24
          ),
          itemCount: m.menuItems.length,
          itemBuilder: (context, i) {
            var item = m.menuItems[i];
            return _buildFoodCard(item, m);
          },
        )),
      ],
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> item, MenuController m) {
    // 1. DATA SANITIZATION (The Fix)
    String imageUrl = item['image'] ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c';
    String name = item['name'] ?? 'Unnamed Dish';
    String price = item['price']?.toString() ?? '0.0';
    String desc = item['description'] ?? 'No description available.';
    String category = item['category'] ?? 'Uncategorized';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE SECTION
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                height: 160, 
                color: Colors.grey[200], 
                child: const Icon(Icons.broken_image, color: Colors.grey)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(name, 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("₹$price", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(desc, 
                    maxLines: 2, overflow: TextOverflow.ellipsis, 
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(label: Text(category, style: const TextStyle(fontSize: 10))),
                    IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => m.deleteItem(item['id'])),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(MenuController m) {
    Get.defaultDialog(
      title: "Add New Product",
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: m.nameC, decoration: const InputDecoration(labelText: "Dish Name (e.g. Paneer Tikka)")),
            TextField(controller: m.descC, decoration: const InputDecoration(labelText: "Description (Ingredients/Prep)")),
            TextField(controller: m.priceC, decoration: const InputDecoration(labelText: "Price (₹)")),
            TextField(controller: m.categoryC, decoration: const InputDecoration(labelText: "Category (Main, Starter, Drink)")),
            TextField(controller: m.urlC, decoration: const InputDecoration(labelText: "Image URL (Unsplash/Direct Link)")),
          ],
        ),
      ),
      onConfirm: () => m.saveItem(),
      textConfirm: "DEPLOY TO APP",
      confirmTextColor: Colors.white,
    );
  }
}

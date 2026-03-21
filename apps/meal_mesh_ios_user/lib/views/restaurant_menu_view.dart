import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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
    // Inject Cart Controller
    final cart = Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // FLOATING CART SUMMARY AT THE BOTTOM
      bottomNavigationBar: Obx(() {
        if (cart.totalItems == 0) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              // We will navigate to Cart View later
              Get.snackbar("Checkout", "Proceeding to pay ₹${cart.totalAmount}");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                  child: Text("${cart.totalItems} Items", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const Text("View Cart", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text("₹${cart.totalAmount}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: Colors.orange,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                child: Text(restaurantName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              background: Image.network(restaurantImage, fit: BoxFit.cover),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('restaurants')
                .doc(restaurantId)
                .collection('menu')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: Colors.orange)));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text("This restaurant hasn't uploaded a menu yet.", style: TextStyle(color: Colors.grey))),
                  ),
                );
              }

              final menuItems = snapshot.data!.docs;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var item = menuItems[index].data() as Map<String, dynamic>;
                    String itemId = menuItems[index].id; // Get the actual Firestore Document ID
                    String itemName = item['name'] ?? 'Unnamed Item';
                    String itemDesc = item['description'] ?? '';
                    double itemPrice = double.tryParse(item['price'].toString()) ?? 0.0;
                    String itemImage = item['image'] ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c';

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(itemImage, width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(itemDesc, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 8),
                                Text("₹$itemPrice", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                          // ADD TO CART BUTTON
                          IconButton(
                            onPressed: () {
                              cart.addItem(itemId, itemName, itemPrice, itemImage, restaurantId);
                            },
                            icon: const Icon(Icons.add_circle, color: Colors.orange, size: 36),
                          )
                        ],
                      ),
                    );
                  },
                  childCount: menuItems.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)), 
        ],
      ),
    );
  }
}

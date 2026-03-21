import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();
  
  // Stores items as { itemId: { name, price, quantity, image, restaurantId } }
  final RxMap<String, Map<String, dynamic>> cartItems = <String, Map<String, dynamic>>{}.obs;

  void addItem(String id, String name, double price, String image, String restaurantId) {
    if (cartItems.containsKey(id)) {
      cartItems[id]!['quantity'] += 1;
    } else {
      cartItems[id] = {
        'id': id,
        'name': name,
        'price': price,
        'quantity': 1,
        'image': image,
        'restaurantId': restaurantId,
      };
    }
    cartItems.refresh(); // Forces GetX UI updates
    
    Get.snackbar(
      "Added to Cart", 
      "$name added (Qty: ${cartItems[id]!['quantity']})",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.shopping_bag, color: Colors.orange),
    );
  }

  void removeItem(String id) {
    if (cartItems.containsKey(id)) {
      if (cartItems[id]!['quantity'] > 1) {
        cartItems[id]!['quantity'] -= 1;
      } else {
        cartItems.remove(id);
      }
      cartItems.refresh();
    }
  }

  double get totalAmount {
    double total = 0;
    cartItems.forEach((key, item) => total += (item['price'] * item['quantity']));
    return total;
  }

  int get totalItems {
    int count = 0;
    cartItems.forEach((key, item) => count += item['quantity'] as int);
    return count;
  }
}

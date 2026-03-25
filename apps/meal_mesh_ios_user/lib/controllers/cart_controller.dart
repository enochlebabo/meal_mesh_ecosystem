import 'package:flutter/material.dart'; // THE MISSING LINK
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();
  
  // Map of Item ID to Quantity
  final RxMap<String, int> cartItems = <String, int>{}.obs;

  void addToCart(String itemId) {
    if (cartItems.containsKey(itemId)) {
      cartItems[itemId] = cartItems[itemId]! + 1;
    } else {
      cartItems[itemId] = 1;
    }
    
    // Now Colors.green and Colors.white will be recognized
    Get.snackbar(
      "Added to Cart", 
      "$itemId added to your order", 
      snackPosition: SnackPosition.BOTTOM, 
      backgroundColor: Colors.green, 
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  int get totalItems => cartItems.values.fold(0, (sum, item) => sum + item);
}

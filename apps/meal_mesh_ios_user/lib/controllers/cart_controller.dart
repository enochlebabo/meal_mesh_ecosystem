import "package:flutter/material.dart";
import 'package:get/get.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({required this.id, required this.name, required this.price, this.quantity = 1});
}

class CartController extends GetxController {
  var cartItems = <String, CartItem>{}.obs;

  void addToCart(String id, String name, double price) {
    if (cartItems.containsKey(id)) {
      cartItems[id]!.quantity += 1;
    } else {
      cartItems[id] = CartItem(id: id, name: name, price: price);
    }
    cartItems.refresh();
    Get.snackbar("Added to Cart", "$name added to your tray", 
      snackPosition: SnackPosition.BOTTOM, 
      backgroundColor: Colors.green.withOpacity(0.1),
      duration: const Duration(seconds: 1));
  }

  // Displaying Total in Rupees
  String get totalAmountString => "₹${totalAmount.toStringAsFixed(2)}";
  
  double get totalAmount => cartItems.values
      .fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get itemCount => cartItems.length;
}

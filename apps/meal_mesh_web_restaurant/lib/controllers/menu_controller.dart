import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final RxList<Map<String, dynamic>> menuItems = <Map<String, dynamic>>[].obs;

  // Form Controllers for High-Fidelity Items
  final nameC = TextEditingController();
  final descC = TextEditingController();
  final priceC = TextEditingController();
  final urlC = TextEditingController(); // FOR IMAGE URLS
  final categoryC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _listenToMenu();
  }

  void _listenToMenu() {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      _db.collection('restaurants').doc(uid).collection('menu')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((s) => menuItems.value = s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
    }
  }

  Future<void> saveItem() async {
    String? uid = _auth.currentUser?.uid;
    if (nameC.text.isEmpty || priceC.text.isEmpty) return;

    await _db.collection('restaurants').doc(uid).collection('menu').add({
      'name': nameC.text.trim(),
      'description': descC.text.trim(),
      'price': double.tryParse(priceC.text) ?? 0.0,
      'image': urlC.text.trim().isEmpty 
          ? "https://images.unsplash.com/photo-1546069901-ba9599a7e63c" // Default Food Image
          : urlC.text.trim(),
      'category': categoryC.text.trim().isEmpty ? "Main Course" : categoryC.text.trim(),
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    nameC.clear(); descC.clear(); priceC.clear(); urlC.clear(); categoryC.clear();
    Get.back();
    Get.snackbar("Success", "Catalog updated and synced to customers!");
  }

  Future<void> deleteItem(String id) async {
    String? uid = _auth.currentUser?.uid;
    await _db.collection('restaurants').doc(uid).collection('menu').doc(id).delete();
  }
}

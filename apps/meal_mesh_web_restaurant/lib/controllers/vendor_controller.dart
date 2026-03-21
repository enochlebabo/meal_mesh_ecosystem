import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxMap<String, dynamic> restaurantData = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  final RxMap<String, int> salesData = <String, int>{}.obs; // Item Name -> Count

  @override
  void onInit() {
    super.onInit();
    _initStreams();
  }

  void _initStreams() {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _db.collection('restaurants').doc(uid).snapshots().listen((d) => restaurantData.value = d.data() ?? {});
    
    // Listen to orders to calculate analytics
    _db.collection('orders').where('restaurantId', isEqualTo: uid).snapshots().listen((s) {
      orders.value = s.docs.map((d) => {'id': d.id, ...d.data()}).toList();
      _calculateAnalytics();
    });
  }

  void _calculateAnalytics() {
    Map<String, int> counts = {};
    for (var order in orders) {
      List items = order['items'] ?? [];
      for (var item in items) {
        counts[item] = (counts[item] ?? 0) + 1;
      }
    }
    salesData.value = counts;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({'status': status});
  }

  Future<void> toggleStore(bool isOpen) async {
    String? uid = _auth.currentUser?.uid;
    await _db.collection('restaurants').doc(uid).update({'isOpen': isOpen});
  }
}

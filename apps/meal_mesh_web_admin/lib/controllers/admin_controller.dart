import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final RxList<Map<String, dynamic>> allUsers = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allRestaurants = <Map<String, dynamic>>[].obs;
  final broadcastController = TextEditingController();

  // Computed totals for the UI
  int get customerCount => allUsers.where((u) => u['role'] == 'customer').length;
  int get vendorCount => allRestaurants.length;
  int get pendingVendorCount => allRestaurants.where((r) => r['isApproved'] == false).length;

  @override
  void onInit() {
    super.onInit();
    _initStreams();
  }

  void _initStreams() {
    _db.collection('users').snapshots().listen((s) => allUsers.value = s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
    _db.collection('restaurants').snapshots().listen((s) => allRestaurants.value = s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Future<void> sendBroadcast() async {
    if (broadcastController.text.isEmpty) return;
    await _db.collection('notifications').add({
      'message': broadcastController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });
    broadcastController.clear();
    Get.snackbar("Success", "Broadcast sent.");
  }

  Future<void> toggleApproval(String id, bool status) async {
    await _db.collection('restaurants').doc(id).update({'isApproved': !status});
  }

  Future<void> deleteEntity(String collection, String id) async {
    await _db.collection(collection).doc(id).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/map_picker_view.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _listenToUser();
  }

  void _listenToUser() {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      _db.collection('users').doc(uid).snapshots().listen((doc) {
        if (doc.exists) {
          userData.value = doc.data() as Map<String, dynamic>;
          nameC.text = userData['name'] ?? '';
          phoneC.text = userData['phone'] ?? '';
          addressC.text = userData['address'] ?? '';
        }
      });
    }
  }

  // OPENS THE MAP AND WAITS FOR THE ADDRESS
  Future<void> openMapPicker() async {
    final selectedAddress = await Get.to(() => const MapPickerView());
    if (selectedAddress != null && selectedAddress is String) {
      addressC.text = selectedAddress;
    }
  }

  Future<void> updateProfile() async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) {
      Get.snackbar("Auth Error", "Please log in to save your profile.");
      return;
    }
    try {
      await _db.collection('users').doc(uid).set({
        'name': nameC.text.trim(),
        'phone': phoneC.text.trim(),
        'address': addressC.text.trim(),
        'role': 'customer', 
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar("Synced Successfully", "Profile updated across the network.", snackPosition: SnackPosition.TOP, backgroundColor: Colors.green.shade600, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.snackbar("Logged Out", "You have been signed out.");
  }
}

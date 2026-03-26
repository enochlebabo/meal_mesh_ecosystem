import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';

class DriverDataController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String? currentUid = FirebaseAuth.instance.currentUser?.uid;

  final RxList<QueryDocumentSnapshot> availableOrders = <QueryDocumentSnapshot>[].obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);

  @override
  void onInit() {
    super.onInit();
    _initTracking();
    _listenOrders();
  }

  void _initTracking() async {
    await Geolocator.requestPermission();
    Geolocator.getPositionStream().listen((pos) {
      currentPosition.value = pos;
      if (currentUid != null) {
        _db.collection('drivers').doc(currentUid).update({
          'currentLocation': GeoPoint(pos.latitude, pos.longitude),
          'lastActive': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  void _listenOrders() {
    availableOrders.bindStream(_db.collection('orders')
      .where('status', isEqualTo: 'pending')
      .snapshots().map((s) => s.docs));
  }

  void launchMap(double lat, double lng, String label) {
    MapsLauncher.launchCoordinates(lat, lng, label);
  }

  Future<void> acceptOrder(String id) async {
    await _db.collection('orders').doc(id).update({
      'status': 'accepted',
      'driverId': currentUid,
    });
    Get.snackbar("Order Claimed", "Navigate to restaurant", backgroundColor: Colors.green, colorText: Colors.white);
  }
}

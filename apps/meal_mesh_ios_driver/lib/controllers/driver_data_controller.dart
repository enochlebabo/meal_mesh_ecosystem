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
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10)
    ).listen((pos) {
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

  // RESTORED METHOD: Fixes the UI Build Error
  double calculateDistance(double destLat, double destLng) {
    if (currentPosition.value == null) return 0.0;
    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
      destLat,
      destLng,
    );
    return distanceInMeters / 1000; // Convert to KM
  }

  void launchMap(double lat, double lng, String label) {
    MapsLauncher.launchCoordinates(lat, lng, label);
  }

  Future<void> acceptOrder(String id) async {
    if (currentUid == null) return;
    try {
      await _db.collection('orders').doc(id).update({
        'status': 'accepted',
        'driverId': currentUid,
      });
      Get.snackbar("Success", "Order Claimed!", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

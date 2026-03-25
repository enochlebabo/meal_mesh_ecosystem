import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/map_tracker_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapTrackerView extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const MapTrackerView({super.key, required this.orderId, required this.orderData});

  @override
  State<MapTrackerView> createState() => _MapTrackerViewState();
}

class _MapTrackerViewState extends State<MapTrackerView> {
  final mapC = Get.put(MapTrackerController());

  @override
  void initState() {
    super.initState();
    // Trigger the GPS routing as soon as the screen opens
    String restaurantLoc = widget.orderData['restaurantName'] + ", Anand, Gujarat"; // Fallback context
    String customerLoc = widget.orderData['customerAddress'] ?? "Anand, Gujarat";
    mapC.generateRoute(restaurantLoc, customerLoc);
  }

  void _completeDelivery() async {
    // Update the ecosystem that the order is done
    await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
      'status': 'delivered',
      'completedAt': FieldValue.serverTimestamp(),
    });
    Get.back(); // Go back to the radar screen
    Get.snackbar("Delivery Complete", "Great job! Looking for next order.", backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Active Delivery", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (mapC.isLoading.value || mapC.initialCameraPosition.value == null) {
          return const Center(child: CircularProgressIndicator(color: Colors.green));
        }

        return Stack(
          children: [
            // The Google Map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: mapC.initialCameraPosition.value!,
                zoom: 14.0,
              ),
              markers: mapC.markers,
              onMapCreated: (controller) => mapC.mapController = controller,
              myLocationEnabled: true, // Shows the blue dot for the driver's phone
            ),
            
            // The Bottom Action Sheet
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.orderData['customerName'] ?? 'Customer', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.orderData['customerAddress'] ?? '', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: _completeDelivery,
                        child: const Text("MARK DELIVERED", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}

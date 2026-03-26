import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/driver_data_controller.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final dataC = Get.find<DriverDataController>();

    return Scaffold(
      body: Stack(
        children: [
          // Reactive Map: Moves camera to current driver position
          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                dataC.currentPosition.value?.latitude ?? 22.5726, 
                dataC.currentPosition.value?.longitude ?? 72.9289
              ), 
              zoom: 15
            ),
            myLocationEnabled: true,
            mapType: MapType.normal,
          )),

          Positioned(
            bottom: 20, left: 10, right: 10,
            child: Obx(() {
              if (dataC.availableOrders.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                  child: const Text("Searching for orders...", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                );
              }

              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dataC.availableOrders.length,
                  itemBuilder: (context, index) {
                    var order = dataC.availableOrders[index];
                    var orderData = order.data() as Map<String, dynamic>;
                    
                    // Dynamic Distance Calculation
                    double dist = dataC.calculateDistance(
                      orderData['restaurantLat'] ?? 0.0, 
                      orderData['restaurantLng'] ?? 0.0
                    );

                    return Card(
                      color: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        width: 320,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(orderData['restaurantName'] ?? 'Food Pickup', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                Text("${dist.toStringAsFixed(1)} km", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Divider(color: Colors.white12),
                            Text("Dropoff: ${orderData['deliveryAddress'] ?? 'Nearby'}", style: const TextStyle(color: Colors.grey)),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, minimumSize: const Size(double.infinity, 45)),
                              onPressed: () => dataC.acceptOrder(order.id),
                              child: const Text("ACCEPT ORDER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

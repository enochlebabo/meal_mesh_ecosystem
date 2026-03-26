import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/driver_data_controller.dart';

class RestaurantListView extends StatelessWidget {
  const RestaurantListView({super.key});

  @override
  Widget build(BuildContext context) {
    final dataC = Get.find<DriverDataController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text("Partner Restaurants"), backgroundColor: Colors.black),
      body: Obx(() {
        if (dataC.approvedRestaurants.isEmpty) {
          return const Center(child: Text("No partner restaurants yet.", style: TextStyle(color: Colors.grey)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: dataC.approvedRestaurants.length,
          itemBuilder: (context, index) {
            var data = dataC.approvedRestaurants[index].data() as Map<String, dynamic>;
            return Card(
              color: const Color(0xFF1E1E1E),
              child: ListTile(
                leading: const Icon(Icons.restaurant, color: Colors.orange),
                title: Text(data['name'] ?? 'Partner', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(data['address'] ?? 'Anand, Gujarat', style: const TextStyle(color: Colors.grey)),
                trailing: const Icon(Icons.chevron_right, color: Colors.greenAccent),
              ),
            );
          },
        );
      }),
    );
  }
}

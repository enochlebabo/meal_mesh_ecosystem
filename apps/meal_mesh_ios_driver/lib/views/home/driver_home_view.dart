import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/job_controller.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final jobC = Get.put(JobController());

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Professional Dark Mode
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Radar: Live Jobs", style: TextStyle(color: Colors.white)),
        actions: [
          Switch(value: true, activeColor: Colors.green, onChanged: (v) {})
        ],
      ),
      body: Obx(() {
        if (jobC.availableJobs.isEmpty) {
          return const Center(
            child: Text("Waiting for orders...", style: TextStyle(color: Colors.grey, fontSize: 18)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobC.availableJobs.length,
          itemBuilder: (context, index) {
            var doc = jobC.availableJobs[index];
            var data = doc.data() as Map<String, dynamic>;

            return Card(
              color: const Color(0xFF2C2C2C),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("💰 New Delivery", style: TextStyle(color: Colors.greenAccent.shade400, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.grey),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.store, color: Colors.orange),
                      title: Text(data['restaurantName'] ?? 'Unknown', style: const TextStyle(color: Colors.white)),
                      subtitle: const Text("Pickup", style: TextStyle(color: Colors.grey)),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.location_on, color: Colors.red),
                      title: Text(data['customerAddress'] ?? 'No Address', style: const TextStyle(color: Colors.white)),
                      subtitle: const Text("Dropoff", style: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () => jobC.acceptJob(doc.id, data),
                        child: const Text("ACCEPT JOB", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

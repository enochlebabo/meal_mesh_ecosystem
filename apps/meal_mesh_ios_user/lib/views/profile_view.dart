import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(UserController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        title: const Text("My Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: CircleAvatar(radius: 50, backgroundColor: Colors.orange, child: Icon(Icons.person, size: 50, color: Colors.white))),
            const SizedBox(height: 32),
            const Text("Delivery Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            _buildTextField("Full Name", Icons.person_outline, c.nameC),
            const SizedBox(height: 16),
            _buildTextField("Phone Number", Icons.phone_outlined, c.phoneC, isNumber: true),
            const SizedBox(height: 16),
            
            // ADDRESS FIELD WITH MAP BUTTON
            TextField(
              controller: c.addressC,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Delivery Address",
                prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.map, color: Colors.orange),
                  onPressed: () => c.openMapPicker(), // TRIGGERS THE MAP
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.orange, width: 2)),
              ),
            ),
            
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 55, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () => c.updateProfile(), icon: const Icon(Icons.sync, color: Colors.white), label: const Text("SAVE & SYNC", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: TextButton.icon(onPressed: () => c.logout(), icon: const Icon(Icons.logout, color: Colors.red), label: const Text("Sign Out", style: TextStyle(color: Colors.red, fontSize: 16))))
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, color: Colors.grey), filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.orange, width: 2)),
      ),
    );
  }
}

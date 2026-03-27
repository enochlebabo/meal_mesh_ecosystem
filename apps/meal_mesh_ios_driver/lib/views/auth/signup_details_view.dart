import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupDetailsView extends StatelessWidget {
  SignupDetailsView({super.key});

  final nameC = TextEditingController();
  final vehicleC = TextEditingController();
  final addressC = TextEditingController();
  final phoneC = TextEditingController();

  Future<void> _submitDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Syncing exactly with your Firestore screenshot fields
    await FirebaseFirestore.instance.collection('drivers').doc(user.uid).update({
      'name': nameC.text,
      'phone': phoneC.text,
      'vehicle': vehicleC.text,
      'address': addressC.text,
      'isOnline': true, // Setting online as per your DB example
    });

    Get.snackbar("Submitted", "Wait for admin to flip isApproved to true",
      snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
    
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Profile Sync"), backgroundColor: Colors.black),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _input(nameC, "Name", Icons.person),
          _input(phoneC, "Phone", Icons.phone),
          _input(vehicleC, "Vehicle (e.g. pulsar ns 200)", Icons.motorcycle),
          _input(addressC, "Address", Icons.map),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _submitDetails,
            child: const Text("SYNC TO DATABASE"),
          )
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, String l, IconData i) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: l, prefixIcon: Icon(i, color: Colors.greenAccent)),
    );
  }
}

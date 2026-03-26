import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupDetailsView extends StatelessWidget {
  SignupDetailsView({super.key});

  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final vehicleC = TextEditingController();
  final addressC = TextEditingController();
  final phoneC = TextEditingController();

  Future<void> _submitDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('drivers').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': nameC.text,
      'vehicle': vehicleC.text,
      'address': addressC.text,
      'phone': phoneC.text,
      'isApproved': false, // Crucial: Admin must manually flip this
      'isOnline': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    Get.defaultDialog(
      title: "Success",
      middleText: "Your details have been submitted. Please wait for admin approval.",
      onConfirm: () {
        FirebaseAuth.instance.signOut();
        Get.offAllNamed('/login');
      },
      textConfirm: "OK",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Complete Your Profile"), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Welcome to the Fleet!", style: TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Fill in your details to join MealMesh.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              _buildField(nameC, "Full Name", Icons.person),
              _buildField(phoneC, "Phone Number", Icons.phone),
              _buildField(vehicleC, "Vehicle Type (e.g. Pulsar NS 200)", Icons.motorcycle),
              _buildField(addressC, "Residential Address", Icons.home),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: _submitDetails,
                child: const Text("SUBMIT FOR REVIEW", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.greenAccent),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24), borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.greenAccent), borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

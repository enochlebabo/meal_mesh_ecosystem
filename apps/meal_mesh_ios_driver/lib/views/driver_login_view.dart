import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/driver_auth_service.dart';

class DriverLoginView extends StatelessWidget {
  const DriverLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = DriverAuthService.to;
    final emailC = TextEditingController(text: "driver@test.com");
    final passC = TextEditingController(text: "password123");

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.delivery_dining, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              const Text("MealMesh Driver", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 48),

              TextField(
                controller: emailC,
                decoration: InputDecoration(labelText: "Email", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passC,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () => auth.signInWithEmail(emailC.text, passC.text),
                child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () => auth.registerDriver(emailC.text, passC.text, "New Driver"),
                child: const Text("Register as New Driver", style: TextStyle(color: Colors.green)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

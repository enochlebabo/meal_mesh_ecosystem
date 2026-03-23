import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/driver_auth_service.dart';

class DriverLoginView extends StatelessWidget {
  const DriverLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = DriverAuthService.to;

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
              const Text(
                "MealMesh Driver",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                "Earn on your schedule.\nSign in to view your live orders.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // APPLE LOGIN BUTTON
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.apple, size: 24),
                label: const Text("Continue with Apple", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                onPressed: () => auth.signInWithApple(),
              ),
              const SizedBox(height: 16),

              // GOOGLE LOGIN BUTTON
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                // Using a standard flutter icon for speed, normally you'd use a Google logo asset
                icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.red), 
                label: const Text("Continue with Google", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                onPressed: () => auth.signInWithGoogle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

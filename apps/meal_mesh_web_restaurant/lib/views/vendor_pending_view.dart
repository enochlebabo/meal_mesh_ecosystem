import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/vendor_auth_service.dart';

class VendorPendingView extends StatelessWidget {
  const VendorPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.hourglass_empty_rounded, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              const Text("Registration Received!", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text(
                "Your restaurant profile is currently under review by the Mealmesh Admin Team. "
                "You will gain access to your dashboard once your documents are verified.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const Divider(height: 40),
              const Text("Need Help?", style: TextStyle(fontWeight: FontWeight.bold)),
              const Text("Contact: admin@mealmesh.com", style: TextStyle(color: Colors.blue)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => VendorAuthService.to.logout(),
                  child: const Text("Back to Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

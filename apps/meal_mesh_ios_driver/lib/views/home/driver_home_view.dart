import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/driver_auth_service.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<DriverAuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.logout(),
          )
        ],
      ),
      body: const Center(
        child: Text("Welcome to the Fleet Dashboard", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

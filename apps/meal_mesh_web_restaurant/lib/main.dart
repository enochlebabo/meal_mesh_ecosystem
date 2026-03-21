import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'services/vendor_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Load Environment (Added safety check)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found");
  }

  // 2. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // 3. Initialize Auth Service (This handles the navigation logic)
  Get.put(VendorAuthService());
  
  runApp(const MealMeshRestaurantApp());
}

class MealMeshRestaurantApp extends StatelessWidget {
  const MealMeshRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mealmesh Vendor Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      // Set home to a loading screen. 
      // VendorAuthService.onReady() will immediately redirect the user.
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'services/admin_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment first
  await dotenv.load(fileName: ".env");
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Inject Service
  Get.put(AdminAuthService());

  runApp(const MealMeshAdmin());
}

class MealMeshAdmin extends StatelessWidget {
  const MealMeshAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mealmesh Admin',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Auth service will handle the redirection from this loading screen
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

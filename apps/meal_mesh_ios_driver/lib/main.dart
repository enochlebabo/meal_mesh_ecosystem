import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/driver_auth_service.dart';
import 'firebase_options.dart'; // newly generated file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try { 
    await dotenv.load(fileName: ".env"); 
  } catch (e) { 
    debugPrint("No .env found: $e"); 
  }
  
  // Initialize Firebase using the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  
  Get.put(DriverAuthService());
  runApp(const MealMeshDriverApp());
}

class MealMeshDriverApp extends StatelessWidget {
  const MealMeshDriverApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MealMesh Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.green))),
    );
  }
}

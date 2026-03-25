import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'views/home/driver_home_view.dart';
// Assuming your options file is in the root of lib
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase using the existing native config
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Load secrets into memory before the app runs
  await dotenv.load(fileName: ".env");

  runApp(const GetMaterialApp(
    title: 'MealMesh Driver',
    debugShowCheckedModeBanner: false,
    home: DriverHomeView(),
  ));
}

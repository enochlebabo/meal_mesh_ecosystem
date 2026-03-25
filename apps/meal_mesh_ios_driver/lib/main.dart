import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'views/home/driver_home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // By leaving options empty, Firebase automatically reads your iOS GoogleService-Info.plist
  await Firebase.initializeApp();
  
  // Load secrets into memory before the app runs
  await dotenv.load(fileName: ".env");

  runApp(const GetMaterialApp(
    title: 'MealMesh Driver',
    debugShowCheckedModeBanner: false,
    home: DriverHomeView(),
  ));
}

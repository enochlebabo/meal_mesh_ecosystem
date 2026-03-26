import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'routes/app_routes.dart'; 
import 'bindings/initial_binding.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Note: We removed Get.put(AuthService()) here because 
  // it is now handled cleanly inside InitialBinding().
  runApp(const MealMeshUserApp());
}

class MealMeshUserApp extends StatelessWidget {
  const MealMeshUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'MealMesh User',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            useMaterial3: true, // Modern Flutter standard
          ),
          initialBinding: InitialBinding(), // THIS IS THE FIX
          initialRoute: AppRoutes.LOGIN, 
          getPages: AppRoutes.pages, 
        );
      },
    );
  }
}
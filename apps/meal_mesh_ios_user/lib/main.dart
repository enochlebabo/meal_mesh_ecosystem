import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'services/auth_service.dart';
import 'routes/app_routes.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthService());
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
          theme: ThemeData(primarySwatch: Colors.orange),
          // THIS IS KEY: It MUST point to the HOME name, which we just mapped to the Wrapper
          initialRoute: AppRoutes.LOGIN, 
          getPages: AppRoutes.pages, 
        );
      },
    );
  }
}

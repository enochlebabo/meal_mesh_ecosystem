import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/driver_auth_service.dart';
import 'firebase_options.dart';
import 'views/auth/login_view.dart';
import 'views/home/driver_home_view.dart';
import 'views/auth/signup_details_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Environment Init
  try { 
    await dotenv.load(fileName: ".env"); 
  } catch (e) { 
    debugPrint("Build Warning: No .env found. Using native config."); 
  }
  
  // 2. Firebase Init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  
  // 3. Service Injection
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
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.greenAccent,
        scaffoldBackgroundColor: Colors.black,
      ),
      // Use the logic-driven Gate as the starting point
      home: const AuthGate(),
      getPages: [
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(name: '/signup-details', page: () => SignupDetailsView()),
        GetPage(name: '/home', page: () => const DriverHomeView()),
      ],
    );
  }
}

/// Decision Engine: Watches the user stream and decides where to route them
class AuthGate extends GetView<DriverAuthService> {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.user.value;

      // Case 1: Not logged in
      if (user == null) {
        return const LoginView();
      }

      // Case 2: Logged in - The AuthService handles the redirection 
      // to /signup-details or /home based on Firestore approval status.
      // While checking, we show a professional loader.
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.greenAccent),
              SizedBox(height: 20),
              Text("Syncing Fleet Data...", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
    });
  }
}

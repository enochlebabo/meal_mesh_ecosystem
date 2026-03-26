import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'services/driver_auth_service.dart';
import 'views/auth/signup_details_view.dart';
import 'views/home/main_navigation_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

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
      // Define Routes here
      getPages: [
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(name: '/signup-details', page: () => SignupDetailsView()),
        GetPage(name: '/home', page: () => const MainNavigationWrapper()),
      ],
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoginView();
        return const MainNavigationWrapper();
      },
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authS = Get.find<DriverAuthService>();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delivery_dining, size: 100, color: Colors.greenAccent),
            const SizedBox(height: 20),
            const Text("MEALMESH DRIVER", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => authS.signInWithGoogle(),
              icon: const Icon(Icons.login),
              label: const Text("Login with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                foregroundColor: Colors.black,
                minimumSize: const Size(250, 50)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

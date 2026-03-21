import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../views/admin_login_view.dart';
import '../views/admin_dashboard_view.dart';

class AdminAuthService extends GetxService {
  static AdminAuthService get to => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();
    currentUser.bindStream(_auth.authStateChanges());
    ever(currentUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) async {
    if (user == null) {
      Get.offAll(() => const AdminLoginView());
    } else {
      final demoEmail = dotenv.env['ADMIN_EMAIL']?.trim();
      if (user.email == demoEmail) {
        Get.offAll(() => const AdminDashboardView());
        return;
      }
      DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists && doc['role'] == 'admin') {
        Get.offAll(() => const AdminDashboardView());
      } else {
        await logout();
        Get.snackbar("Error", "Unauthorized: Admin role required.");
      }
    }
  }

  Future<void> login(String email, String password) async {
    final envEmail = dotenv.env['ADMIN_EMAIL']?.trim();
    final envPass = dotenv.env['ADMIN_PASSWORD']?.trim();
    if (email.trim() == envEmail && password.trim() == envPass) {
      try {
        await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      } catch (e) {
        if (e.toString().contains('user-not-found')) {
           await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
        } else {
          Get.snackbar("Auth Error", e.toString());
        }
      }
    } else {
      Get.snackbar("Login Failed", "Check .env credentials.");
    }
  }

  Future<void> logout() async => await _auth.signOut();
}

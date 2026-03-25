import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../views/user_login_view.dart'; 
import '../views/user_home_view.dart'; // Adjust if your main screen is named differently

class UserAuthService extends GetxService {
  static UserAuthService get to => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();
    currentUser.bindStream(_auth.authStateChanges());
    // This is the magic line: It listens for logout and forces the redirect
    ever(currentUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) {
    if (user == null) {
      Get.offAll(() => const UserLoginView());
    } else {
      Get.offAll(() => const UserHomeView());
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      // The ever() listener will catch this and instantly route to UserLoginView
    } catch (e) {
      Get.snackbar("Sign Out Error", e.toString());
    }
  }
}

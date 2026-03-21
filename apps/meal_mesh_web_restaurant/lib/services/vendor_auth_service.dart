import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../views/vendor_login_view.dart';
import '../views/vendor_dashboard_view.dart';
import '../views/vendor_pending_view.dart';

class VendorAuthService extends GetxService {
  static VendorAuthService get to => Get.find();
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
      Get.offAll(() => const VendorLoginView());
    } else {
      // Check Firestore for approval status
      DocumentSnapshot doc = await _db.collection('restaurants').doc(user.uid).get();
      
      if (doc.exists) {
        bool isApproved = doc['isApproved'] ?? false;
        if (isApproved) {
          Get.offAll(() => const VendorDashboardView());
        } else {
          Get.offAll(() => const VendorPendingView());
        }
      } else {
        // If Auth exists but no Firestore doc, they might be a Customer trying to sneak in
        await logout();
        Get.snackbar("Access Denied", "No Merchant Profile found. Please register.");
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
    } catch (e) {
      Get.snackbar("Login Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> registerRestaurant({
    required String email, 
    required String password, 
    required String name, 
    required String address
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), 
        password: password.trim()
      );
      
      // Initialize the Restaurant Document
      await _db.collection('restaurants').doc(cred.user!.uid).set({
        'name': name,
        'address': address,
        'email': email.trim(),
        'isApproved': false, // Admin must approve this
        'isOpen': false,
        'image': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
        'rating': 5.0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Mirror to Users collection for Admin management
      await _db.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email.trim(),
        'role': 'vendor',
        'createdAt': FieldValue.serverTimestamp(),
      });
      
    } catch (e) {
      Get.snackbar("Registration Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> logout() async => await _auth.signOut();
}

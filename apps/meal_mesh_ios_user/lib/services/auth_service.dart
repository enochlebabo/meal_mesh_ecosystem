import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../routes/app_routes.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxString userRole = ''.obs;

  @override
  void onReady() {
    super.onReady();
    currentUser.bindStream(_auth.authStateChanges());
    ever(currentUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) async {
    if (user == null) {
      Get.offAllNamed(AppRoutes.LOGIN);
    } else {
      await _fetchUserRole(user.uid);
      if (userRole.value == 'customer') {
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.snackbar("Access Denied", "This app is for customers only.");
        await logout();
      }
    }
  }

  Future<void> _fetchUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        userRole.value = doc['role'] ?? 'customer';
      }
    } catch (e) {
      userRole.value = 'customer';
    }
  }

  Future<void> registerCustomer(String name, String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _db.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error", e.toString());
      rethrow; 
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
      if (googleUser == null) return; 

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
         Get.snackbar("Error", "Missing Google Auth Token");
         return;
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: null, 
      );

      UserCredential userCred = await _auth.signInWithCredential(credential);

      if (userCred.additionalUserInfo?.isNewUser ?? false) {
        await _db.collection('users').doc(userCred.user!.uid).set({
          'name': userCred.user!.displayName ?? 'Google User',
          'email': userCred.user!.email,
          'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      if (e.toString().contains('canceled')) {
        return; 
      }
      Get.snackbar("Google Login Failed", e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> logout() async {
    try {
      // THE FIX: Accessing the instance correctly for release compilation
      await GoogleSignIn.instance.signOut();
      await _auth.signOut();
    } catch (e) {
      Get.snackbar("Sign Out Error", e.toString());
    }
  }
}

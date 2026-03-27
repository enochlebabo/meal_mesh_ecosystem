import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DriverAuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rxn<User> user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred = await _auth.signInWithCredential(credential);
      String uid = userCred.user!.uid;

      // Sync Check: Match fields from your Firestore screenshot
      DocumentSnapshot driverDoc = await _db.collection('drivers').doc(uid).get();
      
      if (!driverDoc.exists) {
        // Create initial record matching your DB structure
        await _db.collection('drivers').doc(uid).set({
          'uid': uid,
          'email': userCred.user!.email,
          'name': userCred.user!.displayName ?? "",
          'isApproved': false, 
          'isOnline': false,
          'address': "",
          'phone': "",
          'vehicle': "",
          'currentLocation': const GeoPoint(22.556, 72.951), // Default from your screenshot
          'createdAt': FieldValue.serverTimestamp(),
        });
        Get.offAllNamed('/signup-details');
      } else {
        bool isApproved = driverDoc.get('isApproved') ?? false;
        if (!isApproved) {
          await logout();
          Get.snackbar("Pending", "Admin approval required.", 
            backgroundColor: Colors.orange, colorText: Colors.white);
        } else {
          Get.offAllNamed('/home');
        }
      }
    } catch (e) {
      Get.snackbar("Auth Error", "Check console for details");
      debugPrint("Auth Error: $e");
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}

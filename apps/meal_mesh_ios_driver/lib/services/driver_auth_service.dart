import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../views/driver_login_view.dart';
import '../views/driver_dashboard_view.dart';
import '../views/driver_pending_view.dart';

class DriverAuthService extends GetxService {
  static DriverAuthService get to => Get.find();
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
      Get.offAll(() => const DriverLoginView());
    } else {
      _db.collection('drivers').doc(user.uid).snapshots().listen((doc) {
        if (doc.exists) {
          bool isApproved = doc['isApproved'] ?? false;
          if (isApproved) {
            Get.offAll(() => const DriverDashboardView());
          } else {
            Get.offAll(() => const DriverPendingView());
          }
        } else {
          // Fallback if document creation fails or is delayed
          Get.offAll(() => const DriverPendingView());
        }
      });
    }
  }

  // --- OAUTH PROVIDERS ---

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential cred = await _auth.signInWithCredential(credential);
      await _checkAndCreateDriverProfile(cred.user!);
    } catch (e) {
      Get.snackbar("Google Sign-In Failed", e.toString());
    }
  }

  Future<void> signInWithApple() async {
    try {
      // Modern Firebase handles the native Apple bottom sheet automatically!
      final appleProvider = AppleAuthProvider();
      UserCredential cred = await _auth.signInWithProvider(appleProvider);
      await _checkAndCreateDriverProfile(cred.user!);
    } catch (e) {
      Get.snackbar("Apple Sign-In Failed", e.toString());
    }
  }

  // --- SECURITY INTERCEPTOR ---
  
  Future<void> _checkAndCreateDriverProfile(User user) async {
    final docRef = _db.collection('drivers').doc(user.uid);
    final docSnap = await docRef.get();

    // If this is their first time logging in, create their restricted profile
    if (!docSnap.exists) {
      await docRef.set({
        'name': user.displayName ?? 'New Driver',
        'email': user.email ?? '',
        'vehicle': 'Pending Details',
        'isApproved': false, // STRICT SECURITY GATE
        'isOnline': false,
        'currentLocation': const GeoPoint(0, 0),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}

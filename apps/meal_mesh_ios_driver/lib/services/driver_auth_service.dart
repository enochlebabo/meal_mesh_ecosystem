import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      // Real-time listener for Admin Approval
      _db.collection('drivers').doc(user.uid).snapshots().listen((doc) {
        if (doc.exists) {
          bool isApproved = doc['isApproved'] ?? false;
          if (isApproved) {
            Get.offAll(() => const DriverDashboardView());
          } else {
            Get.offAll(() => const DriverPendingView());
          }
        } else {
          logout();
        }
      });
    }
  }

  Future<void> registerDriver(String email, String password, String name, String vehicle) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Creates the driver profile (Pending Approval)
      await _db.collection('drivers').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'vehicle': vehicle,
        'isApproved': false,
        'isOnline': false,
        'currentLocation': const GeoPoint(0, 0),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> logout() async => await _auth.signOut();
}

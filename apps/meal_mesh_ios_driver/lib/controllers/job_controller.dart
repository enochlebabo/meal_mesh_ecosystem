import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../views/tracking/map_tracker_view.dart';

class JobController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxList<QueryDocumentSnapshot> availableJobs = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    _db.collection('orders')
       .where('status', isEqualTo: 'pending')
       .snapshots()
       .listen((snapshot) => availableJobs.value = snapshot.docs);
  }

  Future<void> acceptJob(String orderId, Map<String, dynamic> orderData) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'status': 'driver_assigned',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // Navigate to the live map tracker!
      Get.to(() => MapTrackerView(orderId: orderId, orderData: orderData));
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

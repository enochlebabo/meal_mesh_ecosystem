import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RestaurantController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Dynamic list containing ONLY approved restaurants
  final RxList<QueryDocumentSnapshot> restaurants = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchApprovedRestaurants();
  }

  void _fetchApprovedRestaurants() {
    // The .where() clause is the gatekeeper. 
    // It tells Firebase: "Do not send me any document unless isApproved is true."
    restaurants.bindStream(
      _db.collection('restaurants')
         .where('isApproved', isEqualTo: true) 
         // You can chain .where('isActive', isEqualTo: true) here if you want dual-layer control
         .snapshots()
         .map((snapshot) => snapshot.docs)
    );
  }
}

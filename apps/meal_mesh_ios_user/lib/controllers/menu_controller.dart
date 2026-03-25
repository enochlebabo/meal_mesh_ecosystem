import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RestaurantMenuController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Dynamic list of menu items from the specific restaurant sub-collection
  final RxList<QueryDocumentSnapshot> menuItems = <QueryDocumentSnapshot>[].obs;

  void bindMenuStream(String restaurantId) {
    // Only show items where 'isAvailable' is true (set by Admin)
    menuItems.bindStream(
      _db.collection('restaurants')
         .doc(restaurantId)
         .collection('menu')
         .where('isAvailable', isEqualTo: true)
         .snapshots()
         .map((snapshot) => snapshot.docs)
    );
  }
}

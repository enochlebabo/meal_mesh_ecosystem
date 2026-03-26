import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/menu_item_model.dart';

class RestaurantController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  RxList<DocumentSnapshot> restaurants = <DocumentSnapshot>[].obs;
  RxList<MenuItem> menuItems = <MenuItem>[].obs; // Using the model now
  RxBool isLoading = true.obs;
  RxBool isMenuLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLiveRestaurants();
  }

  void fetchLiveRestaurants() {
    _firestore
        .collection('restaurants')
        .where('isApproved', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      restaurants.value = snapshot.docs;
      isLoading.value = false;
    });
  }

  void fetchRestaurantMenu(String restaurantId) {
    isMenuLoading.value = true;
    _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .snapshots()
        .listen((snapshot) {
      menuItems.value = snapshot.docs
          .map((doc) => MenuItem.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      isMenuLoading.value = false;
    });
  }
}

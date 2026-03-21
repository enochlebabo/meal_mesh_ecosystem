import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/data_models.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchLiveRestaurants();
  }

  void _fetchLiveRestaurants() {
    _db.collection('restaurants').where('isApproved', isEqualTo: true).snapshots().listen(
      (snapshot) {
        isLoading.value = false;
        hasError.value = false;
        
        restaurants.value = snapshot.docs.map<RestaurantModel>((doc) {
          final data = doc.data();
          return RestaurantModel(
            id: doc.id,
            name: data['name'] ?? 'Unnamed Restaurant',
            address: data['address'] ?? 'No address provided',
            image: (data['image'] != null && data['image'].toString().isNotEmpty) 
                ? data['image'] 
                : 'https://images.unsplash.com/photo-1550547660-d9450f859349', // Safe fallback
            rating: (data['rating'] ?? 0.0).toDouble(), 
            deliveryTime: data['deliveryTime'] ?? 'Calculating...',
          );
        }).toList();
      },
      onError: (error) {
        isLoading.value = false;
        hasError.value = true;
        Get.snackbar("Network Error", "Unable to connect to the ecosystem.");
      }
    );
  }
}

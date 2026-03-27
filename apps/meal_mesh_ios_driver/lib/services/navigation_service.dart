import 'package:maps_launcher/maps_launcher.dart';
import 'package:get/get.dart';

class NavigationService extends GetxService {
  
  Future<void> launchNavigation({
    required double lat, 
    required double lng, 
    required String title
  }) async {
    try {
      await MapsLauncher.launchCoordinates(lat, lng, title);
    } catch (e) {
      Get.snackbar(
        "Navigation Error", 
        "Could not open maps application.",
        snackPosition: SnackPosition.BOTTOM
      );
    }
  }
}
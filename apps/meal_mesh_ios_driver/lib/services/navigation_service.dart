import 'package:maps_launcher/maps_launcher.dart';
import 'package:get/get.dart';

class NavigationService extends GetxService {
  
  /// Opens the native Maps app and starts turn-by-turn navigation
  Future<void> launchNavigation({
    required double lat, 
    required double lng, 
    required String title
  }) async {
    try {
      // This will open Apple Maps on iOS and Google Maps on Android automatically
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
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';

class MapTrackerController extends GetxController {
  GoogleMapController? mapController;
  
  // Reactive state for the map
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rx<LatLng?> initialCameraPosition = Rx<LatLng?>(null);
  final RxBool isLoading = true.obs;

  Future<void> generateRoute(String pickupAddress, String dropoffAddress) async {
    isLoading.value = true;

    // 1. Convert Text to GPS using Positionstack
    final pickupCoords = await LocationService.getCoordinates(pickupAddress);
    final dropoffCoords = await LocationService.getCoordinates(dropoffAddress);

    if (pickupCoords != null && dropoffCoords != null) {
      final pickupLatLng = LatLng(pickupCoords['lat']!, pickupCoords['lng']!);
      final dropoffLatLng = LatLng(dropoffCoords['lat']!, dropoffCoords['lng']!);

      // 2. Set the initial camera to the restaurant
      initialCameraPosition.value = pickupLatLng;

      // 3. Drop the pins
      markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLatLng,
        infoWindow: const InfoWindow(title: "Restaurant (Pickup)"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));

      markers.add(Marker(
        markerId: const MarkerId('dropoff'),
        position: dropoffLatLng,
        infoWindow: const InfoWindow(title: "Customer (Dropoff)"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));

      // 4. Zoom map to fit both pins
      Future.delayed(const Duration(milliseconds: 500), () {
        mapController?.animateCamera(CameraUpdate.newLatLngBounds(
          _boundsFromLatLngList([pickupLatLng, dropoffLatLng]), 50.0));
      });
    } else {
      Get.snackbar("GPS Error", "Could not locate addresses via Positionstack.");
    }
    
    isLoading.value = false;
  }

  // Helper math to calculate the camera zoom box
  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}

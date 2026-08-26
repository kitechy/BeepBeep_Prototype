import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Request permission for location
  Future<bool> requestPermission() async {
    // Check if location service is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    final locationPermission = await Permission.location.request();

    if (!locationPermission.isGranted) {
      return false;
    }

    return true;
  }

  // Get current location of the device
  Future<Position> getCurrentLocation() async {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  // get location everytime the device moves about 5 meters
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        // report new location when moved about 5 meters
        distanceFilter: 5,
      ),
    );
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GetLocation extends GetxController {
  final geolocator = GeolocatorPlatform.instance;

  Future<bool> get getLocationStatus async {
    return await geolocator.isLocationServiceEnabled();
  }

  Future requestLocationPermission() async {
    await geolocator.requestPermission();
  }

  double? distance(
    double startLat,
    double startLong,
    double endLat,
    double endLong,
  ) {
    try {
      return geolocator.distanceBetween(
        startLat,
        startLong,
        endLat,
        endLong,
      );
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<Map?> getUserLocation() async {
    try {
      Position? position = await geolocator.getCurrentPosition();

      return {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "altitude": position.altitude,
      };
    } catch (err) {
      print(err);
    }
    return null;
  }
}

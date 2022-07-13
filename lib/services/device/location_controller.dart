import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pbl_arm/models/location_model.dart';

class GetLocation {
  final geolocator = GeolocatorPlatform.instance;

  Future<bool> get getLocationStatus async {
    return await geolocator.isLocationServiceEnabled();
  }

  getLocationAsStream(String roomId) async {
    geolocator.getPositionStream().listen(
      (event) async {
        await FirebaseFirestore.instance.collection("rooms").doc(roomId).set(
          {
            "latitude": event.latitude,
            "longitude": event.longitude,
          },
          SetOptions(merge: true),
        );
      },
    );
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
      debugPrint(err.toString());
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
      debugPrint(err.toString());
    }
    return null;
  }
}

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../network/users_api.dart';

class LocationService {
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('[Location] Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('[Location] Permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('[Location] Permission permanently denied.');
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      debugPrint('[Location] Got position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      debugPrint('[Location] Failed to get position: $e');
      return null;
    }
  }

  /// Gets current location and sends it to the backend.
  static Future<void> syncLocationWithBackend() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) return;

      await UsersApi.updateLocation(
        lat: position.latitude,
        lng: position.longitude,
      );
      debugPrint('[Location] Synced with backend.');
    } catch (e) {
      debugPrint('[Location] Failed to sync: $e');
    }
  }
}

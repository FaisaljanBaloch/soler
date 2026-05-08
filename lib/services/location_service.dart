import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for handling location permissions and fetching user coordinates
class LocationService {
  static Future<void> _ensureLocationAccess() async {
    final isLocationServiceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      throw Exception('Location services are disabled.');
    }

    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      final requestedPermission = await Geolocator.requestPermission();
      if (requestedPermission != LocationPermission.whileInUse &&
          requestedPermission != LocationPermission.always) {
        throw Exception('Location permission was denied.');
      }
    } else if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. Please enable it in settings.',
      );
    }
  }

  /// Request location permission from the user
  /// Returns true if permission is granted, false otherwise
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Check if location permission is already granted
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Get current device location (latitude, longitude)
  /// Throws an exception if permission is not granted or location services are disabled
  static Future<({double latitude, double longitude})>
  getCurrentLocation() async {
    try {
      await _ensureLocationAccess();

      // Get the current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return (latitude: position.latitude, longitude: position.longitude);
    } catch (e) {
      rethrow;
    }
  }

  /// Get current position with timeout handling
  static Future<({double latitude, double longitude})>
  getCurrentLocationWithTimeout({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    await _ensureLocationAccess();

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: timeout,
      );

      return (latitude: position.latitude, longitude: position.longitude);
    } catch (error) {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return (latitude: lastKnown.latitude, longitude: lastKnown.longitude);
      }

      throw Exception('Location request timed out.');
    }
  }
}

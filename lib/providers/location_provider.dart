import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/location_service.dart';

/// Provider for user's current location (latitude, longitude)
/// Returns an AsyncValue containing location coordinates or error
final locationProvider =
    FutureProvider<({double latitude, double longitude})>((ref) async {
  return await LocationService.getCurrentLocationWithTimeout();
});

/// Provider to request location permission
final locationPermissionProvider = FutureProvider<bool>((ref) async {
  return await LocationService.requestLocationPermission();
});

/// Provider to check if location permission is granted
final isLocationGrantedProvider = FutureProvider<bool>((ref) async {
  return await LocationService.isLocationPermissionGranted();
});

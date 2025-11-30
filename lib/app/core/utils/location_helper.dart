// ignore_for_file: deprecated_member_use

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Get current device location (latitude & longitude)
Future<Position> getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location service is enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    throw Exception("Location services are disabled.");
  }

  // Check permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception("Location permission permanently denied");
  }

  // Get current location coordinates
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

/// Convert latitude & longitude to full address string
Future<String> getAddressFromLatLong(Position position) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  Placemark place = placemarks.first;

  return "${place.name}, ${place.street}, ${place.subLocality}, ${place.locality}, "
      "${place.administrativeArea}, ${place.country} - ${place.postalCode}";
}

/// One-shot function: directly get address without handling position separately
Future<String> getCurrentAddress() async {
  Position position = await getCurrentPosition();
  return await getAddressFromLatLong(position);
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:network_info_plus/network_info_plus.dart';

class LocationInfo {
  final String? localIP;
  final String? publicIP;
  final double? latitude;
  final double? longitude;
  final String? address;
  final Map<String, dynamic>? ipLocationData;

  LocationInfo({
    this.localIP,
    this.publicIP,
    this.latitude,
    this.longitude,
    this.address,
    this.ipLocationData,
  });

  Map<String, dynamic> toJson() => {
    "local_ip": localIP,
    "public_ip": publicIP,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "ip_location_data": ipLocationData,
  };
}

class LocationService {
  static final Dio _dio = Dio();
  static final NetworkInfo _networkInfo = NetworkInfo();

  /// Get local IP address
  static Future<String?> getLocalIP() async {
    try {
      return await _networkInfo.getWifiIP();
    } catch (_) {
      return null;
    }
  }

  /// Get public IP address
  static Future<String?> getPublicIP() async {
    try {
      final response = await _dio.get("https://api.ipify.org?format=json");
      return response.data["ip"];
    } catch (_) {
      return null;
    }
  }

  /// Get location from public IP
  static Future<Map<String, dynamic>?> getLocationFromIP(String ip) async {
    try {
      final response = await _dio.get("https://ip-api.com/json/$ip");
      return response.data;
    } catch (_) {
      return null;
    }
  }

  /// Get current position
  static Future<Position?> getCurrentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get address from latitude and longitude
  static Future<String?> getAddress(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.name} ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get full location info
  static Future<LocationInfo> getLocationInfo() async {
    final localIP = await getLocalIP();
    final publicIP = await getPublicIP();
    final ipLocationData =
        publicIP != null ? await getLocationFromIP(publicIP) : null;
    final position = await getCurrentPosition();
    
    String? address;
    double? latitude;
    double? longitude;
    debugPrint("Position: $position");
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;
      debugPrint("Latitude: $latitude, Longitude: $longitude");
      address = await getAddress(latitude, longitude);
    }
    return LocationInfo(
      localIP: localIP,
      publicIP: publicIP,
      latitude: latitude,
      longitude: longitude,
      address: address,
      ipLocationData: ipLocationData,
    );
  }
}
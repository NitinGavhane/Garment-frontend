import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  Position? _position;
  String _address = '';
  bool _permissionGranted = false;
  bool _isLoading = false;

  Position? get position => _position;
  String get address => _address;
  bool get permissionGranted => _permissionGranted;
  bool get isLoading => _isLoading;

  Future<void> requestLocation() async {
    _isLoading = true;
    notifyListeners();

    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _permissionGranted = true;
      try {
        _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        await _reverseGeocode();
      } catch (e) {
        _address = 'Location unavailable';
      }
    } else {
      _permissionGranted = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _reverseGeocode() async {
    if (_position == null) return;
    try {
      final placemarks = await placemarkFromCoordinates(
        _position!.latitude,
        _position!.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = <String>[
          if (place.subLocality != null && place.subLocality!.isNotEmpty)
            place.subLocality!,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality!,
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty)
            place.administrativeArea!,
        ];
        _address = parts.isNotEmpty ? parts.join(', ') : 'Unknown location';
      } else {
        _address = 'Unknown location';
      }
    } catch (e) {
      _address = '${_position!.latitude.toStringAsFixed(4)}, ${_position!.longitude.toStringAsFixed(4)}';
    }
  }
}

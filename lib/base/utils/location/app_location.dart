import 'package:geolocator/geolocator.dart';

abstract class AppLocation {
  Future<Position> get position;
  Future<LocationPermission> get permission;
  Future<LocationPermission> requestPermission();
}

class AppLocationImpl implements AppLocation {
  @override
  Future<Position> get position => Geolocator.getCurrentPosition();

  @override
  Future<LocationPermission> get permission => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }
}

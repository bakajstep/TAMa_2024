import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const _lastLatitudeKey = 'lastLatitude';
  static const _lastLongitudeKey = 'lastLongitude';

  Future<LatLng?> getLastKnownPosition() async {
    final pref = await SharedPreferences.getInstance();
    final double? lat = pref.getDouble(_lastLatitudeKey);
    final double? lon = pref.getDouble(_lastLongitudeKey);

    if (lat != null && lon != null) {
      return LatLng(lat, lon);
    }
    return null;
  }

  Future<void> saveLastKnownPosition(LatLng position) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setDouble(_lastLatitudeKey, position.latitude);
    await pref.setDouble(_lastLongitudeKey, position.longitude);
  }

  Future<bool> isLocationServiceEnabled() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(distanceFilter: 2),
    );
  }
}

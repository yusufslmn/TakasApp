import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  late bool servicePermission = false;
  late LocationPermission permission;

  Future<Position>? getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<Placemark?> getPlaceMark(currentLocation) async {
    final List<Placemark> placeMarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    if (placeMarks.isNotEmpty) {
      return placeMarks[0];
    }
    return null;
  }
}

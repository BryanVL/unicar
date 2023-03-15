import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:unicar/models/interfaces/geolocation_interface.dart';
import 'package:geocoding/geocoding.dart';

class GeolocationNative implements Geolocation {
  @override
  Future<LatLng?> coordenadasDesdeLugar(String lugar) async {
    List<Location> locations = await locationFromAddress(lugar);
    LatLng? res;
    if (locations.isNotEmpty) {
      res = LatLng(locations[0].latitude, locations[0].longitude);
    }
    return Future.value(res);
  }

  @override
  double distanciaEntreDosPuntos(LatLng punto1, LatLng punto2) {
    return Geolocator.distanceBetween(
        punto1.latitude, punto1.longitude, punto2.latitude, punto2.longitude);
  }

  @override
  Future<Position?> localizacionActualDelUsuario() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return Geolocator.getLastKnownPosition();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.value(
          Position(
            longitude: -4.42034000,
            latitude: 36.72016000,
            timestamp: DateTime.now(),
            accuracy: 1,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 1,
          ),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.value(
        Position(
          longitude: -4.42034000,
          latitude: 36.72016000,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 1,
        ),
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<String?> lugarDesdeCordenadas(LatLng coordenadas) async {
    List<Placemark> locations =
        await placemarkFromCoordinates(coordenadas.latitude, coordenadas.longitude);
    String? res;
    if (locations.isNotEmpty) {
      res = '${locations[0].street}, ${locations[0].locality}';
    }
    return Future.value(res);
  }
}

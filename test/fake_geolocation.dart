import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:unicar/models/interfaces/geolocation_interface.dart';

class GeolocationFake implements Geolocation {
  @override
  Future<LatLng?> coordenadasDesdeLugar(String lugar) async {
    return Future.value(LatLng(36.72016, -4.42034));
  }

  @override
  double distanciaEntreDosPuntos(LatLng punto1, LatLng punto2) {
    return 100;
  }

  @override
  Future<Position?> localizacionActualDelUsuario() async {
    return Future.value(
      Position(
        latitude: 36.72016,
        longitude: -4.42034,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 1,
      ),
    );
  }

  @override
  Future<Map<String, String>?> lugarDesdeCordenadas(LatLng coordenadas) async {
    return Future.value({'calle': 'Una calle', 'localidad': 'Malaga'});
  }
}

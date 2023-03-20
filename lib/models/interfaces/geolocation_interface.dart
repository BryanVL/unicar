import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

abstract class Geolocation {
  Future<Position?> localizacionActualDelUsuario();
  double distanciaEntreDosPuntos(LatLng punto1, LatLng punto2);
  Future<Map<String, String>?> lugarDesdeCordenadas(LatLng coordenadas);
  Future<LatLng?> coordenadasDesdeLugar(String lugar);
}

import 'package:latlong2/latlong.dart';

class LocalizacionPersonalizada {
  final String nombreCompleto;
  final String localidad;
  final LatLng coordenadas;
  final int radio;

  LocalizacionPersonalizada({
    required this.nombreCompleto,
    required this.localidad,
    required this.coordenadas,
    required this.radio,
  });
}

enum TipoPosicion { origen, destino }

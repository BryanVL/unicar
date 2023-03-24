import 'package:latlong2/latlong.dart';

class Usuario {
  final String id;
  final String nombre;
  final String? tituloDefecto;
  final String? descripcionDefecto;
  final String? origenDefecto;
  final String? destinoDefecto;
  final LatLng? coordOrigenDefecto;
  final int? radioOrigenDefecto;
  final LatLng? coordDestinoDefecto;
  final int? radioDestinoDefecto;
  final String? urlIcono;

  Usuario({
    required this.id,
    required this.nombre,
    this.tituloDefecto,
    this.descripcionDefecto,
    this.origenDefecto,
    this.destinoDefecto,
    this.coordOrigenDefecto,
    this.radioOrigenDefecto,
    this.coordDestinoDefecto,
    this.radioDestinoDefecto,
    this.urlIcono,
  });

  Usuario.fromKeyValue(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'] ?? '',
        tituloDefecto = json['titulo_defecto'],
        descripcionDefecto = json['descripcion_defecto'],
        origenDefecto = json['origen_defecto'],
        destinoDefecto = json['destino_defecto'],
        coordOrigenDefecto = json['latitud_origen_defecto'] == null
            ? null
            : LatLng(json['latitud_origen_defecto'] as double,
                json['longitud_origen_defecto'] as double),
        coordDestinoDefecto = json['latitud_destino_defecto'] == null
            ? null
            : LatLng(json['latitud_destino_defecto'] as double,
                json['longitud_destino_defecto'] as double),
        radioOrigenDefecto = json['radio_origen_defecto'],
        radioDestinoDefecto = json['radio_destino_defecto'],
        urlIcono = json['url_icono'];

  copyWith({
    String? nombre,
    String? tituloDefecto,
    String? descripcionDefecto,
    String? origenDefecto,
    String? destinoDefecto,
    LatLng? coordOrigenDefecto,
    int? radioOrigenDefecto,
    LatLng? coordDestinoDefecto,
    int? radioDestinoDefecto,
    String? urlIcono,
  }) {
    return Usuario(
      id: id,
      nombre: nombre ?? this.nombre,
      tituloDefecto: tituloDefecto ?? this.tituloDefecto,
      descripcionDefecto: descripcionDefecto ?? this.descripcionDefecto,
      origenDefecto: origenDefecto ?? this.origenDefecto,
      destinoDefecto: destinoDefecto ?? this.destinoDefecto,
      coordOrigenDefecto: coordOrigenDefecto ?? this.coordOrigenDefecto,
      coordDestinoDefecto: coordDestinoDefecto ?? this.coordDestinoDefecto,
      radioOrigenDefecto: radioOrigenDefecto ?? this.radioOrigenDefecto,
      radioDestinoDefecto: radioDestinoDefecto ?? this.radioDestinoDefecto,
      urlIcono: urlIcono ?? this.urlIcono,
    );
  }
}

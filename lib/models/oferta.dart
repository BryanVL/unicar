import 'package:latlong2/latlong.dart';
import 'package:unicar/models/usuario.dart';

class Oferta {
  final int id;
  final String? creadoEn;
  final String origen;
  final String destino;
  final LatLng? coordOrigen;
  final int? radioOrigen;
  final LatLng? coordDestino;
  final int? radioDestino;
  final String hora;
  final int plazasTotales;
  final int plazasDisponibles;
  final String? titulo;
  final String? descripcion;
  final Usuario creador;
  final bool paraEstarA;
  final bool esPeriodico;

  Oferta({
    required this.id,
    this.creadoEn,
    required this.origen,
    required this.destino,
    this.coordOrigen,
    this.radioOrigen,
    this.coordDestino,
    this.radioDestino,
    required this.hora,
    required this.plazasTotales,
    required this.plazasDisponibles,
    this.titulo,
    this.descripcion,
    required this.creador,
    required this.paraEstarA,
    required this.esPeriodico,
  });

  Oferta.fromKeyValue(Map<String, dynamic> json)
      : id = json['id'] as int,
        origen = json['origen']!,
        destino = json['destino']!,
        hora = json['hora']!,
        creadoEn = json['created_at'],
        creador = Usuario(
          id: json['creado_por'],
          nombre: json['usuario']['nombre'],
          urlIcono: json['usuario']['url_icono'],
        ),
        descripcion = json['descripcion'],
        coordOrigen = json['latitud_origen'] == null
            ? null
            : LatLng(json['latitud_origen'] as double, json['longitud_origen'] as double),
        radioOrigen = json['radio_origen'] as int?,
        coordDestino = json['latitud_destino'] == null
            ? null
            : LatLng(json['latitud_destino'] as double, json['longitud_destino'] as double),
        radioDestino = json['radio_destino'] as int?,
        plazasDisponibles = json['plazas_disponibles'] as int,
        plazasTotales = json['plazas_totales'] as int,
        titulo = (json['titulo'] == null || json['titulo'] == '')
            ? 'Viaje a ${json['destino']}'
            : json['titulo'],
        paraEstarA = json['para_estar_a'],
        esPeriodico = json['es_periodico'];

  Oferta copyWith({
    String? creadoEn,
    String? origen,
    String? destino,
    LatLng? coordOrigen,
    int? radioOrigen,
    LatLng? coordDestino,
    int? radioDestino,
    String? hora,
    int? plazasTotales,
    int? plazasDisponibles,
    String? titulo,
    String? descripcion,
    Usuario? creador,
    bool? paraEstarA,
    bool? esPeriodico,
  }) {
    return Oferta(
      id: id,
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      hora: hora ?? this.hora,
      creadoEn: creadoEn ?? this.creadoEn,
      descripcion: descripcion ?? this.descripcion,
      coordOrigen: coordOrigen ?? this.coordOrigen,
      radioOrigen: radioOrigen ?? this.radioOrigen,
      coordDestino: coordDestino ?? this.coordDestino,
      radioDestino: radioDestino ?? this.radioDestino,
      plazasDisponibles: plazasDisponibles ?? this.plazasDisponibles,
      plazasTotales: plazasTotales ?? this.plazasTotales,
      titulo: titulo ?? this.titulo,
      creador: creador ?? this.creador,
      paraEstarA: paraEstarA ?? this.paraEstarA,
      esPeriodico: esPeriodico ?? this.esPeriodico,
    );
  }

  Oferta copyWithWithoutCoords({
    String? creadoEn,
    String? origen,
    String? destino,
    LatLng? coordOrigen,
    int? radioOrigen,
    LatLng? coordDestino,
    int? radioDestino,
    String? hora,
    int? plazasTotales,
    int? plazasDisponibles,
    String? titulo,
    String? descripcion,
    Usuario? creador,
    bool? paraEstarA,
    bool? esPeriodico,
  }) {
    return Oferta(
      id: id,
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      hora: hora ?? this.hora,
      creadoEn: creadoEn ?? this.creadoEn,
      descripcion: descripcion ?? this.descripcion,
      coordOrigen: coordOrigen,
      radioOrigen: radioOrigen,
      coordDestino: coordDestino,
      radioDestino: radioDestino,
      plazasDisponibles: plazasDisponibles ?? this.plazasDisponibles,
      plazasTotales: plazasTotales ?? this.plazasTotales,
      titulo: titulo ?? this.titulo,
      creador: creador ?? this.creador,
      paraEstarA: paraEstarA ?? this.paraEstarA,
      esPeriodico: esPeriodico ?? this.esPeriodico,
    );
  }

  static List<Oferta> fromList(List datos) {
    return datos.map((e) => Oferta.fromKeyValue(e)).toList();
  }

  static const List<String> ubicaciones = [
    'Selecciona uno',
    'Torremolinos',
    'Teatinos',
    'Fuengirola',
    'Ampliación de Teatinos',
    'Benalmadena',
    'Alhaurin de la torre',
  ];
}

enum TipoViaje { propio, apuntado, oferta }

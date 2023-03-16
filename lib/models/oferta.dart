import 'package:flutter/material.dart';

class Oferta {
  final int id;
  final String? creadoEn;
  final String origen;
  final String destino;
  final double? latitudOrigen;
  final double? longitudOrigen;
  final double? latitudDestino;
  final double? longitudDestino;
  final String hora;
  final int plazasTotales;
  final int plazasDisponibles;
  final String? titulo;
  final String? descripcion;
  final String creadoPor;
  final String nombreCreador;

  Oferta({
    required this.id,
    this.creadoEn,
    required this.origen,
    required this.destino,
    this.latitudOrigen,
    this.longitudOrigen,
    this.latitudDestino,
    this.longitudDestino,
    required this.hora,
    required this.plazasTotales,
    required this.plazasDisponibles,
    this.titulo,
    this.descripcion,
    required this.creadoPor,
    required this.nombreCreador,
  });

  Oferta.fromKeyValue(Map<String, dynamic> json)
      : id = json['id'] as int,
        origen = json['origen']!,
        destino = json['destino']!,
        hora = json['hora_inicio']!,
        creadoEn = json['created_at'],
        creadoPor = json['creado_por'],
        descripcion = json['descripcion'],
        latitudDestino = json['latitud_destino'] as double?,
        latitudOrigen = json['latitud_origen'] as double?,
        longitudDestino = json['longitud_destino'] as double?,
        longitudOrigen = json['longitud_origen'] as double?,
        nombreCreador = json['usuario']['nombre'],
        plazasDisponibles = json['plazas_disponibles'] as int,
        plazasTotales = json['plazas_totales'] as int,
        titulo = (json['titulo'] == null || json['titulo'] == '')
            ? 'Viaje a ${json['destino']}'
            : json['titulo'];

  Oferta copyWith({
    String? creadoEn,
    String? origen,
    String? destino,
    double? latitudOrigen,
    double? longitudOrigen,
    double? latitudDestino,
    double? longitudDestino,
    String? hora,
    int? plazasTotales,
    int? plazasDisponibles,
    String? titulo,
    String? descripcion,
    String? creadoPor,
    String? nombreCreador,
  }) {
    return Oferta(
      id: id,
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      hora: hora ?? this.hora,
      creadoEn: creadoEn ?? this.creadoEn,
      descripcion: descripcion ?? this.descripcion,
      latitudDestino: latitudDestino ?? this.latitudDestino,
      latitudOrigen: latitudOrigen ?? this.latitudOrigen,
      longitudDestino: longitudDestino ?? this.longitudDestino,
      longitudOrigen: longitudOrigen ?? this.longitudOrigen,
      plazasDisponibles: plazasDisponibles ?? this.plazasDisponibles,
      plazasTotales: plazasTotales ?? this.plazasTotales,
      titulo: titulo ?? this.titulo,
      creadoPor: creadoPor ?? this.creadoPor,
      nombreCreador: nombreCreador ?? this.nombreCreador,
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

  static final listaUbicaciones = ubicaciones
      .map(
        (ubicacion) => DropdownMenuItem(
          alignment: Alignment.center,
          value: ubicacion,
          child: Text(
            ubicacion,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      )
      .toList();
}

enum TipoViaje { propio, apuntado, oferta }

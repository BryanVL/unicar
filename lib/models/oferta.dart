import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Oferta {
  final int id;
  final String? creadoEn;
  final String origen;
  final String destino;
  final LatLng? coordOrigen;
  final LatLng? coordDestino;
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
    this.coordOrigen,
    this.coordDestino,
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
        hora = json['hora']!,
        creadoEn = json['created_at'],
        creadoPor = json['creado_por'],
        descripcion = json['descripcion'],
        coordOrigen = json['latitud_origen'] == null
            ? null
            : LatLng(json['latitud_origen'] as double, json['longitud_origen'] as double),
        coordDestino = json['latitud_destino'] == null
            ? null
            : LatLng(json['latitud_destino'] as double, json['longitud_destino'] as double),
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
    LatLng? coordOrigen,
    LatLng? coordDestino,
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
      coordOrigen: coordOrigen ?? this.coordOrigen,
      coordDestino: coordDestino ?? this.coordDestino,
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

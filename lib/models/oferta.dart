import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Oferta {
  final int id;
  final DateTime? creadoEn;
  final String origen;
  final String destino;
  final double? latitudOrigen;
  final double? longitudOrigen;
  final double? latitudDestino;
  final double? longitudDestino;
  final String hora;
  final int? plazasTotales;
  final int? plazasDisponibles;
  final String? titulo;
  final String? descripcion;
  final String? urlIcono;
  final int? creadoPor;
  final String? nombreCreador;

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
    this.plazasTotales,
    this.plazasDisponibles,
    this.titulo,
    this.descripcion,
    this.creadoPor,
    this.nombreCreador,
    this.urlIcono,
  });

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

  //Oferta.fromDatabase();
  final supabase = Supabase.instance.client;
  Future<Oferta?> recogerDatos() async {
    final data = await supabase.from('Viaje').select(
          'id,created_at,Origen,Destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_ocupadas,descripcion, creado_por',
        );
    print(data);
  }

  static Future<void> nuevoViaje(String origen, String destino, String hora, String plazas,
      String descripcion, String titulo, int usuario) async {
    await Supabase.instance.client.from('Viaje').insert({
      'Origen': origen,
      'Destino': destino,
      'hora_inicio': hora,
      'plazas_totales': plazas,
      'plazas_disponibles': plazas,
      'descripcion': descripcion,
      'titulo': titulo,
      'creado_por': usuario
    });
  }

  static Future<List> datosExtra(int id) async {
    return await Supabase.instance.client
        .from('Viaje')
        .select(
          'plazas_disponibles, descripcion, Usuario!Viaje_creado_por_fkey(nombre)',
        )
        .eq('id', id);
  }
}

enum TipoViaje { propio, apuntado, oferta }

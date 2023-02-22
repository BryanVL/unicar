import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final int? plazasTotales;
  final int? plazasDisponibles;
  final String? titulo;
  final String? descripcion;
  final String? urlIcono;
  final String? creadoPor;
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
        nombreCreador = '',
        plazasDisponibles = json['plazas_disponibles'] as int?,
        plazasTotales = json['plazas_totales'] as int?,
        titulo = json['titulo'],
        urlIcono = '';

  static List<Oferta> fromList(List datos) {
    return datos.map((e) => Oferta.fromKeyValue(e)).toList();
  }

  /* static List<Oferta> fromList2(List datos) async {
    
    final List<Oferta>viajes = datos.map((e) => Oferta.fromKeyValue(e)).toList();
    final List pasajero = await Supabase.instance.client.from('Es_pasajero').select('*');
    pasajero.map((e) => e['']);
    return 
  }*/

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
    final data = await supabase.from('viaje').select(
          'id,created_at,Origen,Destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_ocupadas,descripcion, creado_por',
        );
    print(data);
  }

  static Future<void> nuevoViaje(String origen, String destino, String hora, String plazas,
      String descripcion, String titulo, String usuario) async {
    await Supabase.instance.client.from('viaje').insert({
      'origen': origen,
      'destino': destino,
      'hora_inicio': hora,
      'plazas_totales': plazas,
      'plazas_disponibles': plazas,
      'descripcion': descripcion,
      'titulo': titulo,
      'creado_por': usuario
    });
  }

  static Future<void> eliminarViaje(int id) async {
    final db = Supabase.instance.client;
    await db.from('es_pasajero').delete().match({'id_viaje': id});
    await db.from('viaje').delete().match({'id': id});
  }

  static Future<void> reservarPlaza(int id, int plazas, String idUSer) async {
    if (plazas > 0) {
      final db = Supabase.instance.client;
      await db.from('viaje').update({'plazas_disponibles': plazas - 1}).match({'id': id});
      await db.from('es_pasajero').insert(
        {
          'id_viaje': id,
          'id_usuario': idUSer,
        },
      );
    }
  }

  static Future<void> cancelarPlaza(int id, int plazas, String idUSer) async {
    final db = Supabase.instance.client;
    await db.from('es_pasajero').delete().match({'id_viaje': id, 'id_usuario': idUSer});
    await db.from('viaje').update({'plazas_disponibles': plazas + 1}).match({'id': id});
  }

  static Future<List<int>> idsDeViajeApuntado(String id) async {
    return await Supabase.instance.client
        .from(
          'es_pasajero',
        )
        .select(
          'id_viaje',
        )
        .match(
      {'id_usuario': id},
    );
  }

  static Future<void> actualizarViaje(
    int idViaje,
    String origen,
    String destino,
    String plazasTotales,
    String hora,
    String titulo,
    String descripcion,
  ) async {
    final db = Supabase.instance.client;
    await db.from('viaje').update({
      'origen': origen,
      'destino': destino,
      'plazas_totales': plazasTotales,
      'hora_inicio': hora,
      'titulo': titulo,
      'descripcion': descripcion,
    }).match({'id': idViaje});
  }

//TODO eliminar esta funcion
  static Future<List> datosExtra(int id) async {
    return await Supabase.instance.client
        .from('viaje')
        .select(
          'plazas_totales,plazas_disponibles, descripcion, usuario!viaje_creado_por_fkey(nombre, id)',
        )
        .eq('id', id);
  }
}

enum TipoViaje { propio, apuntado, oferta }

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
  final int? creadoPor;
  final String? nombreCreador;
  //final List<int>? usuariosApuntados;

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
    //this.usuariosApuntados,
  });

  Oferta.fromKeyValue(Map<String, dynamic> json)
      : id = json['id'] as int,
        origen = json['Origen']!,
        destino = json['Destino']!,
        hora = json['hora_inicio']!,
        creadoEn = json['created_at'],
        creadoPor = json['creado_por'] as int,
        descripcion = json['descripcion'],
        latitudDestino = json['latitud_destino'] as double?,
        latitudOrigen = json['latitud_origen'] as double?,
        longitudDestino = json['longitud_destino'] as double?,
        longitudOrigen = json['longitud_origen'] as double?,
        nombreCreador = '',
        plazasDisponibles = json['plazas_disponibles'] as int,
        plazasTotales = json['plazas_totales'] as int,
        titulo = json['titulo'],
        urlIcono = '';
  // usuariosApuntados = json[0]['usuarios_apuntados'];

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

  static Future<void> eliminarViaje(int id) async {
    final db = Supabase.instance.client;
    await db.from('Es_pasajero').delete().match({'Id_viaje': id});
    await db.from('Viaje').delete().match({'id': id});
  }

  static Future<void> reservarPlaza(int id, int plazas, int idUSer) async {
    if (plazas > 0) {
      final db = Supabase.instance.client;
      await db.from('Viaje').update({'plazas_disponibles': plazas - 1}).match({'id': id});
      await db.from('Es_pasajero').insert(
        {
          'Id_viaje': id,
          'id_usuario': idUSer,
        },
      );
    }
  }

  static Future<void> cancelarPlaza(int id, int plazas, int idUSer) async {
    final db = Supabase.instance.client;
    await db.from('Es_pasajero').delete().match({'Id_viaje': id, 'id_usuario': idUSer});
    await db.from('Viaje').update({'plazas_disponibles': plazas + 1}).match({'id': id});
  }

  static Future<List<int>> idsDeViajeApuntado(int id) async {
    return await Supabase.instance.client
        .from(
          'Es_pasajero',
        )
        .select(
          'Id_viaje',
        )
        .match(
      {'id_usuario': 1},
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
    await db.from('Viaje').update({
      'Origen': origen,
      'Destino': destino,
      'plazas_totales': plazasTotales,
      'hora_inicio': hora,
      'titulo': titulo,
      'descripcion': descripcion,
    }).match({'id': idViaje});
  }

  static Future<List> datosExtra(int id) async {
    return await Supabase.instance.client
        .from('Viaje')
        .select(
          'plazas_totales,plazas_disponibles, descripcion, Usuario!Viaje_creado_por_fkey(nombre, id)',
        )
        .eq('id', id);
  }
}

enum TipoViaje { propio, apuntado, oferta }

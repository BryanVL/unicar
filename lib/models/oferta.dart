import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Oferta {
  final int id;
  final DateTime creadoEn;
  final String origen;
  final String destino;
  final double latitudOrigen;
  final double longitudOrigen;
  final double latitudDestino;
  final double longitudDestino;
  final String hora;
  final int plazasTotales;
  final int plazasOcupadas;
  final String descripcion;
  final int creadoPor;

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

  Oferta(
    this.id,
    this.creadoEn,
    this.origen,
    this.destino,
    this.latitudOrigen,
    this.longitudOrigen,
    this.latitudDestino,
    this.longitudDestino,
    this.hora,
    this.plazasTotales,
    this.plazasOcupadas,
    this.descripcion,
    this.creadoPor,
  );

  //Oferta.fromDatabase();
  final supabase = Supabase.instance.client;
  Future<Oferta?> recogerDatos() async {
    final data = await supabase.from('Viaje').select(
          'id,created_at,Origen,Destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_ocupadas,descripcion, creado_por',
        );
    print(data);
  }

  static Future<void> nuevoViaje(String origen, String destino, String hora, String plazas,
      String descripcion, usuario) async {
    await Supabase.instance.client.from('Viaje').insert({
      'Origen': origen,
      'Destino': destino,
      'hora_inicio': hora,
      'plazas_totales': plazas,
      'descripcion': descripcion,
      'creado_por': usuario
    });
  }
}

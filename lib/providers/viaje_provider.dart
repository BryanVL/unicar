import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/tarjetaViaje.dart';

final dataTarjetasViajesOferta = FutureProvider<List<TarjetaViaje>>((ref) async {
  final List contenido = await Supabase.instance.client
      .from(
        'Viaje',
      )
      .select(
        'id,Origen,Destino,hora_inicio, titulo',
      )
      .neq(
        'creado_por',
        1,
      )
      .order('created_at');

  final List<TarjetaViaje> res = contenido.map(
    (elemento) {
      return TarjetaViaje(
        id: elemento['id'],
        origen: elemento['Origen'],
        destino: elemento['Destino'],
        fechaHora: elemento['hora_inicio'],
        titulo: elemento['titulo'],
      );
    },
  ).toList();

  return res;
});

final dataTarjetasViajesUsuario = FutureProvider<List<TarjetaViaje>>((ref) async {
  final List contenido = await Supabase.instance.client
      .from(
        'Viaje',
      )
      .select(
        'id,Origen,Destino,hora_inicio, titulo',
      )
      .eq(
        'creado_por',
        1,
      )
      .order(
        'created_at',
      );

  final List<TarjetaViaje> res = contenido.map(
    (elemento) {
      return TarjetaViaje(
        id: elemento['id'],
        origen: elemento['Origen'],
        destino: elemento['Destino'],
        fechaHora: elemento['hora_inicio'],
        titulo: elemento['titulo'],
      );
    },
  ).toList();

  return res;
});

final dataTarjetasViajesApuntado = FutureProvider<List<TarjetaViaje>>((ref) async {
  final List contenido = await Supabase.instance.client
      .from(
        'Es_pasajero',
      )
      .select(
        'Viaje(id,Origen,Destino,hora_inicio,titulo)',
      )
      .eq(
        'id_usuario',
        1,
      );

  final List<TarjetaViaje> res = contenido.map(
    (elemento) {
      return TarjetaViaje(
        id: elemento['Viaje']['id'],
        origen: elemento['Viaje']['Origen'],
        destino: elemento['Viaje']['Destino'],
        fechaHora: elemento['Viaje']['hora_inicio'],
        titulo: elemento['Viaje']['titulo'],
      );
    },
  ).toList();

  return res;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/tarjetaViaje.dart';

final dataTarjetasViajesOferta = FutureProvider<List<TarjetaViaje>>((ref) async {
  final List contenido = await Supabase.instance.client
      .from(
        'Viaje',
      )
      .select(
        'id,Origen,Destino,hora_inicio',
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
        'id,Origen,Destino,hora_inicio',
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
        'Viaje(id,Origen,Destino,hora_inicio)',
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
      );
    },
  ).toList();

  return res;
});

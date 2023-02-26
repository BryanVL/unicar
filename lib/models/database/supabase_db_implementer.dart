import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/database/database_interface.dart';

class SupabaseDB implements Database {
  final sp = Supabase.instance.client;

  @override
  void actualizarViaje(
    int idViaje,
    String origen,
    String destino,
    String plazasTotales,
    String hora,
    String titulo,
    String descripcion,
  ) async {
    await sp.from('viaje').update({
      'origen': origen,
      'destino': destino,
      'plazas_totales': plazasTotales,
      'hora_inicio': hora,
      'titulo': titulo,
      'descripcion': descripcion,
    }).match({'id': idViaje});
  }

  @override
  void cancelarPlaza(int id, int plazas, String idUSer) async {
    await sp.from('es_pasajero').delete().match({'id_viaje': id, 'id_usuario': idUSer});
    await sp.from('viaje').update({'plazas_disponibles': plazas + 1}).match({'id': id});
  }

  @override
  void crearViaje(
    String origen,
    String destino,
    String hora,
    String plazas,
    String descripcion,
    String titulo,
    String usuario,
  ) async {
    await sp.from('viaje').insert({
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

  @override
  void eliminarViaje(int id) async {
    await sp.from('es_pasajero').delete().match({'id_viaje': id});
    await sp.from('viaje').delete().match({'id': id});
  }

  @override
  Future<List> recogerViajeRecienCreado(String idUser, String hora) async {
    return await sp
        .from('viaje')
        .select(
          'id, created_at, origen, destino, latitud_origen, longitud_origen, latitud_destino, longitud_destino, hora_inicio, plazas_totales, plazas_disponibles, descripcion, creado_por, titulo, usuario!viaje_creado_por_fkey(nombre)',
        )
        .match({'creado_por': idUser /*, 'hora_inicio': hora*/})
        .order('created_at')
        .limit(1);
  }

  @override
  Future<List> recogerViajesAjenos(String idUser) async {
    return await sp
        .from(
          'viaje',
        )
        .select(
          'id,created_at,origen,destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo, usuario!viaje_creado_por_fkey(nombre)',
        )
        .neq('creado_por', idUser)
        .order('created_at');
  }

  @override
  void reservarPlaza(int id, int plazas, String idUSer) async {
    if (plazas > 0) {
      await sp.from('viaje').update({'plazas_disponibles': plazas - 1}).match({'id': id});
      await sp.from('es_pasajero').insert(
        {
          'id_viaje': id,
          'id_usuario': idUSer,
        },
      );
    }
  }

  @override
  Future<List> usuarioEsPasajero(String idUser) async {
    return await sp
        .from(
          'es_pasajero',
        )
        .select(
          'id_viaje',
        )
        .eq('id_usuario', idUser);
  }

  @override
  Future<List> viajesDelUsuario(String idUser) async {
    return await sp
        .from(
          'viaje',
        )
        .select(
          'id,created_at,origen,destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo, usuario!viaje_creado_por_fkey(nombre)',
        )
        .eq('creado_por', idUser)
        .order('created_at');
  }
}

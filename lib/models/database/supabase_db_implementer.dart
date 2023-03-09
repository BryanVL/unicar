import 'dart:async';

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
  Future<List> recogerViajeRecienCreado(String idUser) async {
    return await sp
        .from('viaje')
        .select(
          'id',
        )
        .match({'creado_por': idUser})
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

  @override
  Future<String> nombreUsuario(String idUser) async {
    final List consulta = await sp
        .from(
          'usuario',
        )
        .select('nombre')
        .match({'id': idUser});
    return Future.value(consulta[0]['nombre']);
  }

  @override
  Future<AuthResponse> iniciarSesion(String correo, String password) async {
    return await sp.auth.signInWithPassword(
      email: correo,
      password: password,
    );
  }

  @override
  void iniciarSesionConProvider(Provider provider) async {
    await sp.auth.signInWithOAuth(provider, redirectTo: 'com.example.unicar://login-callback/');
  }

  @override
  void borrarCuenta(String idUser) async {
    await sp.auth.signOut();
    await sp.rpc('deleteUser', params: {'iduser': idUser});
  }

  @override
  void cerrarSesion() async {
    await sp.auth.signOut();
  }

  @override
  Future<Session?> comprobarSesion() async {
    return await SupabaseAuth.instance.initialSession;
  }

  @override
  Future<List> recogerChats(String idUser) async {
    return await sp
        .from(
          'chat',
        )
        .select(
          'id, usuario_creador, usuario_receptor',
        )
        .or('usuario_creador.eq.$idUser,usuario_receptor.eq.$idUser')
        .order('created_at');
  }

  @override
  void crearChat(String idCreador, String idReceptor) async {
    await sp.from('chat').insert({'usuario_creador': idCreador, 'usuario_receptor': idReceptor});
  }

  @override
  Future<int> recogerUltimoIdChatCreado(String idUser) async {
    List consulta = await sp
        .from('chat')
        .select('id')
        .match({'usuario_creador': idUser})
        .order('created_at')
        .limit(1);
    return int.parse(consulta[0]['id']);
  }

  @override
  Future<List> usuarioDesdeId(String id) async {
    return await sp.from('usuario').select('id,nombre').match({'id': id});
  }

//TODO puedo hacer un Provider con .family que de uno de estos y luego en el chat escuchar lo
  @override
  Stream<List<Map<String, dynamic>>> escucharMensajesChat(int idChat) {
    final consulta =
        sp.from('mensajes').stream(primaryKey: ['id']).eq('chat_id', idChat); //.listen((event) {});
    return consulta;
  }
}

import 'dart:async';

import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/interfaces/database_interface.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/models/usuario.dart';

class SupabaseDB implements Database {
  final sp = Supabase.instance.client;

  @override
  void actualizarViaje({
    required int idViaje,
    required String origen,
    required String destino,
    required String plazasTotales,
    required String hora,
    required String titulo,
    required String descripcion,
    LatLng? coordOrigen,
    LatLng? coordDestino,
    int? radioOrigen,
    int? radioDestino,
    required bool paraEstarA,
    required bool esPeriodico,
  }) async {
    await sp.from('viaje').update({
      'origen': origen,
      'destino': destino,
      'plazas_totales': plazasTotales,
      'hora': hora,
      'titulo': titulo,
      'descripcion': descripcion,
      'latitud_origen': coordOrigen?.latitude,
      'longitud_origen': coordOrigen?.longitude,
      'latitud_destino': coordDestino?.latitude,
      'longitud_destino': coordDestino?.longitude,
      'radio_origen': radioOrigen,
      'radio_destino': radioDestino,
      'para_estar_a': paraEstarA,
      'es_periodico': esPeriodico,
    }).match({'id': idViaje});
  }

  @override
  void cancelarPlaza(int id, int plazas, String idUSer) async {
    await sp.from('es_pasajero').delete().match({'id_viaje': id, 'id_usuario': idUSer});
    await sp.from('viaje').update({'plazas_disponibles': plazas + 1}).match({'id': id});
  }

  @override
  Future<int> crearViaje({
    required String origen,
    required String destino,
    required String hora,
    required String plazas,
    required String descripcion,
    required String titulo,
    LatLng? coordOrigen,
    LatLng? coordDestino,
    int? radioOrigen,
    int? radioDestino,
    required bool paraEstarA,
    required bool esPeriodico,
  }) async {
    final int id = await sp.rpc('crear_viaje', params: {
      'origen': origen,
      'destino': destino,
      'hora': hora,
      'plazas_totales': plazas,
      'plazas_disponibles': plazas,
      'descripcion': descripcion,
      'titulo': titulo,
      'latitud_origen': coordOrigen?.latitude,
      'longitud_origen': coordOrigen?.longitude,
      'latitud_destino': coordDestino?.latitude,
      'longitud_destino': coordDestino?.longitude,
      'radio_origen': radioOrigen,
      'radio_destino': radioDestino,
      'para_estar_a': paraEstarA,
      'es_periodico': esPeriodico,
    });
    return id;
  }

  @override
  void eliminarViaje(int id) async {
    await sp.from('es_pasajero').delete().match({'id_viaje': id});
    await sp.from('viaje').delete().match({'id': id});
  }

  @override
  Future<List<Oferta>> recogerViajesAjenos(String idUser) async {
    final List consulta = await sp
        .from(
          'viaje',
        )
        .select(
          'id,created_at,origen,destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo, radio_origen, radio_destino, para_estar_a, es_periodico, usuario!viaje_creado_por_fkey(nombre, url_icono)',
        )
        .neq('creado_por', idUser)
        .gt('plazas_disponibles', 0)
        .gte('hora', DateTime.now().subtract(const Duration(minutes: 15)))
        .order('created_at');

    return Oferta.fromList(consulta);
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
  Future<List<Oferta>> viajesDelUsuario(String idUser) async {
    return Oferta.fromList(
      await sp
          .from(
            'viaje',
          )
          .select(
            'id,created_at,origen,destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo, radio_origen, radio_destino, para_estar_a, es_periodico, usuario!viaje_creado_por_fkey(nombre, url_icono)',
          )
          .eq('creado_por', idUser)
          .gte('hora', DateTime.now().subtract(const Duration(hours: 3)))
          .order('created_at'),
    );
  }

  @override
  Future<List<Oferta>> recogerViajesApuntado(String idUser) async {
    return Oferta.fromList(
      await sp
          .from(
            'viaje',
          )
          .select(
            'id,created_at,origen,destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo, radio_origen, radio_destino, para_estar_a, es_periodico, usuario!viaje_creado_por_fkey(nombre, url_icono), es_pasajero!inner(id_usuario)',
          )
          .neq('creado_por', idUser)
          .eq('es_pasajero.id_usuario', idUser)
          .gte('hora', DateTime.now().subtract(const Duration(hours: 3)))
          .order('created_at'),
    );
  }

  @override
  Future<Usuario> datosUsuario(String idUser) async {
    final List consulta = await sp
        .from(
          'usuario',
        )
        .select(
            'id, nombre, url_icono, titulo_defecto, descripcion_defecto, origen_defecto, destino_defecto, latitud_origen_defecto, latitud_destino_defecto, longitud_origen_defecto, longitud_destino_defecto, radio_origen_defecto, radio_destino_defecto')
        .match({'id': idUser});

    return Future.value(Usuario.fromKeyValue(consulta[0]));
  }

  @override
  Future<Usuario> datosUsuarioAjeno(String idUser) async {
    final List consulta = await sp
        .from(
          'usuario',
        )
        .select('nombre, url_icono')
        .match({'id': idUser});

    return Future.value(Usuario(
      id: idUser,
      nombre: consulta[0]['nombre'],
      urlIcono: consulta[0]['url_icono'],
    ));
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
  Future<List<int>> recogerIdsChats(String idUser) async {
    final List consulta = await sp
        .from(
          'participantes_chat',
        )
        .select(
          'chat_id, chat(ultimo_mensaje_mandado)',
        )
        .match({'usuario_id': idUser}).order(
      'ultimo_mensaje_mandado',
      foreignTable: 'chat',
      ascending: false,
    );

    consulta.sort(
      (a, b) {
        return DateTime.parse(b['chat']['ultimo_mensaje_mandado'] as String)
            .compareTo(DateTime.parse(a['chat']['ultimo_mensaje_mandado']));
      },
    );

    final List<int> idsChat = consulta.map((e) {
      return e['chat_id'] as int;
    }).toList();

    return idsChat;
  }

  @override
  Future<int> crearChat(String otroUsuario) async {
    return await sp.rpc('crear_chat', params: {'other_user_id': otroUsuario});
  }

  @override
  Stream<List<Map<String, dynamic>>> escucharMensajesChat(int idChat) {
    return sp.from('mensaje').stream(primaryKey: ['id']).eq('chat_id', idChat).order('created_at');
  }

  @override
  Future<List<String>> recogerUsuariosAjenosChat(int idChat, String idUser) async {
    final List consulta = await sp
        .from('participantes_chat')
        .select('usuario_id')
        .eq('chat_id', idChat)
        .neq('usuario_id', idUser);
    return consulta.map((e) {
      return e['usuario_id'] as String;
    }).toList();
  }

  @override
  void enviarMensaje(int chatId, String text, String creadorId) async {
    await sp.from('mensaje').insert({
      'chat_id': chatId,
      'contenido': text,
      'creador': creadorId,
    });
    /*await sp
        .from('chat')
        .update({'ultimo_mensaje_mandado': DateTime.now().toIso8601String()}).match({'id': chatId});*/
  }

  @override
  void actualizarEstadoMensajes(int chatId, String usuarioAjenoId) async {
    await sp
        .from('mensaje')
        .update({'visto': true}).match({'chat_id': chatId, 'creador': usuarioAjenoId});
  }

  @override
  Future<List<Usuario>> recogerParticipantesViaje(int idViaje) async {
    final List<dynamic> consulta = await sp
        .from('es_pasajero')
        .select('id_usuario, usuario(nombre, url_icono)')
        .eq('id_viaje', idViaje);

    return consulta
        .map((e) => Usuario(
            id: e['id_usuario'],
            nombre: e['usuario']['nombre'],
            urlIcono: e['usuario']['url_icono']))
        .toList();
  }

  @override
  Future<int> recogerPlazasViaje(int idViaje) async {
    final List consulta = await sp.from('viaje').select('plazas_disponibles').eq('id', idViaje);
    return consulta[0]['plazas_disponibles'];
  }

  @override
  void actualizarDatosUsuario(String id, String? nombre, String? urlIcono) async {
    await Supabase.instance.client.from('usuario').update(
      {
        'nombre': nombre,
        'url_icono': urlIcono,
      },
    ).match(
      {
        'id': id,
      },
    );
  }

  @override
  void actualizarDatosExtraUsuario(String userId, String titulo, String descripcion) async {
    await sp.from('usuario').update(
        {'titulo_defecto': titulo, 'descripcion_defecto': descripcion}).match({'id': userId});
  }
}

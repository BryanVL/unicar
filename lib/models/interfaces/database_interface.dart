import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/usuario.dart';

abstract class Database {
  Future<List> recogerViajesAjenos(String idUser);
  Future<List> recogerViajesApuntado(String idUser);
  Future<List> viajesDelUsuario(String idUser);
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
  });
  void eliminarViaje(int id);
  void reservarPlaza(int id, int plazas, String idUSer);
  void cancelarPlaza(int id, int plazas, String idUSer);
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
  });
  Future<int> recogerPlazasViaje(int idViaje);
  Future<List<Usuario>> recogerParticipantesViaje(int idViaje);
  Future<Usuario> datosUsuario(String idUser);
  Future<Usuario> datosUsuarioAjeno(String idUser);
  Future<AuthResponse> iniciarSesion(String correo, String password);
  void iniciarSesionConProvider(Provider provider);
  void actualizarDatosUsuario(
    String id,
    String? nombre,
    String? urlIcono,
  );
  void cerrarSesion();
  void borrarCuenta(String idUser);
  void actualizarDatosExtraUsuario(String userId, String titulo, String descripcion);
  Future<Session?> comprobarSesion();
  Future<List> recogerIdsChats(String idUser);
  Future<List> recogerUsuariosAjenosChat(int idChat, String idUser);
  Future<int> crearChat(String otroUsuario);

  Stream<List<Map<String, dynamic>>> escucharMensajesChat(int idChat);
  void enviarMensaje(int chatId, String text, String creadorId);
  void actualizarEstadoMensajes(int chatId, String usuarioAjenoId);
}

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class Database {
  Future<List> recogerViajesAjenos(String idUser);
  Future<List> usuarioEsPasajero(String idUser);
  Future<List> viajesDelUsuario(String idUser);
  Future<List> recogerViajeRecienCreado(String idUser);
  void crearViaje(
    String origen,
    String destino,
    String hora,
    String plazas,
    String descripcion,
    String titulo,
    String usuario,
  );
  void eliminarViaje(int id);
  void reservarPlaza(int id, int plazas, String idUSer);
  void cancelarPlaza(int id, int plazas, String idUSer);
  void actualizarViaje(
    int idViaje,
    String origen,
    String destino,
    String plazasTotales,
    String hora,
    String titulo,
    String descripcion,
  );
  Future<String> nombreUsuario(String idUser);
  Future<AuthResponse> iniciarSesion(String correo, String password);
  void iniciarSesionConProvider(Provider provider);
  void cerrarSesion();
  void borrarCuenta(String idUser);
  Future<Session?> comprobarSesion();
  Future<List> recogerChats(String idUser);
  void crearChat(
    String idCreador,
    String idReceptor,
  );
  Future<int> recogerUltimoIdChatCreado(String idUser);
  Future<List> usuarioDesdeId(String id);

  Stream<List<Map<String, dynamic>>> escucharMensajesChat(int idChat);
}

import 'package:latlong2/latlong.dart';
import 'package:gotrue/src/types/session.dart';
import 'package:gotrue/src/types/provider.dart';
import 'package:gotrue/src/types/auth_response.dart';
import 'package:unicar/models/interfaces/database_interface.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/models/oferta.dart';

class FakeSupabase implements Database {
  @override
  void actualizarDatosExtraUsuario(String userId, String titulo, String descripcion) {
    // TODO: implement actualizarDatosExtraUsuario
  }

  @override
  void actualizarDatosUsuario(String id, String? nombre, String? urlIcono) {
    // TODO: implement actualizarDatosUsuario
  }

  @override
  void actualizarEstadoMensajes(int chatId, String usuarioAjenoId) {
    // TODO: implement actualizarEstadoMensajes
  }

  @override
  void actualizarViaje(
      {required int idViaje,
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
      required bool esPeriodico}) {
    // TODO: implement actualizarViaje
  }

  @override
  void borrarCuenta(String idUser) {
    // TODO: implement borrarCuenta
  }

  @override
  void cancelarPlaza(int id, int plazas, String idUSer) {
    // TODO: implement cancelarPlaza
  }

  @override
  void cerrarSesion() {
    // TODO: implement cerrarSesion
  }

  @override
  Future<Session?> comprobarSesion() {
    // TODO: implement comprobarSesion
    throw UnimplementedError();
  }

  @override
  Future<int> crearChat(String otroUsuario) {
    // TODO: implement crearChat
    throw UnimplementedError();
  }

  @override
  Future<int> crearViaje(
      {required String origen,
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
      required bool esPeriodico}) {
    // TODO: implement crearViaje
    throw UnimplementedError();
  }

  @override
  Future<Usuario> datosUsuario(String idUser) {
    // TODO: implement datosUsuario
    throw UnimplementedError();
  }

  @override
  Future<Usuario> datosUsuarioAjeno(String idUser) {
    // TODO: implement datosUsuarioAjeno
    throw UnimplementedError();
  }

  @override
  void eliminarViaje(int id) {
    // TODO: implement eliminarViaje
  }

  @override
  void enviarMensaje(int chatId, String text, String creadorId) {}

  @override
  Stream<List<Map<String, dynamic>>> escucharMensajesChat(int idChat) {
    // TODO: implement escucharMensajesChat
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> iniciarSesion(String correo, String password) {
    // TODO: implement iniciarSesion
    throw UnimplementedError();
  }

  @override
  void iniciarSesionConProvider(Provider provider) {
    // TODO: implement iniciarSesionConProvider
  }

  @override
  Future<List<int>> recogerIdsChats(String idUser) {
    // TODO: implement recogerIdsChats
    throw UnimplementedError();
  }

  @override
  Future<List<Usuario>> recogerParticipantesViaje(int idViaje) {
    // TODO: implement recogerParticipantesViaje
    throw UnimplementedError();
  }

  @override
  Future<int> recogerPlazasViaje(int idViaje) {
    // TODO: implement recogerPlazasViaje
    throw UnimplementedError();
  }

  @override
  Future<List<String>> recogerUsuariosAjenosChat(int idChat, String idUser) {
    // TODO: implement recogerUsuariosAjenosChat
    throw UnimplementedError();
  }

  @override
  Future<List<Oferta>> recogerViajesAjenos(String idUser) {
    // TODO: implement recogerViajesAjenos
    throw UnimplementedError();
  }

  @override
  Future<List<Oferta>> recogerViajesApuntado(String idUser) {
    // TODO: implement recogerViajesApuntado
    throw UnimplementedError();
  }

  @override
  void reservarPlaza(int id, int plazas, String idUSer) {
    // TODO: implement reservarPlaza
  }

  @override
  Future<List<Oferta>> viajesDelUsuario(String idUser) {
    // TODO: implement viajesDelUsuario
    throw UnimplementedError();
  }
}

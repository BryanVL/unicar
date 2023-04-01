import 'package:latlong2/latlong.dart';
// ignore: depend_on_referenced_packages
import 'package:gotrue/src/types/session.dart';
// ignore: depend_on_referenced_packages
import 'package:gotrue/src/types/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:gotrue/src/types/auth_response.dart';
import 'package:unicar/models/interfaces/database_interface.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/models/oferta.dart';

class FakeSupabase implements Database {
  @override
  void actualizarDatosExtraUsuario(String userId, String titulo, String descripcion) {}

  @override
  void actualizarDatosUsuario(String id, String? nombre, String? urlIcono) {}

  @override
  void actualizarEstadoMensajes(int chatId, String usuarioAjenoId) {}

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
      required bool esPeriodico}) {}

  @override
  void borrarCuenta(String idUser) {}

  @override
  void cancelarPlaza(int id, int plazas, String idUSer) {}

  @override
  void cerrarSesion() {}

  @override
  Future<Session?> comprobarSesion() {
    throw UnimplementedError();
  }

  @override
  Future<int> crearChat(String otroUsuario) {
    return Future.value(111);
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
    return Future.value(112);
  }

  @override
  Future<Usuario> datosUsuario(String idUser) {
    throw UnimplementedError();
  }

  @override
  Future<Usuario> datosUsuarioAjeno(String idUser) {
    throw UnimplementedError();
  }

  @override
  void eliminarViaje(int id) {}

  @override
  void enviarMensaje(int chatId, String text, String creadorId) {}

  @override
  Stream<List<Map<String, dynamic>>> escucharMensajesChat(int idChat) {
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> iniciarSesion(String correo, String password) {
    throw UnimplementedError();
  }

  @override
  void iniciarSesionConProvider(Provider provider) {}

  @override
  Future<List<int>> recogerIdsChats(String idUser) {
    throw UnimplementedError();
  }

  @override
  Future<List<Usuario>> recogerParticipantesViaje(int idViaje) {
    throw UnimplementedError();
  }

  @override
  Future<int> recogerPlazasViaje(int idViaje) {
    throw UnimplementedError();
  }

  @override
  Future<List<Usuario>> recogerUsuariosAjenosChat(int idChat, String idUser) {
    throw UnimplementedError();
  }

  @override
  Future<List<Oferta>> recogerViajesAjenos(String idUser) {
    throw UnimplementedError();
  }

  @override
  Future<List<Oferta>> recogerViajesApuntado(String idUser) {
    throw UnimplementedError();
  }

  @override
  void reservarPlaza(int id, int plazas, String idUSer) {}

  @override
  Future<List<Oferta>> viajesDelUsuario(String idUser) {
    throw UnimplementedError();
  }
}

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/usuario_provider.dart';

import 'database_provider.dart';

//OFERTAS DISPONIBLES
class OfertasDisponiblesController extends r.AsyncNotifier<List<Oferta>> {
  List<Oferta> estadoAux = [];
  String filtroOrigen = 'Selecciona uno';
  String filtroDestino = 'Selecciona uno';
  String filtroHora = '';
  String get getfiltroHora => filtroHora;
  @override
  FutureOr<List<Oferta>> build() {
    ref.watch(usuarioProvider);
    return _inicializarLista();
  }

  Future<List<Oferta>> _inicializarLista() async {
    final List consultaViajes = await ref.read(databaseProvider).recogerViajesAjenos(
          ref.read(usuarioProvider)!.id,
        );

    final List consultaPasajero = await ref.read(databaseProvider).usuarioEsPasajero(
          ref.read(usuarioProvider)!.id,
        );

    final listaViajes = Oferta.fromList(consultaViajes);
    final List<int> idsQuitar = consultaPasajero.map((e) => e['id_viaje'] as int).toList();

    final List<Oferta> res = listaViajes.where((e) {
      return !idsQuitar.contains(e.id);
    }).toList();

    return Future.value(res);
  }

  void addOferta(Oferta oferta) async {
    state = await r.AsyncValue.guard(() {
      return Future(() => [oferta, ...(state.value!)]);
    });
  }

  void eliminarOferta(int id) {
    state = state.whenData((value) => value.where((element) => element.id != id).toList());
  }

  void reservarPlaza(Oferta oferta) {
    ref.read(databaseProvider).reservarPlaza(
          oferta.id,
          oferta.plazasDisponibles,
          ref.read(usuarioProvider)!.id,
        );
    ref
        .read(ofertasUsuarioApuntadoProvider.notifier)
        .addOferta(oferta.copyWith(plazasDisponibles: oferta.plazasDisponibles - 1));
    eliminarOferta(oferta.id);
  }

//TODO filtros con consultas a la base de datos en vez de local
//Se puede hacer igual que como esta ahora pero si lo que se recibe no es null se
//hace una consulta con el origen puesto y si luego se pone un destino se cojen los viajes
//con ese destino y me quedo con los que coincidan en las dos listas
  void filtrar(String origen, String destino, String hora) {
    List<Oferta> nuevoEstado = [];
    List<Oferta> aux = [];

    if (estadoAux.isEmpty) {
      estadoAux = state.value!;
    } else {
      state = AsyncValue.data(estadoAux);
    }

    List<Oferta> ofertas = state.whenData((value) => value).value!;

    if (origen != 'Selecciona uno') {
      filtroOrigen = origen;
      nuevoEstado.addAll(ofertas.where((element) => element.origen == origen));
    }

    if (destino != 'Selecciona uno') {
      filtroDestino = destino;
      if (nuevoEstado.isNotEmpty) {
        aux.addAll(nuevoEstado.where((element) => element.destino == destino));
        nuevoEstado = [];
        nuevoEstado.addAll(aux);
        aux = [];
      } else {
        nuevoEstado.addAll(ofertas.where((element) => element.destino == destino));
      }
    }

    if (hora != '') {
      filtroHora = hora;
      if (nuevoEstado.isNotEmpty) {
        aux.addAll(nuevoEstado.where((element) {
          final tElem = DateTime.parse(element.hora);
          final time = DateTime.parse(hora);

          return tElem.day == time.day && tElem.hour == time.hour && tElem.minute == time.minute;
        }));
        nuevoEstado = [];
        nuevoEstado.addAll(aux);
        aux = [];
      } else {
        nuevoEstado.addAll(ofertas.where((element) {
          final tElem = DateTime.parse(element.hora);
          final time = DateTime.parse(hora);

          return tElem.day == time.day && tElem.hour == time.hour && tElem.minute == time.minute;
        }));
      }
    }

    state = AsyncValue.data(nuevoEstado);
  }

  Future<void> eliminarFiltros() async {
    filtroDestino = 'Selecciona uno';
    filtroOrigen = 'Selecciona uno';
    filtroHora = '';
    state = AsyncValue.data(estadoAux);
    estadoAux = [];
  }
}

//Este proveedor da acceso a todas las ofertas disponibles
final ofertasDisponiblesProvider =
    r.AsyncNotifierProvider<OfertasDisponiblesController, List<Oferta>>(
  () {
    return OfertasDisponiblesController();
  },
);

//
//
//
//
//
//
//
//
//
//
//

//Ofertas que el usuario OFRECE
class OfertasOfrecidasUsuarioController extends r.AsyncNotifier<List<Oferta>> {
  @override
  FutureOr<List<Oferta>> build() {
    ref.watch(usuarioProvider);
    return _inicializarLista();
  }

  Future<List<Oferta>> _inicializarLista() async {
    final List consultaViajes = await ref.read(databaseProvider).viajesDelUsuario(
          ref.read(usuarioProvider)!.id,
        );

    return Future.value(Oferta.fromList(consultaViajes));
  }

  void addNewOferta(
    String origen,
    String destino,
    String hora,
    String plazas,
    String descripcion,
    String titulo,
  ) async {
    final user = ref.read(usuarioProvider);
    ref.read(databaseProvider).crearViaje(
          origen,
          destino,
          hora,
          plazas,
          descripcion,
          titulo,
          user!.id,
        );
    final consulta = await ref.read(databaseProvider).recogerViajeRecienCreado(
          user.id,
        );

    final viaje = Oferta(
      id: consulta[0]['id'],
      origen: origen,
      destino: destino,
      hora: hora,
      plazasTotales: int.parse(plazas),
      plazasDisponibles: int.parse(plazas),
      titulo: titulo,
      descripcion: descripcion,
      creadoPor: user.id,
      nombreCreador: user.nombre!,
      urlIcono: 'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg',
    );

    state = await r.AsyncValue.guard(() {
      return Future(() => [viaje, ...(state.value!)]);
    });
  }

  void eliminarOferta(int id) {
    ref.read(databaseProvider).eliminarViaje(id);
    state = state.whenData((value) => value.where((element) => element.id != id).toList());
  }

  void editarOferta(
    int id,
    String origen,
    String destino,
    String plazas,
    String hora,
    String titulo,
    String descripcion,
  ) {
    ref
        .read(databaseProvider)
        .actualizarViaje(id, origen, destino, plazas, hora, titulo, descripcion);

    List<Oferta> ofertas = state.whenData((value) => value).value!;
    int index = ofertas.indexWhere((value) => value.id == id);
    Oferta o = ofertas[index];
    int plazasDisp = o.plazasDisponibles;
    ofertas[index] = o.copyWith(
      origen: origen,
      destino: destino,
      hora: hora,
      plazasDisponibles: plazasDisp + (int.parse(plazas) - plazasDisp).abs(),
      plazasTotales: int.parse(plazas),
      titulo: titulo,
      descripcion: descripcion,
    );

    state = AsyncValue.data(ofertas);
  }
}

//Este proveedor da acceso a todas las ofertas disponibles
final ofertasOfrecidasUsuarioProvider =
    r.AsyncNotifierProvider<OfertasOfrecidasUsuarioController, List<Oferta>>(
  () {
    return OfertasOfrecidasUsuarioController();
  },
);

//
//
//
//
//
//
//
//
//
//
//

//Ofertas a las que el usuario esta APUNTADO
class OfertasUsuarioApuntadoController extends r.AsyncNotifier<List<Oferta>> {
  @override
  FutureOr<List<Oferta>> build() {
    ref.watch(usuarioProvider);
    return _inicializarLista();
  }

  Future<List<Oferta>> _inicializarLista() async {
    final List consultaViajes = await ref.read(databaseProvider).recogerViajesAjenos(
          ref.read(usuarioProvider)!.id,
        );

    final List consultaPasajero = await ref.read(databaseProvider).usuarioEsPasajero(
          ref.read(usuarioProvider)!.id,
        );

    final listaViajes = Oferta.fromList(consultaViajes);
    final List<int> idsQuitar = consultaPasajero.map((e) => e['id_viaje'] as int).toList();

    final List<Oferta> res = listaViajes.where((e) {
      return idsQuitar.contains(e.id);
    }).toList();

    return Future.value(res);
  }

  void cancelarReserva(Oferta oferta) {
    ref.read(databaseProvider).cancelarPlaza(
          oferta.id,
          oferta.plazasDisponibles,
          ref.read(usuarioProvider)!.id,
        );

    ref.invalidate(ofertasDisponiblesProvider);
    eliminarOferta(oferta.id);
  }

  void addOferta(Oferta oferta) async {
    state = await r.AsyncValue.guard(() {
      return Future(() => [oferta, ...(state.value!)]);
    });
  }

  void eliminarOferta(int id) {
    state = state.whenData((value) => value.where((element) => element.id != id).toList());
  }
}

//Este proveedor da acceso a todas las ofertas disponibles
final ofertasUsuarioApuntadoProvider =
    r.AsyncNotifierProvider<OfertasUsuarioApuntadoController, List<Oferta>>(
  () {
    return OfertasUsuarioApuntadoController();
  },
);

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicar/models/localizacion.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/localizacion_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';

import 'database_provider.dart';

class OfertasController extends r.AsyncNotifier<Map<String, List<Oferta>>> {
  List<Oferta> estadoAux = [];
  String filtroOrigen = 'Selecciona uno';
  String filtroDestino = 'Selecciona uno';
  LocalizacionPersonalizada? filtroOrigenP;
  LocalizacionPersonalizada? filtroDestinoP;
  String filtroHora = '';
  int filtroGroupValue = 2;

  @override
  FutureOr<Map<String, List<Oferta>>> build() {
    ref.watch(usuarioProvider);
    return _inicializarLista();
  }

  Future<Map<String, List<Oferta>>> _inicializarLista() async {
    final idUser = ref.read(usuarioProvider)!.id;
    final List<Oferta> ofertas = Oferta.fromList(
      await ref.read(databaseProvider).recogerViajesAjenos(idUser),
    );
    final List<Oferta> viajesPropios = Oferta.fromList(
      await ref.read(databaseProvider).viajesDelUsuario(idUser),
    );
    final List<Oferta> viajesApuntado = Oferta.fromList(
      await ref.read(databaseProvider).recogerViajesApuntado(idUser),
    );

    Map<String, List<Oferta>> res = <String, List<Oferta>>{};

    res.putIfAbsent('ofertas', () => ofertas);

    res.putIfAbsent('propio', () => viajesPropios);

    res.putIfAbsent('apuntado', () => viajesApuntado);

    return Future.value(res);
  }

  void addOferta(Oferta oferta) async {
    state = await r.AsyncValue.guard(() {
      state.value!.update('propio', (value) => [oferta, ...(state.value!['propio']!)]);

      return Future(() => state.value!);
    });
  }

  void eliminarOferta(int id) {
    state = state.whenData((value) {
      value['propio']!.where((element) => element.id != id).toList();
      return value;
    });
  }

  void reservarPlaza(Oferta oferta) async {
    final pl = ref.read(plazasProvider(oferta.id));
    pl.whenData((plazas) {
      if (plazas > 0) {
        ref.read(databaseProvider).reservarPlaza(
              oferta.id,
              plazas,
              ref.read(usuarioProvider)!.id,
            );

        state.value!.update(
          'apuntado',
          (value) => [
            oferta.copyWith(plazasDisponibles: plazas - 1),
            ...(state.value!['apuntado']!),
          ],
        );

        state = state.whenData((value) {
          value['ofertas']!.where((element) => element.id != oferta.id).toList();
          return value;
        });
      }
    });
  }

  void cancelarReserva(Oferta oferta) {
    final pl = ref.read(plazasProvider(oferta.id));
    pl.whenData((plazas) {
      ref.read(databaseProvider).cancelarPlaza(
            oferta.id,
            plazas,
            ref.read(usuarioProvider)!.id,
          );

      state.value!.update(
        'ofertas',
        (value) => [
          oferta.copyWith(plazasDisponibles: plazas + 1),
          ...(state.value!['ofertas']!),
        ],
      );
      state = state.whenData((value) {
        value['apuntado']!.where((element) => element.id != oferta.id).toList();
        return value;
      });
    });
  }

  void addNewOferta(
    String origen,
    String destino,
    String hora,
    String plazas,
    String descripcion,
    String titulo,
    LatLng? coordOrigen,
    LatLng? coordDestino,
    int? radioOrigen,
    int? radioDestino,
    bool paraEstarA,
    bool esPeriodico,
  ) async {
    final user = ref.read(usuarioProvider);
    final idNuevo = await ref.read(databaseProvider).crearViaje(
          origen: origen,
          destino: destino,
          hora: hora,
          plazas: plazas,
          descripcion: descripcion,
          titulo: titulo,
          paraEstarA: paraEstarA,
          coordOrigen: coordOrigen,
          coordDestino: coordDestino,
          radioOrigen: radioOrigen,
          radioDestino: radioDestino,
          esPeriodico: esPeriodico,
        );

    final viaje = Oferta(
      id: idNuevo,
      origen: origen,
      destino: destino,
      hora: hora,
      plazasTotales: int.parse(plazas),
      plazasDisponibles: int.parse(plazas),
      titulo: titulo,
      descripcion: descripcion,
      creador: user!,
      paraEstarA: paraEstarA,
      coordOrigen: coordOrigen,
      radioOrigen: radioOrigen,
      coordDestino: coordDestino,
      radioDestino: radioDestino,
      esPeriodico: esPeriodico,
    );

    state = await r.AsyncValue.guard(() {
      state.value!.update('propio', (value) => [viaje, ...(state.value!['propio']!)]);

      return Future(() => state.value!);
    });
  }

  void editarOferta({
    required int id,
    required String origen,
    required String destino,
    required String plazas,
    required String hora,
    required String titulo,
    required String descripcion,
    LatLng? coordOrigen,
    LatLng? coordDestino,
    int? radioOrigen,
    int? radioDestino,
    required bool paraEstarA,
    required bool esPeriodico,
  }) {
    ref.read(databaseProvider).actualizarViaje(
          idViaje: id,
          origen: origen,
          destino: destino,
          plazasTotales: plazas,
          hora: hora,
          titulo: titulo,
          descripcion: descripcion,
          coordOrigen: coordOrigen,
          coordDestino: coordDestino,
          radioOrigen: radioOrigen,
          radioDestino: radioDestino,
          paraEstarA: paraEstarA,
          esPeriodico: esPeriodico,
        );

    List<Oferta> ofertas = state.whenData((value) => value).value!['propio']!;
    int index = ofertas.indexWhere((value) => value.id == id);
    Oferta o = ofertas[index];
    int plazasDisp = o.plazasDisponibles;
    ofertas[index] = o.copyWithWithoutCoords(
      origen: origen,
      destino: destino,
      hora: hora,
      plazasDisponibles: plazasDisp + (int.parse(plazas) - plazasDisp).abs(),
      plazasTotales: int.parse(plazas),
      titulo: titulo,
      descripcion: descripcion,
      coordOrigen: coordOrigen,
      coordDestino: coordDestino,
      radioOrigen: radioOrigen,
      radioDestino: radioDestino,
      paraEstarA: paraEstarA,
      esPeriodico: esPeriodico,
    );

    state = AsyncValue.data(<String, List<Oferta>>{
      'oferta': state.value!['ofertas']!,
      'apuntado': state.value!['apuntado']!,
      'propio': ofertas
    });
  }

//TODO filtros con consultas a la base de datos en vez de local
//Se puede hacer igual que como esta ahora pero si lo que se recibe no es null se
//hace una consulta con el origen puesto y si luego se pone un destino se cojen los viajes
//con ese destino y me quedo con los que coincidan en las dos listas
  void filtrar(
    String origen,
    String destino,
    String hora,
    LocalizacionPersonalizada? origenP,
    LocalizacionPersonalizada? destinoP,
    int groupValue,
  ) {
    List<Oferta> nuevoEstado = [];
    List<Oferta> aux = [];
    bool filtroPosicionAplicado = false;

    if (estadoAux.isEmpty) {
      estadoAux = state.value!['ofertas']!;
    } else {
      state = AsyncValue.data(<String, List<Oferta>>{
        'oferta': estadoAux,
        'apuntado': state.value!['apuntado']!,
        'propio': state.value!['propio']!
      });
    }

    List<Oferta> ofertas = state.whenData((value) => value).value!['ofertas']!;

    if (origenP == null && destinoP == null) {
      if (origen != 'Selecciona uno') {
        filtroPosicionAplicado = true;
        filtroOrigen = origen;
        nuevoEstado.addAll(ofertas.where((element) => element.origen == origen));
      }

      if (destino != 'Selecciona uno') {
        filtroPosicionAplicado = true;
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
    } else if (origenP != null || destinoP != null) {
      if (origenP != null) {
        filtroPosicionAplicado = true;
        filtroOrigenP = LocalizacionPersonalizada(
          nombreCompleto: origenP.nombreCompleto,
          localidad: origenP.localidad,
          coordenadas: origenP.coordenadas,
          radio: origenP.radio,
        );
        nuevoEstado.addAll(
          ofertas.where(
            (element) {
              return element.coordOrigen != null
                  ? ref
                          .read(geolocationProvider)
                          .distanciaEntreDosPuntos(element.coordOrigen!, origenP.coordenadas) <=
                      (element.radioOrigen! + origenP.radio)
                  : false;
            },
          ),
        );
      }

      if (destinoP != null) {
        filtroPosicionAplicado = true;
        filtroDestinoP = LocalizacionPersonalizada(
          nombreCompleto: destinoP.nombreCompleto,
          localidad: destinoP.localidad,
          coordenadas: destinoP.coordenadas,
          radio: destinoP.radio,
        );
        if (nuevoEstado.isNotEmpty) {
          aux.addAll(
            nuevoEstado.where(
              (element) {
                return element.coordDestino != null
                    ? ref
                            .read(geolocationProvider)
                            .distanciaEntreDosPuntos(element.coordDestino!, destinoP.coordenadas) <=
                        (element.radioDestino! + destinoP.radio)
                    : false;
              },
            ),
          );
          nuevoEstado = [];
          nuevoEstado.addAll(aux);
          aux = [];
        } else {
          nuevoEstado.addAll(
            ofertas.where(
              (element) {
                return element.coordDestino != null
                    ? ref
                            .read(geolocationProvider)
                            .distanciaEntreDosPuntos(element.coordDestino!, destinoP.coordenadas) <=
                        (element.radioDestino! + destinoP.radio)
                    : false;
              },
            ),
          );
        }
      }
    }

    if (hora != '') {
      if (groupValue == 0) {
        if (nuevoEstado.isNotEmpty) {
          aux.addAll(nuevoEstado.where((element) => element.paraEstarA));
          nuevoEstado = [];
          nuevoEstado.addAll(aux);
          aux = [];
        } else {
          nuevoEstado.addAll(ofertas.where((element) => element.paraEstarA));
        }
      } else if (groupValue == 1) {
        if (nuevoEstado.isNotEmpty) {
          aux.addAll(nuevoEstado.where((element) => !element.paraEstarA));
          nuevoEstado = [];
          nuevoEstado.addAll(aux);
          aux = [];
        } else {
          nuevoEstado.addAll(ofertas.where((element) => !element.paraEstarA));
        }
      }
      filtroGroupValue = groupValue;
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
      } else if (nuevoEstado.isEmpty && !filtroPosicionAplicado) {
        nuevoEstado.addAll(ofertas.where((element) {
          final tElem = DateTime.parse(element.hora);
          final time = DateTime.parse(hora);

          return tElem.day == time.day && tElem.hour == time.hour && tElem.minute == time.minute;
        }));
      }
    }

    state = AsyncValue.data(<String, List<Oferta>>{
      'oferta': nuevoEstado,
      'apuntado': state.value!['apuntado']!,
      'propio': state.value!['propio']!
    });
  }

  Future<void> eliminarFiltros() async {
    filtroDestino = 'Selecciona uno';
    filtroOrigen = 'Selecciona uno';
    filtroHora = '';
    filtroOrigenP = null;
    filtroDestinoP = null;
    filtroGroupValue = 2;
    state = AsyncValue.data(<String, List<Oferta>>{
      'oferta': estadoAux,
      'apuntado': state.value!['apuntado']!,
      'propio': state.value!['propio']!
    });
    estadoAux = [];
  }
}

//Este proveedor da acceso a todas las ofertas disponibles
final viajesProvider = r.AsyncNotifierProvider<OfertasController, Map<String, List<Oferta>>>(
  () {
    return OfertasController();
  },
);

final ofertasProvider = Provider<List<Oferta>>((ref) {
  final viajes = ref.watch(viajesProvider).value!['ofertas']!;
  print('rebuild');
  return viajes;
});

final propiosProvider = FutureProvider<List<Oferta>>((ref) async {
  final viajes = ref.watch(viajesProvider).value!['propio']!;
  return viajes;
});

final apuntadoProvider = FutureProvider<List<Oferta>>((ref) async {
  final viajes = ref.watch(viajesProvider).value!['apuntado']!;
  return viajes;
});

/*
//OFERTAS DISPONIBLES
class OfertasDisponiblesController extends r.AsyncNotifier<List<Oferta>> {
  List<Oferta> estadoAux = [];
  String filtroOrigen = 'Selecciona uno';
  String filtroDestino = 'Selecciona uno';
  LocalizacionPersonalizada? filtroOrigenP;
  LocalizacionPersonalizada? filtroDestinoP;
  String filtroHora = '';
  int filtroGroupValue = 2;

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

  void reservarPlaza(Oferta oferta) async {
    final pl = ref.read(plazasProvider(oferta.id));
    pl.whenData((value) {
      if (value > 0) {
        ref.read(databaseProvider).reservarPlaza(
              oferta.id,
              value,
              ref.read(usuarioProvider)!.id,
            );
        ref
            .read(ofertasUsuarioApuntadoProvider.notifier)
            .addOferta(oferta.copyWith(plazasDisponibles: value - 1));
        eliminarOferta(oferta.id);
      }
    });
  }

//TODO filtros con consultas a la base de datos en vez de local
//Se puede hacer igual que como esta ahora pero si lo que se recibe no es null se
//hace una consulta con el origen puesto y si luego se pone un destino se cojen los viajes
//con ese destino y me quedo con los que coincidan en las dos listas
  void filtrar(
    String origen,
    String destino,
    String hora,
    LocalizacionPersonalizada? origenP,
    LocalizacionPersonalizada? destinoP,
    int groupValue,
  ) {
    List<Oferta> nuevoEstado = [];
    List<Oferta> aux = [];
    bool filtroPosicionAplicado = false;

    if (estadoAux.isEmpty) {
      estadoAux = state.value!;
    } else {
      state = AsyncValue.data(estadoAux);
    }

    List<Oferta> ofertas = state.whenData((value) => value).value!;

    if (origenP == null && destinoP == null) {
      if (origen != 'Selecciona uno') {
        filtroPosicionAplicado = true;
        filtroOrigen = origen;
        nuevoEstado.addAll(ofertas.where((element) => element.origen == origen));
      }

      if (destino != 'Selecciona uno') {
        filtroPosicionAplicado = true;
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
    } else if (origenP != null || destinoP != null) {
      if (origenP != null) {
        filtroPosicionAplicado = true;
        filtroOrigenP = LocalizacionPersonalizada(
          nombreCompleto: origenP.nombreCompleto,
          localidad: origenP.localidad,
          coordenadas: origenP.coordenadas,
          radio: origenP.radio,
        );
        nuevoEstado.addAll(
          ofertas.where(
            (element) {
              return element.coordOrigen != null
                  ? ref
                          .read(geolocationProvider)
                          .distanciaEntreDosPuntos(element.coordOrigen!, origenP.coordenadas) <=
                      (element.radioOrigen! + origenP.radio)
                  : false;
            },
          ),
        );
      }

      if (destinoP != null) {
        filtroPosicionAplicado = true;
        filtroDestinoP = LocalizacionPersonalizada(
          nombreCompleto: destinoP.nombreCompleto,
          localidad: destinoP.localidad,
          coordenadas: destinoP.coordenadas,
          radio: destinoP.radio,
        );
        if (nuevoEstado.isNotEmpty) {
          aux.addAll(
            nuevoEstado.where(
              (element) {
                return element.coordDestino != null
                    ? ref
                            .read(geolocationProvider)
                            .distanciaEntreDosPuntos(element.coordDestino!, destinoP.coordenadas) <=
                        (element.radioDestino! + destinoP.radio)
                    : false;
              },
            ),
          );
          nuevoEstado = [];
          nuevoEstado.addAll(aux);
          aux = [];
        } else {
          nuevoEstado.addAll(
            ofertas.where(
              (element) {
                return element.coordDestino != null
                    ? ref
                            .read(geolocationProvider)
                            .distanciaEntreDosPuntos(element.coordDestino!, destinoP.coordenadas) <=
                        (element.radioDestino! + destinoP.radio)
                    : false;
              },
            ),
          );
        }
      }
    }

    if (hora != '') {
      if (groupValue == 0) {
        if (nuevoEstado.isNotEmpty) {
          aux.addAll(nuevoEstado.where((element) => element.paraEstarA));
          nuevoEstado = [];
          nuevoEstado.addAll(aux);
          aux = [];
        } else {
          nuevoEstado.addAll(ofertas.where((element) => element.paraEstarA));
        }
      } else if (groupValue == 1) {
        if (nuevoEstado.isNotEmpty) {
          aux.addAll(nuevoEstado.where((element) => !element.paraEstarA));
          nuevoEstado = [];
          nuevoEstado.addAll(aux);
          aux = [];
        } else {
          nuevoEstado.addAll(ofertas.where((element) => !element.paraEstarA));
        }
      }
      filtroGroupValue = groupValue;
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
      } else if (nuevoEstado.isEmpty && !filtroPosicionAplicado) {
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
    filtroOrigenP = null;
    filtroDestinoP = null;
    filtroGroupValue = 2;
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
    LatLng? coordOrigen,
    LatLng? coordDestino,
    int? radioOrigen,
    int? radioDestino,
    bool paraEstarA,
    bool esPeriodico,
  ) async {
    final user = ref.read(usuarioProvider);
    final idNuevo = await ref.read(databaseProvider).crearViaje(
          origen: origen,
          destino: destino,
          hora: hora,
          plazas: plazas,
          descripcion: descripcion,
          titulo: titulo,
          paraEstarA: paraEstarA,
          coordOrigen: coordOrigen,
          coordDestino: coordDestino,
          radioOrigen: radioOrigen,
          radioDestino: radioDestino,
          esPeriodico: esPeriodico,
        );

    final viaje = Oferta(
      id: idNuevo,
      origen: origen,
      destino: destino,
      hora: hora,
      plazasTotales: int.parse(plazas),
      plazasDisponibles: int.parse(plazas),
      titulo: titulo,
      descripcion: descripcion,
      creador: user!,
      paraEstarA: paraEstarA,
      coordOrigen: coordOrigen,
      radioOrigen: radioOrigen,
      coordDestino: coordDestino,
      radioDestino: radioDestino,
      esPeriodico: esPeriodico,
    );

    state = await r.AsyncValue.guard(() {
      return Future(() => [viaje, ...(state.value!)]);
    });
  }

  void eliminarOferta(int id) {
    ref.read(databaseProvider).eliminarViaje(id);
    state = state.whenData((value) => value.where((element) => element.id != id).toList());
  }

  void editarOferta({
    required int id,
    required String origen,
    required String destino,
    required String plazas,
    required String hora,
    required String titulo,
    required String descripcion,
    LatLng? coordOrigen,
    LatLng? coordDestino,
    int? radioOrigen,
    int? radioDestino,
    required bool paraEstarA,
    required bool esPeriodico,
  }) {
    ref.read(databaseProvider).actualizarViaje(
          idViaje: id,
          origen: origen,
          destino: destino,
          plazasTotales: plazas,
          hora: hora,
          titulo: titulo,
          descripcion: descripcion,
          coordOrigen: coordOrigen,
          coordDestino: coordDestino,
          radioOrigen: radioOrigen,
          radioDestino: radioDestino,
          paraEstarA: paraEstarA,
          esPeriodico: esPeriodico,
        );

    List<Oferta> ofertas = state.whenData((value) => value).value!;
    int index = ofertas.indexWhere((value) => value.id == id);
    Oferta o = ofertas[index];
    int plazasDisp = o.plazasDisponibles;
    ofertas[index] = o.copyWithWithoutCoords(
      origen: origen,
      destino: destino,
      hora: hora,
      plazasDisponibles: plazasDisp + (int.parse(plazas) - plazasDisp).abs(),
      plazasTotales: int.parse(plazas),
      titulo: titulo,
      descripcion: descripcion,
      coordOrigen: coordOrigen,
      coordDestino: coordDestino,
      radioOrigen: radioOrigen,
      radioDestino: radioDestino,
      paraEstarA: paraEstarA,
      esPeriodico: esPeriodico,
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
    final List consultaViajes = await ref.read(databaseProvider).recogerViajesApuntado(
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
    final pl = ref.read(plazasProvider(oferta.id));
    pl.whenData((value) {
      ref.read(databaseProvider).cancelarPlaza(
            oferta.id,
            value,
            ref.read(usuarioProvider)!.id,
          );

      ref.invalidate(ofertasDisponiblesProvider);
      eliminarOferta(oferta.id);
    });
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
*/

final plazasProvider = r.FutureProvider.family.autoDispose<int, int>((ref, id) {
  return ref.watch(databaseProvider).recogerPlazasViaje(id);
});

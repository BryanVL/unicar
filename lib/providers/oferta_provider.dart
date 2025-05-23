import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicar/models/localizacion.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/localizacion_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';

import 'database_provider.dart';

//Cambiar inicializar para que lo haga segun el tipo, hacer comprobaciones en funciones como cancelar reserva
class OfertasController extends r.AsyncNotifier<List<Oferta>> {
  List<Oferta> estadoAux = [];
  String filtroOrigen = 'Selecciona uno';
  String filtroDestino = 'Selecciona uno';
  LocalizacionPersonalizada? filtroOrigenP;
  LocalizacionPersonalizada? filtroDestinoP;
  String filtroHora = '';
  int filtroGroupValue = 2;
  final List<Oferta>? valorDefecto;
  final TipoViaje tipo;

  OfertasController({this.valorDefecto, required this.tipo});

  @override
  FutureOr<List<Oferta>> build() {
    ref.watch(usuarioProvider);
    return valorDefecto != null ? Future.value(valorDefecto) : _inicializarLista();
  }

  Future<List<Oferta>> _inicializarLista() async {
    switch (tipo) {
      case TipoViaje.oferta:
        final List<Oferta> listaOfertas =
            await ref.read(databaseProvider).recogerViajesAjenos(ref.read(usuarioProvider)!.id);
        List<Oferta>? ofertasApuntado = ref.read(ofertasUsuarioApuntadoProvider).valueOrNull;

        if (ofertasApuntado != null) {
          for (var ap in ofertasApuntado) {
            listaOfertas.removeWhere((element) => element.id == ap.id);
          }
        }

        return Future.value(listaOfertas);
      case TipoViaje.apuntado:
        return Future.value(
          await ref.read(databaseProvider).recogerViajesApuntado(
                ref.read(usuarioProvider)!.id,
              ),
        );
      case TipoViaje.propio:
        return Future.value(
          await ref.read(databaseProvider).viajesDelUsuario(
                ref.read(usuarioProvider)!.id,
              ),
        );
    }
  }

  void addOferta(Oferta oferta) async {
    state = await r.AsyncValue.guard(() {
      return Future(() => [oferta, ...(state.value!)]);
    });
  }

  void eliminarOferta(int id) {
    if (tipo == TipoViaje.propio) {
      ref.read(databaseProvider).eliminarViaje(id);
    }
    state = state.whenData((value) => value.where((element) => element.id != id).toList());
  }

  void reservarPlaza(Oferta oferta) async {
    if (tipo == TipoViaje.oferta) {
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
  }

  void cancelarReserva(Oferta oferta) {
    if (tipo == TipoViaje.apuntado) {
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
    if (tipo == TipoViaje.propio) {
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
        plazasDisponibles: plazasDisp + (int.parse(plazas) - o.plazasTotales),
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
    if (tipo == TipoViaje.propio) {
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
      addOferta(viaje);
    }
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
    if (tipo == TipoViaje.propio) return;
    if (tipo == TipoViaje.apuntado) return;
    if (origen == 'Selecciona uno' &&
        destino == 'Selecciona uno' &&
        hora == '' &&
        origenP == null &&
        destinoP == null) return;
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
    } else {
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
          final int valorGrupo = element.paraEstarA ? 0 : 1;

          return tElem.day == time.day &&
              tElem.hour == time.hour &&
              tElem.minute == time.minute &&
              (valorGrupo == groupValue || groupValue == 2);
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
    if (estadoAux.isNotEmpty) {
      state = AsyncValue.data(estadoAux);
    }
    estadoAux = [];
  }
}

//Este proveedor da acceso a todas las ofertas disponibles
final ofertasDisponiblesProvider = r.AsyncNotifierProvider<OfertasController, List<Oferta>>(
  () {
    return OfertasController(tipo: TipoViaje.oferta);
  },
);

//Este proveedor da acceso a todas las ofertas disponibles
final ofertasOfrecidasUsuarioProvider = r.AsyncNotifierProvider<OfertasController, List<Oferta>>(
  () {
    return OfertasController(tipo: TipoViaje.propio);
  },
);

//Este proveedor da acceso a todas las ofertas disponibles
final ofertasUsuarioApuntadoProvider = r.AsyncNotifierProvider<OfertasController, List<Oferta>>(
  () {
    return OfertasController(tipo: TipoViaje.apuntado);
  },
);

final plazasProvider = r.FutureProvider.family.autoDispose<int, int>((ref, id) {
  return ref.watch(databaseProvider).recogerPlazasViaje(id);
});

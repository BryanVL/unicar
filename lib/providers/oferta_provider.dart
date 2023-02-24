import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/usuario_provider.dart';

/*class OfertaController extends r.AsyncNotifier<List<Oferta>> {
  @override
  FutureOr<List<Oferta>> build() {
    return _inicializarLista();
  }

//Añade una oferta al proveedor
  void addOferta(int idUser, String hora) async {
    final List consulta = await Supabase.instance.client
        .from(
          'Viaje',
        )
        .select(
          'id, created_at, Origen, Destino, latitud_origen, longitud_origen, latitud_destino, longitud_destino, hora_inicio, plazas_totales, plazas_disponibles, descripcion, creado_por, titulo',
        )
        .match({'creado_por': idUser, 'hora_inicio': hora})
        .order('created_at')
        .limit(1);

    state = await r.AsyncValue.guard(() {
      return Future(() => Oferta.fromList([consulta, ...(state.value!)]));
    });
  }

  void editarOferta() async {
    state = await r.AsyncValue.guard(_inicializarLista);
  }

  //Reserva una plaza de una oferta
  void reservarPlaza() async {
    state = await r.AsyncValue.guard(_inicializarLista);
  }

  void cancelarReserva() async {
    state = await r.AsyncValue.guard(_inicializarLista);
  }

  //Inicializa los datos del proveedor cogiendo todos los viajes de la tabla
  Future<List<Oferta>> _inicializarLista() async {
    final List datos = await Supabase.instance.client
        .from(
          'Viaje',
        )
        .select(
          'id,created_at,Origen,Destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo, usuarios_apuntados',
        )
        .order('created_at');

    return datos
        .map(
          (e) => Oferta(
            id: e['id'],
            origen: e['Origen'],
            destino: e['Destino'],
            hora: e['hora_inicio'],
            creadoPor: e['creado_por'],
            titulo: e['titulo'],
          ),
        )
        .toList();
  }

  //Actualiza todos los datos
  Future<void> actualizarDatos() async {
    state = await r.AsyncValue.guard(_inicializarLista);
  }

  void eliminarOferta(int id) async {
    state.value!.removeWhere((element) => element.id == id);
    state = state;
  }

  void filtrarPorHora(String hora) {}

  void filtrarPosicion(String? origen, String? destino) {}
}

//Este proveedor da acceso a todas las ofertas
final ofertaProvider = r.AsyncNotifierProvider<OfertaController, List<Oferta>>(() {
  return OfertaController();
});

//Este proveedor da las ofertas que el usuario puede solicitar
final ofertasDisponibles = r.FutureProvider<List<Oferta>>(
  (ref) {
    final viajesApuntado = ref.watch(ofertasApuntado).value ?? [];
    final viajesUsuario = ref.watch(ofertasDelUsuario).value ?? [];
    final listaViajes = ref.watch(ofertaProvider).value ?? [];

    List<Oferta> res = [];
    if (listaViajes.isNotEmpty) {
      res = listaViajes.where(
        (element) {
          return !viajesApuntado.contains(element) && !viajesUsuario.contains(element);
        },
      ).toList();
    }
    return res;
  },
);

//Este proveedor da las ofertas que el usuario ha creado
final ofertasDelUsuario = r.FutureProvider<List<Oferta>>(
  (ref) async {
    final listaViajes = ref.watch(ofertaProvider).value ?? [];

    return listaViajes.where((element) {
      return element.creadoPor == 1;
    }).toList();
  },
);

//Este proveedor da las ofertas a las que el usuario se ha apuntado
final ofertasApuntado = r.FutureProvider<List<Oferta>>(
  (ref) async {
    final listaViajes = ref.watch(ofertaProvider).value ?? [];
    final List apuntado = await Supabase.instance.client
        .from(
          'Es_pasajero',
        )
        .select(
          'Id_viaje',
        )
        .match(
      {'id_usuario': 1},
    );
    final List datosDeApuntado = apuntado.map((e) {
      return e['Id_viaje'];
    }).toList();

    return listaViajes.where((element) {
      return datosDeApuntado.contains(element.id);
    }).toList();
  },
);

*/
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
//
//
//
//
//
//
//
//

//Este proveedor da las ofertas a las que el usuario se ha apuntado
/*final ofertasAjenas = r.FutureProvider<List<Oferta>>((ref) async {
  final List datos = await Supabase.instance.client
      .from(
        'Viaje',
      )
      .select(
        'id,created_at,Origen,Destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo, usuarios_apuntados',
      )
      .order('created_at');

  return Oferta.fromList(datos);
});*/

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
    final List consultaViajes = await Supabase.instance.client
        .from(
          'viaje',
        )
        .select(
          'id,created_at,origen,destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo',
        )
        .neq('creado_por', ref.read(usuarioProvider))
        .order('created_at');
    final List consultaPasajero = await Supabase.instance.client
        .from(
          'es_pasajero',
        )
        .select(
          'id_viaje',
        )
        .eq('id_usuario', ref.read(usuarioProvider));
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
    ref.read(ofertasUsuarioApuntadoProvider.notifier).addOferta(oferta);
    eliminarOferta(oferta.id);
  }

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
        aux.addAll(nuevoEstado.where((element) => element.hora == hora));
        nuevoEstado = [];
        nuevoEstado.addAll(aux);
        aux = [];
      } else {
        nuevoEstado.addAll(ofertas.where((element) => element.hora == hora));
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
    final List consultaViajes = await Supabase.instance.client
        .from(
          'viaje',
        )
        .select(
          'id,created_at,origen,destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo',
        )
        .eq('creado_por', ref.read(usuarioProvider))
        .order('created_at');

    return Future.value(Oferta.fromList(consultaViajes));
  }

  void addNewOferta(String hora) async {
    final consulta = await Supabase.instance.client
        .from(
          'viaje',
        )
        .select(
          'id, created_at, origen, destino, latitud_origen, longitud_origen, latitud_destino, longitud_destino, hora_inicio, plazas_totales, plazas_disponibles, descripcion, creado_por, titulo',
        )
        .match({'creado_por': ref.read(usuarioProvider), 'hora_inicio': hora})
        .order('created_at')
        .limit(1);
    final viaje = Oferta.fromKeyValue(consulta[0]);
    state = await r.AsyncValue.guard(() {
      return Future(() => [viaje, ...(state.value!)]);
    });
  }

  void eliminarOferta(int id) {
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
    List<Oferta> ofertas = state.whenData((value) => value).value!;
    int index = ofertas.indexWhere((value) => value.id == id);
    Oferta o = ofertas[index];
    ofertas[index] = Oferta(
      id: id,
      origen: origen,
      destino: destino,
      hora: hora,
      plazasTotales: int.parse(plazas),
      plazasDisponibles: o.plazasDisponibles,
      titulo: titulo,
      descripcion: descripcion,
      creadoEn: o.creadoEn,
      creadoPor: o.creadoPor,
      latitudDestino: o.latitudDestino,
      latitudOrigen: o.latitudOrigen,
      longitudDestino: o.longitudDestino,
      longitudOrigen: o.longitudOrigen,
      nombreCreador: o.nombreCreador,
      urlIcono: o.urlIcono,
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
    final List consultaViajes = await Supabase.instance.client
        .from(
          'viaje',
        )
        .select(
          'id,created_at,origen,destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo',
        )
        .neq('creado_por', ref.read(usuarioProvider))
        .order('created_at');
    final List consultaPasajero = await Supabase.instance.client
        .from(
          'es_pasajero',
        )
        .select(
          'id_viaje',
        )
        .eq('id_usuario', ref.read(usuarioProvider));
    final listaViajes = Oferta.fromList(consultaViajes);
    final List<int> idsQuitar = consultaPasajero.map((e) => e['id_viaje'] as int).toList();

    final List<Oferta> res = listaViajes.where((e) {
      return idsQuitar.contains(e.id);
    }).toList();

    return Future.value(res);
  }

  void cancelarReserva(Oferta oferta) {
    ref.read(ofertasDisponiblesProvider.notifier).addOferta(oferta);
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

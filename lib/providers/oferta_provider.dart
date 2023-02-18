import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/oferta.dart';

class OfertaController extends r.AsyncNotifier<List<Oferta>> {
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
      return Future(() => [Oferta.fromJson(consulta), ...(state.value!)]);
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

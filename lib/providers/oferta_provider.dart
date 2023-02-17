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

  void addOferta(Oferta oferta) {
    state.value!.add(oferta);
  }

  void reservarPlaza(Oferta oferta) {
    _inicializarLista();
  }

  Future<List<Oferta>> _inicializarLista() async {
    final List datos = await Supabase.instance.client
        .from(
          'Viaje',
        )
        .select(
          'id,created_at,Origen,Destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo',
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

  Future<void> actualizarDatos() async {
    state = await r.AsyncValue.guard(_inicializarLista);
  }
}

final ofertasDelUsuario = r.Provider<List<Oferta>>((ref) {
  final listaViajes = ref.watch(ofertaProvider).value ?? [];
  if (listaViajes.isNotEmpty) {}

  final res = listaViajes.where((element) {
    return element.creadoPor == 1;
  }).toList();
  return res;
});

final ofertasApuntado = FutureProvider<List<Oferta>>((ref) async {
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
  final List datosDeApuntado = apuntado.map(
    (e) {
      return e['Id_viaje'];
    },
  ).toList();

  final res = listaViajes.where(
    (element) {
      return datosDeApuntado.contains(element.id);
    },
  ).toList();

  return res;
});

final ofertaProvider = r.AsyncNotifierProvider<OfertaController, List<Oferta>>(() {
  return OfertaController();
});

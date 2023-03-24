import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/mensaje.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';

final mensajesProvider = StreamProvider.family<List<Map<String, dynamic>>, int>((ref, idChat) {
  return ref.watch(databaseProvider).escucharMensajesChat(idChat);
});

class MensajesController extends FamilyAsyncNotifier<List<Mensaje>, int> {
  @override
  FutureOr<List<Mensaje>> build(int arg) {
    ref.watch(usuarioProvider);
    final suscripcion = ref.read(databaseProvider).escucharMensajes(arg);
    print('aqui');
    suscripcion.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: 'mensaje',
        //filter: 'chat_id=$arg',
      ),
      (payload, [ref]) {
        print('Change received: ${payload.toString()}');
        addMensajes(payload);
      },
    );
    return _inicializarLista(arg);
  }

  Future<List<Mensaje>> _inicializarLista(int idChat) async {
    return Future.value(ref.read(databaseProvider).recogerMensajesChat(idChat));
  }

  void addMensajes(dynamic nuevos) {}
}

final nuevoMensajesProvider = AsyncNotifierProviderFamily<MensajesController, List<Mensaje>, int>(
  () {
    return MensajesController();
  },
);

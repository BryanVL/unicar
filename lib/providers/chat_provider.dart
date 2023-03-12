import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/chat.dart';
import 'package:unicar/providers/usuario_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import 'database_provider.dart';

class ChatController extends AsyncNotifier<List<Chat>> {
  @override
  FutureOr<List<Chat>> build() {
    ref.watch(usuarioProvider);
    return _inicializarLista();
  }

  Future<List<Chat>> _inicializarLista() async {
    final List consultaChats = await ref.read(databaseProvider).recogerIdsChats(
          ref.read(usuarioProvider)!.id,
        );

    List<Chat> res = [];
    /*consultaChats.forEach((element) async {
      final List listausuarios = await ref.read(databaseProvider).recogerUsuariosAjenosChat(
            element['id'],
            ref.read(usuarioProvider)!.id,
          );
      listausuarios.forEach((element2) {
        res.add(Chat(element['id'], ref.read(usuarioProvider)!.id, element2['id']));
      });
    });*/

    for (int element in consultaChats) {
      final List listausuarios = await ref.read(databaseProvider).recogerUsuariosAjenosChat(
            element,
            ref.read(usuarioProvider)!.id,
          );

      for (String element2 in listausuarios) {
        res.add(Chat(element, ref.read(usuarioProvider)!.id, element2));
      }
    }
    //final listaChats = Chat.fromList(consultaChats);

    return Future.value(res);
  }

  void crearChat(String idReceptor) async {
    if (buscarIdDeChat(idReceptor) == -1) {
      final String idUsuario = ref.read(usuarioProvider)!.id;
      final int idChat = await ref.read(databaseProvider).crearChat(idReceptor);

      final nuevoChat = Chat(idChat, idUsuario, idReceptor);
      state = await AsyncValue.guard(() {
        return Future(() => [nuevoChat, ...(state.value!)]);
      });
    }
  }

  int buscarIdDeChat(String idReceptor) {
    final Chat? chatBuscado = state.value!.firstWhereOrNull(
      (element) => element.usuarioReceptor == idReceptor,
    );

    return chatBuscado == null ? -1 : chatBuscado.id;
  }
}

final chatProvider = AsyncNotifierProvider<ChatController, List<Chat>>(() {
  return ChatController();
});

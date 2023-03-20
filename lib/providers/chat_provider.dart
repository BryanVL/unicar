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
/*TODO si aqui para cada id de chat (element) hago una consulta a la tabla chat para recoger
la fecha del ultimo mensaje, puedo tambien ordenar.
Otra opcion sería mover el atributo ultimo_mensaje a la tabla participante de chat y al recoger
la fila de los dos usuario comparar las fechas y quedarme con el mas reciente y con
eso ordenar los chats*/
    for (int element in consultaChats) {
      final List listausuarios = await ref.read(databaseProvider).recogerUsuariosAjenosChat(
            element,
            ref.read(usuarioProvider)!.id,
          );

      for (String element2 in listausuarios) {
        res.add(Chat(element, ref.read(usuarioProvider)!.id, element2));
      }
    }

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

  void actualizarMensajesVistos(int idChat, String idUsuarioAjeno) {
    ref.read(databaseProvider).actualizarEstadoMensajes(idChat, idUsuarioAjeno);
  }

  void ponerChatAlPrincipio(int idChat) async {
    final estado = state.value!;
    final chat = estado.firstWhere((element) => element.id == idChat);
    estado.remove(chat);
    estado.insert(0, chat);
    state = await AsyncValue.guard(() {
      return Future(() => estado);
    });
  }
}

final chatProvider = AsyncNotifierProvider<ChatController, List<Chat>>(() {
  return ChatController();
});

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/chat.dart';
import 'package:unicar/providers/usuario_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import 'database_provider.dart';

class ChatController extends AsyncNotifier<List<Chat>> {
  final List<Chat>? valorDefecto;

  ChatController({this.valorDefecto});
  @override
  FutureOr<List<Chat>> build() {
    ref.watch(usuarioProvider);
    return valorDefecto != null ? Future.value(valorDefecto) : _inicializarLista();
  }

  Future<List<Chat>> _inicializarLista() async {
    final List consultaChats = await ref.read(databaseProvider).recogerIdsChats(
          ref.read(usuarioProvider)!.id,
        );

    List<Chat> res = [];
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

  Future<int> crearChat(String idReceptor) async {
    int? idChat = buscarIdDeChat(idReceptor);
    if (idChat == null) {
      final String idUsuario = ref.read(usuarioProvider)!.id;
      idChat = await ref.read(databaseProvider).crearChat(idReceptor);

      final nuevoChat = Chat(idChat, idUsuario, idReceptor);
      state = await AsyncValue.guard(() {
        return Future(() => [nuevoChat, ...(state.value!)]);
      });
    }
    return idChat;
  }

  int? buscarIdDeChat(String idReceptor) {
    final Chat? chatBuscado = state.value!.firstWhereOrNull(
      (element) => element.usuarioReceptor == idReceptor,
    );

    return chatBuscado?.id;
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

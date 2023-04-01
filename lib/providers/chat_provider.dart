import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/chat.dart';
import 'package:unicar/models/usuario.dart';
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

      for (Usuario element2 in listausuarios) {
        res.add(Chat(element, ref.read(usuarioProvider)!, element2, []));
      }
    }

    return Future.value(res);
  }

  Future<Chat> crearChat(Usuario receptor) async {
    Chat? nuevoChat = buscarChat(receptor.id);

    if (nuevoChat == null) {
      final idChat = await ref.read(databaseProvider).crearChat(receptor.id);

      nuevoChat = Chat(idChat, ref.read(usuarioProvider)!, receptor, []);
      state = await AsyncValue.guard(() {
        return Future(() => [nuevoChat!, ...(state.value!)]);
      });
    }
    return nuevoChat;
  }

  Chat? buscarChat(String idReceptor) {
    final Chat? chatBuscado = state.value!.firstWhereOrNull(
      (element) => element.usuarioReceptor.id == idReceptor,
    );

    return chatBuscado;
  }

  void actualizarMensajesVistos(int idChat, String idUsuarioAjeno) {
    ref.read(databaseProvider).actualizarEstadoMensajes(idChat, idUsuarioAjeno);
  }

  void actualizarChat(Chat chatActualizado) {
    final int index = state.value!.indexWhere((element) => element.id == chatActualizado.id);
    final estado = state.value!;
    estado[index] = chatActualizado;
    state = AsyncValue.data(estado);
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

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/chat.dart';
import 'package:unicar/providers/usuario_provider.dart';

import 'database_provider.dart';

class ChatController extends AsyncNotifier<List<Chat>> {
  @override
  FutureOr<List<Chat>> build() {
    return _inicializarLista();
  }

  Future<List<Chat>> _inicializarLista() async {
    final List consultaChats = await ref.read(databaseProvider).recogerChats(
          ref.read(usuarioProvider)!.id,
        );

    final listaChats = Chat.fromList(consultaChats);

    return Future.value(listaChats);
  }

  //TODO Crear chat
  void crearChat() {}
}

final chatProvider = AsyncNotifierProvider<ChatController, List<Chat>>(() {
  return ChatController();
});

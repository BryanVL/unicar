import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/chat.dart';
import 'package:unicar/models/mensaje.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/providers/mensajes_provider.dart';
import 'package:unicar/widgets/mensaje.dart';

import '../providers/usuario_provider.dart';
import '../widgets/cuadro_envio_mensaje.dart';

class VerChatScreen extends ConsumerWidget {
  const VerChatScreen(
    this.chat, {
    super.key,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mensajes = ref.watch(mensajesProvider(chat.id));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blue, //Color.fromARGB(198, 35, 86, 255),
        title: Text(
          chat.usuarioReceptor.nombre,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: mensajes.when(
              data: (data) {
                return ListView.builder(
                  reverse: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    //print(data);
                    return MensajeWidget(msg: Mensaje.fromKeyValue(data[index]));
                  },
                );
              },
              error: (error, stackTrace) => Text('Error al cargar los mensajes, Codigo: $error'),
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: EnvioMensajeWidget(chat.usuarioReceptor.id, chat.id),
          ),
        ],
      ),
    );
  }
}

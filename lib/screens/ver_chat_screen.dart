import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/usuario.dart';

import '../providers/usuario_provider.dart';
import '../widgets/cuadro_envio_mensaje.dart';

class VerChatScreen extends ConsumerWidget {
  const VerChatScreen(
    this.idUsuarioAjeno, {
    super.key,
  });
//TODO mostrar mensajes del chat seleccionado
//TODO escuchar mensajes provider y a lo que escucha pornerle un .listen() y en base a eso hacer cosas
  final String idUsuarioAjeno;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioAjeno(idUsuarioAjeno));
    return Scaffold(
      appBar: AppBar(
        title: usuario.when(
          data: (data) {
            return Text(
              data.nombre!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            );
          },
          error: (error, stackTrace) {
            return const Text('Hubo un problema al cargar el nombre del usuario');
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
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
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: EnvioMensajeWidget(),
          ),
        ],
      ),
    );
  }
}

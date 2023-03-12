import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/mensaje.dart';
import 'package:unicar/providers/usuario_provider.dart';

class MensajeWidget extends ConsumerWidget {
  const MensajeWidget({super.key, required this.msg});
  final Mensaje msg;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esDelUsuario = msg.idUsuarioCreador == ref.read(usuarioProvider)!.id;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Align(
        alignment: esDelUsuario ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: esDelUsuario ? Colors.blue[600] : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              msg.contenido,
              style: TextStyle(
                color: esDelUsuario ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

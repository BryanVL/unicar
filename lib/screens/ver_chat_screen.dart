import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/usuario.dart';

class VerChatScreen extends ConsumerWidget {
  const VerChatScreen(
    this.usuarioAjeno, {
    super.key,
  });
//TODO mostrar mensajes del chat seleccionado
//TODO escuchar mensajes provider y a lo que escucha pornerle un .listen() y en base a eso hacer cosas
  final Usuario usuarioAjeno;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          usuarioAjeno.nombre!,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

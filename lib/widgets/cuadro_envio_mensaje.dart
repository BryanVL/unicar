import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/chat_provider.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/widgets/textform.dart';

class EnvioMensajeWidget extends ConsumerWidget {
  EnvioMensajeWidget(this.idUsuarioAjeno, {super.key});
  final String idUsuarioAjeno;

  final TextEditingController _mensaje = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 135,
            ),
            child: Scrollbar(
              thickness: 0,
              child: MyTextForm(
                controlador: _mensaje,
                label: 'Escribe un mensaje',
                tipoTeclado: TextInputType.text,
                funcionValidacion: null,
                usarMaximo: true,
              ),
            ),
          ),
        ),
        IconButton(
          alignment: Alignment.center,
          iconSize: 42,
          onPressed: () {
            if (_mensaje.text != '') {
              ref.read(databaseProvider).enviarMensaje(
                  ref.read(chatProvider.notifier).buscarIdDeChat(idUsuarioAjeno)!,
                  _mensaje.text,
                  ref.read(usuarioProvider)!.id);
              _mensaje.text = '';
            }
          },
          icon: const Icon(
            size: 42,
            color: Colors.blue,
            Icons.send_rounded,
          ),
        ),
      ],
    );
  }
}

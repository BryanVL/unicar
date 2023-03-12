import 'package:flutter/material.dart';
import 'package:unicar/widgets/textform.dart';

class EnvioMensajeWidget extends StatefulWidget {
  const EnvioMensajeWidget({super.key});

  @override
  State<EnvioMensajeWidget> createState() => _EnvioMensajeWidgetState();
}

class _EnvioMensajeWidgetState extends State<EnvioMensajeWidget> {
  final TextEditingController _mensaje = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {},
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

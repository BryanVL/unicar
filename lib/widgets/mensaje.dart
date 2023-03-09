import 'package:flutter/material.dart';

import '../models/mensaje.dart';

//TODO burbuja de mensaje
class MensajeWidget extends StatelessWidget {
  const MensajeWidget({super.key, required this.msg});
  final Mensaje msg;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(msg.contenido),
      ),
    );
  }
}

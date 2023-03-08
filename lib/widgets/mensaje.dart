import 'package:flutter/material.dart';

class Mensaje extends StatelessWidget {
  const Mensaje({super.key, required this.contenido});
  final String contenido;
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
        child: Text(contenido),
      ),
    );
  }
}

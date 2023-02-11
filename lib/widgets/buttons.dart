import 'package:flutter/material.dart';

class boton extends StatelessWidget {
  const boton({super.key, required this.funcion, required this.textoBoton});
  final VoidCallback funcion;
  final String textoBoton;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: funcion,
      child: Text(textoBoton),
    );
  }
}

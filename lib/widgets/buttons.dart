import 'package:flutter/material.dart';

class boton extends StatelessWidget {
  const boton(
      {super.key,
      required this.funcion,
      required this.textoBoton,
      this.paddingTop,
      this.paddingBottom,
      this.paddingLeft,
      this.paddingRight});
  final VoidCallback funcion;
  final String textoBoton;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(
          top: paddingTop ?? 0,
          bottom: paddingBottom ?? 0,
          left: paddingLeft ?? 0,
          right: paddingRight ?? 0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: funcion,
      child: Text(textoBoton),
    );
  }
}

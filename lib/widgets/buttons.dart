import 'package:flutter/material.dart';

class Boton extends StatelessWidget {
  const Boton({
    super.key,
    required this.funcion,
    required this.textoBoton,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.paddingTodo,
    this.colorBoton,
    this.textSize,
  });
  final VoidCallback funcion;
  final String textoBoton;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingTodo;
  final Color? colorBoton;
  final double? textSize;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorBoton,
        padding: EdgeInsets.only(
          top: paddingTop ?? paddingTodo ?? 0,
          bottom: paddingBottom ?? paddingTodo ?? 0,
          left: paddingLeft ?? paddingTodo ?? 0,
          right: paddingRight ?? paddingTodo ?? 0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: funcion,
      child: Text(
        textoBoton,
        style: TextStyle(
          fontSize: textSize,
        ),
      ),
    );
  }
}

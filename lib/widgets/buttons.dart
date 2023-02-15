import 'package:flutter/material.dart';

class boton extends StatelessWidget {
  const boton({
    super.key,
    required this.funcion,
    required this.textoBoton,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.paddingTodo,
  });
  final VoidCallback funcion;
  final String textoBoton;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingTodo;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
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
      child: Text(textoBoton),
    );
  }
}

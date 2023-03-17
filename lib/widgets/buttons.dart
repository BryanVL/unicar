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
          top: paddingTop ?? paddingTodo ?? 12,
          bottom: paddingBottom ?? paddingTodo ?? 12,
          left: paddingLeft ?? paddingTodo ?? 12,
          right: paddingRight ?? paddingTodo ?? 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
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

class BotonMaterial extends StatelessWidget {
  const BotonMaterial(
      {super.key,
      required this.contenido,
      required this.funcion,
      this.colorBorde,
      this.anchoBorde,
      this.paddingContenido,
      this.paddingExterior});
  final Widget contenido;
  final VoidCallback funcion;
  final Color? colorBorde;
  final double? anchoBorde;
  final EdgeInsets? paddingContenido;
  final EdgeInsets? paddingExterior;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingExterior ?? const EdgeInsets.only(top: 24.0, left: 24, right: 24),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: colorBorde ?? Colors.blue,
            width: anchoBorde ?? 2,
          ),
        ),
        onPressed: funcion,
        child: Padding(
          padding: paddingContenido ?? const EdgeInsets.symmetric(vertical: 16.0),
          child: contenido,
        ),
      ),
    );
  }
}

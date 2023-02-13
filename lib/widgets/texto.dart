import 'package:flutter/material.dart';

class TextoSeccion extends StatelessWidget {
  const TextoSeccion(
      {super.key,
      required this.texto,
      this.paddingTop,
      this.paddingBottom,
      this.paddingLeft,
      this.paddingRight});
  final String texto;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop ?? 0,
        bottom: paddingBottom ?? 0,
        left: paddingLeft ?? 0,
        right: paddingRight ?? 0,
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 30,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

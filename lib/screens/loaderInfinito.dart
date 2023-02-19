import 'package:flutter/material.dart';

class EndlessLoader extends StatelessWidget {
  const EndlessLoader({Key? key, required this.tiempoMili}) : super(key: key);
  final int tiempoMili;
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: tiempoMili),
      () {
        Navigator.of(context).pop();
      },
    );
    return const Scaffold(
      backgroundColor: Color.fromARGB(97, 75, 165, 201),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

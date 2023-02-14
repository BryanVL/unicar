import 'package:flutter/material.dart';

class VerViajeScreen extends StatelessWidget {
  const VerViajeScreen({super.key});
  static const kRouteName = "/VerViaje";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Titulo de viaje'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(children: []),
    );
  }
}

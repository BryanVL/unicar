import 'package:flutter/material.dart';
import 'package:unicar/widgets/dropdown.dart';

class CrearOferta extends StatefulWidget {
  const CrearOferta({super.key});

  static const kRouteName = "/CrearOferta";

  @override
  State<CrearOferta> createState() => _CrearOfertaState();
}

class _CrearOfertaState extends State<CrearOferta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Nuevo viaje'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            customDropdown(titulo: 'Origen'),
            customDropdown(titulo: 'Destino'),
            Container(
              width: 300,
              height: 200,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}

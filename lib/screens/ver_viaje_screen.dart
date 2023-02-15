import 'package:flutter/material.dart';
import 'package:unicar/widgets/buttons.dart';

import '../models/oferta.dart';

class VerViajeScreen extends StatelessWidget {
  VerViajeScreen({
    super.key,
    required this.oferta,
  });

  final Oferta oferta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(oferta.titulo!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Hero(
                  tag: 'imagenUsuario${oferta.id}',
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(oferta.urlIcono!),
                    radius: 35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    oferta.nombreCreador!,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
            child: Text(
              'Origen: ${oferta.origen}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
            child: Text(
              'Destino: ${oferta.destino}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
            child: Text(
              'Plazas disponibles: ${oferta.plazasDisponibles}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
            child: Text(
              'Hora salida: ${oferta.hora}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
            child: Text(
              'Descripción',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0, left: 16),
            child: Text(
              oferta.descripcion ?? 'Sin descripción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: Container(
              alignment: Alignment.center,
              width: 300,
              height: 200,
              color: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: boton(
                    paddingTodo: 16,
                    funcion: () {},
                    textoBoton: 'Solicitar plaza',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: boton(
                    paddingTodo: 16,
                    funcion: () {},
                    textoBoton: 'Abrir chat',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:unicar/widgets/buttons.dart';

import '../widgets/tarjeta_viaje.dart';

class OfertasScreen extends StatelessWidget {
  const OfertasScreen({super.key});

  static const kRouteName = "/Ofertas";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(
                top: 32,
                left: 16,
              ),
              child: boton(
                  paddingTop: 16,
                  paddingBottom: 16,
                  paddingLeft: 64,
                  paddingRight: 64,
                  funcion: () {
                    Navigator.of(context).pushNamed('/CrearOferta');
                  },
                  textoBoton: 'Filtrar')),
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 100,
                itemBuilder: (context, index) {
                  return tarjetaViaje(
                    //key: Key('$index'),
                    origen: 'origen',
                    destino: 'destino',
                    fechaHora: 'fechaHora',
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 60, 119, 245),
        onPressed: () {
          Navigator.of(context).pushNamed('/CrearOferta');
        },
        label: const Text('Publicar oferta'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/screens/crear_oferta_screen.dart';
import 'package:unicar/screens/filtrar_screen.dart';
import 'package:unicar/widgets/buttons.dart';

import '../widgets/tarjeta_viaje.dart';

class OfertasScreen extends ConsumerWidget {
  const OfertasScreen({super.key});

  static const kRouteName = "/Ofertas";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viajes = ref.watch(ofertasProvider);
    print('Remontado');
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
            ),
            child: Boton(
              paddingTop: 12,
              paddingBottom: 12,
              paddingLeft: 48,
              paddingRight: 48,
              textoBoton: 'Filtrar',
              textSize: 20,
              funcion: () {
                Navigator.of(context).pushNamed(FiltrarScreen.kRouteName);
              },
            ),
          ),
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viajes.length,
                itemBuilder: (context, index) {
                  return TarjetaViajeWidget(
                    tipo: TipoViaje.oferta,
                    oferta: viajes[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 60, 119, 245),
        onPressed: () {
          Navigator.of(context).pushNamed(CrearOferta.kRouteName);
        },
        label: const Text(
          'Publicar oferta',
          style: TextStyle(fontSize: 16),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

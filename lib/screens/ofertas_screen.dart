import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/viaje_provider.dart';
import 'package:unicar/widgets/buttons.dart';

import '../models/tarjetaViaje.dart';
import '../widgets/tarjeta_viaje.dart';

class OfertasScreen extends ConsumerWidget {
  const OfertasScreen({super.key});

  static const kRouteName = "/Ofertas";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datosTarjetasViaje = ref.watch(dataTarjetasViajesOferta);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                top: 32,
                left: 16,
              ),
              child: boton(
                  paddingTop: 16,
                  paddingBottom: 16,
                  paddingLeft: 64,
                  paddingRight: 64,
                  funcion: () {
                    Navigator.of(context).pushNamed('/Filtrar');
                  },
                  textoBoton: 'Filtrar')),
          datosTarjetasViaje.when(
            data: (data) {
              return Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return TarjetaViajeWidget(
                        tipo: TipoViaje.oferta,
                        datosTarjeta: TarjetaViaje(
                          id: data[index].id,
                          origen: data[index].origen,
                          destino: data[index].destino,
                          fechaHora: data[index].fechaHora,
                          titulo: data[index].titulo,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            loading: () {
              return CircularProgressIndicator();
            },
            error: (error, stackTrace) {
              return Text(
                  'Hubo un error al cargar los viajes, intentalo de nuevo. Codigo error: $error');
            },
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

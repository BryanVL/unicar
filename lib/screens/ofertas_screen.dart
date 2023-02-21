import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/screens/crear_oferta_screen.dart';
import 'package:unicar/screens/filtrar_screen.dart';
import 'package:unicar/widgets/buttons.dart';

import '../models/tarjetaViaje.dart';
import '../widgets/tarjeta_viaje.dart';

class OfertasScreen extends ConsumerWidget {
  const OfertasScreen({super.key});

  static const kRouteName = "/Ofertas";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viajes = ref.watch(ofertasDisponiblesProvider);
    return Scaffold(
      body: viajes.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                ),
                child: boton(
                  paddingTop: 16,
                  paddingBottom: 16,
                  paddingLeft: 64,
                  paddingRight: 64,
                  textoBoton: 'Filtrar',
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
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return TarjetaViajeWidget(
                        tipo: TipoViaje.oferta,
                        datosTarjeta: TarjetaViaje(
                          id: data[index].id,
                          origen: data[index].origen,
                          destino: data[index].destino,
                          fechaHora: data[index].hora,
                          titulo: data[index].titulo,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Text(
              'Hubo un error al cargar los viajes, intentalo de nuevo. Codigo error: $error');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 60, 119, 245),
        onPressed: () {
          Navigator.of(context).pushNamed(CrearOferta.kRouteName);
        },
        label: const Text('Publicar oferta'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

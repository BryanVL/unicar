import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/screens/filtrar_screen.dart';

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
                        oferta: data[index],
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
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 60, 119, 245),
        onPressed: () {
          Navigator.of(context).pushNamed(FiltrarScreen.kRouteName);
        },
        label: const Text(
          'Filtrar',
          style: TextStyle(fontSize: 20),
        ),
        icon: const Icon(Icons.filter_list),
      ),
    );
  }
}

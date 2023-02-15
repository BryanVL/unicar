import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/viaje_provider.dart';

import '../widgets/seccion_tarjetas.dart';
import '../widgets/texto.dart';

class MisViajesScreen extends ConsumerWidget {
  const MisViajesScreen({super.key});

  static const kRouteName = "/ViajesScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viajesDelUsuario = ref.watch(dataTarjetasViajesUsuario);
    final viajesApuntado = ref.watch(dataTarjetasViajesApuntado);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                const TextoSeccion(
                  paddingLeft: 16,
                  paddingBottom: 16,
                  texto: 'Viajes que ofreces',
                ),
                viajesDelUsuario.when(
                  data: (data) {
                    return SeccionTarjetas(
                      datosViaje: data,
                    );
                  },
                  loading: () {
                    return SizedBox(
                      height: 100,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Text(
                        'Hubo un error al cargar los viajes, intentalo de nuevo. Codigo error: $error');
                  },
                ),
                const TextoSeccion(
                  texto: 'Viajes en los que estas apuntado',
                  paddingTop: 48,
                  paddingBottom: 16,
                  paddingLeft: 16,
                ),
                viajesApuntado.when(
                  data: (data) {
                    return SeccionTarjetas(
                      datosViaje: data,
                    );
                  },
                  loading: () {
                    return SizedBox(
                      height: 100,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Text(
                        'Hubo un error al cargar los viajes, intentalo de nuevo. Codigo error: $error');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

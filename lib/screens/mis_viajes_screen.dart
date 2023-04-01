import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/chat_provider.dart';
import 'package:unicar/providers/oferta_provider.dart';

import '../widgets/seccion_tarjetas.dart';
import '../widgets/texto.dart';
import 'crear_oferta_screen.dart';

class MisViajesScreen extends ConsumerWidget {
  const MisViajesScreen({super.key});

  static const kRouteName = "/ViajesScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viajesDelUsuario = ref.watch(ofertasOfrecidasUsuarioProvider);
    final viajesApuntado = ref.watch(ofertasUsuarioApuntadoProvider);
    //El tener esto aqui es para inicializar el estado de chats sin que el usuario
    //Entre en la pantalla de chats, hasta que encuentre una mejor manera de hacerlo
    //esto debe estar aqui para evitar errores
    // ignore: unused_local_variable
    final chats = ref.read(chatProvider);
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
                      tipo: TipoViaje.propio,
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
                      tipo: TipoViaje.apuntado,
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
                )
              ],
            ),
          )
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

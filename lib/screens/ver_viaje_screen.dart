import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:unicar/providers/chat_provider.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/editar_oferta_screen.dart';
import 'package:unicar/screens/tab_bar_screen.dart';
import 'package:unicar/screens/ver_chat_screen.dart';
import 'package:unicar/widgets/buttons.dart';
import 'package:unicar/widgets/mapa.dart';
import 'package:unicar/widgets/texto.dart';

import '../models/oferta.dart';
import '../providers/tema_provider.dart';

class VerViajeScreen extends ConsumerWidget {
  const VerViajeScreen({
    super.key,
    required this.oferta,
    required this.tipo,
  });
  final TipoViaje tipo;
  final Oferta oferta;
  final estiloTexto = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pasajeros = ref.watch(pasajerosViajeProvider(oferta.id));
    final plazasD = ref.watch(plazasProvider(oferta.id));

    final botonEliminar = Boton(
      colorBoton: Colors.red,
      textSize: 16,
      paddingTodo: 16,
      funcion: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text('¿Estas seguro de que quieres borrar el viaje?'),
              actions: [
                TextButton(
                  onPressed: () {
                    ref.read(ofertasOfrecidasUsuarioProvider.notifier).eliminarOferta(oferta.id);
                    Navigator.of(context).popUntil(ModalRoute.withName(TabBarScreen.kRouteName));
                  },
                  child: const Text('Borrar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
      textoBoton: 'Eliminar oferta',
    );

    final botonEditar = Boton(
      textSize: 16,
      paddingTodo: 16,
      funcion: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EditarOfertaScreen(oferta)),
        );
      },
      textoBoton: 'Editar oferta',
    );

    final botonAbrirChat = Boton(
      textSize: 16,
      paddingTodo: 16,
      funcion: () async {
        if (context.mounted) {
          ref.read(chatProvider.notifier).crearChat(oferta.creadoPor);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => VerChatScreen(oferta.creadoPor),
          ));
        }
      },
      textoBoton: 'Abrir chat',
    );

    final botonReservar = Boton(
      textSize: 16,
      paddingTodo: 16,
      funcion: () {
        ref.read(ofertasDisponiblesProvider.notifier).reservarPlaza(oferta);
        Navigator.of(context).pop();
      },
      textoBoton: 'Reservar plaza',
    );

    final botonCancelarPlaza = Boton(
      textSize: 16,
      colorBoton: Colors.red,
      paddingTodo: 16,
      funcion: () {
        ref.read(ofertasUsuarioApuntadoProvider.notifier).cancelarReserva(oferta);

        Navigator.of(context).pop();
      },
      textoBoton: 'Cancelar reserva',
    );
    Widget devolverBoton(TipoViaje t) {
      switch (t) {
        case TipoViaje.propio:
          return botonEditar;
        case TipoViaje.apuntado:
          return botonCancelarPlaza;
        case TipoViaje.oferta:
          return botonReservar;
      }
    }

    final tema = ref.watch(temaProvider).when(
          data: (data) => data == 'claro' ? true : false,
          error: (error, stackTrace) => true,
          loading: () => true,
        );

    Color color = tema ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Hero(
          tag: 'titulo${oferta.id}',
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              oferta.titulo!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      backgroundImage: ref.read(imagenDefectoProvider),
                      /*AssetImage(
                          'lib/assets/defaultProfile.png'),*/ //NetworkImage(oferta.urlIcono!), //TODO cosa de imagen
                      radius: 35,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      oferta.nombreCreador,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextoTitulo(texto: 'Viaje'),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                    child: Hero(
                      tag: 'viajeOD${oferta.id}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: color, fontSize: 20),
                            children: [
                              const TextSpan(text: 'Viaje con origen '),
                              TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                text: oferta.origen,
                              ),
                              const TextSpan(text: ' y destino '),
                              TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                text: oferta.destino,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const TextoTitulo(texto: 'Hora'),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      bottom: 8,
                      top: 8,
                    ),
                    child: Hero(
                      tag: 'hora${oferta.id}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: color, fontSize: 20),
                            children: [
                              TextSpan(
                                text: oferta.paraEstarA ? 'Para estar el: ' : 'Salida: ',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                  text: DateFormat('dd/MM/yyyy  kk:mm')
                                      .format(DateTime.parse(oferta.hora))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const TextoTitulo(texto: 'Datos extra'),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      bottom: 8,
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: color, fontSize: 20),
                        children: [
                          const TextSpan(
                            text: 'Plazas libres: ',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                              text: '${plazasD.when(
                            data: (data) => data,
                            error: (error, stackTrace) => 'No se puedieron cargar las plazas',
                            loading: () => '',
                          )}'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
                    child: Text(
                      'Descripción',
                      style: estiloTexto,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, left: 32),
                    child: Text(
                      oferta.descripcion == '' ? 'Sin descripción' : oferta.descripcion!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  tipo == TipoViaje.propio
                      ? Column(
                          children: [
                            const TextoTitulo(texto: 'Pasajeros apuntados'),
                            Column(
                              children: pasajeros.when(
                                data: (data) {
                                  List<Widget> res = [];
                                  for (var element in data) {
                                    res.add(
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage: ref.read(imagenDefectoProvider),
                                            radius: 20,
                                          ),
                                          title: Text(element.nombre!),
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(width: 1, color: Colors.blue),
                                              borderRadius: BorderRadius.circular(15)),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete_outlined),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        '¿Estas seguro de que quieres cancelar la reserva del usuario ${element.nombre}?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          ref
                                                              .read(databaseProvider.notifier)
                                                              .eliminarPasajero(
                                                                oferta.id,
                                                                element.id,
                                                                oferta.plazasDisponibles,
                                                              );
                                                          ref
                                                              .read(
                                                                  pasajerosViajeProvider(oferta.id)
                                                                      .notifier)
                                                              .update((state) {
                                                            state.value!.removeWhere(
                                                                (user) => user.id == element.id);
                                                            final res = state.value!;
                                                            return AsyncData(res);
                                                          });

                                                          if (context.mounted) {
                                                            Navigator.of(context).pop();
                                                          }
                                                        },
                                                        child: const Text('Aceptar'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('Cancelar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          onTap: () {},
                                          onLongPress: () {},
                                        ),
                                      ),
                                    );
                                  }
                                  if (res.isEmpty) {
                                    res.add(
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'No hay pasajeros apuntados',
                                            style: TextStyle(fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return res;
                                },
                                error: (error, stackTrace) =>
                                    [const Text('No se pudieron cargar los pasajeros')],
                                loading: () => [const Center(child: CircularProgressIndicator())],
                              ),
                            ),
                          ],
                        )
                      : Column(),
                ],
              ),
            ),

            //TODO poner aqui listview para poner tarjetas por cada usuario que sea pasajero
            //con un boton para eliminarlo
            Padding(
              padding: const EdgeInsets.only(top: 48.0, bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: devolverBoton(tipo),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: tipo == TipoViaje.propio ? botonEliminar : botonAbrirChat),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 96.0),
              child: oferta.coordOrigen != null
                  ? SizedBox(
                      height: 300,
                      child: Mapa(oferta.coordOrigen!, oferta.coordDestino!, oferta.radioOrigen!,
                          oferta.radioDestino!))
                  : const SizedBox(
                      height: 1,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

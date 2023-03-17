import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:unicar/providers/chat_provider.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/editar_oferta_screen.dart';
import 'package:unicar/screens/tab_bar_screen.dart';
import 'package:unicar/screens/ver_chat_screen.dart';
import 'package:unicar/widgets/buttons.dart';
import 'package:unicar/widgets/mapa.dart';
import 'package:unicar/widgets/texto.dart';

import '../models/oferta.dart';

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
                    padding: const EdgeInsets.only(left: 32.0, bottom: 8),
                    child: Hero(
                      tag: 'viajeOD${oferta.id}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black, fontSize: 20),
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
                      left: 32.0,
                      bottom: 8,
                      top: 8,
                    ),
                    child: Hero(
                      tag: 'hora${oferta.id}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black, fontSize: 20),
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
                      left: 32.0,
                      bottom: 8,
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                        children: [
                          const TextSpan(
                            text: 'Plazas libres: ',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: '${oferta.plazasDisponibles}'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, bottom: 8, top: 8),
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
                ],
              ),
            ),
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
                      height: 300,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

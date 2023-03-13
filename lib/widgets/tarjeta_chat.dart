import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/chat_provider.dart';
import 'package:unicar/providers/mensajes_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/ver_chat_screen.dart';

import '../models/chat.dart';

class TarjetaChat extends ConsumerWidget {
  const TarjetaChat({
    super.key,
    required this.chat,
  });
  final Chat chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String idBuscar = ref.watch(usuarioProvider)!.id == chat.usuarioCreador
        ? chat.usuarioReceptor
        : chat.usuarioCreador;
    final otroUsuario = ref.watch(usuarioAjeno(idBuscar));
    final ultimoMensaje = ref.watch(mensajesProvider(chat.id));
    return otroUsuario.when(
      data: (data) {
        return Padding(
            padding: const EdgeInsets.only(
              bottom: 24,
              right: 16,
              left: 16,
            ),
            child: ultimoMensaje.when(
              data: (msg) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: const Offset(4.0, 4.0),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                    color: msg.isEmpty ||
                            msg[0]['creador'] == ref.watch(usuarioProvider)!.id ||
                            msg[0]['visto']
                        ? Colors.white
                        : const Color.fromARGB(255, 220, 220, 255),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Material(
                    elevation: 0,
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        ref.read(chatProvider.notifier).actualizarMensajesVistos(chat.id, data.id);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VerChatScreen(data.id),
                        ));
                      },
                      splashColor: Colors.blue[300],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 60,
                            width: 60,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  //TODO icono
                                  'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    maxLines: 1,
                                    data.nombre!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 22.0,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    msg.isEmpty ? '' : msg[0]['contenido'],
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      overflow: TextOverflow.ellipsis,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => const Text('Error'),
              loading: () => const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 0,
              )),
            ));
      },
      error: (Object error, StackTrace stackTrace) {
        return Text('Error al cargar los chats, Codigo: $error');
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

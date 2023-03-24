import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/chat_provider.dart';
import 'package:unicar/providers/mensajes_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/ver_chat_screen.dart';

import '../models/chat.dart';
import '../providers/tema_provider.dart';

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
    final ultimoMensaje = ref.watch(nuevoMensajesProvider(chat.id));
    //Este listen hace que el chat se ponga el primero si alguien manda un mensaje
    ref.listen(mensajesProvider(chat.id), (AsyncValue<List<Map<String, dynamic>>>? previous,
        AsyncValue<List<Map<String, dynamic>>>? next) {
      if (previous != null &&
          previous.hasValue &&
          next != null &&
          next.hasValue &&
          previous.value!.length != next.value!.length) {
        ref.read(chatProvider.notifier).ponerChatAlPrincipio(chat.id);
      }
    });
    final tema = ref.watch(temaProvider).when(
          data: (data) => data == 'claro' ? true : false,
          error: (error, stackTrace) => true,
          loading: () => true,
        );

    BoxDecoration temaClaro = BoxDecoration(
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
      color: ultimoMensaje.when(
        data: (msg) {
          return msg.isEmpty ||
                  msg[0].idUsuarioCreador == ref.watch(usuarioProvider)!.id ||
                  msg[0].visto
              ? Colors.white
              : const Color.fromARGB(255, 220, 220, 255);
        },
        error: (error, stackTrace) => Colors.white,
        loading: () => Colors.white,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
    );

    BoxDecoration temaOscuro = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade800,
          offset: const Offset(4.0, 4.0),
          blurRadius: 15,
          spreadRadius: 1,
        ),
        const BoxShadow(
          color: Colors.black,
          offset: Offset(-4.0, -4.0),
          blurRadius: 15,
          spreadRadius: 1,
        ),
      ],
      color: ultimoMensaje.when(
        data: (msg) {
          return msg.isEmpty ||
                  msg[0].idUsuarioCreador == ref.watch(usuarioProvider)!.id ||
                  msg[0].visto
              ? const Color.fromARGB(255, 29, 26, 26)
              : const Color.fromARGB(255, 220, 220, 255);
        },
        error: (error, stackTrace) => Colors.white,
        loading: () => Colors.white,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
    );

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
                  decoration: tema ? temaClaro : temaOscuro,
                  child: Material(
                    elevation: 0,
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        ultimoMensaje.whenData((msg) {
                          if (msg.isNotEmpty &&
                              msg[0].idUsuarioCreador != ref.watch(usuarioProvider)!.id &&
                              !msg[0].visto) {
                            ref
                                .read(chatProvider.notifier)
                                .actualizarMensajesVistos(chat.id, data.id);
                          }
                        });

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VerChatScreen(data.id, chat.id),
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
                              image: DecorationImage(
                                image: data.urlIcono != null
                                    ? NetworkImage(data.urlIcono!)
                                    : ref.read(imagenDefectoProvider),
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
                                    data.nombre,
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
                                    msg.isEmpty ? '' : msg[0].contenido,
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
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }
}

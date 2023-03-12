import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final String idBuscar = ref.read(usuarioProvider)!.id == chat.usuarioCreador
        ? chat.usuarioReceptor
        : chat.usuarioCreador;
    final otroUsuario = ref.watch(usuarioAjeno(idBuscar));
    return otroUsuario.when(
      data: (data) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
            right: 8,
            left: 8,
          ),
          child: Container(
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
              color: Colors.white,
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VerChatScreen(data.id),
                  ));
                },
                splashColor: Colors.blue[300],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
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
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //),
        );
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

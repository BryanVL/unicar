import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/ver_viaje_screen.dart';

import '../models/oferta.dart';
import '../providers/tema_provider.dart';

class TarjetaViajeWidget extends ConsumerWidget {
  const TarjetaViajeWidget({
    super.key,
    required this.tipo,
    required this.oferta,
  });

  final Oferta oferta;
  final TipoViaje tipo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? imagenUsuario;

    if (TipoViaje.propio != tipo) {
      final usr = ref.watch(usuarioAjeno(oferta.creadoPor));
      usr.whenData((value) => imagenUsuario = value.urlIcono);
    } else {
      imagenUsuario = ref.watch(usuarioProvider)!.urlIcono;
    }

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
      color: /*Color.fromARGB(255, 240, 240, 255),*/
          Colors.white,
      /*Colors.blue[400],*/
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
      color: /*Color.fromARGB(255, 240, 240, 255),*/
          const Color.fromARGB(255, 29, 26, 26),
      /*Colors.blue[400],*/
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
        right: 16,
        left: 16,
      ),
      child: DecoratedBox(
        decoration: tema ? temaClaro : temaOscuro,
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VerViajeScreen(oferta: oferta, tipo: tipo),
              ));
            },
            splashColor: Colors.blue[300],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'imagenUsuario${oferta.id}',
                  child: Container(
                    height: 80,
                    width: 80,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: imagenUsuario != null
                            ? NetworkImage(imagenUsuario!)
                            : ref.read(imagenDefectoProvider),
                        fit: BoxFit.cover,
                      ),
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
                        Hero(
                          tag: 'titulo${oferta.id}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              maxLines: 1,
                              (oferta.titulo == null || oferta.titulo == ''
                                  ? 'Viaje a ${oferta.destino}'
                                  : oferta.titulo)!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20.0,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Hero(
                            tag: 'viajeOD${oferta.id}',
                            child: Material(
                              type: MaterialType.transparency,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    const WidgetSpan(
                                      child: Icon(
                                        Icons.map_outlined,
                                        size: 19,
                                        //color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Colors.blue[800],
                                      ),
                                      text: oferta.origen,
                                    ),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.arrow_right_alt_rounded,
                                        size: 17,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                    TextSpan(
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Colors.blue[800],
                                      ),
                                      text: oferta.destino,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Hero(
                          tag: 'hora${oferta.id}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.timelapse,
                                    size: 19,
                                  ),
                                  oferta.paraEstarA
                                      ? Text(
                                          'Para estar: ${DateFormat('dd/MM kk:mm').format(DateTime.parse(oferta.hora))}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Color.fromARGB(255, 53, 27, 145)),
                                        )
                                      : Text(
                                          'Salida: ${DateFormat('dd/MM kk:mm').format(DateTime.parse(oferta.hora))}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Color.fromARGB(255, 53, 27, 145)),
                                        ),
                                ],
                              ),
                            ),
                          ),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicar/screens/ver_viaje_screen.dart';

import '../models/oferta.dart';

class TarjetaViajeWidget extends StatelessWidget {
  const TarjetaViajeWidget({
    super.key,
    required this.tipo,
    required this.oferta,
  });

  final Oferta oferta;
  final TipoViaje tipo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
        right: 16,
        left: 16,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          /*border: const Border.fromBorderSide(
              BorderSide(
                color: Colors.blue,
                width: 1,
              ),
            ),*/
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
                        image: NetworkImage(
                          oferta.urlIcono ??
                              'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                /*Expanded(
                    flex: 1,
                    child: Hero(
                      tag: 'imagenUsuario${datosTarjeta.id}',
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg'),
                        radius: 35,
                      ),
                    ),
                  ),*/
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
                                fontSize: 22.0,
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
                                    TextSpan(
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      text: oferta.origen,
                                    ),
                                    const WidgetSpan(
                                      child: Icon(
                                        Icons.arrow_right_alt_rounded,
                                        size: 16,
                                      ),
                                    ),
                                    TextSpan(
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
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
                              child: Text(
                                'Salida: ${DateFormat('dd/MM kk:mm').format(DateTime.parse(oferta.hora))}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
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
      //),
    );
  }
}

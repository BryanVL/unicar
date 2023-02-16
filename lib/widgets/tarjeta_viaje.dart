import 'package:flutter/material.dart';
import 'package:unicar/models/tarjetaViaje.dart';
import 'package:unicar/screens/ver_viaje_screen.dart';

import '../models/oferta.dart';

class TarjetaViajeWidget extends StatelessWidget {
  const TarjetaViajeWidget({
    super.key,
    required this.datosTarjeta,
    required this.tipo,
  });
  final TarjetaViaje datosTarjeta;
  final TipoViaje tipo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
        right: 16,
        left: 16,
      ),
      child: GestureDetector(
        onTap: () async {
          final Future<List> objFuturo = Oferta.datosExtra(datosTarjeta.id);
          objFuturo.then((value) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VerViajeScreen(
                  tipo: tipo,
                  oferta: Oferta(
                    id: datosTarjeta.id,
                    origen: datosTarjeta.origen,
                    destino: datosTarjeta.destino,
                    hora: datosTarjeta.fechaHora,
                    plazasDisponibles: value[0]['plazas_disponibles'] ?? 0,
                    titulo: datosTarjeta.titulo == null || datosTarjeta.titulo == ''
                        ? 'Viaje a ${datosTarjeta.destino}'
                        : datosTarjeta.titulo,
                    descripcion: value[0]['descripcion'],
                    urlIcono: datosTarjeta.iconoURL ??
                        'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg',
                    nombreCreador: value[0]['Usuario']['nombre'],
                    creadoPor: value[0]['Usuario']['id'],
                  ),
                ),
              ),
            );
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                Color.fromARGB(197, 51, 123, 206),
                Colors.blue,
              ],
            ),
            color: Color.fromARGB(197, 51, 123, 206),
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
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
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 1,
                        (datosTarjeta.titulo == null || datosTarjeta.titulo == ''
                            ? 'Viaje a ${datosTarjeta.destino}'
                            : datosTarjeta.titulo)!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 22.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              text: datosTarjeta.origen,
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
                              text: datosTarjeta.destino,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Salida: ${datosTarjeta.fechaHora}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
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

import 'package:flutter/material.dart';
import 'package:unicar/models/tarjetaViaje.dart';

class TarjetaViajeWidget extends StatelessWidget {
  const TarjetaViajeWidget({
    super.key,
    required this.datosTarjeta,
  });
  final TarjetaViaje datosTarjeta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
        right: 16,
        left: 16,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/VerViaje');
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
                const Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg'),
                    radius: 35,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        maxLines: 1,
                        'Titulo de viaje',
                        style: TextStyle(
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

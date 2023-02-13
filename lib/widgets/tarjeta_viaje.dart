import 'package:flutter/material.dart';

class tarjetaViaje extends StatelessWidget {
  const tarjetaViaje({
    super.key,
    this.titulo,
    required this.origen,
    required this.destino,
    required this.fechaHora,
    this.descripcion,
    this.iconoURL,
  });
  final String? titulo;
  final String origen;
  final String destino;
  final String fechaHora;
  final String? descripcion;
  final String? iconoURL;

  @override
  Widget build(BuildContext context) {
    //print(key);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
        right: 16,
        left: 16,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/verViaje');
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
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              text: "Torremolinos ",
                            ),
                            WidgetSpan(
                              child: Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 16,
                              ),
                            ),
                            TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              text: " Teatinos",
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Salida: 14:30',
                        style: TextStyle(
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

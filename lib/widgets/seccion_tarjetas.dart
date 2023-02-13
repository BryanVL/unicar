import 'package:flutter/material.dart';
import 'package:unicar/widgets/tarjeta_viaje.dart';

class SeccionTarjetas extends StatelessWidget {
  const SeccionTarjetas({super.key, required this.numTarjetas});
  final int numTarjetas;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: numTarjetas,
        itemBuilder: (context, index) {
          return const tarjetaViaje(
            //key: Key('$index'),
            origen: 'origen',
            destino: 'destino',
            fechaHora: 'fechaHora',
          );
        },
      ),
    );
  }
}

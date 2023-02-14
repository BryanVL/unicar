import 'package:flutter/material.dart';
import 'package:unicar/models/tarjetaViaje.dart';
import 'package:unicar/widgets/tarjeta_viaje.dart';

class SeccionTarjetas extends StatelessWidget {
  const SeccionTarjetas({
    super.key,
    required this.datosViaje,
  });
  final List<TarjetaViaje> datosViaje;

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
        itemCount: datosViaje.length,
        itemBuilder: (context, index) {
          return TarjetaViajeWidget(
            datosTarjeta: datosViaje[index],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Oferta {
  final int id;
  final DateTime creadoEn;
  final double latitud;
  final double longitud;
  final TimeOfDay hora;
  final int plazasTotales;
  final int plazasOcupadas;
  final String descripcion;
  final int creadoPor;

  Oferta(
    this.id,
    this.creadoEn,
    this.latitud,
    this.longitud,
    this.hora,
    this.plazasTotales,
    this.plazasOcupadas,
    this.descripcion,
    this.creadoPor,
  );

  /*Oferta.fromDatabase(

  )*/
}

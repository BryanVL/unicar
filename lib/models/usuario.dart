class Usuario {
  final String id;
  final String? nombre;
  final String? tituloDefecto;
  final String? origenDefecto;
  final String? destinoDefecto;
  final double? latitudOrigenDefecto;
  final double? longitudOrigenDefecto;
  final double? latitudDestinoDefecto;
  final double? longitudDestinoDefecto;
  final String? urlIcono;

  Usuario({
    required this.id,
    this.nombre,
    this.tituloDefecto,
    this.origenDefecto,
    this.destinoDefecto,
    this.latitudOrigenDefecto,
    this.longitudOrigenDefecto,
    this.latitudDestinoDefecto,
    this.longitudDestinoDefecto,
    this.urlIcono,
  });
}

class TarjetaViaje {
  const TarjetaViaje({
    required this.id,
    this.titulo,
    required this.origen,
    required this.destino,
    required this.fechaHora,
    this.iconoURL,
  });
  final int id;
  final String? titulo;
  final String origen;
  final String destino;
  final String fechaHora;
  final String? iconoURL;
}

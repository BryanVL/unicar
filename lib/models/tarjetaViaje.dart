import 'oferta.dart';

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

  static List<TarjetaViaje> listaDeTarjetasDesdeOfertas(List<Oferta> ofertas) {
    return ofertas
        .map(
          (e) => TarjetaViaje(
            id: e.id,
            origen: e.origen,
            destino: e.destino,
            fechaHora: e.hora,
            titulo: e.titulo,
          ),
        )
        .toList();
  }
}

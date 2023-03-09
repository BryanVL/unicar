class Mensaje {
  final int id;
  final int idChat;
  final String idUsuarioCreador;
  final String contenido;
  final String? creadoEn;

  Mensaje({
    required this.id,
    required this.idChat,
    required this.idUsuarioCreador,
    required this.contenido,
    this.creadoEn,
  });
}

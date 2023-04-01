class Mensaje {
  final int id;
  final int idChat;
  final String idUsuarioCreador;
  final String contenido;
  final bool visto;

  Mensaje({
    required this.id,
    required this.idChat,
    required this.idUsuarioCreador,
    required this.contenido,
    required this.visto,
  });

  Mensaje.fromKeyValue(Map<String, dynamic> json)
      : id = json['id'],
        idChat = json['chat_id'],
        idUsuarioCreador = json['creador'],
        contenido = json['contenido'],
        visto = json['visto'];

  static List<Mensaje> fromList(List datos) {
    return datos.map((e) => Mensaje.fromKeyValue(e)).toList();
  }

  Mensaje.vacio()
      : id = 0,
        idChat = 0,
        idUsuarioCreador = '',
        contenido = '',
        visto = true;
}

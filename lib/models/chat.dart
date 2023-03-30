import 'package:unicar/models/usuario.dart';

class Chat {
  final int id;
  final Usuario usuarioCreador;
  final Usuario usuarioReceptor;
  //final String usuarioCreador;
  //final String usuarioReceptor;

  Chat(
    this.id,
    this.usuarioCreador,
    this.usuarioReceptor,
  );

  Chat.fromKeyValue(Map<String, dynamic> json)
      : id = json['id'] as int,
        usuarioCreador = json['usuario_creador'],
        usuarioReceptor = json['usuario_receptor'];

  static List<Chat> fromList(List datos) {
    return datos.map((e) => Chat.fromKeyValue(e)).toList();
  }
}

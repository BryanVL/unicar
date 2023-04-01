import 'package:unicar/models/mensaje.dart';
import 'package:unicar/models/usuario.dart';

class Chat {
  final int id;
  final Usuario usuarioCreador;
  final Usuario usuarioReceptor;
  final List<Mensaje>? mensajes;
  //final String usuarioCreador;
  //final String usuarioReceptor;

  Chat(
    this.id,
    this.usuarioCreador,
    this.usuarioReceptor,
    this.mensajes,
  );

  Chat.fromKeyValue(Map<String, dynamic> json)
      : id = json['id'] as int,
        usuarioCreador = json['usuario_creador'],
        usuarioReceptor = json['usuario_receptor'],
        mensajes = [];

  static List<Chat> fromList(List datos) {
    return datos.map((e) => Chat.fromKeyValue(e)).toList();
  }

  copyWith({
    Usuario? usuarioCreador,
    Usuario? usuarioReceptor,
    List<Mensaje>? mensajes,
  }) {
    return Chat(
      id,
      usuarioCreador ?? this.usuarioCreador,
      usuarioReceptor ?? this.usuarioReceptor,
      mensajes ?? this.mensajes,
    );
  }
}

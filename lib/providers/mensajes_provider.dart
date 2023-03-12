import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';

//TODO toda la logica para cargar los mensajes en tiempo real
/*final mensajesProvider = Provider.family<Stream<List<Map<String, dynamic>>>, int>((ref, idChat) {
  return ref.read(databaseProvider).escucharMensajesChat(idChat);
});*/

final mensajesProvider = StreamProvider.family<List<Map<String, dynamic>>, int>((ref, idChat) {
  return ref.read(databaseProvider).escucharMensajesChat(idChat);
});

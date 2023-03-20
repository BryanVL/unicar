import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';

final mensajesProvider = StreamProvider.family<List<Map<String, dynamic>>, int>((ref, idChat) {
  return ref.watch(databaseProvider).escucharMensajesChat(idChat);
});

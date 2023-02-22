import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/database.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/usuario_provider.dart';

final viajesAjenosProvider = FutureProvider<List<Oferta>>((ref) {
  return dbSupabase.recogerViajesAjenos(ref.read(usuarioProvider));
});

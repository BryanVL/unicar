import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';

import '../models/usuario.dart';

final usuarioProvider = StateProvider<Usuario?>((ref) => null);

final usuarioAjeno = FutureProvider.family<Usuario, String>((ref, String id) async {
  return await ref.read(databaseProvider).datosUsuarioAjeno(id);
});

final imagenDefectoProvider = Provider<AssetImage>((ref) {
  return const AssetImage('lib/assets/defaultProfile.png');
});

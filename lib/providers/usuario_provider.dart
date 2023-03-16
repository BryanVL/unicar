import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';

import '../models/usuario.dart';

final usuarioProvider = StateProvider<Usuario?>((ref) => null);

final usuarioAjeno = FutureProvider.family<Usuario, String>((ref, String id) async {
  final consultaUsuario = await ref.read(databaseProvider).usuarioDesdeId(id);

  return Usuario(id: consultaUsuario[0]['id'], nombre: consultaUsuario[0]['nombre']);
});

final imagenDefectoProvider = Provider<AssetImage>((ref) {
  return const AssetImage('lib/assets/defaultProfile.png');
});

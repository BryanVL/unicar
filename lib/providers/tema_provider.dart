import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemaController extends AsyncNotifier<String> {
  final String? valorDefecto;

  TemaController({this.valorDefecto});
  @override
  FutureOr<String> build() {
    return valorDefecto != null ? Future.value(valorDefecto) : _inicializarLista();
  }

  Future<String> _inicializarLista() async {
    final prefs = await SharedPreferences.getInstance();
    final String tema = prefs.getString('tema') ?? 'claro';
    return Future.value(tema);
  }

  void cambiarTema() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.value == 'claro') {
      state = const AsyncValue.data('oscuro');
      prefs.setString('tema', 'oscuro');
    } else {
      state = const AsyncValue.data('claro');
      prefs.setString('tema', 'claro');
    }
  }
}

final temaProvider = AsyncNotifierProvider<TemaController, String>(() {
  return TemaController();
});

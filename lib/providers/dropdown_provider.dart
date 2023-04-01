import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/localizacion.dart';

final dropdownProvider = StateProvider.family.autoDispose<String, TipoPosicion>((ref, tipo) {
  return 'Selecciona uno';
});

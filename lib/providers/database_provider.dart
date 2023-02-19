import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/database.dart';
import 'package:unicar/models/oferta.dart';

final viajesAjenosProvider = FutureProvider<List<Oferta>>((ref) {
  return dbSupabase.recogerViajesAjenos();
});

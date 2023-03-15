import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../models/geolocation_implementer.dart';
import '../models/interfaces/geolocation_interface.dart';

final geolocationProvider = Provider<Geolocation>((ref) => GeolocationNative());

final localizacionActualUsuarioProvider = FutureProvider<Position?>((ref) async {
  return ref.watch(geolocationProvider).localizacionActualDelUsuario();
});

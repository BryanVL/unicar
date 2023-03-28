// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:unicar/main.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/screens/ver_viaje_screen.dart';

void main() {
  Oferta? oferta;
  setUpAll(() async {
    oferta = Oferta(
      id: 1,
      origen: 'Torremolinos',
      destino: 'Teatinos',
      hora: DateTime.now().add(const Duration(days: 2)).toIso8601String(),
      plazasTotales: 4,
      plazasDisponibles: 4,
      creador: Usuario(id: 'abcde', nombre: 'nombreTest'),
      paraEstarA: true,
      esPeriodico: false,
    );
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final widgetProbar = ProviderScope(
      child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.propio),
      overrides: [
        ofertasOfrecidasUsuarioProvider.overrideWith(() => OfertasOfrecidasUsuarioController())
      ],
    );
  });

  test('description', () => null);
}

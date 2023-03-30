import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/mensajes_provider.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/providers/tema_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/ver_chat_screen.dart';
import 'package:unicar/widgets/textform.dart';

import 'fake_database.dart';

void main() {
  Oferta? oferta;
  Widget? widgetProbar;
  setUpAll(() async {
    oferta = Oferta(
      id: 1,
      origen: 'Torremolinos',
      destino: 'Teatinos',
      hora: DateTime.now().add(const Duration(days: 2)).toIso8601String(),
      plazasTotales: 4,
      plazasDisponibles: 4,
      creador: Usuario(id: 'usuario', nombre: 'UsuarioActivo'),
      paraEstarA: true,
      esPeriodico: false,
      titulo: 'Viaje a Teatinos',
      descripcion: '',
    );

    widgetProbar = MaterialApp(
      home: ProviderScope(
        overrides: [
          databaseProvider.overrideWith(() => DatabaseController(valorDefecto: FakeSupabase())),
          usuarioProvider.overrideWith((ref) => Usuario(id: 'usuario', nombre: 'UsuarioActivo')),
          usuarioAjeno
              .overrideWith((ref, arg) => Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest')),
          mensajesProvider.overrideWith((ref, arg) => Stream.value([
                {'id': 1, 'creador': 'idOtroUsuario', 'contenido': 'Mensaje test', 'visto': true}
              ])),
          pasajerosViajeProvider.overrideWith((ref, arg) => const AsyncValue.data([])),
          plazasProvider.overrideWith((ref, arg) => oferta!.plazasDisponibles),
          temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
          ofertasOfrecidasUsuarioProvider
              .overrideWith(() => OfertasOfrecidasUsuarioController(valorDefecto: [oferta!]))
        ],
        child: const VerChatScreen('idOtroUsuario', 1),
      ),
    );
  });

  tearDownAll(() {});

  testWidgets('Se muestra campo para introducir texto y boton para enviar ',
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetProbar!);

    expect(find.byType(MyTextForm), findsOneWidget);
    expect(find.byIcon(Icons.send_rounded), findsOneWidget);
  });

  testWidgets('Se muestran mensajes y nombre del otro usuario', (WidgetTester tester) async {
    await tester.pumpWidget(widgetProbar!);
    await tester.pump();
    expect(find.text('Mensaje test'), findsOneWidget);
    expect(find.text('UsuarioTest'), findsOneWidget);

    /*tester.enterText(find.byType(MyTextForm), 'Nuevo Mensaje');
      tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();
      expect(find.text('Nuevo mensaje'), findsOneWidget);*/
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

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
import 'package:unicar/screens/tab_bar_screen.dart';
import 'package:unicar/screens/ver_chat_screen.dart';
import 'package:unicar/screens/ver_viaje_screen.dart';
import 'package:unicar/widgets/tarjeta_viaje.dart';
import 'package:unicar/widgets/textform.dart';

import 'fake_database.dart';

void main() {
  Oferta? oferta;
  Oferta? ofertaDisp;
  Oferta? ofertaApunt;
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
    ofertaDisp = Oferta(
      id: 2,
      origen: 'Fuengirola',
      destino: 'Teatinos',
      hora: DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      plazasTotales: 4,
      plazasDisponibles: 3,
      creador: Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest'),
      paraEstarA: true,
      esPeriodico: false,
      titulo: 'Un viajecito',
      descripcion: '',
    );
    ofertaApunt = Oferta(
      id: 3,
      origen: 'Fuengirola',
      destino: 'Ampliación de Teatinos',
      hora: DateTime.now().add(const Duration(days: 4)).toIso8601String(),
      plazasTotales: 4,
      plazasDisponibles: 2,
      creador: Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest'),
      paraEstarA: true,
      esPeriodico: false,
      titulo: 'Test de uma',
      descripcion: '',
    );
  });

  tearDownAll(() {});

  group('Ver viaje', () {
    testWidgets('Botones correctos en viaje propio ', (WidgetTester tester) async {
      final widgetProbar = MaterialApp(
        home: ProviderScope(
          overrides: [
            pasajerosViajeProvider.overrideWith((ref, arg) => const AsyncValue.data([])),
            plazasProvider.overrideWith((ref, arg) => oferta!.plazasDisponibles),
            temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
            ofertasOfrecidasUsuarioProvider
                //TODO Crear o un segundo proyecto unicar o hacer una implementación falsa de Database
                .overrideWith(() => OfertasOfrecidasUsuarioController(valorDefecto: [oferta!]))
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.propio),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      //await tester.pump(const Duration(milliseconds: 200));
      await tester.dragUntilVisible(
        find.text('Editar oferta'), // what you want to find
        find.byType(SingleChildScrollView), // widget you want to scroll
        const Offset(0, 200), // delta to move
      );

      expect(find.text('Editar oferta'), findsOneWidget);
      expect(find.text('Eliminar oferta'), findsOneWidget);
      expect(find.text('Abrir chat'), findsNothing);
      expect(find.text('Reservar plaza'), findsNothing);
      expect(find.text('Cancelar reserva'), findsNothing);
    });

    testWidgets('Botones correctos en viaje ajeno ', (WidgetTester tester) async {
      final widgetProbar = MaterialApp(
        home: ProviderScope(
          overrides: [
            pasajerosViajeProvider.overrideWith((ref, arg) => const AsyncValue.data([])),
            plazasProvider.overrideWith((ref, arg) => oferta!.plazasDisponibles),
            temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
            ofertasOfrecidasUsuarioProvider
                //TODO Crear o un segundo proyecto unicar o hacer una implementación falsa de Database
                .overrideWith(() => OfertasOfrecidasUsuarioController(valorDefecto: [oferta!]))
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.oferta),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      //await tester.pump(const Duration(milliseconds: 200));
      await tester.dragUntilVisible(
        find.text('Abrir chat'), // what you want to find
        find.byType(SingleChildScrollView), // widget you want to scroll
        const Offset(0, 200), // delta to move
      );
      expect(find.text('Editar oferta'), findsNothing);
      expect(find.text('Eliminar oferta'), findsNothing);
      expect(find.text('Abrir chat'), findsOneWidget);
      expect(find.text('Reservar plaza'), findsOneWidget);
      expect(find.text('Cancelar reserva'), findsNothing);
    });

    testWidgets('Botones correctos en viaje apuntado ', (WidgetTester tester) async {
      final widgetProbar = MaterialApp(
        home: ProviderScope(
          overrides: [
            pasajerosViajeProvider.overrideWith((ref, arg) => const AsyncValue.data([])),
            plazasProvider.overrideWith((ref, arg) => oferta!.plazasDisponibles),
            temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
            ofertasOfrecidasUsuarioProvider
                //TODO Crear o un segundo proyecto unicar o hacer una implementación falsa de Database
                .overrideWith(() => OfertasOfrecidasUsuarioController(valorDefecto: [oferta!]))
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.apuntado),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      //await tester.pump(const Duration(milliseconds: 200));
      await tester.dragUntilVisible(
        find.text('Abrir chat'), // what you want to find
        find.byType(SingleChildScrollView), // widget you want to scroll
        const Offset(0, 200), // delta to move
      );

      expect(find.text('Editar oferta'), findsNothing);
      expect(find.text('Eliminar oferta'), findsNothing);
      expect(find.text('Abrir chat'), findsOneWidget);
      expect(find.text('Reservar plaza'), findsNothing);
      expect(find.text('Cancelar reserva'), findsOneWidget);
    });
  });

  group('vista de chat', () {
    Widget? widgetProbar;
    setUpAll(() {
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
  });

  group('Probar pagina principal', () {
    Widget? widgetProbar;
    setUpAll(() {
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
                .overrideWith(() => OfertasOfrecidasUsuarioController(valorDefecto: [oferta!])),
            ofertasDisponiblesProvider
                .overrideWith(() => OfertasDisponiblesController(valorDefecto: [ofertaDisp!])),
            ofertasUsuarioApuntadoProvider
                .overrideWith(() => OfertasUsuarioApuntadoController(valorDefecto: [ofertaApunt!])),
          ],
          child: const TabBarScreen(title: 'Unicar'),
        ),
      );
    });

    testWidgets('Se muestra viaje propio', (WidgetTester tester) async {
      await tester.pumpWidget(widgetProbar!);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(TarjetaViajeWidget),
          matching: find.textContaining('Viaje a Teatinos'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Se muestra viaje apuntado', (WidgetTester tester) async {
      await tester.pumpWidget(widgetProbar!);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(TarjetaViajeWidget),
          matching: find.textContaining('Test de uma'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Se muestran ofertas', (widgetTester) async {
      await widgetTester.pumpWidget(widgetProbar!);
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.text('Ofertas'));

      await widgetTester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(TarjetaViajeWidget),
          matching: find.textContaining('Un viajecito'),
        ),
        findsOneWidget,
      );
    });
  });
}

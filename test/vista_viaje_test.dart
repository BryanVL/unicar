// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:unicar/models/oferta.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/mensajes_provider.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/providers/tema_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/ver_viaje_screen.dart';

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
      paraEstarA: false,
      esPeriodico: false,
      titulo: 'Test de uma',
      descripcion: '',
    );
  });

  tearDownAll(() {});

  group('Ver viaje', () {
    testWidgets('Se muestran datos', (WidgetTester tester) async {
      final widgetProbar = MaterialApp(
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
            ofertasOfrecidasUsuarioProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!])),
            ofertasDisponiblesProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.oferta, valorDefecto: [ofertaDisp!])),
            ofertasUsuarioApuntadoProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [ofertaApunt!])),
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.propio),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Viaje'), // what you want to find
        find.byType(SingleChildScrollView), // widget you want to scroll
        const Offset(0, 100), // delta to move
      );

      expect(find.textContaining('Viaje a Teatinos', findRichText: true), findsOneWidget);
      expect(find.textContaining('Torremolinos', findRichText: true), findsOneWidget);
      expect(find.textContaining('destino Teatinos', findRichText: true), findsOneWidget);

      await tester.dragUntilVisible(
        find.text('Hora'),
        find.byType(SingleChildScrollView),
        const Offset(0, 100),
      );

      expect(find.textContaining('Para estar', findRichText: true), findsOneWidget);
      expect(
          find.textContaining(DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.parse(oferta!.hora)),
              findRichText: true),
          findsOneWidget);

      await tester.dragUntilVisible(
        find.text('Datos extra'),
        find.byType(SingleChildScrollView),
        const Offset(0, 100),
      );
      expect(find.textContaining('Plazas libres', findRichText: true), findsOneWidget);
      expect(find.textContaining(': 4', findRichText: true), findsOneWidget);
      expect(find.textContaining('Descripción', findRichText: true), findsOneWidget);
      expect(find.textContaining('Sin descripción', findRichText: true), findsOneWidget);
      expect(find.textContaining('Viaje recurrente: No', findRichText: true), findsOneWidget);

      await tester.dragUntilVisible(
        find.textContaining('Pasajeros'),
        find.byType(SingleChildScrollView),
        const Offset(0, 100),
      );

      expect(find.textContaining('No hay pasajeros', findRichText: true), findsOneWidget);
    });

    testWidgets('Se muestran datos recurrente y para salir', (WidgetTester tester) async {
      oferta = oferta!.copyWith(paraEstarA: false, esPeriodico: true);
      final widgetProbar = MaterialApp(
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
            ofertasOfrecidasUsuarioProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!])),
            ofertasDisponiblesProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.oferta, valorDefecto: [ofertaDisp!])),
            ofertasUsuarioApuntadoProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [ofertaApunt!])),
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.propio),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Datos extra'),
        find.byType(SingleChildScrollView),
        const Offset(0, 100),
      );
      expect(find.textContaining('Viaje recurrente: Sí', findRichText: true), findsOneWidget);
      expect(find.textContaining('Salida', findRichText: true), findsOneWidget);
    });

    tearDown(() => oferta = oferta!.copyWith(paraEstarA: true, esPeriodico: false));

    testWidgets('Se muestran tarjetas de pasajeros', (WidgetTester tester) async {
      final widgetProbar = MaterialApp(
        home: ProviderScope(
          overrides: [
            databaseProvider.overrideWith(() => DatabaseController(valorDefecto: FakeSupabase())),
            usuarioProvider.overrideWith((ref) => Usuario(id: 'usuario', nombre: 'UsuarioActivo')),
            usuarioAjeno
                .overrideWith((ref, arg) => Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest')),
            mensajesProvider.overrideWith((ref, arg) => Stream.value([
                  {'id': 1, 'creador': 'idOtroUsuario', 'contenido': 'Mensaje test', 'visto': true}
                ])),
            pasajerosViajeProvider.overrideWith((ref, arg) =>
                AsyncValue.data([Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest')])),
            plazasProvider.overrideWith((ref, arg) => oferta!.plazasDisponibles),
            temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
            ofertasOfrecidasUsuarioProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!])),
            ofertasDisponiblesProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.oferta, valorDefecto: [ofertaDisp!])),
            ofertasUsuarioApuntadoProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [ofertaApunt!])),
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.propio),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.textContaining('Pasajeros'),
        find.byType(SingleChildScrollView),
        const Offset(0, 100),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.delete_outlined), findsOneWidget);
    });

    testWidgets('Botones correctos en viaje propio ', (WidgetTester tester) async {
      final widgetProbar = MaterialApp(
        home: ProviderScope(
          overrides: [
            pasajerosViajeProvider.overrideWith((ref, arg) => const AsyncValue.data([])),
            plazasProvider.overrideWith((ref, arg) => oferta!.plazasDisponibles),
            temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
            ofertasOfrecidasUsuarioProvider
                //TODO Crear o un segundo proyecto unicar o hacer una implementación falsa de Database
                .overrideWith(
                    () => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!]))
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.propio),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      //await tester.pump(const Duration(milliseconds: 200));
      await tester.dragUntilVisible(
        find.text('Editar oferta'),
        find.byType(SingleChildScrollView),
        const Offset(0, 200),
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
            ofertasOfrecidasUsuarioProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!]))
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.oferta),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      //await tester.pump(const Duration(milliseconds: 200));
      await tester.dragUntilVisible(
        find.text('Abrir chat'),
        find.byType(SingleChildScrollView),
        const Offset(0, 200),
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
            ofertasOfrecidasUsuarioProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!]))
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.apuntado),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      //await tester.pump(const Duration(milliseconds: 200));
      await tester.dragUntilVisible(
        find.text('Abrir chat'),
        find.byType(SingleChildScrollView),
        const Offset(0, 200),
      );

      expect(find.text('Editar oferta'), findsNothing);
      expect(find.text('Eliminar oferta'), findsNothing);
      expect(find.text('Abrir chat'), findsOneWidget);
      expect(find.text('Reservar plaza'), findsNothing);
      expect(find.text('Cancelar reserva'), findsOneWidget);
    });
    testWidgets('No se muestran pasajeros si no es propio (apuntado)', (WidgetTester tester) async {
      final widgetProbar = MaterialApp(
        home: ProviderScope(
          overrides: [
            databaseProvider.overrideWith(() => DatabaseController(valorDefecto: FakeSupabase())),
            usuarioProvider.overrideWith((ref) => Usuario(id: 'usuario', nombre: 'UsuarioActivo')),
            usuarioAjeno
                .overrideWith((ref, arg) => Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest')),
            mensajesProvider.overrideWith((ref, arg) => Stream.value([
                  {'id': 1, 'creador': 'idOtroUsuario', 'contenido': 'Mensaje test', 'visto': true}
                ])),
            pasajerosViajeProvider.overrideWith((ref, arg) =>
                AsyncValue.data([Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest')])),
            plazasProvider.overrideWith((ref, arg) => oferta!.plazasDisponibles),
            temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
            ofertasOfrecidasUsuarioProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!])),
            ofertasDisponiblesProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.oferta, valorDefecto: [ofertaDisp!])),
            ofertasUsuarioApuntadoProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [ofertaApunt!])),
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.apuntado),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.textContaining('Abrir chat'),
        find.byType(SingleChildScrollView),
        const Offset(0, 100),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Pasajeros'), findsNothing);
    });

    testWidgets('No se muestran pasajeros si no es propio (oferta)', (WidgetTester tester) async {
      final widgetProbar = MaterialApp(
        home: ProviderScope(
          overrides: [
            databaseProvider.overrideWith(() => DatabaseController(valorDefecto: FakeSupabase())),
            usuarioProvider.overrideWith((ref) => Usuario(id: 'usuario', nombre: 'UsuarioActivo')),
            usuarioAjeno
                .overrideWith((ref, arg) => Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest')),
            mensajesProvider.overrideWith((ref, arg) => Stream.value([
                  {'id': 1, 'creador': 'idOtroUsuario', 'contenido': 'Mensaje test', 'visto': true}
                ])),
            pasajerosViajeProvider.overrideWith((ref, arg) =>
                AsyncValue.data([Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest')])),
            plazasProvider.overrideWith((ref, arg) => oferta!.plazasDisponibles),
            temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
            ofertasOfrecidasUsuarioProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!])),
            ofertasDisponiblesProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.oferta, valorDefecto: [ofertaDisp!])),
            ofertasUsuarioApuntadoProvider.overrideWith(
                () => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [ofertaApunt!])),
          ],
          child: VerViajeScreen(oferta: oferta!, tipo: TipoViaje.oferta),
        ),
      );
      await tester.pumpWidget(widgetProbar);
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.textContaining('Abrir chat'),
        find.byType(SingleChildScrollView),
        const Offset(0, 100),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Pasajeros'), findsNothing);
    });
  });
}

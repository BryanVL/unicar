import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:unicar/models/chat.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/providers/chat_provider.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/localizacion_provider.dart';
import 'package:unicar/providers/mensajes_provider.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/providers/tema_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/editar_oferta_screen.dart';
import 'package:unicar/widgets/seleccion_posicion.dart';
import 'package:unicar/widgets/textform.dart';

import 'fake_database.dart';
import 'fake_geolocation.dart';

void main() {
  Oferta? oferta;
  Oferta? ofertaDisp;
  Oferta? ofertaApunt;
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

    widgetProbar = MaterialApp(
      home: ProviderScope(
        overrides: [
          geolocationProvider.overrideWith((ref) => GeolocationFake()),
          chatProvider.overrideWith(
            () => ChatController(
              valorDefecto: [
                Chat(
                  1,
                  Usuario(
                    id: 'usuario',
                    nombre: 'UsuarioActivo',
                    tituloDefecto: 'Titulo por defecto',
                    descripcionDefecto: 'Descripción por defecto',
                  ),
                  Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest'),
                )
              ],
            ),
          ),
          databaseProvider.overrideWith(() => DatabaseController(valorDefecto: FakeSupabase())),
          usuarioProvider.overrideWith(
            (ref) => Usuario(
              id: 'usuario',
              nombre: 'UsuarioActivo',
              tituloDefecto: 'Titulo por defecto',
              descripcionDefecto: 'Descripción por defecto',
            ),
          ),
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
        child: EditarOfertaScreen(oferta!),
      ),
    );
  });

  tearDownAll(() {});

  testWidgets('Los valores de oferta se ven en los dropdowns', (WidgetTester tester) async {
    await tester.pumpWidget(widgetProbar!);
    await tester.pumpAndSettle();

    expect(find.byType(SeleccionPosicion), findsOneWidget);
    expect(find.textContaining('Simple'), findsOneWidget);
    expect(find.textContaining('Personalizado'), findsOneWidget);
    expect(find.textContaining('Torremolinos'), findsNWidgets(2));
    expect(find.textContaining('Teatinos'), findsNWidgets(6));
    expect(find.textContaining('Teatinos'), findsNWidgets(6));
  });

  testWidgets('El valor de hora de la oferta se ve', (WidgetTester tester) async {
    await tester.pumpWidget(widgetProbar!);
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.textContaining('Selección de hora'),
      find.byType(SingleChildScrollView),
      const Offset(0, 100),
    );

    expect(find.textContaining('Estar a'), findsOneWidget);
    expect(find.textContaining('Salir a'), findsOneWidget);

    expect(
      find.textContaining(
        DateFormat('MMM d, yyyy').format(
          DateTime.parse(oferta!.hora),
        ),
        findRichText: true,
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byType(MyTextForm),
        matching: find.textContaining('${oferta!.plazasDisponibles}'),
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byType(MyTextForm),
        matching: find.textContaining('Viaje a Teatinos'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('El valor de datos extra se ven', (WidgetTester tester) async {
    await tester.pumpWidget(widgetProbar!);
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.textContaining('Plazas y otros'),
      find.byType(SingleChildScrollView),
      const Offset(0, 100),
    );

    expect(
      find.descendant(
        of: find.byType(MyTextForm),
        matching: find.textContaining('${oferta!.plazasDisponibles}'),
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byType(MyTextForm),
        matching: find.textContaining('Viaje a Teatinos'),
      ),
      findsOneWidget,
    );
  });
}

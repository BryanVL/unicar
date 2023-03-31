import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:unicar/screens/filtrar_screen.dart';
import 'package:unicar/widgets/seleccion_posicion.dart';

import 'fake_database.dart';
import 'fake_geolocation.dart';

void main() {
  Oferta? oferta1;
  Oferta? oferta2;
  Oferta? oferta3;
  Widget? widgetProbar;
  setUpAll(() async {
    oferta1 = Oferta(
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
    oferta2 = Oferta(
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
    oferta3 = Oferta(
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
                descripcionDefecto: 'Descripción por defecto'),
          ),
          usuarioAjeno
              .overrideWith((ref, arg) => Usuario(id: 'idOtroUsuario', nombre: 'UsuarioTest')),
          mensajesProvider.overrideWith((ref, arg) => Stream.value([
                {'id': 1, 'creador': 'idOtroUsuario', 'contenido': 'Mensaje test', 'visto': true}
              ])),
          pasajerosViajeProvider.overrideWith((ref, arg) => const AsyncValue.data([])),
          plazasProvider.overrideWith((ref, arg) => oferta1!.plazasDisponibles),
          temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
          ofertasOfrecidasUsuarioProvider
              .overrideWith(() => OfertasController(tipo: TipoViaje.propio, valorDefecto: [])),
          ofertasDisponiblesProvider.overrideWith(() => OfertasController(
              tipo: TipoViaje.oferta, valorDefecto: [oferta1!, oferta2!, oferta3!])),
          ofertasUsuarioApuntadoProvider
              .overrideWith(() => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [])),
        ],
        child: const FiltrarScreen(),
      ),
    );
  });

  tearDownAll(() {});

  testWidgets('Se muestran filtros de selección', (WidgetTester tester) async {
    await tester.pumpWidget(widgetProbar!);
    await tester.pumpAndSettle();

    expect(find.byType(SeleccionPosicion), findsOneWidget);
    expect(find.textContaining('Simple'), findsOneWidget);
    expect(find.textContaining('Personalizado'), findsOneWidget);
  });

  testWidgets('Se muestran filtros de hora', (WidgetTester tester) async {
    await tester.pumpWidget(widgetProbar!);
    await tester.pumpAndSettle();

    expect(find.byType(SeleccionPosicion), findsOneWidget);
    expect(find.textContaining('Estar a'), findsOneWidget);
    expect(find.textContaining('Salir a'), findsOneWidget);
    expect(find.textContaining('Ambos'), findsOneWidget);

    expect(find.byType(DateTimePicker), findsOneWidget);
  });

  testWidgets('Se muestran boton para aplicar filtros', (WidgetTester tester) async {
    await tester.pumpWidget(widgetProbar!);
    await tester.pumpAndSettle();

    expect(find.textContaining('Aplicar'), findsOneWidget);
  });

  testWidgets('Se muestran boton para eliminar filtros', (WidgetTester tester) async {
    await tester.pumpWidget(widgetProbar!);
    await tester.pumpAndSettle();

    expect(find.textContaining('Eliminar'), findsOneWidget);
  });
}

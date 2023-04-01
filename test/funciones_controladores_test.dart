import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:unicar/models/chat.dart';
import 'package:unicar/models/localizacion.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/providers/chat_provider.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/localizacion_provider.dart';
import 'package:unicar/providers/mensajes_provider.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/providers/tema_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';

import 'fake_database.dart';
import 'fake_geolocation.dart';

void main() {
  Oferta? oferta;
  Oferta? ofertaDisp;
  Oferta? ofertaApunt;
  ProviderContainer? container;
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

    container = ProviderContainer(
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
                [],
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
        plazasProvider.overrideWith((ref, arg) => ofertaDisp!.plazasDisponibles),
        temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
        ofertasOfrecidasUsuarioProvider
            .overrideWith(() => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!])),
        ofertasDisponiblesProvider.overrideWith(
            () => OfertasController(tipo: TipoViaje.oferta, valorDefecto: [ofertaDisp!])),
        ofertasUsuarioApuntadoProvider.overrideWith(
            () => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [ofertaApunt!])),
      ],
    );
  });

  tearDown(() {
    container = ProviderContainer(
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
                [],
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
        plazasProvider.overrideWith((ref, arg) => ofertaDisp!.plazasDisponibles),
        temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
        ofertasOfrecidasUsuarioProvider
            .overrideWith(() => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!])),
        ofertasDisponiblesProvider.overrideWith(
            () => OfertasController(tipo: TipoViaje.oferta, valorDefecto: [ofertaDisp!])),
        ofertasUsuarioApuntadoProvider.overrideWith(
            () => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [ofertaApunt!])),
      ],
    );
  });

  group('Funciones de oferta', () {
    test('Se añade oferta correctamente', () async {
      await container!.read(ofertasOfrecidasUsuarioProvider.future);
      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.length, 1);
      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.first.id, 1);

      container!.read(ofertasOfrecidasUsuarioProvider.notifier).addOferta(ofertaDisp!);

      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.length, 2);
      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.first.id, 2);
    });

    test('Se elimina una oferta correctamente', () async {
      await container!.read(ofertasOfrecidasUsuarioProvider.future);
      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.length, 1);
      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.first.id, 1);

      container!.read(ofertasOfrecidasUsuarioProvider.notifier).eliminarOferta(1);

      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.length, 0);
    });

    test('Si al borrar no se encuentra oferta no se cambia nada', () async {
      await container!.read(ofertasOfrecidasUsuarioProvider.future);
      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.length, 1);
      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.first.id, 1);

      container!.read(ofertasOfrecidasUsuarioProvider.notifier).eliminarOferta(2);

      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.length, 1);
      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.first.id, 1);
    });

    test('Reservar plaza disminuye el numero de plazas de la oferta ', () async {
      await container!.read(ofertasDisponiblesProvider.future);
      Oferta usada = container!.read(ofertasDisponiblesProvider).value!.first;
      expect(usada.plazasDisponibles, 3);

      container!.read(ofertasDisponiblesProvider.notifier).reservarPlaza(usada);

      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(ofertasUsuarioApuntadoProvider).value!.first.plazasDisponibles, 2);
    });

    test('Reservar no hace nada si la oferta es del usuario o esta apuntado', () async {
      await container!.read(ofertasDisponiblesProvider.future);
      await container!.read(ofertasOfrecidasUsuarioProvider.future);
      await container!.read(ofertasUsuarioApuntadoProvider.future);

      Oferta usada = container!.read(ofertasOfrecidasUsuarioProvider).value!.first;
      expect(usada.plazasDisponibles, 4);

      container!.read(ofertasOfrecidasUsuarioProvider.notifier).reservarPlaza(usada);

      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.first.plazasDisponibles, 4);
      expect(container!.read(ofertasUsuarioApuntadoProvider).value!.length, 1);
    });

    test('Cancelar plaza aumenta el numero de plazas de la oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);
      await container!.read(ofertasOfrecidasUsuarioProvider.future);
      await container!.read(ofertasUsuarioApuntadoProvider.future);
      Oferta usada = container!.read(ofertasUsuarioApuntadoProvider).value!.first;
      expect(usada.plazasDisponibles, 2);

      container!.read(ofertasUsuarioApuntadoProvider.notifier).cancelarReserva(usada);

      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(ofertasDisponiblesProvider).value!.first.plazasDisponibles, 3);
    });

    test('Cancelar reserva no hace nada si la oferta no es de apuntado', () async {
      await container!.read(ofertasDisponiblesProvider.future);
      await container!.read(ofertasOfrecidasUsuarioProvider.future);
      await container!.read(ofertasUsuarioApuntadoProvider.future);

      Oferta usada = container!.read(ofertasOfrecidasUsuarioProvider).value!.first;
      expect(usada.plazasDisponibles, 4);

      container!.read(ofertasOfrecidasUsuarioProvider.notifier).cancelarReserva(usada);

      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(ofertasOfrecidasUsuarioProvider).value!.first.plazasDisponibles, 4);
      expect(container!.read(ofertasUsuarioApuntadoProvider).value!.length, 1);
    });

    test('Editar oferta cambia todos los valores de la oferta que se pasan', () async {
      await container!.read(ofertasDisponiblesProvider.future);
      await container!.read(ofertasOfrecidasUsuarioProvider.future);
      await container!.read(ofertasUsuarioApuntadoProvider.future);

      Oferta usada = container!.read(ofertasOfrecidasUsuarioProvider).value!.first;
      container!.read(ofertasOfrecidasUsuarioProvider.notifier).editarOferta(
            id: usada.id,
            origen: 'Teatinos',
            destino: 'Torremolinos',
            plazas: '5',
            hora:
                DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(const Duration(days: 3))),
            titulo: 'Titulo editado',
            descripcion: 'Descripción editada',
            paraEstarA: false,
            esPeriodico: true,
            coordOrigen: LatLng(0, 0),
            coordDestino: LatLng(1, 1),
            radioOrigen: 123,
            radioDestino: 123,
          );

      await Future.delayed(const Duration(milliseconds: 50));

      final Oferta esperado = container!.read(ofertasOfrecidasUsuarioProvider).value!.first;
      expect(esperado.id, usada.id);
      expect(esperado.origen, 'Teatinos');
      expect(esperado.destino, 'Torremolinos');
      expect(esperado.plazasTotales, 5);
      expect(esperado.plazasDisponibles, 5);
      expect(esperado.hora,
          DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(const Duration(days: 3))));
      expect(esperado.titulo, 'Titulo editado');
      expect(esperado.descripcion, 'Descripción editada');
      expect(esperado.paraEstarA, false);
      expect(esperado.esPeriodico, true);
      expect(esperado.coordOrigen, LatLng(0, 0));
      expect(esperado.coordDestino, LatLng(1, 1));
      expect(esperado.radioOrigen, 123);
      expect(esperado.radioDestino, 123);
    });

    test('Editar oferta no cambia coordenadas si no se le pasan', () async {
      await container!.read(ofertasDisponiblesProvider.future);
      await container!.read(ofertasOfrecidasUsuarioProvider.future);
      await container!.read(ofertasUsuarioApuntadoProvider.future);

      Oferta usada = container!.read(ofertasOfrecidasUsuarioProvider).value!.first;
      container!.read(ofertasOfrecidasUsuarioProvider.notifier).editarOferta(
            id: usada.id,
            origen: 'Teatinos',
            destino: 'Torremolinos',
            plazas: '5',
            hora:
                DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(const Duration(days: 3))),
            titulo: 'Titulo editado',
            descripcion: 'Descripción editada',
            paraEstarA: false,
            esPeriodico: true,
          );

      await Future.delayed(const Duration(milliseconds: 50));

      final Oferta esperado = container!.read(ofertasOfrecidasUsuarioProvider).value!.first;
      expect(esperado.id, usada.id);
      expect(esperado.origen, 'Teatinos');
      expect(esperado.destino, 'Torremolinos');
      expect(esperado.plazasTotales, 5);
      expect(esperado.plazasDisponibles, 5);
      expect(esperado.hora,
          DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(const Duration(days: 3))));
      expect(esperado.titulo, 'Titulo editado');
      expect(esperado.descripcion, 'Descripción editada');
      expect(esperado.paraEstarA, false);
      expect(esperado.esPeriodico, true);
      expect(esperado.coordOrigen, null);
      expect(esperado.coordDestino, null);
      expect(esperado.radioOrigen, null);
      expect(esperado.radioDestino, null);
    });

    test('AddNewOferta crea un viaje correctamente', () async {
      await container!.read(ofertasOfrecidasUsuarioProvider.future);

      container!.read(ofertasOfrecidasUsuarioProvider.notifier).addNewOferta(
            'Torremolinos',
            'Teatinos',
            DateFormat('dd/MM/yyyy  kk:mm').format(
              DateTime.now().add(
                const Duration(days: 3),
              ),
            ),
            '7',
            'Descripción editada',
            'Titulo editado',
            null,
            null,
            null,
            null,
            false,
            true,
          );

      await Future.delayed(const Duration(milliseconds: 50));

      final Oferta esperado = container!.read(ofertasOfrecidasUsuarioProvider).value!.first;
      expect(esperado.id, 112);
      expect(esperado.origen, 'Torremolinos');
      expect(esperado.destino, 'Teatinos');
      expect(esperado.plazasTotales, 7);
      expect(esperado.plazasDisponibles, 7);
      expect(
        esperado.hora,
        DateFormat('dd/MM/yyyy  kk:mm').format(
          DateTime.now().add(
            const Duration(days: 3),
          ),
        ),
      );
      expect(esperado.titulo, 'Titulo editado');
      expect(esperado.descripcion, 'Descripción editada');
      expect(esperado.paraEstarA, false);
      expect(esperado.esPeriodico, true);
      expect(esperado.coordOrigen, null);
      expect(esperado.coordDestino, null);
      expect(esperado.radioOrigen, null);
      expect(esperado.radioDestino, null);
    });

    test('AddNewOferta crea un viaje con coordenadas correctamente', () async {
      await container!.read(ofertasOfrecidasUsuarioProvider.future);

      container!.read(ofertasOfrecidasUsuarioProvider.notifier).addNewOferta(
            'Torremolinos',
            'Teatinos',
            DateFormat('dd/MM/yyyy  kk:mm').format(
              DateTime.now().add(
                const Duration(days: 3),
              ),
            ),
            '7',
            'Descripción editada',
            'Titulo editado',
            LatLng(0, 0),
            LatLng(1, 1),
            123,
            234,
            false,
            true,
          );

      await Future.delayed(const Duration(milliseconds: 50));

      final Oferta esperado = container!.read(ofertasOfrecidasUsuarioProvider).value!.first;
      expect(esperado.id, 112);
      expect(esperado.origen, 'Torremolinos');
      expect(esperado.destino, 'Teatinos');
      expect(esperado.plazasTotales, 7);
      expect(esperado.plazasDisponibles, 7);
      expect(
        esperado.hora,
        DateFormat('dd/MM/yyyy  kk:mm').format(
          DateTime.now().add(
            const Duration(days: 3),
          ),
        ),
      );
      expect(esperado.titulo, 'Titulo editado');
      expect(esperado.descripcion, 'Descripción editada');
      expect(esperado.paraEstarA, false);
      expect(esperado.esPeriodico, true);
      expect(esperado.coordOrigen, LatLng(0, 0));
      expect(esperado.coordDestino, LatLng(1, 1));
      expect(esperado.radioOrigen, 123);
      expect(esperado.radioDestino, 234);
    });

    test('eliminar filtros borra todos los filtros', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtroOrigen = 'Torremolinos';
      container!.read(ofertasDisponiblesProvider.notifier).filtroDestino = 'Teatinos';
      container!.read(ofertasDisponiblesProvider.notifier).filtroHora =
          DateFormat('dd/MM/yyyy  kk:mm').format(
        DateTime.now().add(
          const Duration(days: 3),
        ),
      );
      container!.read(ofertasDisponiblesProvider.notifier).filtroGroupValue = 1;
      container!.read(ofertasDisponiblesProvider.notifier).filtroOrigenP =
          LocalizacionPersonalizada(
        nombreCompleto: '',
        localidad: '',
        coordenadas: LatLng(0, 0),
        radio: 123,
      );
      container!.read(ofertasDisponiblesProvider.notifier).filtroDestinoP =
          LocalizacionPersonalizada(
        nombreCompleto: '',
        localidad: '',
        coordenadas: LatLng(1, 1),
        radio: 234,
      );
      container!.read(ofertasDisponiblesProvider.notifier).estadoAux = [ofertaDisp!];

      await Future.delayed(const Duration(milliseconds: 50));

      container!.read(ofertasDisponiblesProvider.notifier).eliminarFiltros();
      expect(container!.read(ofertasDisponiblesProvider.notifier).filtroOrigen, 'Selecciona uno');
      expect(container!.read(ofertasDisponiblesProvider.notifier).filtroDestino, 'Selecciona uno');
      expect(container!.read(ofertasDisponiblesProvider.notifier).filtroHora, '');
      expect(container!.read(ofertasDisponiblesProvider.notifier).filtroGroupValue, 2);
      expect(container!.read(ofertasDisponiblesProvider.notifier).filtroOrigenP, null);
      expect(container!.read(ofertasDisponiblesProvider.notifier).filtroDestinoP, null);
      expect(container!.read(ofertasDisponiblesProvider.notifier).estadoAux, []);
    });

    test('eliminar filtros no hace nada si no habian filtros aplicados', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).eliminarFiltros();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 1);
    });

    test('Se aplica filtro de posición origen simple correcto y hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Fuengirola',
            'Selecciona uno',
            '',
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      Oferta oferta = container!.read(ofertasDisponiblesProvider).value!.first;
      expect(oferta.origen, 'Fuengirola');
    });

    test('Se aplica filtro de posición origen simple correcto y no hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Torremolinos',
            'Selecciona uno',
            '',
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test('Se aplica filtro de posición destino simple correcto y hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Teatinos',
            '',
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      Oferta oferta = container!.read(ofertasDisponiblesProvider).value!.first;
      expect(oferta.destino, 'Teatinos');
    });

    test('Se aplica filtro de posición destino simple correcto y no hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Torremolinos',
            '',
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test('Se aplica filtro de posición origen y destino simple correcto y hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Fuengirola',
            'Teatinos',
            '',
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      Oferta oferta = container!.read(ofertasDisponiblesProvider).value!.first;
      expect(oferta.origen, 'Fuengirola');
      expect(oferta.destino, 'Teatinos');
    });

    test('Se aplica filtro de posición origen y destino simple correcto y no hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Fuengirola',
            'Torremolinos',
            '',
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test('Se aplica filtro de hora para ambos y hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      Oferta oferta = container!.read(ofertasDisponiblesProvider).value!.first;
      expect(
        DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.parse(oferta.hora)),
        DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(const Duration(days: 3))),
      );
    });

    test('Se aplica filtro de hora para ambos y no hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 4)).toIso8601String(),
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test('Se aplica filtro de hora para estar y hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            null,
            null,
            0,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      Oferta oferta = container!.read(ofertasDisponiblesProvider).value!.first;
      expect(
        DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.parse(oferta.hora)),
        DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(const Duration(days: 3))),
      );
    });

    test('Se aplica filtro de hora para estar y no hay oferta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 4)).toIso8601String(),
            null,
            null,
            0,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test('Se aplica filtro de hora para salir hora correcta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            null,
            null,
            1,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test('Se aplica filtro de hora para salir hora incorrecta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 4)).toIso8601String(),
            null,
            null,
            1,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    setUp(() {
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
        coordOrigen: LatLng(0, 0),
        radioOrigen: 1000,
        coordDestino: LatLng(20, 20),
        radioDestino: 1000,
      );
      container = ProviderContainer(
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
                  [],
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
          plazasProvider.overrideWith((ref, arg) => ofertaDisp!.plazasDisponibles),
          temaProvider.overrideWith(() => TemaController(valorDefecto: 'claro')),
          ofertasOfrecidasUsuarioProvider.overrideWith(
              () => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!])),
          ofertasDisponiblesProvider.overrideWith(
              () => OfertasController(tipo: TipoViaje.oferta, valorDefecto: [ofertaDisp!])),
          ofertasUsuarioApuntadoProvider.overrideWith(
              () => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [ofertaApunt!])),
        ],
      );
    });

    test('Se aplica filtro de posición personalizada origen correcta', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            '',
            LocalizacionPersonalizada(
              nombreCompleto: '',
              localidad: '',
              coordenadas: LatLng(0, 0),
              radio: 1000,
            ),
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.first.coordOrigen, LatLng(0, 0));
    });

    test('Se aplica filtro de posición personalizada destino', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            '',
            null,
            LocalizacionPersonalizada(
              nombreCompleto: '',
              localidad: '',
              coordenadas: LatLng(20, 20),
              radio: 1000,
            ),
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.first.coordDestino, LatLng(20, 20));
    });

    test('Se aplica filtro de posición personalizada de origen y destino', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            '',
            LocalizacionPersonalizada(
              nombreCompleto: '',
              localidad: '',
              coordenadas: LatLng(0, 0),
              radio: 1000,
            ),
            LocalizacionPersonalizada(
              nombreCompleto: '',
              localidad: '',
              coordenadas: LatLng(20, 20),
              radio: 1000,
            ),
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.first.coordOrigen, LatLng(0, 0));
      expect(container!.read(ofertasDisponiblesProvider).value!.first.coordDestino, LatLng(20, 20));
    });

    test('Se aplican filtros de posición simple origen y hora correctamente', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Fuengirola',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.first.origen, 'Fuengirola');
      expect(
          DateFormat('dd/MM/yyyy  kk:mm').format(
              DateTime.parse(container!.read(ofertasDisponiblesProvider).value!.first.hora)),
          DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(
            const Duration(days: 3),
          )));
    });

    test(
        'Se aplican filtros de posición simple origen y hora correctamente, si hora no coincide no sale',
        () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Fuengirola',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 4)).toIso8601String(),
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test(
        'Se aplican filtros de posición simple origen y hora correctamente, si lugar no coincide no sale',
        () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Torremolinos',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });
    test('Se aplican filtros de posición simple destino y hora correctamente', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Teatinos',
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.first.destino, 'Teatinos');
      expect(
          DateFormat('dd/MM/yyyy  kk:mm').format(
              DateTime.parse(container!.read(ofertasDisponiblesProvider).value!.first.hora)),
          DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(
            const Duration(days: 3),
          )));
    });

    test(
        'Se aplican filtros de posición simple destino y hora correctamente, si hora no coincide no sale',
        () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Teatinos',
            DateTime.now().add(const Duration(days: 4)).toIso8601String(),
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test(
        'Se aplican filtros de posición simple destino y hora correctamente, si lugar no coincide no sale',
        () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Torremolinos',
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            null,
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test('Se aplican filtros de posición personalizada origen y hora correctamente', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            LocalizacionPersonalizada(
              nombreCompleto: '',
              localidad: '',
              coordenadas: LatLng(0, 0),
              radio: 1000,
            ),
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.first.coordOrigen, LatLng(0, 0));
      expect(
          DateFormat('dd/MM/yyyy  kk:mm').format(
              DateTime.parse(container!.read(ofertasDisponiblesProvider).value!.first.hora)),
          DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(
            const Duration(days: 3),
          )));
    });

    test(
        'Se aplican filtros de posición personalizada origen y hora correctamente, si hora no coincide no sale',
        () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 4)).toIso8601String(),
            LocalizacionPersonalizada(
              nombreCompleto: '',
              localidad: '',
              coordenadas: LatLng(0, 0),
              radio: 1000,
            ),
            null,
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });

    test('Se aplican filtros de posición personalizada destino y hora correctamente', () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            null,
            LocalizacionPersonalizada(
              nombreCompleto: '',
              localidad: '',
              coordenadas: LatLng(20, 20),
              radio: 1000,
            ),
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.first.coordDestino, LatLng(20, 20));
      expect(
          DateFormat('dd/MM/yyyy  kk:mm').format(
              DateTime.parse(container!.read(ofertasDisponiblesProvider).value!.first.hora)),
          DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now().add(
            const Duration(days: 3),
          )));
    });

    test(
        'Se aplican filtros de posición personalizada destino y hora correctamente, si hora no coincide no sale',
        () async {
      await container!.read(ofertasDisponiblesProvider.future);

      container!.read(ofertasDisponiblesProvider.notifier).filtrar(
            'Selecciona uno',
            'Selecciona uno',
            DateTime.now().add(const Duration(days: 4)).toIso8601String(),
            null,
            LocalizacionPersonalizada(
              nombreCompleto: '',
              localidad: '',
              coordenadas: LatLng(20, 20),
              radio: 1000,
            ),
            2,
          );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(container!.read(ofertasDisponiblesProvider).value!.length, 0);
    });
  });

  group('Funciones de chat', () {
    test('Se busca chat correctamente', () async {
      await container!.read(chatProvider.future);

      final Chat? chatBuscado = container!.read(chatProvider.notifier).buscarChat('idOtroUsuario');

      await Future.delayed(const Duration(milliseconds: 50));

      expect(chatBuscado!.id, 1);
    });

    test('Si chat no existe buscar chat devuelve null', () async {
      await container!.read(chatProvider.future);

      final Chat? chatBuscado = container!.read(chatProvider.notifier).buscarChat('idQueNoExiste');

      await Future.delayed(const Duration(milliseconds: 50));

      expect(chatBuscado, null);
    });
    test('Se crea chat correctamente', () async {
      await container!.read(chatProvider.future);
      expect(container!.read(chatProvider).value!.length, 2);
      expect(container!.read(chatProvider).value!.first.id, 1);

      container!.read(chatProvider.notifier).crearChat(
            Usuario(
              id: 'usuarioTest2',
              nombre: 'nombreTest2',
            ),
          );

      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(chatProvider).value!.length, 3);
      expect(container!.read(chatProvider).value!.first.id, 111);
    });

    setUp(() {
      container = ProviderContainer(
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
                  [],
                ),
                Chat(
                  2,
                  Usuario(
                    id: 'usuario',
                    nombre: 'UsuarioActivo',
                    tituloDefecto: 'Titulo por defecto',
                    descripcionDefecto: 'Descripción por defecto',
                  ),
                  Usuario(id: 'idOtroUsuario2', nombre: 'UsuarioTest2'),
                  [],
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
        ],
      );
    });

    test('El chat se pone al principio correctamente', () async {
      await container!.read(chatProvider.future);
      expect(container!.read(chatProvider).value!.length, 2);
      expect(container!.read(chatProvider).value!.first.id, 1);

      container!.read(chatProvider.notifier).ponerChatAlPrincipio(2);

      await Future.delayed(const Duration(milliseconds: 50));

      expect(container!.read(chatProvider).value!.first.id, 2);
      expect(container!.read(chatProvider).value![1].id, 1);
    });
  });

//TODO dividir la función de filtros en varias funciones privadas más pequeñas
}

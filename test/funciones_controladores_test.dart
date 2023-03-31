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
            .overrideWith(() => OfertasController(tipo: TipoViaje.propio, valorDefecto: [oferta!])),
        ofertasDisponiblesProvider.overrideWith(
            () => OfertasController(tipo: TipoViaje.oferta, valorDefecto: [ofertaDisp!])),
        ofertasUsuarioApuntadoProvider.overrideWith(
            () => OfertasController(tipo: TipoViaje.apuntado, valorDefecto: [ofertaApunt!])),
      ],
    );
  });

  tearDownAll(() {});

  //TODO pruebas sobre funciones de los controladores
  group('Funciones de oferta', () {
    test('test name', () {});
  });

  group('Funciones de chat', () {});

  group('Funcionaes de tema', () {});
}

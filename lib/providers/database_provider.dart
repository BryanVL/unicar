import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/interfaces/database_interface.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/providers/usuario_provider.dart';
import '../models/database/supabase_db_implementer.dart';
import '../screens/login_screen.dart';
import '../screens/nuevo_usuario_screen.dart';
import '../screens/tab_bar_screen.dart';
import 'login_provider.dart';

class DatabaseController extends r.Notifier<Database> {
  final Database? valorDefecto;

  DatabaseController({this.valorDefecto});

  @override
  Database build() {
    return valorDefecto ?? SupabaseDB();
  }

  Future<bool> _comprobarPrimerInicio(User user) async {
    final usuario = await state.datosUsuario(user.id);
    return usuario.nombre == '';
  }

  StreamSubscription<AuthState> comprobarEstadoInicioConProvider(BuildContext context) {
    return Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      if (ref.read(loginProviderProvider)) return;
      final session = data.session;

      if (session != null) {
        ref.read(loginProviderProvider.notifier).state = true;
        final User user = data.session!.user;
        final esNuevoUsuario = _comprobarPrimerInicio(user);
        esNuevoUsuario.then((value) async {
          if (value) {
            final nombreUsuario = user.userMetadata?['full_name'];
            final urlAvatar = user.userMetadata?['avatar_url'];
            state.actualizarDatosUsuario(user.id, nombreUsuario, urlAvatar);

            ref.read(usuarioProvider.notifier).state = Usuario(
              id: user.id,
              nombre: nombreUsuario,
              urlIcono: urlAvatar,
            );
          } else {
            ref.read(usuarioProvider.notifier).state = await state.datosUsuario(user.id);
          }
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed(TabBarScreen.kRouteName);
          }
        });
      }
    });
  }

  void iniciarSesion(
    BuildContext context,
    String correo,
    String password,
  ) async {
    final AuthResponse res = await state.iniciarSesion(correo, password);
    final user = res.user;
    if (user != null) {
      ref.read(usuarioProvider.notifier).state = await state.datosUsuario(user.id);

      final esNuevoUsuario = _comprobarPrimerInicio(user);
      esNuevoUsuario.then((value) {
        if (value) {
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed(NuevoUsuarioScreen.kRouteName);
          }
        } else {
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed(TabBarScreen.kRouteName);
          }
        }
      });
    }
  }

  void iniciarSesionConProvider(Provider provider) async {
    state.iniciarSesionConProvider(provider);
  }

  void cerrarSesion(BuildContext context) async {
    state.cerrarSesion();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.kRouteName,
        (Route<dynamic> route) => false,
      );
    }
  }

  void borrarCuenta(BuildContext context) async {
    state.borrarCuenta(ref.read(usuarioProvider)!.id);

    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.kRouteName,
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<List<Usuario>> recogerPasajeros(int idViaje) {
    return state.recogerParticipantesViaje(idViaje);
  }

  void eliminarPasajero(int idViaje, String idUsuario, int plazas) {
    state.cancelarPlaza(idViaje, plazas, idUsuario);
  }

  Future<int> recogerPlazasDisponibles(int idViaje) {
    return state.recogerPlazasViaje(idViaje);
  }

  void comprobarSesion(BuildContext context) async {
    try {
      final initialSession = await state.comprobarSesion();
      if (initialSession != null) {
        ref.read(usuarioProvider.notifier).state = await state.datosUsuario(initialSession.user.id);

        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(TabBarScreen.kRouteName);
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.kRouteName);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.kRouteName);
      }
    }
  }
}

final databaseProvider = r.NotifierProvider<DatabaseController, Database>(() {
  return DatabaseController();
});

final pasajerosViajeInicialProvider =
    r.FutureProvider.family.autoDispose<List<Usuario>, int>((ref, id) {
  return ref.watch(databaseProvider).recogerParticipantesViaje(id);
});

final pasajerosViajeProvider =
    r.StateProvider.family.autoDispose<r.AsyncValue<List<Usuario>>, int>((ref, id) {
  final res = ref.watch(pasajerosViajeInicialProvider(id));
  return res;
});

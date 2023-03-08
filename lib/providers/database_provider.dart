import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/database/database_interface.dart';
import 'package:unicar/models/usuario.dart';
import 'package:unicar/providers/usuario_provider.dart';
import '../models/database/supabase_db_implementer.dart';
import '../screens/login_screen.dart';
import '../screens/nuevo_usuario_screen.dart';
import '../screens/tab_bar_screen.dart';

class DatabaseController extends r.Notifier<Database> {
  @override
  Database build() {
    return SupabaseDB();
  }

  Future<bool> _comprobarPrimerInicio(User user) async {
    final nombre = await state.nombreUsuario(user.id);
    return nombre == '';
  }

  StreamSubscription<AuthState> comprobarEstadoInicioConProvider(
    BuildContext context,
    bool redirecting,
  ) {
    return Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      if (redirecting) return;
      final session = data.session;

      if (session != null) {
        redirecting = true;
        final User user = data.session!.user;
        final nombreUsuario = await state.nombreUsuario(user.id);
        ref.read(usuarioProvider.notifier).state = Usuario(id: user.id, nombre: nombreUsuario);

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
      final nombre = await state.nombreUsuario(user.id);
      ref.read(usuarioProvider.notifier).state = Usuario(id: user.id, nombre: nombre);

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

  void comprobarSesion(BuildContext context) async {
    try {
      final initialSession = await state.comprobarSesion();
      if (initialSession != null) {
        final nombre = await state.nombreUsuario(initialSession.user.id);
        ref.read(usuarioProvider.notifier).state =
            Usuario(id: initialSession.user.id, nombre: nombre);

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

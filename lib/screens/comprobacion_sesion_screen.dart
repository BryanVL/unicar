import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/screens/login_screen.dart';
import 'package:unicar/screens/tab_bar_screen.dart';

import '../providers/usuario_provider.dart';

class ComprobacionSesionScreen extends ConsumerStatefulWidget {
  const ComprobacionSesionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ComprobacionSesionScreenState();
}

class _ComprobacionSesionScreenState extends ConsumerState<ComprobacionSesionScreen> {
  Future<void> comprobarSesionAnterior() async {
    final prefs = await SharedPreferences.getInstance();
    final String? prefSessionKey = prefs.getString('session');
    if (prefSessionKey != null) {
      try {
        final res = await Supabase.instance.client.auth.recoverSession(prefSessionKey);
        if (res.user != null) {
          ref.read(usuarioProvider.notifier).state = res.user!.id;
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed(TabBarScreen.kRouteName);
          }
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.kRouteName);
        }
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.kRouteName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    comprobarSesionAnterior();
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

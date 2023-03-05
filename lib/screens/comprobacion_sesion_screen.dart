import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Future<void> comprobarSesion() async {
    try {
      final initialSession = await SupabaseAuth.instance.initialSession;
      if (initialSession != null) {
        ref.read(usuarioProvider.notifier).state = initialSession.user.id;

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

  @override
  Widget build(BuildContext context) {
    comprobarSesion();
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/screens/chats_screen.dart';
import 'package:unicar/screens/comprobacion_sesion_screen.dart';
import 'package:unicar/screens/configuracion_screen.dart';
import 'package:unicar/screens/crear_oferta_screen.dart';
import 'package:unicar/screens/filtrar_screen.dart';
import 'package:unicar/screens/login_screen.dart';
import 'package:unicar/screens/mis_viajes_screen.dart';
import 'package:unicar/screens/nuevo_usuario_screen.dart';
import 'package:unicar/screens/ofertas_screen.dart';
import 'package:unicar/screens/register_screen.dart';
import 'package:unicar/screens/tab_bar_screen.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://nfblnvdvegjgqkxhrowm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5mYmxudmR2ZWdqZ3FreGhyb3dtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzU2ODIyOTcsImV4cCI6MTk5MTI1ODI5N30.k7g7SCRdraTHjnIx-MsVde4NR2thrZW4OF8XSNNlJj4',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unicar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color.fromARGB(255, 252, 252,
            252), //Color.fromARGB(255, 251, 255, 255), //const Color.fromARGB(255, 222, 238, 253),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.blue[600], //Color.fromARGB(255, 60, 119, 245),
        ),
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: Colors.black,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.lightBlue,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const ComprobacionSesionScreen(),
      routes: {
        TabBarScreen.kRouteName: (context) => const TabBarScreen(title: 'Unicar'),
        LoginScreen.kRouteName: (context) => const LoginScreen(),
        OfertasScreen.kRouteName: (ctx) => const OfertasScreen(),
        MisViajesScreen.kRouteName: (context) => const MisViajesScreen(),
        ChatsScreen.kRouteName: (context) => const ChatsScreen(),
        CrearOferta.kRouteName: (context) => const CrearOferta(),
        FiltrarScreen.kRouteName: (context) => const FiltrarScreen(),
        ConfiguracionScreen.kRouteName: (context) => const ConfiguracionScreen(),
        RegisterScreen.kRouteName: (context) => const RegisterScreen(),
        NuevoUsuarioScreen.kRouteName: (context) => const NuevoUsuarioScreen(),
      },
    );
  }
}

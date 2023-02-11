import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/screens/chats_screen.dart';
import 'package:unicar/screens/crear_oferta_screen.dart';
import 'package:unicar/screens/mis_viajes_screen.dart';
import 'package:unicar/screens/ofertas_screen.dart';
import 'package:unicar/screens/tab_bar_screen.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://nfblnvdvegjgqkxhrowm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5mYmxudmR2ZWdqZ3FreGhyb3dtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzU2ODIyOTcsImV4cCI6MTk5MTI1ODI5N30.k7g7SCRdraTHjnIx-MsVde4NR2thrZW4OF8XSNNlJj4',
  );

  runApp(const MyApp());
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
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          appBarTheme: const AppBarTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            foregroundColor: Colors.black,
            backgroundColor: Colors.blue,
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
          )),
      home: const TabBarScreen(title: 'Unicar'),
      routes: {
        OfertasScreen.kRouteName: (ctx) => const OfertasScreen(),
        MisViajesScreen.kRouteName: (context) => const MisViajesScreen(),
        ChatsScreen.kRouteName: (context) => const ChatsScreen(),
        CrearOferta.kRouteName: (context) => const CrearOferta(),
      },
    );
  }
}
